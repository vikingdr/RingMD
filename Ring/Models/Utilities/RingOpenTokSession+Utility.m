//
//  RingOpenTokSession+Utility.m
//  Ring
//
//  Created by Tan Nguyen on 9/13/13.
//  Copyright (c) 2013 Matthew James All rights reserved.
//

#import "RingOpenTokSession+Utility.h"

#import "Ring-Essentials.h"

@implementation RingOpenTokSession (Utility)
+ (RingOpenTokSession *)insertWithJSON:(NSDictionary *)jsonData
{
  RingOpenTokSession *session = [NSEntityDescription
                    insertNewObjectForEntityForName:@"RingOpenTokSession"
                    inManagedObjectContext:[RingData sharedInstance].managedObjectContext];
  if (jsonData)
    [session updateAttributeWithJson:jsonData];
  return session;
}

+ (RingOpenTokSession *)findById:(NSNumber *)sessionId
{
  return (RingOpenTokSession *)[[RingData sharedInstance] findSingleEntity:@"RingOpenTokSession" withPredicateString:@"sessionId == %@" andArguments:@[sessionId] withSortDescriptionKey:nil];
}

+ (RingOpenTokSession *)insertOrUpdateWithJSON:(NSDictionary *)jsonData
{
  RingOpenTokSession *session = [self findById:[jsonData objectForKey:@"session_id"]];
  if (session)
    [session updateAttributeWithJson:jsonData];
  else
    session = [RingOpenTokSession insertWithJSON:jsonData];
  
  return session;
}

- (void)updateAttributeWithJson:(NSDictionary *)jsonData
{
  NSDictionary *params = @{ @"token" : @"token", @"sessionId": @"session_id"};
  
  for (NSString *key in [params allKeys]) {
    [RingUtility parseJsonAttributeWithObject:self andJsonData:jsonData andPropertyName:key andJsonKey:[params objectForKey:key]];
  }
}

@end
