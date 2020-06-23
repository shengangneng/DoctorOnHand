//
//  WFRecordAudioViewController.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFRecordAudioViewController.h"
#import "WFRecordVoiceButton.h"
#import "WFAudioPlayer.h"

@interface WFRecordAudioViewController () <WFRecordVoiceButtonDelegate>

@end

@implementation WFRecordAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WFRecordVoiceButton *recordButton = [[WFRecordVoiceButton alloc] init];
    recordButton.frame = CGRectMake(16, kScreenHeight - 300, kScreenWidth - 32, 50);
    recordButton.delegate = self;
    [self.view addSubview:recordButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


#pragma 录制按钮代理
- (void)continueRecordingWithButton:(WFRecordVoiceButton *)button {
    
    DLog(@"持续录制");
}

- (void)didBeginRecordWithButton:(WFRecordVoiceButton *)button {
    DLog(@"开始录制");
    /// 开始录制停止播放
    [[WFAudioPlayer shareAudioPlayer] stopCurrentAudio];
}

- (void)didCancelRecordWithButton:(WFRecordVoiceButton *)button {
    DLog(@"取消录制");
}

- (void)didFinishedRecordWithButton:(WFRecordVoiceButton *)button audioLocalPath:(NSString *)audioLocalPath {
    DLog(@"结束录制返回路径=%@", audioLocalPath);
    
    //转换成amr的路径，文件大小大概只有原来的1/10，所以上传到服务器比较快，播放的时候记得转换成wav的
//    if (audioLocalPath.length > 0) {
//        self.audioLocalPath = audioLocalPath;
//
//        self.playButton.hidden = NO;
//        self.deleteButton.hidden = NO;
//    }
}

- (void)willCancelRecordWithButton:(WFRecordVoiceButton *)button {
    DLog(@"将要取消录制");
}

@end
