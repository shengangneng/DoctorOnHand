//
//  WFRecordVoiceHUD.h
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WFRecordVoiceHUDType) {
    ///开始录制
    WFRecordVoiceHUDTypeBeginRecord,
    ///正在录制
    WFRecordVoiceHUDTypeRecording,
    ///松开取消
    WFRecordVoiceHUDTypeReleaseToCancle,
    ///音频太短
    WFRecordVoiceHUDTypeAudioTooShort,
    ///音频太长
    WFRecordVoiceHUDTypeAudioTooLong,
    ///结束
    WFRecordVoiceHUDTypeEndRecord,
};

@interface WFRecordVoiceHUD : UIView


+ (instancetype)shareInstance;
///刷新视图
- (void)showHUDWithType:(WFRecordVoiceHUDType)type;
///时间太长自动发送
@property (nonatomic, copy) void (^longTimeHandler)(void);

@end
