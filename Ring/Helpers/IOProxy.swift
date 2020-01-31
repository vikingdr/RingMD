//
//  IOProxy.swift
//  Ring
//
//  Created by Jonas De Vuyst (RingMD) on 18/09/14.
//  Copyright (c) 2014 Medpats Global Pte. Ltd. All rights reserved.
//

import Foundation
import UIKit

private let operationQueue = AFHTTPRequestOperationManager().operationQueue

private enum PauzeStatus: Int {
  case Hidden = 0
  case Started
  case Retrying
  case Failed
}

private let loadingView: UIView = {
  let v = NSBundle.mainBundle().loadNibNamed("BusyLoadingView", owner: nil, options: nil).first as UIView
  
  for v2 in v.subviews {
    v2.layer.cornerRadius = 8
  }
  
  return v
  }()

private let retryingView: UIView = {
  let v = NSBundle.mainBundle().loadNibNamed("BusyReconnectingView", owner: nil, options: nil).first as UIView
  
  for v2 in v.subviews {
    v2.layer.cornerRadius = 8
  }
  
  return v
  }()

private let failView = NSBundle.mainBundle().loadNibNamed("FatalHTTPRequestErrorView", owner: nil, options: nil).first as? UIView

private class PauzeOverlayView: UIView {
  let reachabilityManager: AFNetworkReachabilityManager = AFNetworkReachabilityManager(forDomain: "ring.md")
  
  weak var overlayView: UIView? {
    willSet {
      self.overlayView?.removeFromSuperview()
      if let v = newValue {
        v.frame = self.frame
        self.addSubview(v)
      }
    }
  }
  var status: PauzeStatus = .Hidden
  var pendingOperations = 0
  
  class func forView(parent: UIView) -> PauzeOverlayView {
    for v in parent.subviews {
      if let overlayView = v as? PauzeOverlayView {
        return overlayView
      }
    }
    
    let overlayView = PauzeOverlayView()
    parent.addSubview(overlayView)
    
    return overlayView
  }
  
  override func didMoveToSuperview() {
    if let parent = self.superview {
      parent.bringSubviewToFront(self)
      
      if RingSwiftBridge.debug() {
        self.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
      }
    }
  }
  
  func freeze(newStatus: PauzeStatus) {
    if newStatus == .Started {
      self.pendingOperations++
    }
    
    if newStatus.rawValue <= self.status.rawValue {
      return
    }
    
    self.status = newStatus
    
    if let size = self.superview?.frame.size {
      self.frame = CGRectMake(0, 0, size.width, size.height)
      self.hidden = false
      
      switch self.status {
      case .Started:
        loadingView.hidden = true
        self.overlayView = loadingView
        doAfterDelay({loadingView.hidden = false}, seconds: 1)
        
        self.reachabilityManager.setReachabilityStatusChangeBlock({ (status: AFNetworkReachabilityStatus) in
          assert(NSRunLoop.currentRunLoop() == NSRunLoop.mainRunLoop())
          if !self.reachabilityManager.reachable {
            println("Server not reachable. Notify user of efforts to reconnect.")
            self.freeze(.Retrying)
          }
        })
        reachabilityManager.startMonitoring()
      case .Retrying:
        self.reachabilityManager.stopMonitoring()
        self.overlayView = retryingView
      case .Failed:
        self.reachabilityManager.stopMonitoring()
        self.overlayView = failView
      case .Hidden:
        assert(false)
      }
    }
  }
  
  func thaw() {
    self.pendingOperations--
    
    if self.pendingOperations == 0 {
      switch self.status {
      case .Hidden:
        assert(false)
      case .Failed:
        break
      case .Started, .Retrying:
        self.overlayView = nil
        self.hidden = true
        self.status = .Hidden
      }
      
      self.reachabilityManager.stopMonitoring()
    }
  }
}

private enum ErrorType {
  case UserError(String?)
  case UnexpectedError
}

private var alertViews: [String: UIAlertView] = Dictionary()

var cacheableDataCallbacks: [String: [(NSData) -> Void]] = Dictionary()

private func showAlertDialog(title: String, message: String) {
  let k = "\(title): \(message)"
  if alertViews[k] == nil {
    alertViews[k] = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
  }
  alertViews[k]!.show()
}

