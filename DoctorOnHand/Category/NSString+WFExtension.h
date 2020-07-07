//
//  NSString+WFExtension.h
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/16.
//  Copyright © 2019年 jifenzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (WFExtension)

/** 去除字符串两边的空格 */
- (NSString *)clearSideSpace;
/** 是否图片后缀 */
- (BOOL)isPictureResource;
// 计算文字宽度
- (CGRect)testSizeWithMaxWidth:(CGFloat)masWidth textFont:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
