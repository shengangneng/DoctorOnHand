//
//  WFAudioPlayer.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@protocol WFAudioPlayerDelegate <NSObject>
/// 暂停播放
- (void)audioPlayerPause;
/// 播放完成
- (void)audioPlayerFinish;
/// 停止播放
- (void)audioPlayerStop;
@end



@interface WFAudioPlayer : NSObject
///
@property (nonatomic, copy, readonly) NSString *localPath;
/** 音频播放器（本地） */
@property (nonatomic ,strong) AVAudioPlayer *player;
/// 网络
@property (nonatomic, strong) AVPlayer *urlPlayer;
/// 播放进度
@property (nonatomic, assign, readonly) float progress;
/// 播放进度
@property (nonatomic, assign, readonly) BOOL isPlaying;
/// 代理
@property (nonatomic, weak) id<WFAudioPlayerDelegate> delegate;

+ (instancetype)shareAudioPlayer;

/// 播放音频（本地路径）
- (AVAudioPlayer *)playAudioWith:(NSString *)audioPath;
/// 播放音频（网络）
- (AVPlayer *)playAudioWithURL:(NSString *)urlStr;

/// 恢复播放音频
- (void)resumeCurrentAudio;
/// 暂停播放
- (void)pauseCurrentAudio;
/// 停止播放
- (void)stopCurrentAudio;

@end
