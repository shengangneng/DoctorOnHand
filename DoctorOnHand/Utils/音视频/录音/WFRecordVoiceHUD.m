//
//  WFRecordVoiceHUD.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

static CGFloat const levelWidth = 3.0;
static CGFloat const levelMargin = 2.0;
static NSInteger const maxRecordTime = 60;

#import "WFRecordVoiceHUD.h"
#import "WFRecordTool.h"
#import "UIView+Extention.h"

@interface WFRecordVoiceHUD ()

@property (nonatomic, weak) UIView *levelContentView;        // 振幅所有视图的载体
@property (nonatomic, weak) UILabel *timeLabel;              // 录音时长标签
@property (nonatomic, weak) CAReplicatorLayer *replicatorL;  // 复制图层
@property (nonatomic, weak) CAShapeLayer *levelLayer;        // 振幅layer
@property (nonatomic, strong) UIBezierPath *levelPath;       // 画振幅的path
@property (nonatomic, strong) CADisplayLink *levelTimer;     // 振幅计时器
@property (nonatomic, strong) NSMutableArray *currentLevels; // 当前振幅数组
@property (nonatomic, strong) NSMutableArray *allLevels;     // 所有收集到的振幅,预先保存，用于播放
//录制计时器
@property (nonatomic, strong) NSTimer *recordTimer;
///录制时间
@property (nonatomic, assign) NSInteger recordTime;
///
@property (nonatomic, weak) UIView *containView;
///居中的图片
@property (nonatomic, weak) UIImageView *centerImageView;
///描述
@property (nonatomic, weak) UILabel *describeLabel;
///倒计时
@property (nonatomic, weak) UILabel *countDownLabel;
///类型
@property (nonatomic, assign) WFRecordVoiceHUDType type;
//时间
@property (nonatomic, assign) CGFloat durationTime;
///计时器
@property (nonatomic, strong) dispatch_source_t timer;
///渐变图层
@property (nonatomic, weak) CAGradientLayer *gradientLayer;

@end

static WFRecordVoiceHUD *_hud = nil;
@implementation WFRecordVoiceHUD

- (NSMutableArray *)allLevels {
    if (_allLevels == nil) {
        _allLevels = [NSMutableArray array];
    }
    return _allLevels;
}

- (NSMutableArray *)currentLevels {
    if (_currentLevels == nil) {
        _currentLevels = [NSMutableArray arrayWithArray:@[@0.05,@0.05,@0.05,@0.05,@0.05,@0.05]];
    }
    return _currentLevels;
}


+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _hud = [[WFRecordVoiceHUD alloc] init];
    });
    return _hud;
}

- (void)shareVoiceHudWithType:(WFRecordVoiceHUDType)type  {
    self.type = type;
    [self showView];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setView];
    }
    return self;
}

- (void)showView {
    if (self.containView.alpha == 1) {
        return;
    }
    self.containView.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.containView.alpha = 1;
    }];
    
}

- (void)removeHudWithTime:(CGFloat)time {
    self.durationTime = time;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建一个定时器
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(0.1* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.timer, start, interval, 0.0 * NSEC_PER_SEC);
    //设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        
        self.durationTime -= 0.1;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.durationTime <= 0) {
                dispatch_cancel(self.timer);
                [UIView animateWithDuration:0.2 animations:^{
                    self.containView.alpha = 0;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            }
        });
    });
    // 由于定时器默认是暂停的所以我们启动一下
    // 启动定时器
    dispatch_resume(self.timer);
    
}


- (void)setView {
    UIView *containView = [[UIView alloc] init];
    containView.backgroundColor = kRGBColorHEX(0x7C8B8C);
    [self addSubview:containView];
    self.containView = containView;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)kRGBColorHEX(0xFE9494).CGColor, (__bridge id)kRGBColorHEX(0xE95A5A).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = _hud.containView.bounds;
    [containView.layer addSublayer:gradientLayer];
    _gradientLayer = gradientLayer;
    
    
    UILabel *countDownLabel = [[UILabel alloc] init];
    countDownLabel.textAlignment = NSTextAlignmentCenter;
    countDownLabel.font = SystemFont(20);
    countDownLabel.textColor = kRGBColorHEX(0xFFFFFF);
    [containView addSubview:countDownLabel];
    self.countDownLabel = countDownLabel;
    
    
    UIView *levelContentView = [[UIView alloc] initWithFrame:self.bounds];
    [containView addSubview:levelContentView];
    levelContentView.hidden = YES;
    self.levelContentView = levelContentView;
    
    UILabel *timeL = [[UILabel alloc] init];
    timeL.text = @"0:00";
    timeL.textAlignment = NSTextAlignmentCenter;
    timeL.font = SystemFont(13);
    timeL.textColor = kRGBColorHEX(0xFFFFFF);
    [levelContentView addSubview:timeL];
    _timeLabel = timeL;
    
    CAReplicatorLayer *repL = [CAReplicatorLayer layer];
    repL.instanceCount = 2;
    repL.instanceTransform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    [levelContentView.layer addSublayer:repL];
    _replicatorL = repL;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = kRGBColorHEX(0xffffff).CGColor;
    layer.lineWidth = levelWidth;
    [repL addSublayer:layer];
    _levelLayer = layer;
    
    UIImageView *centerImageView = [[UIImageView alloc] init];
    centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [containView addSubview:centerImageView];
    self.centerImageView = centerImageView;
    
    UILabel *describeLabel = [[UILabel alloc] init];
    describeLabel.textAlignment = NSTextAlignmentCenter;
    describeLabel.font = SystemFont(12);
    describeLabel.textColor = kRGBColorHEX(0xffffff);
    [containView addSubview:describeLabel];
    self.describeLabel = describeLabel;
}

