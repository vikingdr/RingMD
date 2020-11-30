//
//  NSDate+Utility.m
//  Ring
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

// It used to be the case that the server stored the user's timezone,
// and that times in Core Data were stored relative to this timezone.
// This then created the need for lots of functions that converted
// back and forth between device time and 'user time'.
//
// Since then we have moved on to solely use device time (with a
// timezone offset) and UTC time.
// (Business hours being the exception to this rule)


#import "NSDate+Utility.h"

#import "Ring-Essentials.h"

#import "ISO8601DateFormatter.h"
#import "RingAuthUser+Utility.h"

@implementation NSDate (Utility)
+ (NSString *)localTimezoneName
{
  return [[NSTimeZone localTimeZone] name];
}

- (NSInteger)userLocalDateComponent:(NSCalendarUnit)component
{
  NSCalendar *cal = [NSCalendar currentCalendar];
  NSDateComponents *components = [cal components:component fromDate:self];
  
  switch(component) {
    case NSCalendarUnitSecond:
      return components.second;
    case NSCalendarUnitMinute:
      return components.minute;
    case NSCalendarUnitHour:
      return components.hour;
    case NSCalendarUnitDay:
      return components.day;
    case NSCalendarUnitWeekday:
      return components.weekday;
    case NSCalendarUnitMonth:
      return components.month;
    case NSCalendarUnitYear:
      return components.year;
    default:
      assert(false);
  }
}

+ (NSString *)userLocalStringFromDate:(NSDate *)date withFormat:(NSString *)format
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.locale = [RingUtility ringLocale];
  [formatter setDateFormat:format];
  return [formatter stringFromDate:date];
}

- (NSString *)userLocalStringWithFormat:(NSString *)format
{
  return [NSDate userLocalStringFromDate:self withFormat:format];
}

+ (NSDate *)userLocalDateFromString:(NSString *)string withFormat:(NSString *)format
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.locale = [RingUtility ringLocale];
  [formatter setDateFormat:format];
  return [formatter dateFromString:string];
}

+ (NSDate *)parse:(NSString *)dateString
{
  if (dateString == nil || [dateString isEqual:[NSNull null]])
    return nil;
  ISO8601DateFormatter *dateFormat = [[ISO8601DateFormatter alloc] init];
  return [dateFormat dateFromString:dateString];
}

+ (NSDate *)ringHourParse:(NSString *)dateString
{
  assert(false); // needs testing or rewriting when business hours are re-enabled
  return [NSDate userLocalDateFromString:dateString withFormat:@"HH:mm"];
}

+ (NSDate *)ringShortDateParse:(NSString *)dateString
{
  assert(false); // needs testing or rewriting when business hours are re-enabled (used in RingDatePicker)
  return [NSDate userLocalDateFromString:dateString withFormat:@"EEE, MMM dd, yyyy, HH:mm"];
}

+ (NSDate *)ringBusinessParse:(NSString *)dateString
{
  assert(false); // needs testing or rewriting when business hours are re-enabled
  return [NSDate userLocalDateFromString:dateString withFormat:@"yyyy/MM/dd HH:mm"];
}

- (NSDate *)dateInNexMinutes:(NSInteger)minute
{
  return [self dateByAddingTimeInterval:60*minute];
}

- (NSString *)dateOnlyFormat // only for user-visible strings
{
  assert(false); // needs testing or rewriting when business hours are re-enabled (used in RingDatePicker)
  return [self userLocalStringWithFormat:@"EEE, MMM dd yyyy"];
}

- (NSString *)dateSubmitServerFormat
{
  return [self userLocalStringWithFormat:@"yyyy-MM-dd"];
}

- (NSString *)shortDisplayFormat // used only for user-visible strings
{
  assert(false); // needs testing or rewriting when busy times are re-enabled
  // NB this used to show the timezone
  // If it's decided to enable this again, perhaps show the city name
  return [NSString stringWithFormat:@"%@, %@",
          [self userLocalStringWithFormat:@"EEE, MMM dd"],
          [self hourFormat]];
}

