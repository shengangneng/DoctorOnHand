//
//  WFWKWebViewController.h
//  DoctorOnHand
//
//  Created by sgn on 2020/7/8.
//  Copyright © 2020 sgn. All rights reserved.
//

#import "WFBaseViewController.h"
#import "WFWebViewUIConfiguration.h"
@class WFWebDefaultView;

NS_ASSUME_NONNULL_BEGIN

@interface WFWKWebViewController : WFBaseViewController

@property (nonatomic, strong) WFWebDefaultView *webDefaultView;                   /** 缺省页 */
@property (nonatomic, strong) WFWebViewUIConfiguration *webViewUIConfiguration;   /** 维护控制器的一些常用参数 */
@property (nonatomic, copy) NSString *originURLPrefix;                              /// 取最初加载的URL的前缀作为标示

#pragma mark - Init Method
- (instancetype)initToObserverEnterForegroundWithURL:(NSString *)url;
- (instancetype)initWithURL:(NSString *)url;
- (instancetype)initWithFileURL:(NSURL *)fileURL;

- (void)reloadURL;

#pragma mark - Public Method
- (void)loadURL:(NSString *)urlString;
// 清除资源并关闭webView
- (void)clearAndPop;
// 返回上一级历史，无历史则清除资源并关闭webView
- (void)back:(UIButton *)sender;
// 移除方法注入，否则会导致内存泄漏
- (void)removeScriptInject;
// 执行JS代码
- (void)evaluateJavaScript:(NSString *)js;
// 仅供二维码调用
- (void)scanCode:(NSString *)scanCodeString;
// 从后台切换到前台，会通知WKWebview待刷新
- (void)homePageNeedRefresh:(NSNotification *)notification;
/**
 * @brief 控制导航栏右上角按钮
 * @param show 控制显示和隐藏
 * @param ibType 图片类型的按钮
 * @param titles 用逗号分隔的标题字符串
 * @param webStringArray 跟titles为一一对应，把webStringArray里面的字符串模拟成点击WebView的操作
 */
- (void)operateNavRightBtnShow:(BOOL)show imageBtnType:(nullable NSString *)ibType titles:(nullable NSString *)titles webStringArray:(nullable NSArray <NSString *>*)webStringArray;

@end

NS_ASSUME_NONNULL_END
