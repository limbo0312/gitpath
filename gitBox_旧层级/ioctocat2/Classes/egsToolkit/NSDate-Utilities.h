/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (Utilities)

// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isSameMonthAsDate: (NSDate *) aDate; 
- (BOOL) isThisMonth;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;
- (BOOL) isInFuture;
- (BOOL) isInPast;

// Date roles
- (BOOL) isTypicallyWorkday;
- (BOOL) isTypicallyWeekend;

// Adjusting dates
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateAtStartOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger) distanceInDaysToDate:(NSDate *)anotherDate;

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;
@property (readonly) NSInteger age;//====获取生日   age



///---------------------------------------------------------------------------------------
/// 第二种方式
//
//  NSDate+Utilities.h
//  MiddMenus
//
//  Created by Thomas Beatty on 1/21/13.
//  Copyright (c) 2013 Thomas Beatty. All rights reserved.
//
///---------------------------------------------------------------------------------------

/**
 Returns a new object the same day at the date specified.
 
 The object returned is at midnight of the morning of the date parameter. Does not preserve time, only day. Time zone is preserved.
 
 @param date Date to find the day of.
 
 @return NSDate A new NSDate object on the same day as date.
 */
+(NSDate *)dayOf:(NSDate *)date;

/**
 Returns a new object the day after the date specified.
 
 The object returned is at midnight of the morning of the day after the date parameter. Does not preserve time, only day. Time zone is preserved.
 
 @param date Date to find the day after.
 
 @return NSDate A new NSDate object the day after date.
 */
+(NSDate *)dayAfter:(NSDate *)date;

/**
 Returns a new object the day before the date specified.
 
 The object returned is at midnight of the morning of the day before the date parameter. Does not preserve time, only day. Time zone is preserved.
 
 @param date Date to find the day before.
 
 @return NSDate A new NSDate object the day before date.
 */
+(NSDate *)dayBefore:(NSDate *)date;

/**
 Returns the current date as a unix timestring.
 
 @return NSString The current Unix timestamp formatted as a string.
 */
+(NSString *)currentUnixTimestampString;

/**
 Returns the current date as a unix timestamp.
 
 @return NSNumber The current Unix timestamp formatted as a number.
 */
+(NSNumber *)currentUnixTimestampNumber;

///---------------------------------------------------------------------------------------
/// @name Instance Methods
///---------------------------------------------------------------------------------------

/**
 Compares two dates to see if they are the same.
 
 @param date The date to compare.
 
 @return BOOL YES if the dates are on the same day, NO otherwise.
 */
-(BOOL)isSameDayAsDate:(NSDate*)date;

/**
 Reports the time of the date parameter as an integer between 0 and 2400 in UTC.
 
 @param date NSDate date to be analyzed.
 
 @return NSInteger Representation of the datetime between 0 and 2400. Always less than 2400.
 */
-(NSInteger)time;

/**
 Reports the time of the date parameter as an integer between 0 and 2400. The time is reported as the local time of the device.
 
 @param date NSDate date to be analyzed.
 
 @return NSInteger Representation of the datetime between 0 and 2359.
 */
-(NSInteger)localTime;


@end
