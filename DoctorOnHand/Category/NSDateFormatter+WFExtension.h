//
//  NSDateFormatter+WFExtension.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WFDateFormatType) {
    kWFDateFormatTypeAll,                       /** 2018-05-10 21:33:03(yyyy-MM-dd HH:mm:ss) */
    kWFDateFormatTypeAllWithoutSeconds,         /** 2018-05-10 21:33(yyyy-MM-dd HH:mm) */
    kWFDateFormatTypeYearMonthDaySlash,         /** 2018/05/04(yyyy/MM/dd) */
    kWFDateFormatTypeYearMonthDayHourMinite,    /** 05月04日21:38(MM月dd日HH:mm) */
    kWFDateFormatTypeShortYearMonthDaySlash,    /** 18/05/04(yy/MM/dd) */
    kWFDateFormatTypeYearMonthDayBar,           /** 2018-05-04(yyyy-MM-dd) */
    kWFDateFormatTypeYearMonthBar,              /** 2018-05(yyyy-MM-dd) */
    kWFDateFormatTypeShortYearMonthDayBar,      /** 18-05-04(yy-MM-dd) */
    kWFDateFormatTypeYearMonthOnly,             /** 201805(yyyyMM) */
    kWFDateFormatTypeYearMonth,                 /** 2018年05月(yyyy年MM月) */
    kWFDateFormatTypeHourMinute,                /** 21:38(HH:mm) */
    kWFDateFormatTypeHourMinuteSeconds,         /** 21:38:55(HH:mm:ss) */
    kWFDateFormatTypeMonthYearDayWeek,          /** 4月,2018年,25,周五(MM月,yyyy年,d,EEE) */
    kWFDateFormatTypeMonthYearDayWeek2,         /** 2018-05-04 星期五(yyyy-MM-dd EEE) */
    kWFDateFormatTypeSpecial,                   /** 2018-05-10T21:33:03.000Z(yyyy-MM-ddTHH:mm:ss.000Z) */
};

@interface NSDateFormatter (WFExtension)

/** 快速格式化日期，使用已经写好的格式 */
+ (NSString *)wf_formatterDate:(NSDate *)date withFormatterType:(WFDateFormatType)type;

@end

NS_ASSUME_NONNULL_END
