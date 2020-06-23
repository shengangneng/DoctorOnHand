//
//  UIView+Extention.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "UIView+Extention.h"

@implementation UIView (Extention)

- (instancetype)cornerAllCornersWithCornerRadius:(CGFloat)cornerRadius {
    
    return [self cornerByRoundingCorners:UIRectCornerAllCorners cornerRadius:cornerRadius];
}


- (instancetype)cornerByRoundingCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.layer.contentsScale = [[UIScreen mainScreen] scale];
    return self;
}


@end
