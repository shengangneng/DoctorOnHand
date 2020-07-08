//
//  NSString+WFExtension.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "NSString+WFExtension.h"

@implementation NSString (WFExtension)

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
