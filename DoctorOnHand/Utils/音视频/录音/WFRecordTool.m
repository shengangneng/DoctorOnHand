//
//  WFRecordTool.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//
#define ALPHA 0.05f                 // 音频振幅调解相对值 (越小振幅就越高)
#import "WFRecordTool.h"
#import <AVFoundation/AVFoundation.h>

static WFRecordTool *instance;

@interface WFRecordTool ()

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@end


@implementation WFRecordTool

+ (instancetype)shareRecordTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (BOOL)initAudioRecorder {
    // 0. 设置录音会话
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    // 1. 确定录音存放的位置
    NSURL *url = [NSURL URLWithString:self.recordPath];
    
    // 2. 设置录音参数
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    // 设置编码格式
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    // 采样率
    [recordSettings setValue :[NSNumber numberWithFloat:44100] forKey: AVSampleRateKey];
    // 通道数
    [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    // 线性采样位数  8、16、24、32
    [recordSettings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    // 录音的质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    // 3. 创建录音对象
    NSError *error = nil;
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    _audioRecorder.meteringEnabled = YES;
    if (error) {
        NSLog(@"创建录音失败：%@",error);
        return NO;
    }
    return YES;
}

- (void)beginRecordWithRecordPath:(NSString *)recordPath {
    NSLog(@"------%@",recordPath);
    _isRecording = YES;
    _recordPath = recordPath;
    if (self.delegate && [self.delegate respondsToSelector:@selector(prepareToRecording)]) {
        [self.delegate prepareToRecording];
    }
    if (![self initAudioRecorder]) { // 初始化录音机
        NSLog(@"录音机创建失败...");
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordingFailed:)]) {
            [self.delegate recordingFailed:@"录音器创建失败"];
        }
        return;
    };
    [self micPhonePermissions:^(BOOL ishave) {
        if (ishave) {
            [self startRecording];
        } else {
            [self showPermissionsAlert];
        }
    }];
}

- (void)startRecording {
    if (!_isRecording) {
        return;
    }
    if (![self.audioRecorder prepareToRecord]) {
        NSLog(@"初始化录音机失败");
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordingFailed:)]) {
            [self.delegate recordingFailed:@"录音器初始化失败"];
        }
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(recording)]) {
        [self.delegate recording];
    }
    [self.audioRecorder record];
    
}

- (void)endRecord {
    _isRecording = NO;
    [self.audioRecorder stop];
}

- (void)pauseRecord {
    [self.audioRecorder pause];
}

- (void)resumeRecord {
    [self.audioRecorder record];
}

- (void)deleteRecord {
    _isRecording = NO;
    [self.audioRecorder stop];
    [self.audioRecorder deleteRecording];
}

// 获取分贝大小（-160dB -- 0dB ，我们把它转换成0 - 1）
- (float)updateLevels {
    [self.audioRecorder updateMeters];
    
    double aveChannel = pow(10, (ALPHA * [self.audioRecorder averagePowerForChannel:0]));
    if (aveChannel < 0) {
        aveChannel =0 ;
    } else if (aveChannel > 1){
        aveChannel = 1;
    }
    
    return aveChannel;
    
}

// 判断麦克风权限
- (void)micPhonePermissions:(void (^)(BOOL ishave))block  {
    __block BOOL ret = NO;
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [avSession requestRecordPermission:^(BOOL available) {
            if (available) ret = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) block(ret);
            });
        }];
    }
}

- (void)showPermissionsAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”中允许访问麦克风。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
