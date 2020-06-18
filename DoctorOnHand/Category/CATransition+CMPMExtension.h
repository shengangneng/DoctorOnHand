//
//  CATransition+CMPMExtension.h
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/7.
//  Copyright © 2019年 shengangneng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CMPMTransitionType) {
    kCMPMTransitionTypeFade,         // 淡出
    kCMPMTransitionTypeMoveIn,       // 覆盖原图
    kCMPMTransitionTypePush,         // 推出
    kCMPMTransitionTypeReveal,       // 从底部显示出来
    kCMPMTransitionTypePageCurl,     // 向上翻一页
    kCMPMTransitionTypePageUnCurl,   // 向下翻一页
    kCMPMTransitionTypeRippleEffect, // 滴水效果
    kCMPMTransitionTypeSuckEffect,   // 收缩效果，如一块布被抽走
    kCMPMTransitionTypeCube,         // 立方体效果
    kCMPMTransitionTypeOglFlip,      // 上下翻转效果
};
typedef NS_ENUM(NSInteger, CMPMTransitionSubType) {
    kCMPMTransitionSubTypeFromRight, // 从右边
    kCMPMTransitionSubTypeFromLeft,  // 从左边
    kCMPMTransitionSubTypeFromTop,   // 从顶部
    kCMPMTransitionSubTypeFromBottom,// 从底部
};

@interface CATransition (CMPMExtension)

/**
 * @brief 快速创建CATransition
 * @param type 动画主类型
 * @param subType 动画子类型
 * @param duration 动画时长
 */
+ (instancetype)transitionWithType:(CMPMTransitionType)type subType:(CMPMTransitionSubType)subType duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
