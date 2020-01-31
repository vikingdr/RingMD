//
//  Avatar.swift
//  Ring
//
//  Created by RingMD on 10/11/14.
//  Copyright (c) 2014 Medpats Global Pte. Ltd. All rights reserved.
//

import Foundation

class AvatarView: UIView {
  private let pictureView = UIImageView(frame: CGRectMake(1, 1, 52, 52))
  private let overlayView = UIImageView(frame: CGRectMake(0, 0, 54, 54))
  private let statusView = UIView(frame: CGRectMake(43, 43, 11, 11))
  private let badgeView = UILabel(frame: CGRectMake(38, 0, 16, 16))
  private let size = CGSizeMake(54, 54)
  private var avatarURLString = ""
  
  override init() {
    super.init()
    initialize()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  private func initialize() {
    let bgColor = UIColor.whiteColor()
    
    self.backgroundColor = bgColor
    
    overlayView.image = UIImage(named: "avatar-bg")
    
    statusView.layer.borderColor = bgColor.CGColor
    statusView.layer.borderWidth = 1
    statusView.layer.cornerRadius = statusView.frame.size.height / 2
    statusView.layer.masksToBounds = true
    
    badgeView.hidden = true
    badgeView.font = UIFont.ringFontOfSize(12)
    badgeView.textAlignment = .Center
    badgeView.textColor = UIColor.whiteColor()
    badgeView.backgroundColor = UIColor.ringOrangeColor()
    badgeView.layer.cornerRadius = 3
    badgeView.layer.masksToBounds = true
    
    for v in [pictureView, overlayView, statusView, badgeView] {
      addSubview(v)
    }
    
    setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
    setContentCompressionResistancePriority(1000, forAxis: .Vertical)
    setContentHuggingPriority(1000, forAxis: .Horizontal)
    setContentHuggingPriority(1000, forAxis: .Vertical)
  }
  
  override func sizeThatFits(size: CGSize) -> CGSize {
    return self.size
  }
  
  override func intrinsicContentSize() -> CGSize {
    return size
  }
  
  func setAvatar(avatarURLString: String) {
    if(avatarURLString != self.avatarURLString) {
      self.pictureView.image = nil
      self.avatarURLString = avatarURLString
      
      NSURLRequest(URL: NSURL(string: avatarURLString)!).operation()
        .deliverCacheableData({data in
          if self.avatarURLString == avatarURLString {
            self.pictureView.image = UIImage(data: data as NSData)
          }
          },
          slowMark: {
            if self.pictureView.image == nil {
              self.pictureView.image = UIImage(named: "default-avatar")
            }
        })
    }
  }
  
  func setOnlineStatus(online: Bool) {
    statusView.backgroundColor = online ? UIColor.ringMainColor() : UIColor.ringOffLineColor()
  }
  
  func setBadge(text: String) {
    badgeView.text = text
    badgeView.hidden = text.isEmpty
  }
  
  func setup(avatarURLString: String, online: Bool, badgeText: String) {
    setAvatar(avatarURLString)
    setOnlineStatus(online)
    setBadge(badgeText)
  }
}