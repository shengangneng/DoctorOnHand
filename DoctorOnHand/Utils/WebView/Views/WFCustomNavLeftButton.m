//
//  WFCustomNavLeftButton.m
//  DoctorOnHand
//
//  Created by sgn on 2020/7/8.
//  Copyright © 2020 sgn. All rights reserved.
//

#import "WFCustomNavLeftButton.h"
#import "UIButton+WFExtension.h"

@interface WFCustomNavLeftButton ()

@property (nonatomic, strong) UIButton *exitButton;     /** 关闭按钮，只在H5要求，才会在第二层级及以后才会出现 */

@end

@implementation WFCustomNavLeftButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.exitButton addTarget:self action:@selector(exit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setShowExit:(BOOL)showExit {
    _showExit = showExit;
    if (showExit) {
        [self addSubview:self.exitButton];
    } else {
        [self.exitButton removeFromSuperview];
    }
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self.exitButton setTitleColor:color forState:UIControlStateNormal];
    [self.exitButton setTitleColor:color forState:UIControlStateHighlighted];
    [self setNeedsDisplay];
}

- (void)exit:(UIButton *)sender {
    if (self.exitBlock) {
        self.exitBlock(sender);
    }
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!self.color) {
        self.color = kBlackColor;
    }
    [self.color setStroke];
    CGContextSetLineWidth(context, 2.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextMoveToPoint(context, 10, self.frame.size.height / 2 - 9);
    CGContextAddLineToPoint(context, 1, self.frame.size.height / 2);
    CGContextAddLineToPoint(context, 10, self.frame.size.height / 2 + 9);
    CGContextStrokePath(context);
}

#pragma mark - Lazy Init
- (UIButton *)exitButton {
    if (!_exitButton) {
        _exitButton = [UIButton normalButtonWithTitle:(@"关闭") titleColor:kBlackColor bgcolor:kClearColor];
        [_exitButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_exitButton setTitleColor:kBlackColor forState:UIControlStateHighlighted];
        _exitButton.layer.masksToBounds = NO;
        _exitButton.backgroundColor = kRedColor;
        _exitButton.titleLabel.font = BoldSystemFont(19);
        _exitButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_exitButton setTitleEdgeInsets:UIEdgeInsetsMake(-1, 0, 0, 0)];
        _exitButton.frame = CGRectMake(28, 0, 40, 44);
    }
    return _exitButton;
}

@end
