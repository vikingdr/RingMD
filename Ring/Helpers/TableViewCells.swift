//
//  UserAspectView.swift
//  Ring
//
//  Created by RingMD on 10/11/14.
//  Copyright (c) 2014 Matthew James All rights reserved.
//

import Foundation

private let padding: CGFloat = 10

class AvatarTableViewCell: UITableViewCell {
  var itemIndex: Int = -1
  let avatarView = AvatarView()
  var mainView: UIView!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialize()
  }
  
  override convenience init() {
    self.init(style: .Default, reuseIdentifier: "AvatarTableViewCell")
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
    initialize()
  }
  
  func obtainMainView() -> UIView {
    assertionFailure("need to override createMainView()")
  }
  
  private func initialize() {
    mainView = obtainMainView()
    contentView.addSubview(avatarView)
    contentView.addSubview(mainView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    avatarView.sizeToFit()
    var frame = avatarView.frame
    
    frame.origin = CGPointMake(padding, padding)
    avatarView.frame = frame
    
    frame.origin.x += frame.size.width + padding
    let maxWidth = self.frame.size.width - frame.size.width - padding * 3
    frame.size = mainView.sizeThatFits(CGSizeMake(maxWidth, CGFloat.max))
    assert(frame.size.width <= maxWidth)
    mainView.frame = frame
  }
  
  override func sizeThatFits(size: CGSize) -> CGSize {
    let avatarSize = avatarView.intrinsicContentSize()
    
    let availableMainSize = CGSizeMake(size.width - padding * 3 - avatarSize.width, size.height)
    
    return CGSizeMake(size.width, 2 * padding + max(avatarSize.height, mainView.sizeThatFits(availableMainSize).height))
  }
}

private class VStackView: UIView {
  override func layoutSubviews() {
    let availableSpace = CGSizeMake(self.frame.size.width, CGFloat.max)
    var pos = CGPointZero
    
    for v in self.subviews as [UIView] {
      var size = v.sizeThatFits(availableSpace)
      size.width = availableSpace.width
//      size.width = min(size.width, availableSpace.width)
      v.frame = CGRect(origin: pos, size: size)
      pos.y += size.height
    }
  }
  
  override func sizeThatFits(size: CGSize) -> CGSize {
//    var maxWidth: CGFloat = 0
    var totalHeight: CGFloat = 0
    
    for v in self.subviews as [UIView] {
      let sizeThatFits = v.sizeThatFits(size)
//      maxWidth = max(maxWidth, sizeThatFits.width)
      totalHeight += sizeThatFits.height
    }
    
//    maxWidth = min(maxWidth, size.width)
    return CGSizeMake(size.width, totalHeight)
  }
}

private class HStackView: UIView {
  init(views: UIView...) {
    super.init()
    for v in views as [UIView] {
      addSubview(v)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func layoutSubviews() {
    let hpadding: CGFloat = 2
    
    var availableSpace = self.frame.size
    var pos = CGPointZero
    
    var height: CGFloat = 0
    
    for v in self.subviews as [UIView] {
      v.frame = CGRect(origin: pos, size: v.sizeThatFits(availableSpace))
      pos.x += v.frame.size.width + hpadding
      availableSpace.width -= (v.frame.size.width + hpadding)
      
      height = max(height, v.frame.size.height)
    }
    
    for v in self.subviews as [UIView] {
      var frame = v.frame
      frame.origin.y = (height - frame.size.height) / 3 * 2
      // frame.size.height = height
      v.frame = frame
    }
    
    let lastView = self.subviews.last as UIView
    lastView.frame.size.width = availableSpace.width - lastView.frame.origin.x
  }
  
  override func sizeThatFits(size: CGSize) -> CGSize {
    var maxHeight: CGFloat = 0
    var totalWidth: CGFloat = 0
    
    for v in self.subviews as [UIView] {
      let sizeThatFits = v.sizeThatFits(size)
      maxHeight = max(maxHeight, sizeThatFits.height)
      totalWidth += sizeThatFits.width
    }
    
    maxHeight = min(maxHeight, size.height)
    
    return CGSizeMake(totalWidth, maxHeight)
  }
}

private enum LabelType {
  case name
  case specialty
  case rate
  case summary
  case prose
  case timestamp
  case subject
  
  func createLabel() -> UILabel {
    let l = UILabel()
    l.lineBreakMode = .ByTruncatingMiddle
    
    switch(self) {
    case .name:
      l.font = UIFont.boldRingFontOfSize(14)
    default:
      l.font = UIFont.ringFontOfSize(12)
      l.textColor = UIColor.ringDarkGrayColor()
    }
    
    return l
  }
}

struct Message {
  let avatarURLString: String
  let senderName: String
  let senderIsOnline: Bool = false
  let timestamp: String
  let htmlText: String
  
  func attributedText(#font: UIFont) -> NSAttributedString {
    if let data = "<a href='http://example.com'>TEST</a>x".dataUsingEncoding(NSUnicodeStringEncoding) {
      if let attrString = NSMutableAttributedString(data: data,
        options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
      documentAttributes: nil,
        error: nil) {
          attrString.addAttributes([NSFontAttributeName: font], range: NSMakeRange(0, attrString.length))
          return attrString
      }
    }
    
    println("Failed to convert “\(htmlText)” to an attributed string")
    return NSAttributedString(string: "")
  }
}

class ConversationTableViewCell: AvatarTableViewCell {
  private let nameLabel = LabelType.name.createLabel()
  private let timestampLabel = LabelType.timestamp.createLabel()
  private let messageBodyLabel = LabelType.prose.createLabel()
  
  override func obtainMainView() -> UIView {
    let v = VStackView()
    
    let clock = UIImageView(image: UIImage(named: "clock"))
    for x in [nameLabel, HStackView(views: clock, timestampLabel), messageBodyLabel] {
      v.addSubview(x)
    }
    
    messageBodyLabel.numberOfLines = 0
    
    return v
  }
  
  func setup(message: Message) {
    avatarView.setup(message.avatarURLString, online: message.senderIsOnline, badgeText: "")
    avatarView.hidden = false
    
    nameLabel.text = message.senderName
    timestampLabel.text = Timestamp(ISO8601String: message.timestamp).absoluteDateAndTime()
    messageBodyLabel.attributedText = message.attributedText(font: messageBodyLabel.font)
  }
  
  func setup() {
    avatarView.hidden = true
    nameLabel.text = " "
    timestampLabel.text = "Loading…"
    messageBodyLabel.text = " "
  }
}
