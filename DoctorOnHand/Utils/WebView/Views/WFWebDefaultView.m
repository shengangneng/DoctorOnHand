//
//  WFWebDefaultView.m
//  DoctorOnHand
//
//  Created by sgn on 2020/7/8.
//  Copyright © 2020 sgn. All rights reserved.
//

#import "WFWebDefaultView.h"

@interface WFWebDefaultView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *refreshButton;

@end

@implementation WFWebDefaultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = WebDefaultViewTypeNoNetwork;
        self.backgroundColor = kRGBA(248, 248, 248, 1);
        [self setupSubViews];
        [self sutupConstaints];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.refreshButton];
}

- (void)sutupConstaints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(50);
        make.trailing.equalTo(self.mas_trailing).offset(-50);
        make.centerY.equalTo(self.mas_centerY).offset(20);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.titleLabel.mas_top).offset(-40);
    }];
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(25);
        make.width.equalTo(@75);
        make.centerX.equalTo(self.titleLabel.mas_centerX);
    }];
}

- (void)setType:(WebDefaultViewType)type {
    switch (type) {
        case WebDefaultViewTypeNoNetwork: {
            self.imageView.image = ImageName(@"network_err");
            self.titleLabel.text = (@"当前网络不可用，请稍后重试");
            self.refreshButton.hidden = NO;
        }break;
        case WebDefaultViewTypeNetworkBusy: {
            self.imageView.image = ImageName(@"network_err");
            self.titleLabel.text = (@"当前网络繁忙，请稍后重试");
            self.refreshButton.hidden = NO;
        }break;
        case WebDefaultViewTypeRequestFail: {
            self.imageView.image = ImageName(@"request_fail");
            self.titleLabel.text = (@"服务器开小差了，请稍后再试");
            self.refreshButton.hidden = YES;
        }break;
        default:
            break;
    }
}

#pragma mark - Target Action
- (void)refreshView:(UIButton *)sender {
    // 刷新
    if (self.delegate && [self.delegate respondsToSelector:@selector(webDefaultViewDidRefresh)]) {
        [self.delegate webDefaultViewDidRefresh];
    }
}

#pragma mark - Lazy Init
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, 25)];
        _titleLabel.text = (@"网络中断，请检查您的网络状态");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
        _titleLabel.textColor = kTextLightColor;
        _titleLabel.font = SystemFont(16);
    }
    return _titleLabel;
}

- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton sizeToFit];
        _refreshButton.layer.borderColor = kMainBlueColor.CGColor;
        _refreshButton.layer.cornerRadius = 5;
        _refreshButton.layer.borderWidth = 1;
        [_refreshButton setTitle:(@"重新加载") forState:UIControlStateNormal];
        [_refreshButton setTitleColor:kMainBlueColor forState:UIControlStateNormal];
        [_refreshButton setTitle:(@"重新加载") forState:UIControlStateHighlighted];
        [_refreshButton setTitleColor:kTextLightColor forState:UIControlStateHighlighted];
        _refreshButton.titleLabel.font = SystemFont(15);
        [_refreshButton addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

@end
