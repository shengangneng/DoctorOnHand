//
//  WFLoginViewController.m
//  DoctorOnHand
//
//  Created by gangneng shen on 2020/6/18.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFLoginViewController.h"
#import "WFBrushBoardView.h"

@interface WFLoginViewController ()

@end

@implementation WFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[[WFBrushBoardView alloc] initWithFrame:self.view.frame]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
    
}

- (void)setupAttributes {
    
}

- (void)setupSubViews {
    
}

- (void)setupConstraints {
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
