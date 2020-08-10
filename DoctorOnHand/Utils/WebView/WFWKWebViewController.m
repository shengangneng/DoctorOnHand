//
//  WFWKWebViewController.m
//  DoctorOnHand
//
//  Created by sgn on 2020/7/8.
//  Copyright © 2020 sgn. All rights reserved.
//

#import "WFWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "UIButton+WFExtension.h"
#import "WFWebViewBridge.h"
#import "AppDelegate.h"
#import "WFWebViewConst.h"
#import "WFWebDefaultView.h"
#import "NSCharacterSet+WFExtension.h"
#import "WFCustomNavigationBar.h"
#import "WFCustomNavLeftButton.h"
#import "UIViewController+WFExtention.h"
#import "WFCommomTool.h"

#define URL_CUT_LENGTH 50

@interface WFWKWebViewController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, WFWebDefaultViewDelegate, UIGestureRecognizerDelegate, WFWebViewBridgeDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property (nonatomic, strong) WFWebViewBridge *webViewBridge;             /** 与H5交互的类 */
@property (nonatomic, strong) WFCustomNavLeftButton *backButton;          /** 返回按钮（包含exitButton) */
@property (nonatomic, strong) UIProgressView *progressView;                 /** 进度条 */

// Datas
@property (nonatomic, copy) NSString *url;                                  /** 记录跳转url */
@property (nonatomic, strong) NSURL *fileURL;                               /** 记录本地文件URL */

@end

@implementation WFWKWebViewController

- (instancetype)initToObserverEnterForegroundWithURL:(NSString *)url {
    self = [self init];
    if (self) {
        self.url = url;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePageNeedRefresh:) name:UIApplicationWillEnterForegroundNotification object:nil];
        if (self.url.length > URL_CUT_LENGTH) {
            self.originURLPrefix = [self.url substringToIndex:URL_CUT_LENGTH];
        }
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)url {
    self = [self init];
    if (self) {
        self.url = url;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePageNeedRefresh:) name:UIApplicationWillEnterForegroundNotification object:nil];
        if (self.url.length > URL_CUT_LENGTH) {
            self.originURLPrefix = [self.url substringToIndex:URL_CUT_LENGTH];
        }
    }
    return self;
}

- (instancetype)initWithFileURL:(NSURL *)fileURL {
    self = [self init];
    if (self) {
        self.fileURL = fileURL;
    }
    return self;
}

- (void)reloadURL {
    [self.webView reload];
}

