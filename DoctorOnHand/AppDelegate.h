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
@property (strong, nonatomic) WFMaskBackView *maskBackView;

@end

