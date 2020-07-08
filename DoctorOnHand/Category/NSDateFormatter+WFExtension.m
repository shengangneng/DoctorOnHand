//
//  NSDateFormatter+WFExtension.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "NSDateFormatter+WFExtension.h"

@implementation NSDateFormatter (WFExtension)

/** 快速格式化日期，使用已经写好的格式 */
+ (NSString *)wf_formatterDate:(NSDate *)date withFormatterType:(WFDateFormatType)type {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatterType = nil;
    switch (type) {
        case kWFDateFormatTypeAll:                   { formatterType = @"yyyy-MM-dd HH:mm:ss"; }break;
        case kWFDateFormatTypeAllWithoutSeconds:     { formatterType = @"yyyy-MM-dd HH:mm"; }break;
        case kWFDateFormatTypeYearMonthDaySlash:     { formatterType = @"yyyy/MM/dd"; }break;
        case kWFDateFormatTypeYearMonthDayHourMinite:{ formatterType = @"MM月dd日HH:mm"; }break;
        case kWFDateFormatTypeShortYearMonthDaySlash:{ formatterType = @"yy/MM/dd"; }break;
        case kWFDateFormatTypeYearMonthDayBar:       { formatterType = @"yyyy-MM-dd"; }break;
        case kWFDateFormatTypeYearMonthBar:          { formatterType = @"yyyy-MM"; }break;
        case kWFDateFormatTypeShortYearMonthDayBar:  { formatterType = @"yy-MM-dd"; }break;
        case kWFDateFormatTypeYearMonthOnly:         { formatterType = @"yyyyMM"; }break;
        case kWFDateFormatTypeYearMonth:             { formatterType = @"yyyy年MM月"; }break;
        case kWFDateFormatTypeHourMinute:            { formatterType = @"HH:mm"; }break;
        case kWFDateFormatTypeHourMinuteSeconds:     { formatterType = @"HH:mm:ss"; }break;
        case kWFDateFormatTypeMonthYearDayWeek:      { formatterType = @"M月,yyyy年,d,EEE"; }break;
        case kWFDateFormatTypeMonthYearDayWeek2:     { formatterType = @"yyyy-MM-dd EEE"; }break;
        case kWFDateFormatTypeSpecial:               { formatterType = @"yyyy-MM-dd'T'HH:mm:ss.000'Z'"; }break;
        default:                                       { formatterType = @"yyyy-MM-dd HH:mm:ss"; }break;
    }
    [formatter setDateFormat:formatterType];
    return [formatter stringFromDate:date];
}

@end