#pragma mark - UIApplicationWillEnterForegroundNotification
- (void)homePageNeedRefresh:(NSNotification *)notification {
    if (self.isViewLoaded && self.view.window) {
        [self mpm_homepageNeedRefresh];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.webViewBridge = [[WFWebViewBridge alloc] initWithTargetWebview:self.webView cantPopVC:@[@"WFQRCodeViewController"]];
        self.webViewBridge.delegate = self;
        self.webViewUIConfiguration = [WFWebViewUIConfiguration defaultUIConfiguration];
        // 当退出登录的时候，需要释放WKWebView
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewNeedDealloc) name:kWebViewNeedDeallocNotification object:nil];
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
        [self.webViewUIConfiguration addObserver:self forKeyPath:@"hasTabbar" options:NSKeyValueObservingOptionNew context:nil];
        [self.webViewUIConfiguration addObserver:self forKeyPath:@"webViewScrollEnabled" options:NSKeyValueObservingOptionNew context:nil];
        [self.webViewUIConfiguration addObserver:self forKeyPath:@"coverViewShowing" options:NSKeyValueObservingOptionNew context:nil];
        [self.webViewUIConfiguration addObserver:self forKeyPath:@"backButtonColor" options:NSKeyValueObservingOptionNew context:nil];
        [self.webViewUIConfiguration addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [self.webViewUIConfiguration addObserver:self forKeyPath:@"navHidden" options:NSKeyValueObservingOptionNew context:nil];
        [self.webViewUIConfiguration addObserver:self forKeyPath:@"needRightNav" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc {
    // 移除所有的通知
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webViewUIConfiguration removeObserver:self forKeyPath:@"hasTabbar"];
    [self.webViewUIConfiguration removeObserver:self forKeyPath:@"webViewScrollEnabled"];
    [self.webViewUIConfiguration removeObserver:self forKeyPath:@"coverViewShowing"];
    [self.webViewUIConfiguration removeObserver:self forKeyPath:@"backButtonColor"];
    [self.webViewUIConfiguration removeObserver:self forKeyPath:@"title"];
    [self.webViewUIConfiguration removeObserver:self forKeyPath:@"navHidden"];
    [self.webViewUIConfiguration removeObserver:self forKeyPath:@"needRightNav"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"======================WKWebView dealloc======================");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = self.webViewUIConfiguration.navHidden;
    [self mpm_homepageNeedRefresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Private Method
- (void)mpm_homepageNeedRefresh {
    NSTimeInterval duration = [NSDate date].timeIntervalSince1970 - self.webViewUIConfiguration.lastUpdateTime;
    if (duration > 3) {
        // 两秒钟内不允许反复刷新
        self.webViewUIConfiguration.lastUpdateTime = [NSDate date].timeIntervalSince1970;
        dispatch_async(kMainQueue, ^{
            [self.webView evaluateJavaScript:[NSString stringWithFormat:@"%@()",kHomePageNeedRefresh] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                
            }];
        });
    }
}

- (void)setupAttributes {
    self.view.backgroundColor = kWhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    __weak typeof(self) weakself = self;
    self.backButton.exitBlock = ^(UIButton * _Nonnull exitButton) {
        __strong typeof(weakself) strongself = weakself;
        // 关闭按钮
        [strongself clearAndPop];
    };
    
    if (self.fileURL) {
        if (@available(iOS 9.0, *)) {
            [self.webView loadFileURL:self.fileURL allowingReadAccessToURL:self.fileURL];
        } else {
            NSURL *fileURL = [self fileURLForBuggyWKWebView8:self.fileURL];
            [self.webView loadRequest:[NSURLRequest requestWithURL:fileURL]];
        }
    } else {
        NSURL *url;
        // 如果使用[NSCharacterSet URLFragmentAllowedCharacterSet]
        NSCharacterSet *set = [NSCharacterSet wf_urlAllowCharecterSet];
        if ([NSURL URLWithString:self.url] != nil) {
            url = [NSURL URLWithString:self.url];
        } else if ([NSURL URLWithString:[self.url stringByAddingPercentEncodingWithAllowedCharacters:set]] != nil) {
            url = [NSURL URLWithString:[self.url stringByAddingPercentEncodingWithAllowedCharacters:set]];
        }
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        
        [self.webView loadRequest:request];
    }
    self.webViewUIConfiguration.lastUpdateTime = [NSDate date].timeIntervalSince1970;
}

- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}

- (void)loadURL:(NSString *)urlString {
    NSURL *url;
    NSCharacterSet *set = [NSCharacterSet wf_urlAllowCharecterSet];
    if ([NSURL URLWithString:urlString] != nil) {
        url = [NSURL URLWithString:urlString];
    } else if ([NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:set]] != nil) {
        url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:set]];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

- (void)setupSubViews {
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.webView addSubview:self.progressView];
    [self.view addSubview:self.webDefaultView];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.backButton]];
}


#pragma mark - kWebViewNeedDeallocNotification

- (void)webViewNeedDealloc {
    [self removeScriptInject];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        // 监听到页面loading状态
        [self.progressView setAlpha:1.0f];
        float progressValue = fabsf([change[@"new"] floatValue]);
        if (progressValue > self.progressView.progress) {
            [self.progressView setProgress:progressValue animated:YES];
        } else {
            [self.progressView setProgress:progressValue animated:NO];
        }
        if (progressValue >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        // 监听H5标题的变化
        if ([object isKindOfClass:[WKWebView class]]) {
            self.navigationItem.title = self.webView.title;
        } else if ([object isKindOfClass:[WFWebViewUIConfiguration class]]) {
            self.navigationItem.title = self.webViewUIConfiguration.title;
        }
    } else if ([keyPath isEqualToString:@"canGoBack"]) {
        // 监听H5浏览器的浏览器历史情况
        if (self.webViewUIConfiguration.needExit) {
            self.backButton.showExit = self.webView.canGoBack;
        }
    } else if ([keyPath isEqualToString:@"hasTabbar"]) {
        // 监听是否有Tabbar的修改
        CGRect frame;
        if (self.webViewUIConfiguration.navHidden) {
            frame = CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight-kStatusBarHeight-kBottomHeight);
        } else {
            frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-kBottomHeight);
        }
        if (self.webViewUIConfiguration.hasTabbar) {
            frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - kTabbarHeight);
        }
        self.webView.frame = frame;
    } else if ([keyPath isEqualToString:@"webViewScrollEnabled"]) {
        self.webView.scrollView.scrollEnabled = self.webViewUIConfiguration.webViewScrollEnabled;
    } else if ([keyPath isEqualToString:@"backButtonColor"]) {
        // 返回按钮颜色改变
        self.backButton.color = self.webViewUIConfiguration.backButtonColor;
    } else if ([keyPath isEqualToString:@"navHidden"]) {
        // 改变导航栏的隐藏和显示
        CGRect frame;
        if (self.webViewUIConfiguration.navHidden) {
            frame = CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight-kStatusBarHeight-kBottomHeight);
        } else {
            frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-kBottomHeight);
        }
        if (self.webViewUIConfiguration.hasTabbar) {
            frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - kTabbarHeight);
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.webView.frame = frame;
            self.navigationController.navigationBarHidden = self.webViewUIConfiguration.navHidden;
        }];
    }
}

