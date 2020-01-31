//
//  Utility.swift
//  Ring
//
//  Created by RingMD on 10/11/14.
//  Copyright (c) 2014 Medpats Global Pte. Ltd. All rights reserved.
//

import Foundation

func doAfterDelay(f: dispatch_block_t!, #seconds: Double) {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), f)
}