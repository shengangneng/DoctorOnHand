//
//  NSString+CMPMExtension.m
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/16.
//  Copyright © 2019年 jifenzhi. All rights reserved.
//

#import "NSString+CMPMExtension.h"

@implementation NSString (CMPMExtension)

/** 去除字符串两边的空格 */
- (NSString *)clearSideSpace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/** 是否图片后缀 */
- (BOOL)isPictureResource {
    if ([self isEqualToString:@"png"] ||
        [self isEqualToString:@"jpg"] ||
        [self isEqualToString:@"jpeg"] ||
        [self isEqualToString:@"gif"]) {
        return YES;
    }
    return NO;
}

- (CGRect)testSizeWithMaxWidth:(CGFloat)masWidth textFont:(UIFont *)font {
    return [self boundingRectWithSize:CGSizeMake(masWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
}

@end
