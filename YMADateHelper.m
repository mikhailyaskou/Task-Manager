//
//  YMADateHelper.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 10.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMADateHelper.h"

//static NSString * const YMADateFormat = @"mm:HH/dd.MM.yyyy";
static NSString * const YMADateFormat = @"dd.MM.yyyy";

@implementation YMADateHelper

+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:YMADateFormat];
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:YMADateFormat];
    return [formatter dateFromString:dateString];
}

@end
