//
//  UIView+Extention.h
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extention)

/**
 *  给view切圆角
 *  corners : 哪个角
 *  cornerRadii : 圆角size
 */
- (instancetype)cornerByRoundingCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius;
/**
 *  给view所有角切圆角
 *  cornerRadii : 圆角size
 */
- (instancetype)cornerAllCornersWithCornerRadius:(CGFloat)cornerRadius;

@end
