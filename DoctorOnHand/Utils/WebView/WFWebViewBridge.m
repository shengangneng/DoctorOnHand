//
//  WFWebViewBridge.m
//  DoctorOnHand
//
//  Created by sgn on 2020/7/8.
//  Copyright © 2020 sgn. All rights reserved.
//

#import "WFWebViewBridge.h"
// 定位
#import "AppDelegate.h"
#import "WFWKWebViewController.h"
#import "WFBaseNavigationController.h"
#import "WFWebViewConst.h"
#import "NSCharacterSet+WFExtension.h"
#import "WFCustomNavigationBar.h"
#import "WFSignatureViewController.h"           /// 手写板
#import "WFRecordAudioViewController.h"         /// 录音
#import "WFRecordVideoPadViewController.h"      /// 录像
#import "WFTakePhotoPadViewController.h"        /// 拍照
#import "WFPlayVideoViewController.h"           /// 播放视频
#import "WFLoginViewController.h"               /// 登录页
#import "WFAudioPlayer.h"                       /// 单例：播放语音

@interface WFWebViewBridge ()

@property (nonatomic, weak) WKWebView *targetWebView;
@property (nonatomic, copy) NSArray *cantPopVC;

@property (nonatomic, strong) NSMutableDictionary *callbackDic;             /** 记录异步回调方法的字典。key为方法名，value为回调方法名，回调成功之后删除对应的key */

@end


@implementation WFWebViewBridge