- (NSString *)defaultFormat // used only for user-visible strings
{
  // This is used for user-visible time slot strings
  // NB this used to show the timezone
  // If it's decided to enable this again, perhaps show the city name
  return [NSString stringWithFormat:@"%@, %@",
          [self userLocalStringWithFormat:@"EEE, MMM d, yyyy"],
          [self hourFormat]];
}

- (NSString *)compactFormat:(BOOL)directionKnown // used only for user-visible strings
{
  NSDate *oneYearAgo = [[NSDate new] dateByAddingMonths:-12];
  NSDate *oneYearFromNow = [[NSDate new] dateByAddingMonths:12];
  
  NSString *fmt;
  if(directionKnown
     && [self compare:oneYearAgo] == NSOrderedDescending
     && [self compare:oneYearFromNow] == NSOrderedAscending) {
    fmt = @"MMM d";
  } else {
    fmt = @"MMM d, yyyy";
  }
  
  return [NSString stringWithFormat:@"%@, %@",
          [self userLocalStringWithFormat:fmt],
          [self hourFormat]];
}

- (NSString *)sumbitServerFormat
{
  //return [self userLocalStringWithFormat:@"MMM dd, yyyy HH:mm"];
  return [self ISOString];
}

- (NSString *)ISOString
{
  return [self userLocalStringWithFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSSSSZ"];
}

- (NSString *)hourWithoutAPFormat
{
  return [self userLocalStringWithFormat:@"HH:mm"];
}

- (NSString *)hourFormat // only for user-visible strings
{
  NSDateFormatter *fmt = [NSDateFormatter new];
  fmt.locale = [RingUtility ringLocale];
  fmt.dateStyle = NSDateFormatterNoStyle;
  fmt.timeStyle = NSDateFormatterShortStyle;
  return [fmt stringFromDate:self];
}

- (NSString *)countHourFormat
{
  return [self userLocalStringWithFormat:@"HH:mm:ss"];
}

- (NSString *)countMinuteFormat
{
  return [self userLocalStringWithFormat:@"mm:ss"];
}

- (NSDate *)noon
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:12];
  [parts setMinute:0];
  [parts setSecond:0];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)beginOfDay
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:0];
  [parts setMinute:0];
  [parts setSecond:0];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)endOfDay4Part
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:23];
  [parts setMinute:45];
  [parts setSecond:0];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)endOfDay
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:23];
  [parts setMinute:59];
  [parts setSecond:59];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)beginOfYear
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:0];
  [parts setMinute:0];
  [parts setSecond:0];
  [parts setMonth:1];
  [parts setDay:1];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)endOfYear
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:23];
  [parts setMinute:59];
  [parts setSecond:59];
  [parts setDay:28];
  [parts setMonth:12];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)beginOfMonth
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:0];
  [parts setMinute:0];
  [parts setSecond:0];
  [parts setDay:1];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *) dateByAddingMonths: (NSInteger) monthsToAdd
{
  NSCalendar * calendar = [NSCalendar currentCalendar];
  NSDateComponents * months = [[NSDateComponents alloc] init];
  [months setMonth:monthsToAdd];
  return [calendar dateByAddingComponents:months toDate:self options: 0];
}

- (NSDate *) endOfMonth
{
  NSCalendar * calendar = [NSCalendar currentCalendar];
  
  NSDate * plusOneMonthDate = [self dateByAddingMonths: 1];
  NSDateComponents * plusOneMonthDateComponents = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate: plusOneMonthDate];
  NSDate * endOfMonth = [[calendar dateFromComponents: plusOneMonthDateComponents] dateByAddingTimeInterval: -1]; // One second before the start of next month
  
  return endOfMonth;
}

+ (NSDate *)today8AM
{
  NSCalendar *cal = [NSCalendar currentCalendar];
  NSDate *date = [NSDate date];
  NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
  
  [components setHour:8];
  [components setMinute:0];
  [components setSecond:0];
  return [cal dateFromComponents:components];
}

+ (NSDate *)tomorrow8AM
{
  NSDate *date = [self today8AM];
  NSInteger minutes = 24 * 60;
  return [date dateInNexMinutes:minutes];
}

+ (NSDate *)next2Days8AM
{
  NSDate *date = [self today8AM];
  NSInteger minutes = 48 * 60;
  return [date dateInNexMinutes:minutes];
}

