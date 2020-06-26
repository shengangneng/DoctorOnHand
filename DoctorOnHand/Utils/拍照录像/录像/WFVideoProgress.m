//
//  WFVideoProgress.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/25.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFVideoProgress.h"

@interface WFVideoProgress ()

@property (nonatomic, weak) UIView *tView;

@end

@implementation WFVideoProgress

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 背景
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        back.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.3f];
        back.layer.cornerRadius = self.bounds.size.height * 0.5;
        back.layer.masksToBounds = YES;
        [self addSubview:back];
        
        // 进度
        UIView *tView = [[UIView alloc] init];
        tView.backgroundColor = kWhiteColor;
        tView.layer.cornerRadius = self.bounds.size.height * 0.5;
        tView.layer.masksToBounds = YES;
        [self addSubview:tView];
        self.tView = tView;
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress duration:(CGFloat)duration {
    if (progress > 1) progress = 1;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _tView.frame = CGRectMake(0, 0, self.bounds.size.width * progress, self.bounds.size.height);
    } completion:nil];
}

@end
