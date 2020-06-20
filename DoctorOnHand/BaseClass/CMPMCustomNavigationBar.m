//
//  CMPMCustomNavigationBar.m
//  CommunityMPM
//
//  Created by gangneng shen on 2019/12/4.
//  Copyright © 2019 jifenzhi. All rights reserved.
//

#import "CMPMCustomNavigationBar.h"
#import "UIImage+CMPMExtension.h"

@interface CMPMCustomNavigationBar ()

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *backgroundColor;

@end

@implementation CMPMCustomNavigationBar

#pragma mark - Public Method
- (void)updateTitleColor:(UIColor *)tColor backgroundColor:(UIColor *)bgColor {
    self.titleColor = tColor;
    self.backgroundColor = bgColor;
    [self updateAttributes];
    [self layoutIfNeeded];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.barStyle = UIBarStyleDefault;
        self.translucent = NO;
        if (!self.titleColor) {
            self.titleColor = kBlackColor;
        }
        if (!self.backgroundColor) {
            self.backgroundColor = kWhiteColor;
        }
        [self updateAttributes];
    }
    return self;
}

- (void)updateAttributes {
    NSMutableDictionary * textDic = [NSMutableDictionary dictionaryWithCapacity:4];
    [textDic setObject:BoldSystemFont(19) forKey:NSFontAttributeName];
    [textDic setObject:self.titleColor forKey:NSForegroundColorAttributeName];
    self.titleTextAttributes = textDic;
    [self setBackgroundImage:[UIImage getImageFromColor:self.backgroundColor] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[[UIImage alloc] init]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (point.x < 20) {
        // 如果点击范围小于20，则让20点范围上的视图响应
        point = CGPointMake(20, point.y);
    }
    return [super hitTest:point withEvent:event];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // iOS8~10
    Class backgroundClass = NSClassFromString(@"_UINavigationBarBackground");
    Class statusBarBackgroundClass = NSClassFromString(@"_UIBarBackgroundTopCurtainView");
    // iOS10
    Class barBackground = NSClassFromString(@"_UIBarBackground");
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:backgroundClass]) {
            for (UIView * v in view.subviews) {
                if ([v isKindOfClass:statusBarBackgroundClass]) {
                    v.backgroundColor = self.backgroundColor;
                }
            }
        } else if ([view isKindOfClass:barBackground]) {
            view.backgroundColor = self.backgroundColor;
            if (view.subviews.count > 1) {
                view.subviews[1].hidden = YES;
            }
        }
    }
}

@end
