//
//  WFHomeVideoViewController.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/22.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFHomeVideoViewController.h"
#import "WFAVPlayerView.h"

@interface WFHomeVideoViewController () <WFAVPlayerViewDelegate>

@property (nonatomic, strong) WFAVPlayerView *playerView;

@end

@implementation WFHomeVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WFAVPlayerView *playerView = [[WFAVPlayerView alloc] init];
    playerView.frame = self.view.bounds;
    playerView.delegate = self;
    [self.view addSubview:playerView];
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
    [playerView settingPlayerItemWithUrl:[NSURL fileURLWithPath:moviePath]];
}

#pragma mark - WFAVPlayerViewDelegate
- (void)playerDidClose:(WFAVPlayerView *)player {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