private func showAlert(type: ErrorType, overlayView: PauzeOverlayView? = nil) {
  switch type {
  case .UserError(let msg): // not our fault. includes firewall and network configuration errors.
    overlayView?.thaw()
    let msg = (msg == nil ? "An unknown problem occured while communicating with the server." : msg!)
    showAlertDialog("Error", msg)
  case .UnexpectedError:
    if let overlayView = overlayView {
      overlayView.freeze(.Failed)
    } else {
      showAlertDialog("Unexpected Error", "An unknown problem occurred while communicating with the server.")
    }
    break
  }
}

extension AFHTTPRequestOperation {
  convenience init(getURLString: String) {
    self.init(request: NSURLRequest(URL: NSURL(string: getURLString)!))
  }
  
  class func cancelAll() {
    println("Will cancel \(operationQueue.operationCount) HTTP requests")
    for op in operationQueue.operations {
      op.cancel()
    }
    operationQueue.waitUntilAllOperationsAreFinished()
    // Here all operations have been asked to cancel, but their failure handlers might not have been called yet
  }
  
  // Perform a JSON request and automatically block the 'active' view
  // It is recommended to use perform:blockView: instead
  func perform(proceed: (AnyObject) -> (), modally: Bool, json: Bool) {
    var activeView: UIView?
    
    if modally {
      activeView = RingNavigationController.sharedNavigationController().visibleViewController.view
    }
    
    self.perform(proceed, blockView:activeView, json: json)
  }
  
  func perform(proceed: (AnyObject) -> (), modally: Bool) {
    self.perform(proceed, modally: modally, json: true)
  }
  
