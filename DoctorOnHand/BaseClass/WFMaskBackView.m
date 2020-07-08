//
//  WFMaskBackView.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFMaskBackView.h"
#import "AppDelegate.h"

const CGFloat kMaskingAlpha = 0.1;
const CGFloat kWindowToScale = 1.0;
static NSString *kTransform = @"transform";

@interface WFMaskBackView ()

@property(nonatomic, weak) UIView *rootControllerView;

@end

@implementation WFMaskBackView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.arrayImage = [NSMutableArray array];
        self.backgroundColor = [UIColor blackColor];
        self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.maskView = [[UIView alloc] initWithFrame:self.bounds];
        self.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:kMaskingAlpha];
        [self addSubview: self.imgView];
    }
    return self;
}

- (void)removeObserver {
    [self.rootControllerView removeObserver:self forKeyPath:kTransform context:nil];
}

- (void)addObserver {
    self.rootControllerView = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController.view;
    [self.rootControllerView addObserver:self forKeyPath:kTransform options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kTransform]) {
        NSValue *value  = [change objectForKey:NSKeyValueChangeNewKey];
        CGAffineTransform newTransform = [value CGAffineTransformValue];
        [self showEffectChange:CGPointMake(newTransform.tx, 0)];
    }
}

- (void)showEffectChange:(CGPoint)pt {
    if (pt.x > 0){
        _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:-pt.x / ([UIScreen mainScreen].bounds.size.width) * kMaskingAlpha + kMaskingAlpha];
        _imgView.transform = CGAffineTransformMakeScale(kWindowToScale + (pt.x / ([UIScreen mainScreen].bounds.size.width) * (1 - kWindowToScale)), kWindowToScale + (pt.x / ([UIScreen mainScreen].bounds.size.width) * (1 - kWindowToScale)));
    }
    if (pt.x < 0){
        _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.5];
        _imgView.transform = CGAffineTransformIdentity;
    }
}

- (void)restore {
    if (_maskView && _imgView){
        _maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:kMaskingAlpha];
        _imgView.transform = CGAffineTransformMakeScale(kWindowToScale, kWindowToScale);
    }
}

- (void)dealloc {
    [self removeObserver];
}

@end
