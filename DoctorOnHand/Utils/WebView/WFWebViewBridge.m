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
#import "WFWebViewConst.h"
#import "NSCharacterSet+WFExtension.h"
#import "WFCustomNavigationBar.h"

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
        } else if ([func isEqualToString:kClearCache]) {
            // 清除缓存
        } else if ([func isEqualToString:kTakePhoto]) {
            // 拍照
        } else if ([func isEqualToString:kHandWriting]) {
            // 手写板
        } else if ([func isEqualToString:kRecordSound]) {
            // 录音
        } else if ([func isEqualToString:kRecordVideo]) {
            // 录视频
        } else if ([func isEqualToString:kPreviewImg]) {
            // 预览图片
        } else if ([func isEqualToString:kPlaySound]) {
            // 播放录音
        } else if ([func isEqualToString:kPlayVideo]) {
            // 播放视频
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
