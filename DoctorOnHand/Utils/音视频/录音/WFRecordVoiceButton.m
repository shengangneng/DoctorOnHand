//
//  WFRecordVoiceButton.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFRecordVoiceButton.h"
#import "WFRecordVoiceHUD.h"
#import "WFFileManager.h"
#import "WFRecordTool.h"

@interface WFRecordVoiceButton ()

@property (nonatomic, copy) NSString *audioLocalPath;

@end

@implementation WFRecordVoiceButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    return [[WFRecordVoiceButton alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setView];
        [self addGesture];
    }
    return self;
}

- (void)setView {
    self.backgroundColor = kRGBColorHEX(0xf2f2f2);
    [self setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    self.layer.cornerRadius = 5.0f;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
    
    self.titleLabel.font = SystemFont(16);
    
}

- (void)addGesture {
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
    
}

- (void)longPress:(UILongPressGestureRecognizer *)gr {
    
#warning---如果按钮是放在类似微信键盘上，这里的view使用button的superview self.superview
    CGPoint point = [gr locationInView:self];
    [WFRecordVoiceHUD shareInstance].longTimeHandler = ^{//超过最长时间还在长按，主动让手势不可用
        gr.enabled = NO;
    };
    
    if (gr.state == UIGestureRecognizerStateBegan) {//长按开始
        DLog(@"---开始录音");
        [self setButtonStateWithRecording];
        NSString *audioLocalPath = [WFFileManager filePath];
        self.audioLocalPath = audioLocalPath;
        
        ///开始录音
        [[WFRecordTool shareRecordTool] beginRecordWithRecordPath:audioLocalPath];
        [[WFRecordVoiceHUD shareInstance] showHUDWithType:WFRecordVoiceHUDTypeBeginRecord inView:self.superview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didBeginRecordWithButton:)]) {
            [self.delegate didBeginRecordWithButton:self];
        }
        
    } else if (gr.state == UIGestureRecognizerStateChanged) {//长按改变位置
        
        #warning---如果按钮是放在类似微信键盘上，这里的view使用button的superview的height self.superview.height
        if (point.y < 0 || point.y > self.mj_h) {//超出范围提示松开手指取消发送
            DLog(@"---松开取消");
            [self setButtonStateWithCancel];
            
            [[WFRecordVoiceHUD shareInstance] showHUDWithType:WFRecordVoiceHUDTypeReleaseToCancle inView:self.superview];
            if (self.delegate && [self.delegate respondsToSelector:@selector(willCancelRecordWithButton:)]) {
                [self.delegate willCancelRecordWithButton:self];
            }
            
        } else {//在范围内，提示上滑取消发送
            DLog(@"---松开结束");
            [self setButtonStateWithRecording];
            [[WFRecordVoiceHUD shareInstance] showHUDWithType:WFRecordVoiceHUDTypeRecording inView:self.superview];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(continueRecordingWithButton:)]) {
                [self.delegate continueRecordingWithButton:self];
            }
        }
        
    } else if (gr.state == UIGestureRecognizerStateEnded) {//松开手指
        [[WFRecordVoiceHUD shareInstance] showHUDWithType:WFRecordVoiceHUDTypeEndRecord inView:self.superview];
        [self cancelOrEndRecordWithPoint:point];
        
    } else if (gr.state == UIGestureRecognizerStateCancelled) {//手势不可用走
        [self cancelOrEndRecordWithPoint:point];
        gr.enabled = YES;
        
    } else if (gr.state == UIGestureRecognizerStateFailed) {
        DLog(@"UIGestureRecognizerStateFailed---");
    } else if (gr.state == UIGestureRecognizerStatePossible) {
        DLog(@"UIGestureRecognizerStatePossible---");
    }
    
}

- (void)cancelOrEndRecordWithPoint:(CGPoint)point {
    
    [self setButtonStateWithNormal];
    [[WFRecordTool shareRecordTool] endRecord]; // 结束录音
   
#warning---如果按钮是放在类似微信键盘上，这里的view使用button的superview的height self.superview.height
    if (point.y < 0 || point.y > self.mj_h) {//超出范围不发送
        
        [[WFRecordTool shareRecordTool] deleteRecord];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelRecordWithButton:)]) {
            [self.delegate didCancelRecordWithButton:self];
        }
        
    } else {// 在范围内，直接发送
        
        /// 把wav转成amr，减小文件大小
        NSString *amrFilePath = [WFFileManager convertWavtoAMRWithVoiceFilePath:self.audioLocalPath];

        // 删除wav文件
        [WFFileManager removeFile:self.audioLocalPath];
        
        // 代理返回amr文件路径
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishedRecordWithButton:audioLocalPath:)]) {
            [self.delegate didFinishedRecordWithButton:self audioLocalPath:amrFilePath];
        }
    }
}

- (void)setButtonStateWithRecording {
    self.backgroundColor = kRGBColorHEX(0xcccccc); //
    [self setTitle:@"松开 结束" forState:UIControlStateNormal];
}

- (void)setButtonStateWithCancel {
    self.backgroundColor = kRGBColorHEX(0xcccccc); //
    [self setTitle:@"松开 取消" forState:UIControlStateNormal];
}

- (void)setButtonStateWithNormal {
    self.backgroundColor = kRGBColorHEX(0xf2f2f2);
    [self setTitle:@"按住 说话" forState:UIControlStateNormal];
}


@end