  func perform(proceed: (AnyObject) -> (), blockView parent: UIView?, json: Bool = true, numberOfPreviousAttempts: Int = 0) {
    assert(NSRunLoop.currentRunLoop() == NSRunLoop.mainRunLoop())
    assert(self.request != nil)
    assert(self.request.HTTPMethod != nil)
    assert(self.request.URL.scheme != nil)
    assert(self.request.URL.host != nil)
    assert(self.request.URL.path != nil)
    
    let isGetRequest = self.request.HTTPMethod == "GET"
    
    let overlayView: PauzeOverlayView? = parent == nil ? nil : PauzeOverlayView.forView(parent!)
    
    // print information about fatal errors
    let fail = { (msg: String) -> Void in
      println("✋ \(self.request.HTTPMethod!) \(self.request.URL): \(msg)")
      serve(self.responseData)
      showAlert(.UnexpectedError, overlayView: overlayView)
    }
    
    self.setCompletionBlockWithSuccess({(op: AFHTTPRequestOperation!, response: AnyObject?) -> Void in
      func finalize(result: AnyObject) {
        println("👈 \(self.request.HTTPMethod!) \(self.request.URL)")
        serve(self.responseData)
        reportMemoryUsage()
        proceed(result)
        overlayView?.thaw()
      }
      
      if let data = self.responseData {
        if !json {
          finalize(data)
        } else if let result: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) {
          finalize(result)
        } else {
          fail("Invalid JSON data")
        }
      } else {
        fail("Empty response")
      }
      }, failure: { (op: AFHTTPRequestOperation!, err: NSError!) -> Void in
        if self.cancelled {
          println("HTTP request canceled")
          overlayView?.thaw()
          return;
        }
        
        func alert(console techMsg: String, user userMsg: String?) {
          println("✋ \(self.request.HTTPMethod!) \(self.request.URL): \(techMsg)")
          showAlert(.UserError(userMsg), overlayView: overlayView)
        }
        
        func retry(msg: String) {
          println("😰 \(self.request.HTTPMethod!) \(self.request.URL): \(msg) (will try again soon)")
          overlayView?.freeze(.Retrying)
          
          operationQueue.suspended = true
          doAfterDelay({ () -> Void in
            operationQueue.suspended = false
            }, seconds: min(2.0 * Double(numberOfPreviousAttempts), 30.0))
          
          AFHTTPRequestOperation(request: self.request).perform(proceed, blockView: parent, json: json, numberOfPreviousAttempts: numberOfPreviousAttempts + 1)
        }
        
        if let response = op.response {
          switch response.statusCode {
          case 400:
            if isGetRequest {
              fail("400 Bad Request")
            } else {
              var message: String?
              if let data = self.responseString.dataUsingEncoding(NSUTF8StringEncoding) {
                if let dict = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as? NSDictionary {
                  if let error = (dict["message"]) as? String {
                    println("Using 'message' from JSON error response")
                    message = error
                  } else if let error = (dict["error"]) as? String {
                    println("Using 'error' from JSON error response")
                    message = error
                  } else if let errors = dict["errors"] as? [String] {
                    println("Using 'errors' from JSON error response")
                    message = errors.first
                  }
                  
                  if let s = message {
                    message = s + "."
                  }
                }
              }
              
              alert(console: "400 Bad Request", user: message)
            }
          case 401:
            RingSwiftBridge.logout()
            alert(console: "401 Unauthorized", user: "Login failed. Please try again.")
          case 100...199, 408, 500...509:
            retry(err.localizedDescription)
          default:
            fail(err.localizedDescription)
          }
        } else {
          // http://stackoverflow.com/questions/6778167/undocumented-nsurlerrordomain-error-codes-1001-1003-and-1004-using-storeki
          switch Int32(err.code) {
          case CFNetworkErrors.CFURLErrorBadURL.rawValue, CFNetworkErrors.CFURLErrorUnsupportedURL.rawValue:
            fail("Malformed URL")
          case CFNetworkErrors.CFURLErrorDataNotAllowed.rawValue:
            alert(console: err.localizedDescription, user: "The connection failed because data use is currently not allowed.")
          case CFNetworkErrors.CFURLErrorInternationalRoamingOff.rawValue:
            alert(console: err.localizedDescription, user: "This device is not connected to a Wi-Fi network and international roaming is turned off.")
          case CFNetworkErrors.CFURLErrorDNSLookupFailed.rawValue, CFNetworkErrors.CFNetServiceErrorDNSServiceFailure.rawValue:
            alert(console: err.localizedDescription, user: "Failed to lookup the IP address of the RingMD server. Your DNS settings may be misconfigured.")
          case CFNetworkErrors.CFURLErrorUserCancelledAuthentication.rawValue, CFNetworkErrors.CFURLErrorSecureConnectionFailed.rawValue, CFNetworkErrors.CFURLErrorServerCertificateHasBadDate.rawValue, CFNetworkErrors.CFURLErrorServerCertificateNotYetValid.rawValue, CFNetworkErrors.CFURLErrorServerCertificateUntrusted.rawValue:
            switch (Int32(err.code), self.request.URL.host!) {
            case (CFNetworkErrors.CFURLErrorUserCancelledAuthentication.rawValue, "staging-cdn.ring.md"):
              println("😡 Failed to securely download \(self.request.URL)")
              break
            case (CFNetworkErrors.CFURLErrorUserCancelledAuthentication.rawValue, "cdn.ring.md"):
              alert(console: "possible CDN rate limiting", user: "Failed to securely download a file. Please contact support@ring.md.")
            default:
              alert(console: err.localizedDescription, user: "Failed to establish a secure connection to the RingMD server. Please contact support@ring.md.")
            }
          case CFNetworkErrors.CFURLErrorTimedOut.rawValue:
            retry("HTTP request timeout")
          default:
            retry(err.localizedDescription)
          }
        }
    })
    
    println("👉 \(self.request.HTTPMethod!) \(self.request.URL)")
    if let body = self.request.HTTPBody {
      serve(body)
    }
    
    if(numberOfPreviousAttempts == 0) {
      overlayView?.freeze(.Started)
    }
    
    operationQueue.addOperation(self)
  }
  
  func deliverCacheableData(deliver: (NSData) -> (), slowMark: () -> () = {}) {
    assert(NSRunLoop.currentRunLoop() == NSRunLoop.mainRunLoop())
    let tempFilePath = "\(NSTemporaryDirectory())ringmd-cached-data\(self.request.hashValue)"
    
    if let data = NSData(contentsOfFile: tempFilePath) {
      println("😎 Loaded \(self.request.URL) from cache")
      deliver(data)
    } else {
      var delivered = false
      let k = "\(self.request.URL)"
      
      if var callbacks = cacheableDataCallbacks[k] {
        callbacks.append({data in
          delivered = true
          deliver(data)
        })
      } else {
        cacheableDataCallbacks[k] = [deliver]
        
        self.perform({data in
          assert(NSRunLoop.currentRunLoop() == NSRunLoop.mainRunLoop())
          
          let data = data as NSData
          data.writeToFile(tempFilePath, atomically: true)
          delivered = true
          
          for callback in cacheableDataCallbacks[k]! {
            callback(data)
          }
          
          cacheableDataCallbacks[k] = nil
          }, blockView: nil, json: false)
      }
      doAfterDelay({
        assert(NSRunLoop.currentRunLoop() == NSRunLoop.mainRunLoop())
        if !delivered {
//          println("😒 Loading \(self.request.URL) is taking longer than expected.")
          slowMark()
        }
        }, seconds: 1)
    }
  }
}

