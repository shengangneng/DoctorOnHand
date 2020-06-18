//
//  UIColor+CMPMExtension.m
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/11.
//  Copyright © 2019年 jifenzhi. All rights reserved.
//

#import "UIColor+CMPMExtension.h"

@implementation UIColor (CMPMExtension)

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
