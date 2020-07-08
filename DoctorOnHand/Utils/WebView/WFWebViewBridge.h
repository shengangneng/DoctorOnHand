//
//  WFWebViewBridge.h
//  DoctorOnHand
//
//  Created by sgn on 2020/7/8.
//  Copyright © 2020 sgn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "WFWebDefaultView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WFWebViewBridge : NSObject

@property (nonatomic, copy, readonly) NSArray *cantPopVCName;         // 不能pop回的控制器列表

- (instancetype)initWithTargetWebview:(WKWebView *)webview cantPopVC:(NSArray *)cantPopVCName;
// 处理H5的操作
- (void)handleJSWithMessage:(WKScriptMessage *)message;

- (void)clean;

@end

NS_ASSUME_NONNULL_END