#pragma mark - Target Action

- (void)back:(UIButton *)sender {
    if (!self.webViewUIConfiguration.nExit && [self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self clearAndPop];
    }
}

#pragma mark - 长按保存相册
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [gesture locationInView:self.webView];
    NSString *imgJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    [self.webView evaluateJavaScript:imgJS completionHandler:^(id _Nullable imgUrl, NSError * _Nullable error) {
        if (imgUrl) {
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            if (!img) {
                return;
            }
            [self showAlertControllerWithStyle:UIAlertControllerStyleActionSheet title:nil message:nil sureTitle:(@"取消") sureAction:nil sureStyle:UIAlertActionStyleDefault cancelTitle:(@"保存图片") cancelAction:^(UIAlertAction *action) {
                [self savePhotoToPhotosAlbumWithImg:img];
            } cancelStyle:UIAlertActionStyleDefault];
        }
    }];
}
- (void)savePhotoToPhotosAlbumWithImg:(UIImage *)img {
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if (error) {
        msg = (@"保存图片失败");
    } else {
        msg = (@"保存图片成功");
    }
    [WFCommomTool showTextWithTitle:msg inView:self.view animation:YES];
}

#pragma mark - Public Method

- (void)clearAndPop {
    [self.webViewBridge clean];
    [self removeScriptInject];
    if (self.presentingViewController) {
        // 如果是通过present来弹出的，则直接dismiss即可
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    } else {
        UIViewController *vc;
        for (NSInteger i = self.navigationController.viewControllers.count - 2; i >= 0; i--) {
            UIViewController *currentVC = self.navigationController.viewControllers[i];
            if ([self.webViewBridge.cantPopVCName containsObject:NSStringFromClass([currentVC class])]) {
                continue;
            } else {
                vc = currentVC;
                break;
            }
        }
        
        [self.navigationController popToViewController:vc animated:YES];
    }
}

// 移除方法注入，否则会导致内存泄漏
- (void)removeScriptInject {
    [self.webViewConfiguration.userContentController removeScriptMessageHandlerForName:kNative];
}