- (void)setType:(WFRecordVoiceHUDType)type {
    _type = type;
    
    if (type == WFRecordVoiceHUDTypeBeginRecord) {//开始录制
        _hud.describeLabel.text = @"松开发送，上滑取消";
        _hud.levelContentView.hidden = NO;
        _hud.gradientLayer.hidden = YES;
        _hud.countDownLabel.hidden = YES;
        _hud.centerImageView.hidden = YES;
        
        [self beginRecord];
        
        [self setType:WFRecordVoiceHUDTypeRecording];
        
    } else if (type == WFRecordVoiceHUDTypeRecording) {//正在录制
        
        _hud.describeLabel.text = @"松开发送，上滑取消";
        _hud.gradientLayer.hidden = YES;
        _hud.centerImageView.hidden = YES;
        
        if (maxRecordTime - _hud.recordTime <= 6) {
            _hud.levelContentView.hidden = YES;
            _hud.countDownLabel.hidden = NO;
        } else {
            _hud.levelContentView.hidden = NO;
            _hud.countDownLabel.hidden = YES;
        }
        
    } else if (type == WFRecordVoiceHUDTypeReleaseToCancle) {//松开取消
        _hud.centerImageView.hidden = NO;
        _hud.countDownLabel.hidden = YES;
        _hud.levelContentView.hidden = YES;
        _hud.gradientLayer.hidden = NO;
        _hud.centerImageView.image = [UIImage imageNamed:@"audio_record_cancel"];
        _hud.describeLabel.text = @"松开手指，取消发送";
        
        
    } else if (type == WFRecordVoiceHUDTypeAudioTooShort) {//录制太短了
        _hud.centerImageView.hidden = NO;
        _hud.countDownLabel.hidden = YES;
        _hud.levelContentView.hidden = YES;
        _hud.centerImageView.image = [UIImage imageNamed:@"audio_record_warning"];
        _hud.describeLabel.text = @"说话时间太短";
        [_hud removeHudWithTime:0.5];
        
        _hud.gradientLayer.hidden = YES;
    } else if (type == WFRecordVoiceHUDTypeAudioTooLong) {//录制太长了
        _hud.centerImageView.hidden = NO;
        _hud.countDownLabel.hidden = YES;
        _hud.levelContentView.hidden = YES;
        _hud.describeLabel.text = @"说话时间太长";
        _hud.centerImageView.image = [UIImage imageNamed:@"audio_record_warning"];
        
        [self setType:WFRecordVoiceHUDTypeEndRecord];
        
        if (self.longTimeHandler) {
            self.longTimeHandler();
        }
        
    } else if (type == WFRecordVoiceHUDTypeEndRecord) {//录制完成
        
        _hud.centerImageView.hidden = YES;
        if (_hud != nil) {
            [_hud removeHudWithTime:0.2];
        }
        
        [self endRecord];
    }
}

- (void)beginRecord {
    [self.recordTimer invalidate];
    
    // 开始录音先把上一次录音的振幅删掉
    [self.allLevels removeAllObjects];
    self.currentLevels = nil;
    [self startMeterTimer];
    
    self.recordTime = 0;
    
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addSeconed) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.recordTimer forMode:NSRunLoopCommonModes];
}

- (void)addSeconed {
    _hud.recordTime++;
    
    [self updateTimeWithRecordTime:_hud.recordTime];
}

- (void)endRecord {
    if (_hud.recordTime < 1) {
        [_hud setType:WFRecordVoiceHUDTypeAudioTooShort];
    }
    
    _hud.recordTime = 0;
    [self updateTimeWithRecordTime:_hud.recordTime];
    
    [_hud stopMeterTimer];
    [_hud stopRecordTimer];
}

