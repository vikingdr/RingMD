//
//  Timestamp.swift
//  Ring
//
//  Created by RingMD on 25/11/14.
//  Copyright (c) 2014 Medpats Global Pte. Ltd. All rights reserved.
//

import Foundation

struct Timestamp {
  let ISO8601String: String
  let date: NSDate
  
  init(ISO8601String: String) {
    self.ISO8601String = ISO8601String
    self.date = ISO8601DateFormatter().dateFromString(ISO8601String)
  }
  
  func absoluteDateAndTime() -> String {
    return date.userLocalStringWithFormat("yyyy-MM-dd HH:mm")
  }
}