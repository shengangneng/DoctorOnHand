//
//  WFCommomTool.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFCommomTool.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation WFCommomTool

+ (void)showTextWithTitle:(NSString *)title inView:(UIView *)view animation:(BOOL)animation {
    if (![NSThread currentThread].isMainThread) {
        dispatch_async(kMainQueue, ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animation];
            hud.mode = MBProgressHUDModeText;
            hud.removeFromSuperViewOnHide = YES;
            hud.label.text = title;
            hud.label.numberOfLines = 0;
            [hud hideAnimated:YES afterDelay:1.0];
        });
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animation];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.label.text = title;
    hud.label.numberOfLines = 0;
    [hud hideAnimated:YES afterDelay:1.0];
}

/**
 *  验证手机号
 *  @return 是否正确的手机号
 */
- (BOOL)checkPhoneNumInput:(NSString*)mobileNumber {
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:mobileNumber];
    BOOL res2 = [regextestcm evaluateWithObject:mobileNumber];
    BOOL res3 = [regextestcu evaluateWithObject:mobileNumber];
    BOOL res4 = [regextestct evaluateWithObject:mobileNumber];
    if (res1 || res2 || res3 || res4) {
        return YES;
    } else {
        return NO;
    }
}


+ (BOOL)validateMobile:(NSString *)mobileNo {
    // 跟PC端一样，以1开头，11位即可通过验证
    NSString *MOBILE = @"^1\\d{10}$";
    NSPredicate *regexTestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    if ([regexTestMobile evaluateWithObject:mobileNo]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isURL:(NSString *)url {
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:url];
}

/** 检查网络是否真正可用 */
+ (BOOL)checkNetworkCanUse {
    __block BOOL canUse = NO;
    NSString *urlString = @"http://captive.apple.com/";
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 3;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    //**// 使用信号量实现NSURLSession同步请求**
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString* result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        // 解析html页面
        NSString *htmlString = [self filterHTML:result];
        // 除掉换行符
        NSString *resultString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        if ([resultString isEqualToString:@"SuccessSuccess"]) {
            canUse = YES;
        } else {
            canUse = NO;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return canUse;
}

+ (NSString *)filterHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        // (you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    return html;
}

+ (NSString *)getSIMCountryCode {
    // CTTelephonyNetworkInfo object is your entry point to the telephony service
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    // 一个CTCarrier对象，包含有关用户的家庭蜂窝服务提供商的信息
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    // ISO 3166-1 country code string:http://doc.chacuo.net/iso-3166-1
    return carrier.isoCountryCode.uppercaseString;
}

+ (BOOL)checkiOS9AndLaterCanUse {
    if (@available(iOS 9.0, *)) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)getSystemFirstLangCode {
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) {
        // 英文
        language = @"en";
    } else {
        // 否则都默认为中文
        language = @"zh-Hans";
    }
    return language;
}

+ (NSString *)getLangParamForURL {
    NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:@"lang"];
    NSString *param;
    if ([lang.lowercaseString isEqualToString:@"en"]) {
        param = @"lang=en";
    } else if ([lang.lowercaseString isEqualToString:@"zh-hans"]) {
        param = @"lang=zh_CN";
    } else {
        param = @"lang=system";
    }
    return param;
}

+ (NSString *)getLangCodeForH5 {
    NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:@"lang"];
    NSString *code;
    if ([lang.lowercaseString isEqualToString:@"en"]) {
        code = @"en";
    } else if ([lang.lowercaseString isEqualToString:@"zh-hans"]) {
        code = @"zh_CN";
    } else {
        code = @"system";
    }
    return code;
}

+ (NSString *)getLangCodeForHTTPHeader {
    NSString *currentH5Code = [self getLangCodeForH5];
    if ([currentH5Code isEqualToString:@"system"]) {
        if ([[NSLocale preferredLanguages].firstObject hasPrefix:@"en"]) {
            // 英文
            currentH5Code = @"en";
        } else {
            // 否则都默认为中文
            currentH5Code = @"zh-Hans";
        }
    }
    return currentH5Code;
}

@end
