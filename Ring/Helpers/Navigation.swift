//
//  RingNavigationController.swift
//  Ring
//
//  Created by RingMD on 04/11/14.
//  Copyright (c) 2014 Matthew James All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

private func imageWithBadge(underlay: UIImage, badgeText: String) -> UIImage {
  // Style
  let attrStr = NSAttributedString(string: badgeText, attributes: [NSFontAttributeName: UIFont.ringFontOfSize(12), NSForegroundColorAttributeName: UIColor.whiteColor()])
  let textFillMode: CGTextDrawingMode = kCGTextFill
  
  // Layout
  let cornerRadius: CGFloat = 2
  let margin: CGFloat = 1
  let strSize = CGSizeMake(attrStr.size().width, 10)
  let badgeSize = CGSizeMake(strSize.width + margin * 2, strSize.height + margin * 2)
  
  var size = underlay.size
  size.width += badgeSize.width / 3
  size.height += badgeSize.height / 3
  let rect = CGRectMake(0, 0, size.width, size.height)
  
  let badgeRect = CGRectMake(size.width - badgeSize.width, 0, badgeSize.width, badgeSize.height)
  let textOrigin = CGPointMake(badgeRect.origin.x + margin, size.height - badgeRect.size.height - badgeRect.origin.y + margin)
  let underlayRect = CGRectMake(0, (size.height - underlay.size.height) / 2, underlay.size.width, underlay.size.height)
  
  // Create mask for notification count
  
  UIGraphicsBeginImageContextWithOptions(size, false, 0)
  var c = UIGraphicsGetCurrentContext()
  
  CGContextSetTextDrawingMode(c, textFillMode)
  let line = CTLineCreateWithAttributedString(attrStr)
  CGContextSetTextPosition(c, textOrigin.x, textOrigin.y)
  CTLineDraw(line, c);
  
  let maskRef = UIGraphicsGetImageFromCurrentImageContext().CGImage
  let mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
    CGImageGetHeight(maskRef),
    CGImageGetBitsPerComponent(maskRef),
    CGImageGetBitsPerPixel(maskRef),
    CGImageGetBytesPerRow(maskRef),
    CGImageGetDataProvider(maskRef),
    nil,
    false)
  UIGraphicsEndImageContext()
  
  // Draw hamburger icon and badge
  
  UIGraphicsBeginImageContextWithOptions(size, false, 0)
  c = UIGraphicsGetCurrentContext()
  
  CGContextClipToMask(c, rect, mask)
  
  CGContextConcatCTM(c, CGAffineTransformMake(1, 0, 0, -1, 0, size.height))
  CGContextDrawImage(c, underlayRect, underlay.CGImage)
  CGContextConcatCTM(c, CGAffineTransformMake(1, 0, 0, -1, 0, size.height))
  
  UIBezierPath(roundedRect: badgeRect, cornerRadius: cornerRadius).fill()
  
  let img = UIGraphicsGetImageFromCurrentImageContext()
  UIGraphicsEndImageContext()
  
  // Return result
  return img
}

@objc protocol NavigationBarOptions {
  optional func shouldReturnToMenu() -> Bool
  optional func shouldShowNavigationBar() -> Bool
}

var ringNavigationController : RingNavigationController!

class RingNavigationController : UINavigationController, UINavigationControllerDelegate {
  var notificationCount: Int = 0 {
    didSet {
      self.setupBackButton(forViewController: self.visibleViewController)
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.delegate = self
    
    assert(ringNavigationController == nil)
    ringNavigationController = self
  }
  
  class func sharedNavigationController() -> RingNavigationController {
    return ringNavigationController
  }
  
  // MARK: UINavigationControllerDelegate
  
  private func setupBackButton(forViewController vc: UIViewController) {
    let navbar = self.navigationBar
    
    var childOfRoot = false
    if let vcWithOptions = vc as? NavigationBarOptions {
      if let b = vcWithOptions.shouldReturnToMenu?() {
        childOfRoot = b
      }
    }
    
    var backButtonImage: UIImage!
    switch((navbar.hidden || childOfRoot, self.notificationCount)) {
    case (false, _):
      backButtonImage = UIImage(named: "back-btn")!
    case (_, 0):
      backButtonImage = UIImage(named: "menu")!
    case (_, let n):
      backButtonImage = imageWithBadge(UIImage(named: "menu")!, n.description)
    }
    navbar.backIndicatorImage = backButtonImage
    navbar.backIndicatorTransitionMaskImage = backButtonImage
  }
  
  func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
    self.setupBackButton(forViewController: viewController)
  }
  
  func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    let navbar = self.navigationBar
    
    navbar.tintColor = UIColor.whiteColor()
    navbar.barTintColor = UIColor.ringMainColor()
    
    var showNavBar = true
    if let vcWithOptions = viewController as? NavigationBarOptions {
      if let b = vcWithOptions.shouldShowNavigationBar?() {
        showNavBar = b
      }
    }
    
    UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -64), forBarMetrics: .Default)
    
    self.setNavigationBarHidden(!showNavBar, animated: animated)
    UIApplication.sharedApplication().statusBarStyle = showNavBar ? .LightContent : viewController.preferredStatusBarStyle()
  }
  
  // MARK: Navigation between different screens
  
  // Go to the view shown after the user logs in
  func pushUserDefaultViewController(animated: Bool) {
    let mainMenu = self.storyboard!.instantiateViewControllerWithIdentifier("MainMenu") as UIViewController
    let defaultVC = self.storyboard!.instantiateViewControllerWithIdentifier("doctors") as UIViewController
    
    self.viewControllers.append(mainMenu)
    self.pushViewController(defaultVC, animated: animated)
  }
  
  // Pop view controllers until right before the main menu
  func popToMenuChild() {
    for vc in (self.viewControllers as [UIViewController]).reverse() {
      if let vcWithOptions = vc as? NavigationBarOptions {
        if let b = vcWithOptions.shouldReturnToMenu?() {
          if b {
            self.popToViewController(vc, animated: true)
            return
          }
        }
      }
    }
    assert(false)
  }
}
