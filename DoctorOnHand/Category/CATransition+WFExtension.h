//
//  CATransition+WFExtension.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WFTransitionType) {
    kWFTransitionTypeFade,         // 淡出
    kWFTransitionTypeMoveIn,       // 覆盖原图
    kWFTransitionTypePush,         // 推出
    kWFTransitionTypeReveal,       // 从底部显示出来
    kWFTransitionTypePageCurl,     // 向上翻一页
    kWFTransitionTypePageUnCurl,   // 向下翻一页
    kWFTransitionTypeRippleEffect, // 滴水效果
    kWFTransitionTypeSuckEffect,   // 收缩效果，如一块布被抽走
    kWFTransitionTypeCube,         // 立方体效果
    kWFTransitionTypeOglFlip,      // 上下翻转效果
};
typedef NS_ENUM(NSInteger, WFTransitionSubType) {
    kWFTransitionSubTypeFromRight, // 从右边
    kWFTransitionSubTypeFromLeft,  // 从左边
    kWFTransitionSubTypeFromTop,   // 从顶部
    kWFTransitionSubTypeFromBottom,// 从底部
};

@interface CATransition (WFExtension)

/**
 * @brief 快速创建CATransition
 * @param type 动画主类型
 * @param subType 动画子类型
 * @param duration 动画时长
 */
+ (instancetype)transitionWithType:(WFTransitionType)type subType:(WFTransitionSubType)subType duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