private let pauzeOverlayWebViewDelegate = PauzeOverlayWebViewDelegate()

@objc class PauzeOverlayWebViewDelegate: NSObject, UIWebViewDelegate {
  class func sharedInstance() -> PauzeOverlayWebViewDelegate {
    return pauzeOverlayWebViewDelegate;
  }
  
  func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
    webView.scalesPageToFit = true
    webView.suppressesIncrementalRendering = true
    webView.scrollView.bounces = false
    
    let url = request.URL.absoluteString!
    println("👉 \(request.HTTPMethod!) \(url)")
    serve(request.HTTPBody)
    
    let overlay = PauzeOverlayView.forView(webView)
    overlay.freeze(.Started)
    
    if url.hasPrefix(RingSwiftBridge.ringHomepageURLString()) {
      // At the end of the payment process we use magic URLs
      // This should be made more general
      if let r = url.rangeOfString("checkout_result?") {
        // Put arguments in URL into a dictionary
        let argString = url.substringFromIndex(r.endIndex)
        let argArray = argString.componentsSeparatedByString("&")
        var argDict : [String: String] = Dictionary()
        for s in argArray {
          let a = s.componentsSeparatedByString("=")
          if let first = a.first {
            argDict[first] = a.last
          }
        }
        
        // Display result hidden in the URL
        if let result : String = argDict["result"] {
          switch result {
          case "success":
            println("Payment details accepted")
            RingNavigationController.sharedNavigationController().popToMenuChild()
            showAlertDialog("Payment Details Confirmed", "Your payment details have been verified. The doctor will confirm your appointment soon.")
            return false
          case "fail":
            println("Payment details failure")
            showAlert(.UnexpectedError, overlayView: overlay)
            return false
          case "error":
            println("Payment details error")
            let msg = argDict["errorMsg"]?.stringByReplacingOccurrencesOfString("+", withString: " ", options: nil, range: nil).stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            showAlert(.UserError(msg), overlayView: overlay)
            return false
          default:
            break
          }
        }
        
        wut("Bad magic URL")
        showAlert(.UnexpectedError, overlayView: overlay)
        return false
      }
    }
    
    return true
  }
  
  //  func webViewDidStartLoad(webView: UIWebView!) {
  //    println("👉 Loading \(webView.request!.URL)")
  //  }
  
  func webViewDidFinishLoad(webView: UIWebView!) {
    println("👈 \(webView.request!.HTTPMethod!) \(webView.request!.URL)")
    serve(webView.stringByEvaluatingJavaScriptFromString("document.documentElement.outerHTML"))
    PauzeOverlayView.forView(webView).thaw()
  }
  
  func webView(webView: UIWebView!, didFailLoadWithError error: NSError!) {
    wut("✋ Failed to load \(webView.request!.URL) in webview: \(error.localizedDescription)")
    showAlert(.UnexpectedError, overlayView: PauzeOverlayView.forView(webView))
  }
}

extension NSURLRequest {
  class func ringRequest(#method: String, call: String, params: [String: String] = [:]) -> NSMutableURLRequest {
    let serializer = AFJSONRequestSerializer()
    serializer.setValue("application/json", forHTTPHeaderField: "Accept")
    serializer.setValue("gzip,deflate", forHTTPHeaderField: "Accept-Encoding")
    
    let baseURL = "\(RingSwiftBridge.ringAPIBaseURLString())\(call)"
    
    var params = params
    params["user_token"] = RingSwiftBridge.userToken()
    
    var error: NSError?;
    let r = serializer.requestWithMethod(method, URLString: baseURL, parameters: params, error: &error)
    assert(error == nil)
    
    return r
  }
  
  func operation() -> AFHTTPRequestOperation {
    return AFHTTPRequestOperation(request: self)
  }
}