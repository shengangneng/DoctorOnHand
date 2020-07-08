//
//  WFPlayVideoViewController.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/22.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFPlayVideoViewController.h"
#import "WFAVPlayerView.h"

@interface WFPlayVideoViewController () <WFAVPlayerViewDelegate>

@property (nonatomic, strong) WFAVPlayerView *playerView;

@end

@implementation WFPlayVideoViewController

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