+ (NSDate *)next3Days8AM
{
  NSDate *date = [self today8AM];
  NSInteger minutes = 72 * 60;
  return [date dateInNexMinutes:minutes]; 
}

- (NSInteger)distanceToDate:(NSDate *)date
{
  unsigned int flags = NSDayCalendarUnit;
  if (!date)
    date = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:flags
                                             fromDate:self
                                               toDate:date
                                              options:0];
  return components.day;
}

- (NSString *)countDistanceTo:(NSDate *)date
{
  unsigned int flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  if (!date)
    date = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:flags
                                             fromDate:self
                                               toDate:date
                                              options:0];
  NSDate *distanceDate = [calendar dateFromComponents:components];
  if (components.hour > 0) {
    return [distanceDate countHourFormat];
  }
  return [distanceDate countMinuteFormat];
}

+ (NSInteger)currentYear
{
  NSCalendar *cal = [NSCalendar currentCalendar];
  NSDate *date = [NSDate date];
  NSDateComponents *components = [cal components:NSYearCalendarUnit fromDate:date];
  return components.year;
}

- (NSString *)afterDistanceTo:(NSDate *)date
{
  if (!date)
    date = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                             fromDate:date
                                               toDate:self
                                              options:0];
  NSString *distance;
  if (components.day > 0)
  {
    NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:@"MMM dd, HH:mm a"];
    dtFormatter.locale = [RingUtility ringLocale];
    distance = [dtFormatter stringFromDate:self];
    if (components.hour == 0 && components.minute == 0) {
      distance = [NSString stringWithFormat:@"in %d day%@",components.day, (components.day == 1 ? @"" : @"s")];
    } else {
      distance = [NSString stringWithFormat:@"in %d day%@ %dh %dmin",components.day,(components.day == 1 ? @"" : @"s"), components.hour, components.minute];
    }
  }
  else
  {
    if (components.hour > 0)
    {
      if (components.minute > 0)
        distance = [NSString stringWithFormat:@"in %dh %dmin", components.hour, components.minute];
      else
        distance = [NSString stringWithFormat:@"in %dh", components.hour];
    }
    else if (components.minute > 0)
    {
      distance = [NSString stringWithFormat:@"in %dmin", components.minute];
    }
    else
    {
      distance = @"now";
    }
  }
  return distance;
}

- (NSString *)distanceTo:(NSDate *)date
{
  return [self compactFormat:YES];
//  if (!date)
//    date = [NSDate date];
//  NSCalendar *calendar = [NSCalendar currentCalendar];
//  NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
//                                             fromDate:self
//                                               toDate:date
//                                              options:0];
//  NSString *distance;
//  if (components.day > 0)
//  {
//    distance = [self compactFormat:YES];
//  }
//  else
//  {
//    if (components.hour > 0)
//    {
//      if (components.minute > 0)
//        distance = [NSString stringWithFormat:@"%d hour(s) %d min(s) ago", components.hour, components.minute];
//      else
//        distance = [NSString stringWithFormat:@"%d hour(s) ago", components.hour];
//    }
//    else if (components.minute > 0)
//    {
//      distance = [NSString stringWithFormat:@"%d min(s) ago", components.minute];
//    }
//    else
//    {
//      distance = @"a few seconds ago";
//    }
//  }
//  return distance;
}
- (NSInteger)hourValue
{
  return [self userLocalDateComponent:NSHourCalendarUnit];
}

- (NSInteger)minuteValue
{
  return [self userLocalDateComponent:NSMinuteCalendarUnit];
}

- (NSInteger)dayValue
{
  return [self userLocalDateComponent:NSDayCalendarUnit];
}

- (NSInteger)yearValue
{
  return [self userLocalDateComponent:NSYearCalendarUnit];
}

- (NSInteger)monthValue
{
  return [self userLocalDateComponent:NSMonthCalendarUnit];
}

- (NSString *)monthName
{
  return [self userLocalStringWithFormat:@"MMMM"];
}

- (NSString *)yearName
{
  return [self userLocalStringWithFormat:@"yyyy"];
}

- (NSInteger)weekday
{
  return [self userLocalDateComponent:NSWeekdayCalendarUnit];
}
@end
