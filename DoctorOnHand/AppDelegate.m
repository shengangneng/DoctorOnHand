//
//  AppDelegate.m
//  DoctorOnHand
//
//  Created by shengangneng on 20/6/18.
//  Copyright © 2020年 shengangneng. All rights reserved.
//

#import "AppDelegate.h"
#import "WFHomeViewController.h"
#import "WFBaseNavigationController.h"
#import "WFLoginViewController.h"
#import "WFWKWebViewController.h"
#import "WFCommomTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = kWhiteColor;

    // 保存数据
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults valueForKey:kToken];
//    if (token) {
//
//        WFLoginModel *model = [[WFLoginModel alloc] init];
//        model.department = [defaults valueForKey:kDepartment];
//        model.deptId = [defaults valueForKey:kdeptId];
//        model.email = [defaults valueForKey:kEmail];
//        model.hosiptal = [defaults valueForKey:kHosiptal];
//        model.jobTitle = [defaults valueForKey:kJobTitle];
//        model.phone = [defaults valueForKey:kPhone];
//        model.realName = [defaults valueForKey:kRealName];
//        model.sex = [defaults valueForKey:kSex];
//        model.token = [defaults valueForKey:kToken];
//        model.userId = [defaults valueForKey:kUserId];
//        model.userName = [defaults valueForKey:kUserName];
//        model.wards = [defaults valueForKey:kWards];
//        self.loginModel = model;
//
//        NSString *path = [NSString stringWithFormat:@"http://192.168.10.222:8080/#/patient/card?department=%@&depId=%@&email=%@&hosiptal=%@&jobTitle=%@&phone=%@&realName=%@&sex=%@&token=%@&userId=%@&userName=%@&wards=%@",kSafeString(model.department),kSafeString(model.deptId),kSafeString(model.email),kSafeString(model.hosiptal),kSafeString(model.jobTitle),kSafeString(model.phone),kSafeString(model.realName),kSafeString(model.sex),kSafeString(token),kSafeString(model.userId),kSafeString(model.userName),kSafeString(model.wards)];
//        WFWKWebViewController *web = [[WFWKWebViewController alloc] initWithURL:path];
//        web.webViewUIConfiguration.navHidden = YES;
//        WFBaseNavigationController *nav = [[WFBaseNavigationController alloc] initWithRootViewController:web];
//        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
//    } else {
//        WFLoginViewController *nav = [[WFLoginViewController alloc] init];
//        self.window.rootViewController = nav;
//    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.frontHost = [defaults valueForKey:kFrontHost];
    self.backHost = [defaults valueForKey:kBackHost];
    
    if (kIsNilString(self.frontHost) && kIsNilString(self.backHost)) {
        // 没有配置信息
        NSString *path = [[NSBundle mainBundle] pathForResource:(@"index") ofType:@"html" inDirectory:@"WebResources/config"];
        WFWKWebViewController *web = [[WFWKWebViewController alloc] initWithFileURL:[NSURL fileURLWithPath:path]];
        web.webViewUIConfiguration.navHidden = YES;
        web.webViewUIConfiguration.webViewScrollEnabled = YES;
        WFBaseNavigationController *nav = [[WFBaseNavigationController alloc] initWithRootViewController:web];
        self.window.rootViewController = nav;
    } else {
        NSString *token = [defaults valueForKey:kToken];
        if (token) {
            WFLoginModel *model = [[WFLoginModel alloc] init];
            model.department = [defaults valueForKey:kDepartment];
            model.deptId = [defaults valueForKey:kdeptId];
            model.email = [defaults valueForKey:kEmail];
            model.hosiptal = [defaults valueForKey:kHosiptal];
            model.jobTitle = [defaults valueForKey:kJobTitle];
            model.phone = [defaults valueForKey:kPhone];
            model.realName = [defaults valueForKey:kRealName];
            model.sex = [defaults valueForKey:kSex];
            model.token = [defaults valueForKey:kToken];
            model.userId = [defaults valueForKey:kUserId];
            model.userName = [defaults valueForKey:kUserName];
            model.wards = [defaults valueForKey:kWards];
            self.loginModel = model;
    
            NSString *path = [NSString stringWithFormat:@"http://%@/#/patient/card?department=%@&depId=%@&email=%@&hosiptal=%@&jobTitle=%@&phone=%@&realName=%@&sex=%@&token=%@&userId=%@&userName=%@&wards=%@&backHost=%@",self.frontHost,kSafeString(model.department),kSafeString(model.deptId),kSafeString(model.email),kSafeString(model.hosiptal),kSafeString(model.jobTitle),kSafeString(model.phone),kSafeString(model.realName),kSafeString(model.sex),kSafeString(token),kSafeString(model.userId),kSafeString(model.userName),kSafeString(model.wards),self.backHost];
            WFWKWebViewController *web = [[WFWKWebViewController alloc] initWithURL:path];
            web.webViewUIConfiguration.navHidden = YES;
            WFBaseNavigationController *nav = [[WFBaseNavigationController alloc] initWithRootViewController:web];
            self.window.rootViewController = nav;
        } else {
            WFLoginViewController *nav = [[WFLoginViewController alloc] init];
            self.window.rootViewController = nav;
        }
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)logout {
    if (kIsNilString(self.frontHost) && kIsNilString(self.backHost)) {
        [WFCommomTool showTextWithTitle:@"请先保存配置信息" inView:self.window animation:YES];
        return;
    }
    // 清空登录信息
    self.loginModel = nil;
    WFLoginViewController *nav = [[WFLoginViewController alloc] init];
    self.window.rootViewController = nav;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupBackMaskView {
    if (!self.maskBackView) {
        self.maskBackView = [[WFMaskBackView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
        [self.maskBackView addObserver];
        [self.window insertSubview:self.maskBackView atIndex:0];
    } else {
        [self.maskBackView addObserver];
        [self.window sendSubviewToBack:self.maskBackView];
    }
    self.maskBackView.hidden = YES;
}

@end
