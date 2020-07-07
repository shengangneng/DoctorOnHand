//
//  UIColor+WFExtension.m
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/11.
//  Copyright © 2019年 jifenzhi. All rights reserved.
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
