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
            WFTakePhotoPadViewController *takePhoto = [[WFTakePhotoPadViewController alloc] init];
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
            WFSignatureViewController *sign = [[WFSignatureViewController alloc] init];
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
            WFRecordAudioViewController *recordAudio = [[WFRecordAudioViewController alloc] init];
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
            WFRecordVideoPadViewController *recordVideo = [[WFRecordVideoPadViewController alloc] init];
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
            WFPlayVideoViewController *playVideo = [[WFPlayVideoViewController alloc] init];
            [((WFBaseNavigationController *)((WFWKWebViewController *)self.delegate).navigationController) pushViewController:playVideo animated:YES];
        } else if ([func isEqualToString:kLogout]) {
            // 退出登录
            WFLoginViewController *login = [[WFLoginViewController alloc] init];
            [((WFBaseNavigationController *)((WFWKWebViewController *)self.delegate).navigationController) pushViewController:login animated:YES];
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
            NSString *config = params[@"config"];
            WFLoginViewController *login = [[WFLoginViewController alloc] init];
            [((WFBaseNavigationController *)((WFWKWebViewController *)self.delegate).navigationController) pushViewController:login animated:YES];
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
