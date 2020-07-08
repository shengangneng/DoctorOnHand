//
//  WFBaseViewController.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFBaseViewController.h"
#import "UIButton+WFExtension.h"
#import "AppDelegate.h"

@interface WFBaseViewController ()

@end

@implementation WFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setLeftBarButtonWithTitle:(NSString *)title action:(SEL)selector {
    UIButton *leftButton = [UIButton normalButtonWithTitle:title titleColor:kWhiteColor bgcolor:kClearColor];
    [leftButton setImage:ImageName(@"statistics_back") forState:UIControlStateNormal];
    [leftButton setImage:ImageName(@"statistics_back") forState:UIControlStateHighlighted];
    leftButton.titleLabel.font = SystemFont(17);
    leftButton.frame = CGRectMake(0, 0, 50, 40);
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [leftButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0) {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = 10;
        self.navigationItem.leftBarButtonItems = @[negativeSeperator,leftItem];
    } else {
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFullScreen;
}

@end
