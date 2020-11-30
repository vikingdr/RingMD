//
//  StockControls.swift
//  Ring
//
//  Created by RingMD on 29/10/14.
//  Copyright (c) 2014 Matthew James All rights reserved.
//

import Foundation
import QuartzCore

class RingInputViewController : UIViewController {
  @IBOutlet private var mainContainer: UIView!
  @IBOutlet private var navigationBar: UINavigationBar!
  @IBOutlet private var button: UIBarButtonItem!
  
  private weak var hostView: UITextField!
  private var mainView: UIView!
  
  override init() {
    super.init(nibName: "RingInputViewController", bundle: nil)
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func setup(#hostView: UITextField, inputView: UIView) {
    self.hostView = hostView
    self.mainView = inputView
  }
  
  override func viewDidLoad() {
    assert(mainView != nil)
    mainContainer.frame = CGRectMake(0, 0, mainContainer.frame.size.width, 0)
    mainContainer.addSubview(mainView)
    
    navigationBar.tintColor = UIColor.ringMainColor()
    
    switch(hostView.returnKeyType) {
    case .Next:
      break
    case .Send:
      button.title = "Send"
    default:
      assertionFailure("Stock ring view has unsupported return key type")
    }
  }
  
  override func viewDidLayoutSubviews() {
    let size = mainContainer.frame.size
    var frame = mainView.frame
    frame.size = size
    mainView.frame = frame
//    mainView.sizeThatFits(mainContainer.frame.size)
  }
  
  @IBAction func didPressButton(sender: UIBarButtonItem) {
    hostView.delegate?.textFieldShouldReturn!(hostView)
  }
}

class RingTextField : UITextField {
  private var externalViewController: UIViewController?
  private var ringInputViewController: RingInputViewController?
  
  override var inputView: UIView? {
    set {
      if let newValue = newValue {
        let vc = RingInputViewController()
        vc.setup(hostView: self, inputView: newValue)
        ringInputViewController = vc
      } else {
        ringInputViewController = nil
      }
    }
    get {
      return ringInputViewController?.view
    }
  }
  
  func setInputViewController(viewController: UIViewController) {
    externalViewController = viewController
    inputView = viewController.view
  }
  
  override func addGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
    if self.ringInputViewController == nil {
      super.addGestureRecognizer(gestureRecognizer)
    } else if self.gestureRecognizers == nil {
      super.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "becomeFirstResponder"))
    }
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
}

class RingLabel: UILabel {
  required init(coder: NSCoder) {
    super.init(coder: coder)
    self.font = UIFont.ringFontOfSize(UIFont.ringFontSizes().textFontSize)
  }
}

class RingHighlightedLabel: RingLabel {
  required init(coder: NSCoder) {
    super.init(coder: coder)
    self.font = UIFont.boldRingFontOfSize(UIFont.ringFontSizes().textFontSize)
    self.textColor = UIColor.ringMainColor()
  }
}

class RingButton: UIButton {
  override var backgroundColor: UIColor? {
    get { return super.backgroundColor }
    set { }
  }
  
  override func intrinsicContentSize() -> CGSize {
    return CGSizeMake(super.intrinsicContentSize().width, 40)
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
    super.backgroundColor = UIColor.ringOrangeColor()
    
    self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    self.titleLabel?.font = UIFont.boldRingFontOfSize(14)
    
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 0;
    self.layer.masksToBounds = true;
  }
}
