//
//  RingAttachFile+Utility.m
//  Ring
//
//  Created by Medpats on 1/24/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingAttachFile+Utility.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"

#import "RingMessage.h"

@implementation RingAttachFile (Utility)
+ (RingAttachFile *)createEmpty
{
  return [NSEntityDescription
          insertNewObjectForEntityForName:@"RingAttachFile"
          inManagedObjectContext:[RingData sharedInstance].managedObjectContext];;
}
+ (RingAttachFile *)insertWithJSON:(NSDictionary *)jsonData
{
  RingAttachFile *message = [self createEmpty];
  if (jsonData)
    [message updateAttributeWithJson:jsonData];
  return message;
}

+ (RingAttachFile *)findById:(NSNumber *)attachFileId
{
  return (RingAttachFile *)[[RingData sharedInstance] findSingleEntity:@"RingAttachFile" withPredicateString:@"attachFileId == %@" andArguments:@[attachFileId] withSortDescriptionKey:nil];
}

+ (RingAttachFile *)insertOrUpdateWithJSON:(NSDictionary *)jsonData withIdKey:(NSString *)key
{
  RingAttachFile *message = [self findById:[jsonData objectForKey:key]];
  if (message)
    [message updateAttributeWithJson:jsonData];
  else {
    message = [RingAttachFile insertWithJSON:jsonData];
    message.attachFileId = @([[jsonData objectForKey:key] integerValue]);
  }
  return message;
}

+ (RingAttachFile *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  return [self insertOrUpdateWithJSON:jsonData withIdKey:@"id"];
}

+ (NSArray *)insertOrUpdateWithJSONArray:(NSArray *)jsonArray
{
  NSMutableArray *results = [NSMutableArray array];
  if (jsonArray)
  {
    for (NSDictionary *messageJson in jsonArray) {
      [results addObject:[RingAttachFile insertOrUpdateWithJSON:messageJson]];
    }
  }
  return results;
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{@"name" : @"file_name", @"attachFileId": @"id", @"contentType" : @"content_type"};
  
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
}

- (NSURL *)tempFileURL
{
  return self.tempFilePath ? [NSURL fileURLWithPath:self.tempFilePath] : nil;
}

- (NSData *)attachData
{
  NSLog(@"Loading %@ into memory", self.tempFilePath);
  return [NSData dataWithContentsOfURL:self.tempFileURL];
}

- (void)setAttachData:(NSData *)data
{
  [self removeTempFile];
  self.tempFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo].globallyUniqueString stringByAppendingString:self.name]];
  [data writeToFile:self.tempFilePath atomically:NO];
}

- (NSDictionary *)toParameters
{
  return @{@"attach_file" : @{@"path": self.name, @"content_type" : self.contentType, @"attachable_type" : @"Message", @"file_size" : @([self.attachData length])}};
}

- (void)fetchDataWithSuccessBlock:(void(^)())success
{
  if(self.tempFilePath) {
    success();
    return;
  }
  
  AFHTTPRequestOperation *operation = [RingUtility operationWithMethod:@"GET" params:@{} path:[NSString stringWithFormat:attachFilePath, self.attachFileId]];
  [operation perform:^(NSDictionary *fileInfo) {
    NSString *url = fileInfo[@"path"];
    assert(url != nil);
    [[[AFHTTPRequestOperation alloc] initWithGetURLString:url] perform:^(NSData *data) {
      self.attachData = data;
      success();
    } modally:YES json:NO];
  } modally:YES json:YES];
}

- (void)removeTempFile
{
  if(self.tempFilePath) {
    NSError *err = nil;
    [[NSFileManager defaultManager] removeItemAtURL:self.tempFileURL error:&err];
    assert(err == nil);
    self.tempFilePath = nil;
  }
}
@end