- (instancetype)initWithTargetWebview:(WKWebView *)webview cantPopVC:(NSArray *)cantPopVCName {
    self = [super init];
    if (self) {
        self.targetWebView = webview;
        self.cantPopVC = cantPopVCName;
        self.callbackDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray *)cantPopVCName {
    return self.cantPopVC;
}

- (void)clean {
    // 关闭定位、关闭网络监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.callbackDic removeAllObjects];
}

- (void)handleJSWithMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"logout"]) {
        
    } else {
        NSData *jsonData = [message.body dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * msgBody = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        NSString *func = [msgBody objectForKey:@"func"];
        NSDictionary *params = [[msgBody objectForKey:@"params"] isKindOfClass:[NSDictionary class]] ? ((NSDictionary *)[msgBody objectForKey:@"params"]) : nil;
        NSString *callback = [msgBody objectForKey:@"callback"];
//        if ([func isEqualToString:kTakePhoto]) {
//            func = kConsultation;
//            params = @{@"url":@"https://www.baidu.com"};
//        }
        
        if ([func isEqualToString:kGetAccountInfo]) {
            // 登录后获取用户信息
            /*
             callback = appFuncResponseCallback;
             func = getAccountInfo;
             params =     {
                 msg = getAccountInfo;
             };
             */
        } else if ([func isEqualToString:kClearCache]) {
            // 清除缓存
            
        } else if ([func isEqualToString:kTakePhoto]) {
            // 拍照
            /*
             callback = appFuncResponseCallback;
             func = takePhoto;
             params =     {
                 msg = takePhoto;
             };
             */
            NSString *registerId = params[@"registerId"];
            WFTakePhotoPadViewController *takePhoto = [[WFTakePhotoPadViewController alloc] initWithRegisterId:registerId];
            [((WFBaseNavigationController *)((WFWKWebViewController *)self.delegate).navigationController) pushViewController:takePhoto animated:YES];
        } else if ([func isEqualToString:kHandWriting]) {
            // 手写板
            /*
             callback = appFuncResponseCallback;
             func = handWriting;
             params =     {
                 msg = handWriting;
             };
             */
            NSString *registerId = params[@"registerId"];
            WFSignatureViewController *sign = [[WFSignatureViewController alloc] initWithRegisterId:registerId];
            [((WFBaseNavigationController *)((WFWKWebViewController *)self.delegate).navigationController) pushViewController:sign animated:YES];
            
        } else if ([func isEqualToString:kRecordSound]) {
            // 录音
            /*
            callback = appFuncResponseCallback;
            func = recordSound;
            params =     {
                msg = recordSound;
            };
             */
            NSString *registerId = params[@"registerId"];
            WFRecordAudioViewController *recordAudio = [[WFRecordAudioViewController alloc] initWithRegisterId:registerId];
            [((WFBaseNavigationController *)((WFWKWebViewController *)self.delegate).navigationController) pushViewController:recordAudio animated:YES];
            
        } else if ([func isEqualToString:kRecordVideo]) {
            // 录视频
            /*
             callback = appFuncResponseCallback;
             func = recordVideo;
             params =     {
                 msg = recordVideo;
             };
             */
            NSString *registerId = params[@"registerId"];
            WFRecordVideoPadViewController *recordVideo = [[WFRecordVideoPadViewController alloc] initWithRegisterId:registerId];
            [((WFBaseNavigationController *)((WFWKWebViewController *)self.delegate).navigationController) pushViewController:recordVideo animated:YES];
        } else if ([func isEqualToString:kPreviewImg]) {
            // 预览图片
            /*
             callback = cb;
             func = previewImg;
             params =     {
                 data = "[{\"name\":\"\U56fe\U7247/\U674e\U4e3b\U4efb\U7684\U67e5\U623f\U8bb0\U5f55\",\"url\":\"https://cn.vuejs.org/images/logo.png\"}]";
                 msg = previewImg;
             };
             */
            NSString *urlString = [[params[@"data"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[urlString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            NSString *url = dic[@"url"];
            if (kIsNilString(url)) {
                url = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1141259048,554497535&fm=26&gp=0.jpg";
            }
            WFWKWebViewController *webView = [[WFWKWebViewController alloc] initWithURL:url];
            [((WFBaseNavigationController *)((WFWKWebViewController *)self.delegate).navigationController) pushViewController:webView animated:YES];
            
        } else if ([func isEqualToString:kPlaySound]) {
            // 播放录音
            /*
            callback = cb;
            func = playSound;
            params =     {
                data = "[{\"name\":\"\U64ad\U653e\U5f55\U97f3\",\"url\":\"\"}]";
                msg = playSound;
            };
            */
            NSString *urlString = [[params[@"data"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[urlString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            NSString *url = dic[@"url"];
            if (kIsNilString(url)) {
                url = @"http://dict.youdao.com/dictvoice?audio=people&type=2";
            }
            [[WFAudioPlayer shareAudioPlayer] playAudioWithURL:url];
        } else if ([func isEqualToString:kPlayVideo]) {
            // 播放视频
            /*
             callback = cb;
             func = playVideo;
             params =     {
                 data = "[{\"name\":\"\U64ad\U653e\U89c6\U9891\",\"url\":\"\"}]";
                 msg = playVideo;
             };
             */
            NSString *urlString = [[params[@"data"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[urlString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
            NSString *url = dic[@"url"];
            WFPlayVideoViewController *playVideo = [[WFPlayVideoViewController alloc] initWithURL:url];
            [((WFBaseNavigationController *)((WFWKWebViewController *)self.delegate).navigationController) pushViewController:playVideo animated:YES];
        } else if ([func isEqualToString:kLogout]) {
            // 退出登录
            [kAppDelegate logout];
        } else if ([func isEqualToString:kGetConfigUrl]) {
            // 调出配置页面
            NSString *path = [[NSBundle mainBundle] pathForResource:(@"index") ofType:@"html" inDirectory:@"WebResources/config"];
            WFWKWebViewController *web = [[WFWKWebViewController alloc] initWithFileURL:[NSURL fileURLWithPath:path]];
            web.webViewUIConfiguration.navHidden = YES;
            web.webViewUIConfiguration.webViewScrollEnabled = YES;
            WFBaseNavigationController *nav = [[WFBaseNavigationController alloc] initWithRootViewController:web];
            [UIApplication sharedApplication].delegate.window.rootViewController = nav;
        } else if ([func isEqualToString:kSetConfigUrl]) {
            // 确定了配置信息，传到壳保存（然后跳到登录页）
            NSString *frontHost = params[@"frontHost"];
            NSString *backHost = params[@"backHost"];
            NSArray *frontArr = [frontHost componentsSeparatedByString:@":"];
            NSArray *backArr = [frontHost componentsSeparatedByString:@":"];
            if (kIsNilString(frontHost) || frontArr.count != 2) {
                frontHost = @"10.0.1.102:8081";
            }
            if (kIsNilString(backHost) || backArr.count != 2) {
                backHost = @"10.0.1.102:9098";
            }
            kAppDelegate.frontHost = frontHost;
            kAppDelegate.backHost = backHost;
            [[NSUserDefaults standardUserDefaults] setValue:frontHost forKey:kFrontHost];
            [[NSUserDefaults standardUserDefaults] setValue:backHost forKey:kBackHost];
            WFLoginViewController *login = [[WFLoginViewController alloc] init];
            [((WFBaseNavigationController *)((WFWKWebViewController *)self.delegate).navigationController) pushViewController:login animated:YES];
       } else if ([func isEqualToString:kConsultation]) {
           // 使用带有导航栏的webview跳转客服系统
           if (self.delegate && [self.delegate isKindOfClass:[WFBaseViewController class]]) {
               NSString *url = params[@"url"];
               // 控制导航栏隐藏或者显示的参数
               NSNumber *navBarHidden = [params[@"navBarHidden"] isKindOfClass:[NSString class]] ? @(((NSString *)params[@"navBarHidden"]).integerValue) : params[@"navBarHidden"];
               NSNumber *needExitBtn = [params[@"needExitBtn"] isKindOfClass:[NSString class]] ? @(((NSString *)params[@"needExitBtn"]).integerValue) : params[@"needExitBtn"];
               NSNumber *scrollEnabled = [params[@"scrollEnabled"] isKindOfClass:[NSString class]] ? @(((NSString *)params[@"scrollEnabled"]).integerValue) : params[@"scrollEnabled"];
               NSNumber *type = [params[@"type"] isKindOfClass:[NSString class]] ? @(((NSString *)params[@"type"]).integerValue) : params[@"type"];
               WFWKWebViewController *web;
               NSString *titleRGB = params[@"titleRGB"];
               NSString *bgRGB = params[@"bgRGB"];
               NSString *title = params[@"title"];
               if (!kIsNilString(titleRGB) && !kIsNilString(bgRGB)) {
                   // 如果有传递背景颜色值和标题颜色值过来
                   UIColor *titleColor = kRGBA([titleRGB componentsSeparatedByString:@","].firstObject.doubleValue, [titleRGB componentsSeparatedByString:@","][1].doubleValue, [titleRGB componentsSeparatedByString:@","].lastObject.doubleValue, 1);
                   UIColor *bgColor = kRGBA([bgRGB componentsSeparatedByString:@","].firstObject.doubleValue, [bgRGB componentsSeparatedByString:@","][1].doubleValue, [bgRGB componentsSeparatedByString:@","].lastObject.doubleValue, 1);
                   [((WFCustomNavigationBar *)(WFBaseNavigationController *)((WFBaseViewController *)self.delegate).navigationController.navigationBar) updateTitleColor:titleColor backgroundColor:bgColor];
                   web = [[WFWKWebViewController alloc] initWithURL:url];
                   web.webViewUIConfiguration.backButtonColor = titleColor;
               } else {
                   [((WFCustomNavigationBar *)(WFBaseNavigationController *)((WFBaseViewController *)self.delegate).navigationController.navigationBar) updateTitleColor:kBlackColor backgroundColor:kWhiteColor];
                   web = [[WFWKWebViewController alloc] initWithURL:url];
               }
               web.webViewUIConfiguration.navHidden = navBarHidden.boolValue;
               web.webViewUIConfiguration.needExit = needExitBtn.boolValue;
               web.webViewUIConfiguration.title = title;
               web.webViewUIConfiguration.nExit = type.boolValue;
               web.webViewUIConfiguration.webViewScrollEnabled = scrollEnabled.boolValue;
               [((WFBaseNavigationController *)((WFBaseViewController *)self.delegate).navigationController) pushViewController:web animated:YES];
           } else if ([func isEqualToString:kSetStatusBarColor]) {
               NSNumber *rValue = [params[@"rValue"] isKindOfClass:[NSString class]] ? @(((NSString *)params[@"rValue"]).integerValue) : params[@"rValue"];
               NSNumber *gValue = [params[@"gValue"] isKindOfClass:[NSString class]] ? @(((NSString *)params[@"gValue"]).integerValue) : params[@"gValue"];
               NSNumber *bValue = [params[@"bValue"] isKindOfClass:[NSString class]] ? @(((NSString *)params[@"bValue"]).integerValue) : params[@"bValue"];
               if (self.delegate) {
                   UIColor *color = kRGBA(rValue.intValue, gValue.intValue, bValue.intValue, 1);
                   UIColor *title_back_color;
                   if ([color isEqual:kRGBA(255, 255, 255, 1)]) {
                       // 如果背景色是白色，则返回按钮、标题是黑色
                       title_back_color = kBlackColor;
                   } else {
                       title_back_color = kWhiteColor;
                   }
                   [((WFCustomNavigationBar *)(WFBaseNavigationController *)((WFBaseViewController *)self.delegate).navigationController.navigationBar) updateTitleColor:title_back_color backgroundColor:kRGBA(rValue.intValue, gValue.intValue, bValue.intValue, 1)];
                   ((WFWKWebViewController *)self.delegate).webViewUIConfiguration.navColor = kRGBA(rValue.intValue, gValue.intValue, bValue.intValue, 1);
                   ((WFWKWebViewController *)self.delegate).webViewUIConfiguration.backButtonColor = title_back_color;
              }
              
          }
       }
    }
}

#pragma mark - 浏览器缓存
// 获取浏览器缓存
- (float)allCachesSize {
    NSString *cachPath = [ NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [self folderSizeAtPath:cachPath];
}

- (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize];
    }
    return 0 ;
}

- (float)folderSizeAtPath:(NSString *)folderPath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil ) {
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}

// 清理浏览器缓存
- (void)clearCaches {
    NSString *cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray *files = [[NSFileManager defaultManager ] subpathsAtPath:cachPath];
    for (NSString *p in files) {
        NSError *error = nil;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath:path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath:path error:&error];
        }
    }
}


@end
