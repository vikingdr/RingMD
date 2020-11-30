//
//  RingAudioHelper.h
//  Ring
//
//  Created by Medpats on 2/6/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

@interface RingAudioHelper : NSObject
+ (void)setSpeakerEnabled;
+ (void)initSession;
+ (NSDictionary *)initRecordSetting;
+ (void)deactiveSession;
@end
