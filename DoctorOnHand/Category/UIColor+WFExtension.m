//
//  UIColor+WFExtension.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "UIColor+WFExtension.h"

@implementation UIColor (WFExtension)

+ (UIColor *)getThemeColor {
    NSString *color = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeColorKey];
    if (!color || ![color isKindOfClass:[NSString class]]) {
        return kMainColor;
    } else {
        CIColor *colorRef = (CIColor *)[CIColor colorWithString:color];
        return [UIColor colorWithCIColor:colorRef];
    }
}

@end
