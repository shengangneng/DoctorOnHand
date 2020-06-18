//
//  CATransition+CMPMExtension.m
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/7.
//  Copyright © 2019年 shengangneng. All rights reserved.
//

#import "CATransition+CMPMExtension.h"

@implementation CATransition (CMPMExtension)

+ (instancetype)transitionWithType:(CMPMTransitionType)type subType:(CMPMTransitionSubType)subType duration:(NSTimeInterval)duration {
    CATransition *animate = [CATransition animation];
    NSString *typeName;
    switch (type) {
        case kCMPMTransitionTypeFade:{
            typeName = kCATransitionFade;
        }break;
        case kCMPMTransitionTypeMoveIn:{
            typeName = kCATransitionMoveIn;
        }break;
        case kCMPMTransitionTypePush:{
            typeName = kCATransitionPush;
        }break;
        case kCMPMTransitionTypeReveal:{
            typeName = kCATransitionReveal;
        }break;
        case kCMPMTransitionTypePageCurl:{
            typeName = @"pageCurl";
        }break;
        case kCMPMTransitionTypePageUnCurl:{
            typeName = @"pageUnCurl";
        }break;
        case kCMPMTransitionTypeRippleEffect:{
            typeName = @"rippleEffect";
        }break;
        case kCMPMTransitionTypeSuckEffect:{
            typeName = @"suckEffect";
        }break;
        case kCMPMTransitionTypeCube:{
            typeName = @"cube";
        }break;
        case kCMPMTransitionTypeOglFlip:{
            typeName = @"oglFlip";
        }break;
        default:{
            typeName = kCATransitionFade;
        }break;
    }
    
    NSString *subTypeName;
    switch (subType) {
        case kCMPMTransitionSubTypeFromRight:{
            subTypeName = kCATransitionFromRight;
        }break;
        case kCMPMTransitionSubTypeFromLeft:{
            subTypeName = kCATransitionFromLeft;
        }break;
        case kCMPMTransitionSubTypeFromTop:{
            subTypeName = kCATransitionFromTop;
        }break;
        case kCMPMTransitionSubTypeFromBottom:{
            subTypeName = kCATransitionFromBottom;
        }break;
        default:{
            subTypeName = kCATransitionFromRight;
        }break;
    }
    
    animate.type = typeName;
    animate.subtype = subTypeName;
    animate.duration = duration;
    return animate;
}

@end
