//
//  WFRecordVoiceButton.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFRecordVoiceButton;
@protocol WFRecordVoiceButtonDelegate <NSObject>

- (void)didBeginRecordWithButton:(WFRecordVoiceButton *)button;

- (void)continueRecordingWithButton:(WFRecordVoiceButton *)button;

- (void)willCancelRecordWithButton:(WFRecordVoiceButton *)button;

- (void)didFinishedRecordWithButton:(WFRecordVoiceButton *)button audioLocalPath:(NSString *)audioLocalPath;

- (void)didCancelRecordWithButton:(WFRecordVoiceButton *)button;

@end


@interface WFRecordVoiceButton : UIButton

///代理
@property (nonatomic, weak) id<WFRecordVoiceButtonDelegate> delegate;


@end
