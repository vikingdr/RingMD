//
// FileUpload.swift
// Ring
//
// Created by Jonas De Vuyst (RingMD) on 25/09/14.
// Copyright (c) 2014 Matthew James All rights reserved.
//

import Foundation

private func postToS3(dict: NSDictionary, #data: NSData, #filename: NSString, #mimeType: String, #proceed: () -> ()) {
  // Dict is a JSON dictionary returned by the RingMD server
  // See https://aws.amazon.com/articles/1434
  
  let url = dict["direct_fog_url"] as String
  
  let key = dict["key"] as String
  let accessKey = dict["aws_access_key_id"] as String
  let acl = dict["acl"] as String
  let policy = dict["policy"] as String
  let signature = dict["signature"] as String
  
  let params: [String: String] = ["utf8": "", "key": key, "AWSAccessKeyId": accessKey, "acl": acl, "policy": policy, "signature": signature, "success_action_status": "200"]
  
  var error: NSError?
  let request = AFHTTPRequestSerializer().multipartFormRequestWithMethod("POST", URLString: url, parameters: params, constructingBodyWithBlock: { formData in
    formData.appendPartWithFileData(data, name: "file", fileName: filename, mimeType: mimeType)
    }, error: &error)
  assert(error == nil)
  
  request.operation().perform({x in proceed()}, modally: true, json: false)
}

private func upload(call: String, #data: NSData, #filename: String, #mimeType: String, #proceed: (String) -> ()) {
  NSURLRequest.ringRequest(method: "GET", call: call).operation().perform({json in
    let dict = json as NSDictionary
    
    let url = (dict["direct_fog_url"] as String).stringByAppendingString(dict["key"] as String).stringByReplacingOccurrencesOfString("${filename}", withString: filename, options: nil, range: nil)
    
    postToS3(dict, data: data, filename: filename, mimeType: mimeType, proceed: {proceed(url)})
    }, modally: true)
}

@objc class FileUploader {
  class func uploadImageAttachment(image: UIImage, proceed: (String, String, NSData) -> ()) {
    let data = UIImageJPEGRepresentation(image, 0.7)
    let contentType = "image/jpeg"
    upload("uploader/attachment", data: data, filename: "picture.jpg", mimeType: contentType, proceed: {url in proceed(url, contentType, data)})
  }
  
  class func uploadAudioAttachment(data: NSData, proceed: (String, String, NSData) -> ()) {
    let contentType = "audio/mp4"
    upload("uploader/attachment", data: data, filename: "audio.m4a", mimeType: contentType, proceed: {url in proceed(url, contentType, data)})
  }
  
  class func uploadAvatar(image: UIImage, proceed: (String) -> ()) {
    let data = UIImageJPEGRepresentation(image, 0.7)
    upload("uploader/avatar", data: data, filename: "picture.jpg", mimeType: "image/jpeg", proceed: proceed)
  }
}
