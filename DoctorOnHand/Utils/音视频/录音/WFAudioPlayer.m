//
//  WFAudioPlayer.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFAudioPlayer.h"

static WFAudioPlayer *instance;

@interface WFAudioPlayer() <AVAudioPlayerDelegate>

@end

@implementation WFAudioPlayer

+ (instancetype)shareAudioPlayer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (NSString *)localPath {
    return self.player.url.path;
}

- (AVAudioPlayer *)playAudioWith:(NSString *)audioPath {
    
    NSString *lastAudioPath = self.player.url.path;
    // 当前地址跟之前的一样
    if ([lastAudioPath isEqualToString:audioPath] && self.player.isPlaying == YES) {//同一个地址,正在播放
        //停止
        [self pauseCurrentAudio];
        
        return nil;
    }
    // 设置为扬声器播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *url = [NSURL URLWithString:audioPath];
    if (url == nil) {
        url = [[NSBundle mainBundle] URLForResource:audioPath.lastPathComponent withExtension:nil];
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.delegate = self;
    //    NSLog(@"准备播放...%@",url);
    [self.player prepareToPlay];
    //    NSLog(@"播放...");
    [self.player play];
    return self.player;
}


- (void)resumeCurrentAudio {
    [self.player play];
}

- (void)pauseCurrentAudio {
    [self.player pause];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayerPause)]) {
        [self.delegate audioPlayerPause];
    }
}

- (void)stopCurrentAudio {
    [self.player stop];

    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayerStop)]) {
        [self.delegate audioPlayerStop];
    }
}

- (float)progress {
    return self.player.currentTime / self.player.duration;
}

- (BOOL)isPlaying {
    return self.player.isPlaying;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"----%@播放完", player);
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayerFinish)]) {
        [self.delegate audioPlayerFinish];
    }
}

@end
