//
//  CATransition+WFExtension.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "CATransition+WFExtension.h"

@implementation CATransition (WFExtension)

+ (instancetype)transitionWithType:(WFTransitionType)type subType:(WFTransitionSubType)subType duration:(NSTimeInterval)duration {
    CATransition *animate = [CATransition animation];
    NSString *typeName;
    switch (type) {
        case kWFTransitionTypeFade:{
            typeName = kCATransitionFade;
        }break;
        case kWFTransitionTypeMoveIn:{
            typeName = kCATransitionMoveIn;
        }break;
        case kWFTransitionTypePush:{
            typeName = kCATransitionPush;
        }break;
        case kWFTransitionTypeReveal:{
            typeName = kCATransitionReveal;
        }break;
        case kWFTransitionTypePageCurl:{
            typeName = @"pageCurl";
        }break;
        case kWFTransitionTypePageUnCurl:{
            typeName = @"pageUnCurl";
        }break;
        case kWFTransitionTypeRippleEffect:{
            typeName = @"rippleEffect";
        }break;
        case kWFTransitionTypeSuckEffect:{
            typeName = @"suckEffect";
        }break;
        case kWFTransitionTypeCube:{
            typeName = @"cube";
        }break;
        case kWFTransitionTypeOglFlip:{
            typeName = @"oglFlip";
        }break;
        default:{
            typeName = kCATransitionFade;
        }break;
    }
    
    NSString *subTypeName;
    switch (subType) {
        case kWFTransitionSubTypeFromRight:{
            subTypeName = kCATransitionFromRight;
        }break;
        case kWFTransitionSubTypeFromLeft:{
            subTypeName = kCATransitionFromLeft;
        }break;
        case kWFTransitionSubTypeFromTop:{
            subTypeName = kCATransitionFromTop;
        }break;
        case kWFTransitionSubTypeFromBottom:{
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
