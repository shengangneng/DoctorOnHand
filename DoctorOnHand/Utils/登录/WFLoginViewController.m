//
//  WFLoginViewController.m
//  DoctorOnHand
//
//  Created by gangneng shen on 2020/6/18.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFLoginViewController.h"
#import "WFBrushBoardView.h"

@interface WFLoginViewController ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIImageView *logoNameView;
@property (nonatomic, strong) UIImageView *insetView;
@property (nonatomic, strong) UILabel *brifeLabel;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UIImageView *passIcon;
@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *passTextField;
@property (nonatomic, strong) UIView *userLine;
@property (nonatomic, strong) UIView *passLine;
@property (nonatomic, strong) UIButton *loginBt;
@property (nonatomic, strong) UIButton *canceBt;

@end

@implementation WFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupAttributes {
    [self.bgImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapback)]];
    [self.loginBt addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.canceBt addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self.view addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.contentView];
    [self.contentView addSubview:self.insetView];
    [self.contentView addSubview:self.logoView];
    [self.contentView addSubview:self.logoNameView];
    [self.contentView addSubview:self.brifeLabel];
    [self.contentView addSubview:self.userIcon];
    [self.contentView addSubview:self.passIcon];
    [self.contentView addSubview:self.userTextField];
    [self.contentView addSubview:self.passTextField];
    [self.contentView addSubview:self.userLine];
    [self.contentView addSubview:self.passLine];
    [self.contentView addSubview:self.loginBt];
    [self.contentView addSubview:self.canceBt];
}

- (void)setupConstraints {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView.mas_centerX);
        make.centerY.equalTo(self.bgImageView.mas_centerY);
        make.width.equalTo(@510);
        make.height.equalTo(@265);
    }];
    [self.insetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@180);
        make.height.equalTo(@156.5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-24);
        make.leading.equalTo(self.contentView.mas_leading).offset(17);
    }];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60.5);
        make.height.equalTo(@7.5);
        make.bottom.equalTo(self.contentView.mas_top).offset(16);
        make.leading.equalTo(self.contentView.mas_leading).offset(30);
    }];
    [self.logoNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@102.5);
        make.height.equalTo(@19);
        make.top.equalTo(self.logoView.mas_bottom).offset(7.5);
        make.leading.equalTo(self.contentView.mas_leading).offset(30);
    }];
    [self.brifeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(225);
        make.top.equalTo(self.contentView.mas_top).offset(21.5);
    }];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@15);
        make.leading.equalTo(self.contentView.mas_leading).offset(225);
        make.top.equalTo(self.contentView.mas_top).offset(71.5);
    }];
    [self.passIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@15);
        make.leading.equalTo(self.userIcon.mas_leading);
        make.top.equalTo(self.userIcon.mas_bottom).offset(42);
    }];
    [self.userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userIcon.mas_trailing).offset(10);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-25);
        make.centerY.equalTo(self.userIcon.mas_centerY);
    }];
    [self.passTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.passIcon.mas_trailing).offset(10);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-25);
        make.centerY.equalTo(self.passIcon.mas_centerY);
    }];
    [self.userLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userIcon.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-25);
        make.top.equalTo(self.userIcon.mas_bottom).offset(13);
        make.height.equalTo(@0.5);
    }];
    [self.passLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.passIcon.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-25);
        make.top.equalTo(self.passIcon.mas_bottom).offset(13);
        make.height.equalTo(@0.5);
    }];
    [self.loginBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.passIcon.mas_leading);
        make.width.equalTo(@151.5);
        make.height.equalTo(@38);
        make.top.equalTo(self.passLine.mas_bottom).offset(28);
    }];
    [self.canceBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-25);
        make.width.equalTo(@89.5);
        make.height.equalTo(@38);
        make.top.equalTo(self.passLine.mas_bottom).offset(28);
    }];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Target Action

