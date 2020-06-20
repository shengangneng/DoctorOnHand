//
//  CMPMBaseNavigationBar.m
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/7.
//  Copyright © 2019年 jifenzhi. All rights reserved.
//

#import "CMPMBaseNavigationBar.h"
#import "UIImage+CMPMExtension.h"

@interface CMPMBaseNavigationBar ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CMPMBaseNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.barStyle = UIBarStyleDefault;
        self.translucent = NO;
        [self style2];
    }
    return self;
}

- (void)style1 {
    // 设置背景图片
    NSMutableDictionary * textDic = [NSMutableDictionary dictionaryWithCapacity:4];
    [textDic setObject:BoldSystemFont(18) forKey:NSFontAttributeName];
    [textDic setObject:kWhiteColor forKey:NSForegroundColorAttributeName];
    self.titleTextAttributes = textDic;
    [self setBackgroundImage:[UIImage getImageFromColor:kMainBlueColor] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[[UIImage alloc] init]];
}

- (void)style2 {
    // 白色背景，底部有线条
    NSMutableDictionary * textDic = [NSMutableDictionary dictionaryWithCapacity:4];
    [textDic setObject:BoldSystemFont(18) forKey:NSFontAttributeName];
    [textDic setObject:kBlackColor forKey:NSForegroundColorAttributeName];
    self.titleTextAttributes = textDic;
    [self setBackgroundImage:[UIImage getImageFromColor:kWhiteColor] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[[UIImage alloc] init]];
}

- (void)whiteTitle {
    NSMutableDictionary * textDic = [NSMutableDictionary dictionaryWithCapacity:4];
    [textDic setObject:BoldSystemFont(18) forKey:NSFontAttributeName];
    [textDic setObject:kWhiteColor forKey:NSForegroundColorAttributeName];
    self.titleTextAttributes = textDic;
}
- (void)blackTitle {
    NSMutableDictionary * textDic = [NSMutableDictionary dictionaryWithCapacity:4];
    [textDic setObject:BoldSystemFont(18) forKey:NSFontAttributeName];
    [textDic setObject:kBlackColor forKey:NSForegroundColorAttributeName];
    self.titleTextAttributes = textDic;
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
                    v.backgroundColor = kWhiteColor;
                }
            }
        } else if ([view isKindOfClass:barBackground]) {
            view.backgroundColor = kWhiteColor;
            if (view.subviews.count > 1) {
                view.subviews[1].hidden = YES;
            }
        }
    }
}

#pragma mark - Lazy Init
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = SystemFont(18);
        _titleLabel.textColor = kBlackColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
