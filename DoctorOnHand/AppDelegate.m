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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = kWhiteColor;
    
//    WFHomeViewController *home = [[WFHomeViewController alloc] init];
//    WFBaseNavigationController *nav = [[WFBaseNavigationController alloc] initWithRootViewController:home];
    
    if (kIsNilString([[NSUserDefaults standardUserDefaults] stringForKey:kServerURL])) {
        NSString *path = [[NSBundle mainBundle] pathForResource:(@"index") ofType:@"html" inDirectory:@"WebResources/config"];
        WFWKWebViewController *web = [[WFWKWebViewController alloc] initWithFileURL:[NSURL fileURLWithPath:path]];
        web.webViewUIConfiguration.navHidden = YES;
        web.webViewUIConfiguration.webViewScrollEnabled = YES;
        WFBaseNavigationController *nav = [[WFBaseNavigationController alloc] initWithRootViewController:web];
        self.window.rootViewController = nav;
    } else {
        WFLoginViewController *nav = [[WFLoginViewController alloc] init];
        self.window.rootViewController = nav;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
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
