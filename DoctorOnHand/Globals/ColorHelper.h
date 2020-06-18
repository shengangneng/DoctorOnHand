//
//  ColorHelper.h
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/7.
//  Copyright © 2019年 jifenzhi. All rights reserved.
//

#ifndef ColorHelper_h
#define ColorHelper_h
/************************************************************************************************************************/
/***** 系统颜色 *****/
#define kBlackColor         [UIColor blackColor]
#define kDarkGrayColor      [UIColor darkGrayColor]
#define kLightGrayColor     [UIColor lightGrayColor]
#define kWhiteColor         [UIColor whiteColor]
#define kGrayColor          [UIColor grayColor]
#define kRedColor           [UIColor redColor]
#define kGreenColor         [UIColor greenColor]
#define kBlueColor          [UIColor blueColor]
#define kCyanColor          [UIColor cyanColor]
#define kYellowColor        [UIColor yellowColor]
#define kMagentaColor       [UIColor magentaColor]
#define kOrangeColor        [UIColor orangeColor]
#define kPurpleColor        [UIColor purpleColor]
#define kBrownColor         [UIColor brownColor]
#define kClearColor         [UIColor clearColor]
/************************************************************************************************************************/
/***** 随机颜色 *****/
#define kColorRange 255.0
#define kRandomColorOfAlpha(a)      [UIColor colorWithRed:(arc4random()%255)/kColorRange green:(arc4random()%255)/kColorRange blue:(arc4random()%255)/kColorRange alpha:a]

/***** 设置颜色 *****/
#define kRGBA(r, g, b, a)           [UIColor colorWithRed:r/kColorRange green:g/kColorRange blue:b/kColorRange alpha:a]
#define kRGBColorHEX(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/kColorRange green:((float)((rgbValue & 0xFF00) >> 8))/kColorRange blue:((float)(rgbValue & 0xFF))/kColorRange alpha:1.0]

/***** 常用颜色 *****/
#define kMainColor                  kMainBlueColor                  // 主色调
#define kMainBlueColor              kRGBA(61, 128, 252, 1)          // 蓝色色调
#define kAttenBlueColor             kRGBA(60, 143, 232, 1)          // 考勤蓝色色调
#define kMainLightGrayColor         kRGBA(161, 161, 161, 1)         // 浅色
#define kSeperateColor              kRGBA(217, 217, 217, 1)         // 分割线颜色
#define kCommomBackgroundColor      kRGBA(245, 245, 245, 1)         // 常用灰色背景
#define kCommomBackgroundAlphaColor kRGBA(164, 158, 163, 0.38)      // 常用透明背景
#define kTextBlackColor             kRGBA(40, 40, 40, 1)            // 黑色文字颜色
#define kTextLightColor             kRGBA(128, 128, 128, 1)         // 浅色文字颜色
#define kTextLightColor2            kRGBA(204, 204, 204, 1)         // 浅色文字颜色
#define kButtonDisableColor         kRGBA(156, 190, 253, 1)         // 按钮不可点击颜色

#endif /* ColorHelper_h */