- (void)evaluateJavaScript:(NSString *)js {
    dispatch_async(kMainQueue, ^{
        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            
        }];
    });
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    // 一些第三方的URL，不能滚动，需要做特别设置允许
    UIApplication *app = [UIApplication sharedApplication];
    // 打电话
    if ([url.absoluteString.lowercaseString hasPrefix:@"tel:"]) {
        if ([app canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [app openURL:url options:@{} completionHandler:nil];
            } else {
                [app openURL:url];
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (!webView.URL && error.userInfo && error.userInfo[NSURLErrorFailingURLStringErrorKey]) {
        self.url = error.userInfo[NSURLErrorFailingURLStringErrorKey];
    }
    if (error.code == NSURLErrorTimedOut || error.code == 17) {
        // 超时
        self.webDefaultView.type = WebDefaultViewTypeNetworkBusy;
    } else if (error.code == NSURLErrorNotConnectedToInternet) {
        // 断网
        self.webDefaultView.type = WebDefaultViewTypeNoNetwork;
    } else {
        // 其他错误，都会显示404页面
        self.webDefaultView.type = WebDefaultViewTypeRequestFail;
    }
    self.webDefaultView.hidden = NO;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    self.webDefaultView.hidden = NO; // iOS13会有点问题
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 如果预加载了about:blank，则需要此历史
    if ([webView.URL.absoluteString.lowercaseString isEqualToString:@"about:blank"]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [webView.backForwardList performSelector:NSSelectorFromString(@"_removeAllItems")];
#pragma clang diagnostic pop
        
    }
    self.webDefaultView.hidden = YES;
    // 禁止长按弹出
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
}

#pragma mark - WKScriptMessageHandler
// 当js 通过 注入的方法 @“messageSend” 时会调用代理回调。 原生收到的所有信息都通过此方法接收。
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // 通过一个单独的对接类来单独处理JS消息
    [self.webViewBridge handleJSWithMessage:message];
}

#pragma mark - WKUIDelegate

// 通过js alert 显示一个警告面板，调用原生会走此方法。
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
// 通过 js confirm 显示一个确认面板，调用原生会走此方法。
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [action addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    
    [action addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [self presentViewController:action animated:YES completion:nil];
    
}

// 显示输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:defaultText message:prompt preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"输入信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[controller.textFields lastObject] text]);
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - WFWebDefaultViewDelegate
- (void)webDefaultViewDidRefresh {
    if (self.webView.URL) {
        [self.webView reload];
    } else {
        NSURL *url;
        NSCharacterSet *set = [NSCharacterSet wf_urlAllowCharecterSet];
        if ([NSURL URLWithString:self.url] != nil) {
            url = [NSURL URLWithString:self.url];
        } else if ([NSURL URLWithString:[self.url stringByAddingPercentEncodingWithAllowedCharacters:set]] != nil) {
            url = [NSURL URLWithString:[self.url stringByAddingPercentEncodingWithAllowedCharacters:set]];
        }
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
    }
}

#pragma mark - WFWebViewBridgeDelegate
- (void)showDefaultViewWithType:(WebDefaultViewType)type {
    self.webDefaultView.type = type;
    self.webDefaultView.hidden = NO;
}

- (void)hideDefaultView {
    self.webDefaultView.hidden = YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)changeNavBarHidden:(BOOL)navHidden {
    self.webViewUIConfiguration.navHidden = navHidden;
}

#pragma mark - Lazy Init

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:self.webViewConfiguration];

        if (@available(iOS 11.0, *)) {
            // 顶部有空白，需要进行如下设置
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _webView.scrollView.scrollEnabled = NO;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0.3;
        longPress.delegate = self;
        [_webView addGestureRecognizer:longPress];
        _webView.allowsBackForwardNavigationGestures = NO;
        _webView.backgroundColor = kWhiteColor;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

- (WKWebViewConfiguration *)webViewConfiguration {
    if (!_webViewConfiguration) {
        _webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        _webViewConfiguration.userContentController = [[WKUserContentController alloc] init];
        
        // 将 window.webkit.messageHandlers.Bridge 改名成 window.Bridge 与 Android 统一
        [_webViewConfiguration.userContentController addScriptMessageHandler:self name:kNative];
        WKUserScript* userScript = [[WKUserScript alloc]initWithSource:@"if (typeof window.webkit != 'undefined' && typeof window.webkit.messageHandlers.native != 'undefined') { window.native = window.webkit.messageHandlers.native;}" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [_webViewConfiguration.userContentController addUserScript:userScript];
        
        // 偏好设置
        _webViewConfiguration.preferences = [[WKPreferences alloc] init];
        _webViewConfiguration.preferences.javaScriptEnabled = YES;
        _webViewConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    }
    return _webViewConfiguration;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 3)];
        _progressView.trackTintColor = kClearColor;
        _progressView.progressTintColor = kMainBlueColor;
    }
    return _progressView;
}

- (WFWebDefaultView *)webDefaultView {
    if (!_webDefaultView) {
        _webDefaultView = [[WFWebDefaultView alloc] init];
        _webDefaultView.hidden = YES;
        _webDefaultView.delegate = self;
        CGRect frame = self.webView.frame;
        _webDefaultView.frame = frame;
    }
    return _webDefaultView;
}

- (WFCustomNavLeftButton *)backButton {
    if (!_backButton) {
        _backButton = [WFCustomNavLeftButton buttonWithType:UIButtonTypeCustom];
        _backButton.color = self.webViewUIConfiguration.backButtonColor;
        _backButton.frame = CGRectMake(0, 0, 68, 44);
        [_backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    }
    return _backButton;
}

@end
