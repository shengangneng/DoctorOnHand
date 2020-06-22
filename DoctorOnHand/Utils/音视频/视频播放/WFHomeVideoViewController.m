//
//  WFHomeVideoViewController.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/22.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFHomeVideoViewController.h"
#import "WFAVPlayerView.h"

@interface WFHomeVideoViewController ()

@property (nonatomic, strong) WFAVPlayerView *playerView;

@end

@implementation WFHomeVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat palyerW = [UIScreen mainScreen].bounds.size.width;
    WFAVPlayerView *playerView = [[WFAVPlayerView alloc] init];
    playerView.frame = CGRectMake(0, 0, palyerW, palyerW / 7 * 4);
    
    [self.view addSubview:playerView];
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
    [playerView settingPlayerItemWithUrl:[NSURL fileURLWithPath:moviePath]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end
