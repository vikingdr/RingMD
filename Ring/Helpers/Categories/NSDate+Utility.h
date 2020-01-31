;//
//  NSDate+Utility.h
//  Ring
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utility)
+ (NSString *)localTimezoneName;

+ (NSDate *)parse:(NSString *)dateString;
+ (NSDate *)ringShortDateParse:(NSString *)dateString;
+ (NSDate *)ringBusinessParse:(NSString *)dateString;
+ (NSDate *)ringHourParse:(NSString *)dateString;

- (NSString *)userLocalStringWithFormat:(NSString *)format;

+ (NSDate *)today8AM;
+ (NSDate *)tomorrow8AM;
+ (NSDate *)next2Days8AM;
+ (NSDate *)next3Days8AM;
+ (NSInteger)currentYear;
- (NSDate *) dateByAddingMonths: (NSInteger) monthsToAdd;


- (NSDate *)dateInNexMinutes:(NSInteger)minute;
- (NSString *)ISOString;
- (NSString *)hourFormat;
- (NSString *)hourWithoutAPFormat;
- (NSString *)defaultFormat;
- (NSString *)dateOnlyFormat;
- (NSString *)compactFormat:(BOOL)directionKnown;
- (NSString *)shortDisplayFormat;
- (NSString *)dateSubmitServerFormat;
- (NSString *)sumbitServerFormat;
- (NSString *)distanceTo:(NSDate *)date;
- (NSInteger)distanceToDate:(NSDate *)date;
- (NSString *)afterDistanceTo:(NSDate *)date;
- (NSString *)countDistanceTo:(NSDate *)date;
- (NSDate *)endOfDay;
- (NSDate *)endOfDay4Part;
- (NSDate *)beginOfDay;
- (NSDate *)noon;
- (NSDate *) endOfMonth;
- (NSDate *)beginOfMonth;
- (NSDate *)beginOfYear;
- (NSDate *)endOfYear;
- (NSString *)yearName;
- (NSString *)monthName;
- (NSInteger)hourValue;
- (NSInteger)minuteValue;
- (NSInteger)yearValue;
- (NSInteger)monthValue;
- (NSInteger)dayValue;
- (NSInteger)weekday;
@end
