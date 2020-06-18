//
//  NSDateFormatter+CMPMExtension.h
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/17.
//  Copyright © 2019年 jifenzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CMPMDateFormatType) {
    kCMPMDateFormatTypeAll,                       /** 2018-05-10 21:33:03(yyyy-MM-dd HH:mm:ss) */
    kCMPMDateFormatTypeAllWithoutSeconds,         /** 2018-05-10 21:33(yyyy-MM-dd HH:mm) */
    kCMPMDateFormatTypeYearMonthDaySlash,         /** 2018/05/04(yyyy/MM/dd) */
    kCMPMDateFormatTypeYearMonthDayHourMinite,    /** 05月04日21:38(MM月dd日HH:mm) */
    kCMPMDateFormatTypeShortYearMonthDaySlash,    /** 18/05/04(yy/MM/dd) */
    kCMPMDateFormatTypeYearMonthDayBar,           /** 2018-05-04(yyyy-MM-dd) */
    kCMPMDateFormatTypeYearMonthBar,              /** 2018-05(yyyy-MM-dd) */
    kCMPMDateFormatTypeShortYearMonthDayBar,      /** 18-05-04(yy-MM-dd) */
    kCMPMDateFormatTypeYearMonthOnly,             /** 201805(yyyyMM) */
    kCMPMDateFormatTypeYearMonth,                 /** 2018年05月(yyyy年MM月) */
    kCMPMDateFormatTypeHourMinute,                /** 21:38(HH:mm) */
    kCMPMDateFormatTypeHourMinuteSeconds,         /** 21:38:55(HH:mm:ss) */
    kCMPMDateFormatTypeMonthYearDayWeek,          /** 4月,2018年,25,周五(MM月,yyyy年,d,EEE) */
    kCMPMDateFormatTypeMonthYearDayWeek2,         /** 2018-05-04 星期五(yyyy-MM-dd EEE) */
    kCMPMDateFormatTypeSpecial,                   /** 2018-05-10T21:33:03.000Z(yyyy-MM-ddTHH:mm:ss.000Z) */
};

@interface NSDateFormatter (CMPMExtension)

/** 快速格式化日期，使用已经写好的格式 */
+ (NSString *)cmpm_formatterDate:(NSDate *)date withFormatterType:(CMPMDateFormatType)type;

@end

NS_ASSUME_NONNULL_END
