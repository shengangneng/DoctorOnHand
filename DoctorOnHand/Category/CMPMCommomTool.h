//
//  CMPMCommomTool.h
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/12.
//  Copyright © 2019年 jifenzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMPMCommomTool : NSObject

+ (void)showTextWithTitle:(NSString *)title inView:(UIView *)view animation:(BOOL)animation;

/**
 *  @brief 验证手机号
 *  @return 是否正确的手机号
 */
- (BOOL)checkPhoneNumInput:(NSString *)mobileNumber;

+ (BOOL)validateMobile:(NSString *)mobileNo;

/**
 * 判断输入的字符串是不是URL
 */
+ (BOOL)isURL:(NSString *)url;

/** 检查网络是否真正可用 */
+ (BOOL)checkNetworkCanUse;

/** 获取手机运营商的国家code */
+ (NSString *)getSIMCountryCode;

/**
 * @brief 是否iOS9.0以上，iOS9.0以下的话不允许使用App
 * @return 返回是否是iOS9.0以上
 */
+ (BOOL)checkiOS9AndLaterCanUse;

/**
 * @brief 返回当前系统的首选语言
 * @return 要么是zh-Hans中文、要么是en英文
 */
+ (NSString *)getSystemFirstLangCode;

/**
 * @brief 拼接好传入URL中的参数
 * @return lang=en、lang=zh_CN、lang=system
 */
+ (NSString *)getLangParamForURL;

/**
 * @brief 获取传给H5所需的语言参数
 * @return 英文en、中文zh_CN、跟随系统system
 */
+ (NSString *)getLangCodeForH5;


/**
 * @brief 获取接口请求头lang字段参数
 * @return 英文en、中文zh_CN、跟随系统system
*/
+ (NSString *)getLangCodeForHTTPHeader;

@end

NS_ASSUME_NONNULL_END
