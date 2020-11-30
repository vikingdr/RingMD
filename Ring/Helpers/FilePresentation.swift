//
//  FileHandler.swift
//  Ring
//
//  Created by RingMD on 15/10/14.
//  Copyright (c) 2014 Matthew James All rights reserved.
//

import Foundation

extension UIViewController: UIDocumentInteractionControllerDelegate {
  func presentData(data: NSData, withView view: UIView) {    
    let tempURL = NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingPathComponent(NSProcessInfo().globallyUniqueString))!
    data.writeToURL(tempURL, atomically: false)
    
    self.presentFile(tempURL, withView: view)
  }
  
  func presentFile(file: NSURL, withView view: UIView) {
    let dic = UIDocumentInteractionController(URL: file)
    dic.delegate = self
    if !dic.presentPreviewAnimated(true) {
      dic.presentOptionsMenuFromRect(CGRectMake(0, 0, view.frame.size.width, view.frame.size.height), inView:view, animated: true)
    }
  }
  
  public func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
    return self
  }
}
