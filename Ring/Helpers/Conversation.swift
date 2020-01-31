//
//  ConversationView.swift
//  Ring
//
//  Created by RingMD on 12/11/14.
//  Copyright (c) 2014 Medpats Global Pte. Ltd. All rights reserved.
//

// TO DO: this code needs to be abstracted a little more and used for other 'infinite' table views

import Foundation

typealias JSONDict = [String: AnyObject]

private func loadConversationWindow(callback: (JSONDict, startIndex: Int) -> (), #otherUserId: Int, interval desiredInterval: Range<Int>, #didRequest: (Int) -> Bool, blockView: UIView? = nil) {
  let suggestedPadding = 5
  
  var alreadyLoadingAllIndices = true
  for idx in desiredInterval {
    if !didRequest(idx) {
      alreadyLoadingAllIndices = false
      break
    }
  }
  
  if alreadyLoadingAllIndices {
    println("Redundant request for records \(desiredInterval)")
    return
  }
  
  println("Was asked to download records \(desiredInterval)")
  
  let targetStartIndex = max(desiredInterval.startIndex - suggestedPadding, 0)
  var windowSize: Int = desiredInterval.endIndex - desiredInterval.startIndex - 1 + (suggestedPadding + desiredInterval.startIndex - targetStartIndex)
  var startPage = -1
  var startIndex = -1
  do {
    println("Determining request window")
    windowSize++
    
    startPage = targetStartIndex / windowSize + 1
    assert(startPage > 0)
    
    startIndex = (startPage - 1) * windowSize
    assert(startIndex <= max(0, desiredInterval.startIndex))
  } while(startIndex + windowSize < desiredInterval.endIndex)
  
  let requestedInterval = startIndex..<(startIndex + windowSize)
  for idx in requestedInterval {
    didRequest(idx)
  }
  
  println("Will download records \(requestedInterval)")
  
  NSURLRequest.ringRequest(method: "GET", call: "messages/to", params: ["receiver_id": otherUserId.description, "page": "\(startPage)", "per_page": "\(windowSize)", "include_record_count": "true"]).operation().perform({dict in
    let dict = dict as JSONDict
    callback(dict, startIndex: startIndex)
    }, blockView: blockView)
}

private let dummyCell = ConversationTableViewCell()

// conversations are displayed in chronological order, but we receive them in reversed order
// ConversationData helps with that
class ConversationData {
  private var requestedIndices = [Int: Void]()
  
  private var records = [Int: Message]()
  
  var count: Int = 0 {
    willSet {
      assert(newValue >= 0)
    }
    didSet {
      
    }
  }
  
  private func invert(idx: Int) -> Int {
    return count - idx - 1
  }
  
  func didRequest(idx: Int) -> Bool {
    let b = requestedIndices[invert(idx)] != nil
    requestedIndices[invert(idx)] = Void()
    return b
  }
  
  subscript(idx: Int) -> Message? {
    get {
      assert(count > idx)
      return records[invert(idx)]
    }
    set(newValue) {
      assert(count > idx)
      records[invert(idx)] = newValue
    }
  }
}

class ConversationDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
  private let currentUser: JSONDict
  private let otherUserId: Int
  private var recordViews = [ConversationTableViewCell]()
  private var heights = [Int: CGFloat]()
  private var data: ConversationData?
  
  init(currentUserName: String, currentUserAvatarURLString: String, otherUserId: Int) {
    self.otherUserId = otherUserId
    self.currentUser = ["full_name": currentUserName, "avatar": currentUserAvatarURLString]
  }
  
  class func initializeTableView(tableView: UITableView) {
    dummyCell.setup()
    tableView.estimatedRowHeight = dummyCell.sizeThatFits(CGSizeMake(tableView.frame.size.width, CGFloat.max)).height
    tableView.registerClass(ConversationTableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.allowsSelection = false
  }
  
  // convert between row indices and data indices
  // we do the same in ConversationData, which makes this kind of pointless
  // however, having this now will make it easier to abstract this class later
  func inverse(row: Int) -> Int {
    if let data = data {
      return data.count - row - 1
    } else {
      assert(false)
    }
  }
  
  func fetchNewData(tableView: UITableView) {
    loadRecords(0, tableView: tableView)
  }
  
  private func updateRecords(tableView: UITableView)(response: JSONDict, startIndex: Int) {
    let messages = response["messages"] as [JSONDict]
    let otherUser = response["user"] as JSONDict
    let recordCount = response["record_count"] as Int
    let interval = startIndex..<(startIndex + messages.count)
    
    println("Downloaded records \(interval)")
    
    let firstBatch = data!.count == 0
    let recordCountChanged = data!.count != recordCount
    
    if recordCountChanged {
      data!.count = recordCount
    }
    
    for (i, dict) in enumerate(messages) {
      let senderId = dict["sender_id"] as Int
      let currentUser = senderId == otherUserId ? otherUser : self.currentUser
      
      // TO DO: track online status
      let online = (senderId != otherUserId)
      
      data![i + startIndex] = Message(avatarURLString: currentUser["avatar"] as String, senderName: currentUser["full_name"] as String, senderIsOnline: online, timestamp: dict["created_at"] as String, htmlText: dict["content"] as String)
    }
    
    if recordCountChanged {
      tableView.reloadData()
      tableView.scrollToRowAtIndexPath(NSIndexPath(indexes: [0, recordCount - 1], length: 2), atScrollPosition: .Top, animated: !firstBatch)
    } else {
      for v in recordViews {
        if inverse(v.itemIndex) >= interval.startIndex && inverse(v.itemIndex) < interval.endIndex {
          configureView(v, tableView: tableView)
        }
      }
    }
  }
  
  private func configureView(cell: ConversationTableViewCell, tableView: UITableView) {
    if let record = data![inverse(cell.itemIndex)] {
      cell.setup(record)
    } else {
      cell.setup()
      loadRecords(inverse(cell.itemIndex), tableView: tableView)
    }
  }
  
  private func loadRecords(idx: Int, tableView: UITableView) {
    if data == nil {
      data = ConversationData()
    }
    
    let estimatedRecordsPerScreen = Int(ceilf(Float(tableView.frame.size.height) / Float(tableView.estimatedRowHeight)))
    let interval = max(idx, 0)..<(idx + estimatedRecordsPerScreen)
    loadConversationWindow(updateRecords(tableView), otherUserId: otherUserId, interval: interval, didRequest: data!.didRequest, blockView: idx == 0 ? tableView : nil)
  }
  
  // MARK UITableViewDataSource
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell") as ConversationTableViewCell
    recordViews.append(cell)
    cell.itemIndex = indexPath.row
    configureView(cell, tableView: tableView)
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let data = data {
      return data.count
    } else {
      loadRecords(0, tableView: tableView)
      return 0
    }
  }
  
  // MARK UITableViewDelegate
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
  {
    if let h = heights[inverse(indexPath.row)] {
      return h
    } else if let record = data![inverse(indexPath.row)] {
      dummyCell.setup(record)
      let h = dummyCell.sizeThatFits(CGSizeMake(tableView.frame.size.width, CGFloat.max)).height
      heights[inverse(indexPath.row)] = h
      return h
    } else {
      return tableView.estimatedRowHeight
    }
  }
}