#pragma mark - displayLink

- (void)startMeterTimer {
    [self stopMeterTimer];
    self.levelTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeter)];
    
    if (@available(iOS 10.0, *)) {
        self.levelTimer.preferredFramesPerSecond = 10;
    } else {
        self.levelTimer.frameInterval = 6;
    }
    
    [self.levelTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

// 停止定时器
- (void)stopMeterTimer {
    [self.levelTimer invalidate];
    self.levelTimer = nil;
}

- (void)stopRecordTimer {
    
    [self.recordTimer invalidate];
    self.recordTimer = nil;
    
}

- (void)updateMeter {
    CGFloat level = [[WFRecordTool shareRecordTool] updateLevels];
    NSLog(@"%f",level);
    [self.currentLevels removeLastObject];
    [self.currentLevels insertObject:@(level) atIndex:0];
    [self.allLevels addObject:@(level)];
    NSLog(@"%@",self.allLevels);
    [self updateLevelLayer];
}

- (void)updateLevelLayer {
    self.levelPath = [UIBezierPath bezierPath];
    
    CGFloat height = CGRectGetHeight(self.levelLayer.frame);
    for (int i = 0; i < self.currentLevels.count; i++) {
        CGFloat x = i * (levelWidth + levelMargin) + 5;
        CGFloat pathH = [self.currentLevels[i] floatValue] * height;
        CGFloat startY = height / 2.0 - pathH / 2.0;
        CGFloat endY = height / 2.0 + pathH / 2.0;
        [_levelPath moveToPoint:CGPointMake(x, startY)];
        [_levelPath addLineToPoint:CGPointMake(x, endY)];
    }
    
    self.levelLayer.path = _levelPath.CGPath;
}


- (void)showHUDWithType:(WFRecordVoiceHUDType)type {
    [self shareVoiceHudWithType:type];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}

- (void)updateTimeWithRecordTime:(NSInteger)recordTime {
    
    NSString *text;
    if (recordTime < 60) {
        text = [NSString stringWithFormat:@"0:%02zd",recordTime];
    } else {
        NSInteger minutes = recordTime / 60;
        NSInteger seconed = recordTime % 60;
        text = [NSString stringWithFormat:@"%zd:%02zd",minutes,seconed];
    }
    _hud.timeLabel.text = text;
    
    if (maxRecordTime - recordTime <= 0) {
        _hud.countDownLabel.text = @"0";
        [self setType:WFRecordVoiceHUDTypeAudioTooLong];
    } else {
        _hud.countDownLabel.text = @(maxRecordTime - recordTime).stringValue;
    }
    
}




- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat containViewW = (140);
    CGFloat containViewH = (140);
    CGFloat containViewX = (kScreenWidth - containViewW) * 0.5;
    CGFloat containViewY = (kScreenHeight - containViewH) * 0.5;
    CGRect containViewF = CGRectMake(containViewX, containViewY, containViewW, containViewH);
    self.containView.frame = containViewF;
    [self.containView cornerAllCornersWithCornerRadius:(5)];
    
    self.gradientLayer.frame = self.containView.bounds;
    
    self.countDownLabel.frame = self.containView.bounds;
    
    self.levelContentView.frame = self.containView.bounds;
    
    self.replicatorL.frame = self.levelContentView.layer.bounds;
    
    self.timeLabel.frame = CGRectMake(0, 0, (38), containViewH);
    self.timeLabel.center = self.levelContentView.center;
    
    
    self.levelLayer.frame = CGRectMake(self.timeLabel.mj_x + self.timeLabel.mj_w, 0, self.levelContentView.mj_w / 2.0 - self.timeLabel.mj_w *0.5, self.levelContentView.mj_h);
    
    CGFloat centerImageViewY = (32);
    CGFloat centerImageViewW = (57);
    CGFloat centerImageViewH = (57);
    CGFloat centerImageViewX = (self.containView.mj_w - centerImageViewW) * 0.5;
    CGRect centerImageViewF = CGRectMake(centerImageViewX, centerImageViewY, centerImageViewW, centerImageViewH);
    self.centerImageView.frame = centerImageViewF;
    
    
    CGFloat describeLabelX = 0;
    CGFloat describeLabelY = (119);
    CGFloat describeLabelW = self.containView.mj_w;
    CGFloat describeLabelH = (13);
    CGRect describeLabelF = CGRectMake(describeLabelX, describeLabelY, describeLabelW, describeLabelH);
    self.describeLabel.frame = describeLabelF;
}

@end