- (void)tapback {
    [self.view endEditing:YES];
}
- (void)login:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cancel:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Lazy Init

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:ImageName(@"login_bg")];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = kWhiteColor;
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.shadowColor = kRGBA(0, 35, 91, 0.2).CGColor;
        _contentView.layer.shadowOffset = CGSizeMake(0,5);
        _contentView.layer.shadowOpacity = 1;
        _contentView.layer.shadowRadius = 15;
    }
    return _contentView;
}
- (UIImageView *)insetView {
    if (!_insetView) {
        _insetView = [[UIImageView alloc] initWithImage:ImageName(@"login_inset")];
    }
    return _insetView;
}
- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithImage:ImageName(@"login_logo")];
    }
    return _logoView;
}
- (UIImageView *)logoNameView {
    if (!_logoNameView) {
        _logoNameView = [[UIImageView alloc] initWithImage:ImageName(@"login_logo_name")];
    }
    return _logoNameView;
}
- (UILabel *)brifeLabel {
    if (!_brifeLabel) {
        _brifeLabel = [[UILabel alloc] init];
        _brifeLabel.font = SystemFont(17);
        _brifeLabel.textAlignment = NSTextAlignmentLeft;
        [_brifeLabel sizeToFit];
        _brifeLabel.text = @"请登录";
        _brifeLabel.textColor = kRGBA(204, 204, 204, 1);
    }
    return _brifeLabel;
}
- (UIImageView *)userIcon {
    if (!_userIcon) {
        _userIcon = [[UIImageView alloc] initWithImage:ImageName(@"login_user")];
    }
    return _userIcon;
}
- (UIImageView *)passIcon {
    if (!_passIcon) {
        _passIcon = [[UIImageView alloc] initWithImage:ImageName(@"login_pass")];
    }
    return _passIcon;
}
- (UITextField *)userTextField {
    if (!_userTextField) {
        _userTextField = [[UITextField alloc] init];
        _userTextField.font = SystemFont(12);
        _userTextField.textAlignment = NSTextAlignmentLeft;
        [_userTextField sizeToFit];
        _userTextField.placeholder = @"工号/手机号/姓名";
        _userTextField.textColor = kRGBA(153, 153, 153, 1);
    }
    return _userTextField;
}
- (UITextField *)passTextField {
    if (!_passTextField) {
        _passTextField = [[UITextField alloc] init];
        _passTextField.font = SystemFont(12);
        [_passTextField sizeToFit];
        _passTextField.textAlignment = NSTextAlignmentLeft;
        _passTextField.placeholder = @"请输入密码";
        _passTextField.textColor = kRGBA(153, 153, 153, 1);
    }
    return _passTextField;
}
- (UIView *)userLine {
    if (!_userLine) {
        _userLine = [[UIView alloc] init];
        _userLine.backgroundColor = kRGBA(216, 216, 216, 1);
    }
    return _userLine;
}
- (UIView *)passLine {
    if (!_passLine) {
        _passLine = [[UIView alloc] init];
        _passLine.backgroundColor = kRGBA(216, 216, 216, 1);
    }
    return _passLine;
}
- (UIButton *)loginBt {
    if (!_loginBt) {
        _loginBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBt.layer.backgroundColor = kRGBA(22, 120, 255, 1).CGColor;
        _loginBt.layer.cornerRadius = 19;
        _loginBt.layer.shadowColor = kRGBA(53, 134, 248, 1).CGColor;
        _loginBt.layer.shadowOffset = CGSizeMake(0,2.5);
        _loginBt.layer.shadowOpacity = 1;
        _loginBt.layer.shadowRadius = 10;
        [_loginBt setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBt setTitle:@"登录" forState:UIControlStateHighlighted];
        [_loginBt setTitle:@"登录" forState:UIControlStateSelected];
        [_loginBt setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_loginBt setTitleColor:kWhiteColor forState:UIControlStateHighlighted];
        [_loginBt setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _loginBt.titleLabel.font = SystemFont(13);
    }
    return _loginBt;
}
- (UIButton *)canceBt {
    if (!_canceBt) {
        _canceBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _canceBt.layer.borderWidth = 0.5;
        _canceBt.layer.borderColor = kRGBA(22, 120, 255, 1).CGColor;
        _canceBt.layer.backgroundColor = kWhiteColor.CGColor;
        _canceBt.layer.cornerRadius = 19;
        [_canceBt setTitle:@"取消" forState:UIControlStateNormal];
        [_canceBt setTitle:@"取消" forState:UIControlStateHighlighted];
        [_canceBt setTitle:@"取消" forState:UIControlStateSelected];
        [_canceBt setTitleColor:kRGBA(22, 120, 255, 1) forState:UIControlStateNormal];
        [_canceBt setTitleColor:kRGBA(22, 120, 255, 1) forState:UIControlStateHighlighted];
        [_canceBt setTitleColor:kRGBA(22, 120, 255, 1) forState:UIControlStateSelected];
        _canceBt.titleLabel.font = SystemFont(13);
    }
    return _canceBt;
}

@end
