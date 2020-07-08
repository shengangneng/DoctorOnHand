//
//  Constant.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

/************************************************************************************************************************/
// 机型判断
#define kIsiPhoneX      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIsiPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIsiPhoneXSMAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define kStatusBarHeight    ((kIsiPhoneX || kIsiPhoneXR || kIsiPhoneXSMAX) ? 34 : 20)
#define kTopHeight          ((kIsiPhoneX || kIsiPhoneXR || kIsiPhoneXSMAX) ? 88 : 64)
#define kBottomHeight       ((kIsiPhoneX || kIsiPhoneXR || kIsiPhoneXSMAX) ? 34 : 0)
#define kTabbarHeight       49
#define kTabTotalHeight     ((kIsiPhoneX || kIsiPhoneXR || kIsiPhoneXSMAX) ? kTabbarHeight+34 : kTabbarHeight)

/************************************************************************************************************************/
/***** 格式化Log *****/
#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

/************************************************************************************************************************/
/***** 常用方法 *****/
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define ImageName(name) [UIImage imageNamed:name]
#define ImageContentOfFile(fileName, fileType) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(fileName) ofType:(fileType)]]
#define ViewWithTag(view, tag)   (id)[view viewWithTag: tag]
#define Font(name, fontSize)     [UIFont fontWithName:(name) size:(fontSize)]
#define SystemFont(fontSize)     [UIFont systemFontOfSize:fontSize]
#define BoldSystemFont(fontSize) [UIFont boldSystemFontOfSize:fontSize]
#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth    kScreenBounds.size.width
#define kScreenHeight   kScreenBounds.size.height
#define kThemeColorKey  @"CMPMThemeColor"

/************************************************************************************************************************/
/***** GCD *****/
#define kGlobalQueueDEFAULT       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kGlobalQueueHIGH          dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
#define kGlobalQueueLOW           dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
#define kGlobalQueueBACKGROUND    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
#define kMainQueue                dispatch_get_main_queue()

/************************************************************************************************************************/
/***** 防空异常 *****/
#define kIsNilString(str) (str.length == 0 || [str isEqualToString:@""] || [str stringByRemovingPercentEncoding].length == 0)
#define kSafeString(str) kIsNilString(str) ? @"" : str
#define kNoNullString(obj) [obj isKindOfClass:[NSString class]] ? kSafeString(obj) : @""
#define kNumberSafeString(obj) [obj isKindOfClass:[NSString class]] ? obj : ([obj isKindOfClass:[NSNumber class]] ? ((NSNumber *)obj).stringValue : @"")

/***** 常用标量 *****/
#define CLIENT_ID       @"app_mpm_ios"
#define CLIENT_SECRET   @"551d616b11414bcdac64622b04e6f392"
#define kWebViewNeedDeallocNotification @"webViewNeedDealloc"              // 当退出登录的时候，需要释放WKWebView

/********* 国际化 *********/
//#define Localized(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]
#define Localized(key) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",(([[NSUserDefaults standardUserDefaults] objectForKey:@"lang"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"] isEqualToString:@"system"]) ? [[NSUserDefaults standardUserDefaults] objectForKey:@"lang"] : [CMPMCommomTool getSystemFirstLangCode])] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"NLocalizable"]

#endif /* Constant_h */
