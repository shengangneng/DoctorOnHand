//
//  WFRecordAudioViewController.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WFRecordVoiceStatus) {
    WFRecordVoiceStatusReady,       /// 准备还未开始
    WFRecordVoiceStatusBegin,       /// 开始录音
    WFRecordVoiceStatusPause,       /// 暂停录音
    WFRecordVoiceStatusResum,       /// 暂停后重新启动
    WFRecordVoiceStatusEnd          /// 录音结束
};

@interface WFRecordAudioViewController : WFBaseViewController

@end

NS_ASSUME_NONNULL_END
