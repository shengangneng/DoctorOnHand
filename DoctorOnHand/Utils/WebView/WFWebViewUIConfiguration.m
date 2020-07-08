//
//  WFWebViewUIConfiguration.m
//  DoctorOnHand
//
//  Created by sgn on 2020/7/8.
//  Copyright © 2020 sgn. All rights reserved.
//

#import "WFWebViewUIConfiguration.h"

@implementation WFWebViewUIConfiguration

+ (instancetype)defaultUIConfiguration {
    WFWebViewUIConfiguration *config = [[WFWebViewUIConfiguration alloc] init];
    config.navHidden = NO;
    config.needExit = NO;
    config.lastUpdateTime = [NSDate date].timeIntervalSince1970;
    config.title = @"";
    config.backButtonColor = kBlackColor;
    config.hasTabbar = NO;
    config.webViewScrollEnabled = NO;
    config.needPicture = NO;
    config.navColor = kWhiteColor;
    return config;
}

@end
