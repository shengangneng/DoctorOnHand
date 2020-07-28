//
//  AppDelegate.h
//  DoctorOnHand
//
//  Created by shengangneng on 20/6/18.
//  Copyright © 2020年 shengangneng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFMaskBackView.h"
#import "WFLoginModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WFLoginModel *loginModel;
@property (copy, nonatomic) NSString *frontHost;
@property (copy, nonatomic) NSString *backHost;
@property (strong, nonatomic) WFMaskBackView *maskBackView;

- (void)logout;

@end

