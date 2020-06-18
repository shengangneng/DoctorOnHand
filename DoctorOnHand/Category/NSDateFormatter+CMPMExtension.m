//
//  NSDateFormatter+CMPMExtension.m
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/17.
//  Copyright © 2019年 jifenzhi. All rights reserved.
//

#import "NSDateFormatter+CMPMExtension.h"

@implementation NSDateFormatter (CMPMExtension)

/** 快速格式化日期，使用已经写好的格式 */
+ (NSString *)cmpm_formatterDate:(NSDate *)date withFormatterType:(CMPMDateFormatType)type {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatterType = nil;
    switch (type) {
        case kCMPMDateFormatTypeAll:                   { formatterType = @"yyyy-MM-dd HH:mm:ss"; }break;
        case kCMPMDateFormatTypeAllWithoutSeconds:     { formatterType = @"yyyy-MM-dd HH:mm"; }break;
        case kCMPMDateFormatTypeYearMonthDaySlash:     { formatterType = @"yyyy/MM/dd"; }break;
        case kCMPMDateFormatTypeYearMonthDayHourMinite:{ formatterType = @"MM月dd日HH:mm"; }break;
        case kCMPMDateFormatTypeShortYearMonthDaySlash:{ formatterType = @"yy/MM/dd"; }break;
        case kCMPMDateFormatTypeYearMonthDayBar:       { formatterType = @"yyyy-MM-dd"; }break;
        case kCMPMDateFormatTypeYearMonthBar:          { formatterType = @"yyyy-MM"; }break;
        case kCMPMDateFormatTypeShortYearMonthDayBar:  { formatterType = @"yy-MM-dd"; }break;
        case kCMPMDateFormatTypeYearMonthOnly:         { formatterType = @"yyyyMM"; }break;
        case kCMPMDateFormatTypeYearMonth:             { formatterType = @"yyyy年MM月"; }break;
        case kCMPMDateFormatTypeHourMinute:            { formatterType = @"HH:mm"; }break;
        case kCMPMDateFormatTypeHourMinuteSeconds:     { formatterType = @"HH:mm:ss"; }break;
        case kCMPMDateFormatTypeMonthYearDayWeek:      { formatterType = @"M月,yyyy年,d,EEE"; }break;
        case kCMPMDateFormatTypeMonthYearDayWeek2:     { formatterType = @"yyyy-MM-dd EEE"; }break;
        case kCMPMDateFormatTypeSpecial:               { formatterType = @"yyyy-MM-dd'T'HH:mm:ss.000'Z'"; }break;
        default:                                       { formatterType = @"yyyy-MM-dd HH:mm:ss"; }break;
    }
    [formatter setDateFormat:formatterType];
    return [formatter stringFromDate:date];
}

@end
