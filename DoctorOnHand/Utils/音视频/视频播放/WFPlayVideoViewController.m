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

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) WFAVPlayerView *playerView;

@end

@implementation WFPlayVideoViewController

- (instancetype)initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.navigationItem.title = @"视频播放";
    WFAVPlayerView *playerView = [[WFAVPlayerView alloc] init];
    playerView.frame = self.view.bounds;
    playerView.delegate = self;
    [self.view addSubview:playerView];
    if (!kIsNilString(self.url) && [NSURL URLWithString:self.url]) {
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.url]];
        [playerView settingPlayerItem:item];
    } else {
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
        NSURL *fileURL = [NSURL fileURLWithPath:moviePath];
        [playerView settingPlayerItemWithUrl:fileURL];
    }
}

#pragma mark - WFAVPlayerViewDelegate
- (void)playerDidClose:(WFAVPlayerView *)player {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
