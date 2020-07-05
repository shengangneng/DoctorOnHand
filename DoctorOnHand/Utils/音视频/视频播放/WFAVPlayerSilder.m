//
//  WFAVPlayerSilder.m
//  DoctorOnHand
//
//  Created by shengangneng on 20/6/18.
//  Copyright © 2020年 shengangneng. All rights reserved.
//

#import "WFAVPlayerSilder.h"

#define SilderH 3
#define SlipW 12
@implementation WFAVPlayerSilder

- (instancetype)init {
    if (self = [super init]) {
        
        [self addSubview:self.tapView];
        [self.tapView addSubview:self.baseView];
        [self.tapView addSubview:self.bufferView];
        [self.tapView addSubview:self.trackView];
        [self addSubview:self.slipImgView];
    }
    return self;
}

- (void)tapGRAction:(UITapGestureRecognizer *)tapGR {
    CGPoint touchPoint = [tapGR locationInView:self];
    
    if (self.tapChangeValue) {
        self.tapChangeValue(touchPoint.x / self.frame.size.width);
//        self.trackValue = touchPoint.x / self.frame.size.width;
    }
}

- (void)slipImgPanGRAction:(UIPanGestureRecognizer *)panGR {
    //获取偏移量
    CGFloat moveX = [panGR translationInView:self].x;
    
    //重置偏移量，避免下次获取到的是原基础的增量
    [panGR setTranslation:CGPointMake(0, 0) inView:self];
    
    //计算当前中心值
    CGFloat centerX = CGRectGetMaxX(self.slipImgView.frame) - SlipW * 0.5 + moveX;
    
    //防止瞬间大偏移量滑动影响显示效果
    if (centerX < 10) centerX = 10;
    if (centerX > self.bounds.size.width - 10) centerX = self.bounds.size.width - 10;
    
    self.trackValue = centerX / self.frame.size.width;
    
    if (panGR.state == UIGestureRecognizerStateEnded) {
        
        if (self.tapChangeValue) {
            self.tapChangeValue((CGRectGetMaxX(self.slipImgView.frame) - SlipW * 0.5) / self.frame.size.width);
        }
    }
}

- (void)setBufferValue:(float)bufferValue {
    _bufferValue = bufferValue;
    // TODO：会闪退
    /* Terminating app due to uncaught exception 'CALayerInvalidGeometry', reason: 'CALayer position contains NaN: [nan 5.5]'
    *** First throw call stack:
    (0x1c857eab8 0x1c7783d00 0x1c84842f4 0x1ccb628fc 0x1ccb62848 0x1ccb6220c 0x1f5e3d5e8 0x103022f00 0x102fe8ea8 0x102fe870c 0x1c8fe2284 0x1c8fe46c4 0x1c8fe1b04 0x1ce61c270 0x10331b1fc 0x10331c77c 0x10332a158 0x1c850e734 0x1c85093e4 0x1c8508964 0x1ca749d8c 0x1f59a5758 0x10300cdfc 0x1c7fc4fd8)
    libc++abi.dylib: terminating with uncaught exception of type NSException
     */
    self.bufferView.frame = CGRectMake(0, (SlipW - SilderH) / 2, self.frame.size.width * (bufferValue / 1.0), CGRectGetHeight(self.bufferView.frame));
}

- (void)setTrackValue:(float)trackValue {
    _trackValue = trackValue;
    
    CGFloat finishW = self.frame.size.width * trackValue;
    self.trackView.frame = CGRectMake(0, (SlipW - SilderH) / 2, finishW, CGRectGetHeight(self.trackView.frame));
    self.slipImgView.frame = CGRectMake(finishW - SlipW * 0.5, (self.frame.size.height - SlipW) * 0.5, SlipW, SlipW);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tapView.frame = CGRectMake(0, (self.frame.size.height - SlipW) / 2, self.frame.size.width, SlipW);
    self.baseView.frame = CGRectMake(0, (SlipW - SilderH) / 2, self.frame.size.width, SilderH);

    self.bufferView.frame = CGRectMake(0, (SlipW - SilderH) / 2, 0, SilderH);
    self.trackView.frame = CGRectMake(0, (SlipW - SilderH) / 2, 0, SilderH);
    self.slipImgView.frame = CGRectMake(0, (self.frame.size.height - SlipW) * 0.5, SlipW, SlipW);
}

#pragma mark - Lazy Init

- (UIView *)tapView {
    if (_tapView == nil) {
        _tapView = [[UIView alloc] init];
        _tapView.frame = CGRectMake(0, (self.frame.size.height - SlipW) / 2, self.frame.size.width, SlipW);
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
        [_tapView addGestureRecognizer:tapGR];
    }
    return _tapView;
}

- (UIView *)baseView {
    if (_baseView == nil) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = [UIColor whiteColor];
//        _baseView.frame = CGRectMake(0, (SlipW - SilderH) / 2, self.frame.size.width, SilderH);
        _baseView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    }
    return _baseView;
}

- (UIView *)bufferView {
    if (_bufferView == nil) {
        _bufferView = [[UIView alloc] init];
        _bufferView.backgroundColor = [UIColor grayColor];
//        _bufferView.frame = CGRectMake(0, (SlipW - SilderH) / 2, 0, SilderH);
    }
    return _bufferView;
}

- (UIView *)trackView {
    if (_trackView == nil) {
        _trackView = [[UIView alloc] init];
        _trackView.backgroundColor = [UIColor orangeColor];
//        _trackView.frame = CGRectMake(0, (SlipW - SilderH) / 2, 0, SilderH);
    }
    return _trackView;
}

- (UIImageView *)slipImgView {
    if (_slipImgView == nil) {
        _slipImgView = [[UIImageView alloc] init];
        _slipImgView.contentMode = UIViewContentModeScaleAspectFit;
        _slipImgView.image = [UIImage imageNamed:@"btn_player_slider_thumb"];
//        _slipImgView.frame = CGRectMake(0, (self.frame.size.height - SlipW) * 0.5, SlipW, SlipW);
        _slipImgView.userInteractionEnabled = YES;
        [_slipImgView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slipImgPanGRAction:)]];
    }
    return _slipImgView;
}

@end
