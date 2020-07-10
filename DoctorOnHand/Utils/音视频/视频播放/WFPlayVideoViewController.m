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
    self.view.backgroundColor = kWhiteColor;
    self.navigationItem.title = @"视频播放";
    WFAVPlayerView *playerView = [[WFAVPlayerView alloc] init];
    playerView.frame = self.view.bounds;
    playerView.delegate = self;
    [self.view addSubview:playerView];
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
    NSURL *fileURL = [NSURL fileURLWithPath:moviePath];
    NSURL *url = [NSURL URLWithString:@"http://dict.youdao.com/dictvoice?audio=people&type=2"];
    
    [playerView settingPlayerItemWithUrl:fileURL];
}

#pragma mark - WFAVPlayerViewDelegate
- (void)playerDidClose:(WFAVPlayerView *)player {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
