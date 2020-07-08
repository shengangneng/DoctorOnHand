//
//  NSString+WFExtension.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
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
