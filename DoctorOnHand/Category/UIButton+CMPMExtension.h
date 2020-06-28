//
//  UIButton+CMPMExtension.h
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/7.
//  Copyright © 2019年 jifenzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CMPMExtension)

/** 设置普通按钮 */
+ (UIButton *)normalButtonWithTitle:(NSString *)title titleColor:(UIColor *)tColor bgcolor:(UIColor *)color;

/** 文字 + 背景图片按钮 */
+ (UIButton *)titleButtonWithTitle:(NSString *)title nTitleColor:(UIColor *)nColor hTitleColor:(UIColor *)hColor nBGImage:(UIImage *)nImage hImage:(UIImage *)hImage;

/** 文字 + 背景色按钮 */
+ (UIButton *)titleButtonWithTitle:(NSString *)title nTitleColor:(UIColor *)nColor hTitleColor:(UIColor *)hColor bgColor:(UIColor *)bgColor;

/** 背景图片按钮 */
+ (UIButton *)imageButtonWithImage:(UIImage *)image hImage:(UIImage *)hImage;

/** 图片按钮 */
+ (UIButton *)buttonWithNomalHignImage:(UIImage *)nimage selectImage:(UIImage *)sImage;

/** 文字在左 + 图片在右 */
+ (UIButton *)rightImageButtonWithTitle:(NSString *)title nTitleColor:(UIColor *)nColor hTitleColor:(UIColor *)hColor nImage:(UIImage *)nImage hImage:(UIImage *)hImage titleEdgeInset:(UIEdgeInsets)tInset imageEdgeInset:(UIEdgeInsets)imInset ;

/** 设置图片在上，文字在下的按钮 */
+ (UIButton *)imageUpTitleDownButtonWithTitle:(NSString *)title
                                   titleColor:(UIColor *)titleColor
                                    titleFont:(UIFont *)font
                                        image:(UIImage *)image
                                    highImage:(UIImage *)highImage
                               backgroupColor:(UIColor *)bgColor
                                 cornerRadius:(CGFloat)radius
                                       offset:(CGFloat)offset;

@end

NS_ASSUME_NONNULL_END
