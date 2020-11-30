//
//  RingAudioHelper.m
//  Ring
//
//  Created by Medpats on 2/6/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingAudioHelper.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>

@implementation RingAudioHelper

+ (void)setSpeakerEnabled
{
  AVAudioSession *session = [AVAudioSession sharedInstance];
  
  assert(session.category == AVAudioSessionCategoryPlayAndRecord);
  
  NSError *err = nil;
  [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                             error:&err];
  
  if(err) {
    NSLog(@"Failed to activate speaker: %@", err);
  }
}

+ (void)deactiveSession
{
  AVAudioSession *audioSession = [AVAudioSession sharedInstance];
  [audioSession setActive:NO error:nil];
}

+ (void)initSession
{
  NSError *setCategoryErr = nil;
  AVAudioSession *session = [AVAudioSession sharedInstance];
  [session setCategory: AVAudioSessionCategoryPlayAndRecord error: &setCategoryErr];
}

+ (NSDictionary *)initRecordSetting
{
  NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
  
  [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
  [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
  [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
  return recordSetting;
}
@end
