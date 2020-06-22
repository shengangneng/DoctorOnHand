//
//  WFAVPlayerView.h
//  DoctorOnHand
//
//  Created by shengangneng on 20/6/18.
//  Copyright © 2020年 shengangneng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WFAVPlayerControlView.h"

@interface WFAVPlayerView : UIView
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) WFAVPlayerControlView *controlView;
@property (nonatomic, assign) BOOL isFullScreen;

- (instancetype)initWithPlayerItem:(AVPlayerItem *)playerItem;
- (void)settingPlayerItemWithUrl:(NSURL *)playerUrl;
- (void)settingPlayerItem:(AVPlayerItem *)playerItem;
@end
