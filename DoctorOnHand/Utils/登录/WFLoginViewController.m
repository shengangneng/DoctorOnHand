//
//  WFLoginViewController.m
//  DoctorOnHand
//
//  Created by gangneng shen on 2020/6/18.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFLoginViewController.h"
#import "WFBrushBoardView.h"
#import "WFWKWebViewController.h"
#import "WFBaseNavigationController.h"

@interface WFLoginViewController () <UITextFieldDelegate>

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
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
        make.width.equalTo(@765);
        make.height.equalTo(@398);
    }];
    [self.insetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@270);
        make.height.equalTo(@235);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-36);
        make.leading.equalTo(self.contentView.mas_leading).offset(25.5);
    }];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@90.5);
        make.height.equalTo(@11);
        make.top.equalTo(self.contentView.mas_top).offset(24);
        make.leading.equalTo(self.contentView.mas_leading).offset(45);
    }];
    [self.logoNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@154);
        make.height.equalTo(@28.5);
        make.top.equalTo(self.logoView.mas_bottom).offset(11);
        make.leading.equalTo(self.contentView.mas_leading).offset(45);
    }];
    [self.brifeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(337.5);
        make.top.equalTo(self.contentView.mas_top).offset(32);
    }];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22.5);
        make.leading.equalTo(self.contentView.mas_leading).offset(337.5);
        make.top.equalTo(self.contentView.mas_top).offset(107);
    }];
    [self.passIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22.5);
        make.leading.equalTo(self.userIcon.mas_leading);
        make.top.equalTo(self.userIcon.mas_bottom).offset(63);
    }];
    [self.userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userIcon.mas_trailing).offset(15);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-37.5);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.userIcon.mas_centerY);
    }];
    [self.passTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.passIcon.mas_trailing).offset(15);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-37.5);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.passIcon.mas_centerY);
    }];
    [self.userLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userIcon.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-37.5);
        make.top.equalTo(self.userIcon.mas_bottom).offset(19.5);
        make.height.equalTo(@1);
    }];
    [self.passLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.passIcon.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-37.5);
        make.top.equalTo(self.passIcon.mas_bottom).offset(19.5);
        make.height.equalTo(@1);
    }];
    [self.loginBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.passIcon.mas_leading);
        make.width.equalTo(@227);
        make.height.equalTo(@57);
        make.top.equalTo(self.passLine.mas_bottom).offset(42);
    }];
    [self.canceBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-37.5);
        make.width.equalTo(@134);
        make.height.equalTo(@57);
        make.top.equalTo(self.passLine.mas_bottom).offset(42);
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
    NSString *path = [[NSBundle mainBundle] pathForResource:(@"index") ofType:@"html" inDirectory:@"WebResources"];
    NSURL *url = [NSURL fileURLWithPath:path];
    WFWKWebViewController *web = [[WFWKWebViewController alloc] initWithFileURL:url];
    web.webViewUIConfiguration.navHidden = YES;
    WFBaseNavigationController *nav = [[WFBaseNavigationController alloc] initWithRootViewController:web];
    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
}

- (void)cancel:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Keyboard Notification
- (void)keyboardChange:(NSNotification *)notification {
    // 比较键盘高度和TextField的底部位置-设置键盘偏移
    NSDictionary *info = notification.userInfo;
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ll;
    CGFloat originY = (kScreenHeight - CGRectGetHeight(self.contentView.frame)) / 2;
    // 250
    if (self.userTextField.isFirstResponder) {
        ll = CGRectGetMaxY(self.passLine.frame) + originY;
    } else {
        ll = CGRectGetMaxY(self.loginBt.frame) + originY;
    }
    [self changeFrameWithKeyboardOriginY:endKeyboardRect.origin.y textFieldMaxY:ll];
}

- (void)changeFrameWithKeyboardOriginY:(double)y textFieldMaxY:(double)ty {
    if (y < ty) {
        CGFloat delta = ty - y;
        CGAffineTransform pTransform = CGAffineTransformMakeTranslation(0, -delta);
        [UIView animateWithDuration:0.25 animations:^{
            self.contentView.transform = pTransform;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.contentView.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userTextField) {
        [self.passTextField becomeFirstResponder];
    } else if (textField == self.passTextField) {
        [self.view endEditing:YES];
    }
    return YES;
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
        _contentView.layer.cornerRadius = 15;
        _contentView.layer.shadowColor = kRGBA(0, 35, 91, 0.2).CGColor;
        _contentView.layer.shadowOffset = CGSizeMake(0,5);
        _contentView.layer.shadowOpacity = 1;
        _contentView.layer.shadowRadius = 22.5;
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
        _brifeLabel.font = SystemFont(25.5);
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
        _userTextField.font = SystemFont(18);
        _userTextField.textAlignment = NSTextAlignmentLeft;
        [_userTextField sizeToFit];
        _userTextField.delegate = self;
        _userTextField.placeholder = @"工号/手机号/姓名";
        _userTextField.textColor = kRGBA(153, 153, 153, 1);
    }
    return _userTextField;
}
- (UITextField *)passTextField {
    if (!_passTextField) {
        _passTextField = [[UITextField alloc] init];
        _passTextField.font = SystemFont(18);
        [_passTextField sizeToFit];
        _passTextField.delegate = self;
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
        _loginBt.layer.cornerRadius = 28.5;
        _loginBt.layer.shadowColor = kRGBA(53, 134, 248, 1).CGColor;
        _loginBt.layer.shadowOffset = CGSizeMake(0,2.5);
        _loginBt.layer.shadowOpacity = 1;
        _loginBt.layer.shadowRadius = 15;
        [_loginBt setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBt setTitle:@"登录" forState:UIControlStateHighlighted];
        [_loginBt setTitle:@"登录" forState:UIControlStateSelected];
        [_loginBt setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_loginBt setTitleColor:kWhiteColor forState:UIControlStateHighlighted];
        [_loginBt setTitleColor:kWhiteColor forState:UIControlStateSelected];
        _loginBt.titleLabel.font = SystemFont(19.5);
    }
    return _loginBt;
}
- (UIButton *)canceBt {
    if (!_canceBt) {
        _canceBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _canceBt.layer.borderWidth = 1;
        _canceBt.layer.borderColor = kRGBA(22, 120, 255, 1).CGColor;
        _canceBt.layer.backgroundColor = kWhiteColor.CGColor;
        _canceBt.layer.cornerRadius = 28.5;
        [_canceBt setTitle:@"取消" forState:UIControlStateNormal];
        [_canceBt setTitle:@"取消" forState:UIControlStateHighlighted];
        [_canceBt setTitle:@"取消" forState:UIControlStateSelected];
        [_canceBt setTitleColor:kRGBA(22, 120, 255, 1) forState:UIControlStateNormal];
        [_canceBt setTitleColor:kRGBA(22, 120, 255, 1) forState:UIControlStateHighlighted];
        [_canceBt setTitleColor:kRGBA(22, 120, 255, 1) forState:UIControlStateSelected];
        _canceBt.titleLabel.font = SystemFont(19.5);
    }
    return _canceBt;
}

@end
