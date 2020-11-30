//
//  Log.swift
//  Ring
//
//  Created by Jonas De Vuyst (RingMD) on 25/09/14.
//  Copyright (c) 2014 Matthew James All rights reserved.
//

import Foundation

private let webDir: String = {
  return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String
}()

private let webServer: GCDWebServer? = {
  if !RingSwiftBridge.debug() {
    return nil
  }
  
  let server = GCDWebServer()
  let r = server.startWithPort(1337, bonjourName: nil)
  assert(r)
  
  server.addGETHandlerForBasePath("/", directoryPath:webDir, indexFilename:nil, cacheAge:UInt.max, allowRangeRequests: true)
  
  return server
  }()

func serve(data: @autoclosure () -> NSData?) {
  if let webServer = webServer {
    if let data = data() {
      let name = "\(arc4random()).txt"
      let path = webDir.stringByAppendingPathComponent(name)
      data.writeToFile(path, atomically: true)
      println("🔎 \(webServer.serverURL)\(name)")
    } else {
      println("🔎 (empty document)")
    }
  }
}

func serve(text: @autoclosure () -> String?) {
  serve(text()?.dataUsingEncoding(NSUTF8StringEncoding))
}

func wut(message: String) {
  println("😡 \(message)")
}

func reportMemoryUsage() {
  let mebibytes = memoryUsage() / 1024 / 1024
  println("Using \(mebibytes) MiB")
}
