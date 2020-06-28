//
//  CMPMSignatureViewController.m
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/23.
//  Copyright © 2019年 jifenzhi. All rights reserved.
//

#import "CMPMSignatureViewController.h"
#import "CMPMSignatureView.h"
#import "UIButton+CMPMExtension.h"
#import "UIViewController+CMPMExtention.h"

#define kITEM_W     30
#define kMARGIN     20

@interface CMPMSignatureViewController ()

@property (nonatomic, strong) UIButton *saveToAlbumBt;          /// 保存相册
@property (nonatomic, strong) CMPMSignatureView *signatureView; /// 手写板
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UISlider *lineWidthSlider;    /** 设置线条宽度 */
@property (nonatomic, strong) UIButton *colorButton1;       /** 红 */
@property (nonatomic, strong) UIButton *colorButton2;       /** 黄 */
@property (nonatomic, strong) UIButton *colorButton3;       /** 蓝 */
@property (nonatomic, strong) UIButton *colorButton4;       /** 黑 */
@property (nonatomic, strong) UIButton *eraserButton;       /** 橡皮擦 */
@property (nonatomic, strong) UIButton *clearButton;        /** 清空所有数据 */

@property (nonatomic, strong) UIButton *nomalPenBt;         /// 普通笔
@property (nonatomic, strong) UIButton *steelPenBt;         /// 钢笔
@property (nonatomic, strong) UIButton *lastStepBt;         /// 上一步
@property (nonatomic, strong) UIButton *nextStepBt;         /// 下一步

@end

@implementation CMPMSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.lineWidthSlider addTarget:self action:@selector(changeLineWidth:) forControlEvents:UIControlEventValueChanged];
    [self.colorButton1 addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorButton2 addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorButton3 addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorButton4 addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.saveToAlbumBt addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.lastStepBt addTarget:self action:@selector(lastStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextStepBt addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.eraserButton addTarget:self action:@selector(eraser:) forControlEvents:UIControlEventTouchUpInside];
    [self.clearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = kCommomBackgroundColor;
    [self.view addSubview:self.saveToAlbumBt];
    [self.view addSubview:self.signatureView];
    [self.view addSubview:self.lastStepBt];
    [self.view addSubview:self.nextStepBt];
    [self.view addSubview:self.nomalPenBt];
    [self.view addSubview:self.steelPenBt];
    
    [self.view addSubview:self.leftLabel];
    [self.view addSubview:self.rightLabel];
    [self.view addSubview:self.lineWidthSlider];
    [self.view addSubview:self.colorButton1];
    [self.view addSubview:self.colorButton2];
    [self.view addSubview:self.colorButton3];
    [self.view addSubview:self.colorButton4];
    [self.view addSubview:self.eraserButton];
    [self.view addSubview:self.clearButton];
    double itemW = 60;
    double borderW = (kScreenWidth - itemW * 4) / 5;
    
    [self.saveToAlbumBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
    }];
    [self.signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.nextStepBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(kMARGIN);
        make.width.height.equalTo(@(kITEM_W));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kMARGIN);
    }];
    [self.lastStepBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nextStepBt.mas_leading);
        make.width.height.equalTo(@(kITEM_W));
        make.bottom.equalTo(self.nextStepBt.mas_top).offset(-kMARGIN);
    }];
    [self.nomalPenBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nextStepBt.mas_leading);
        make.width.height.equalTo(@(kITEM_W));
        make.bottom.equalTo(self.lastStepBt.mas_top).offset(-kMARGIN);
    }];
    [self.steelPenBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nextStepBt.mas_leading);
        make.width.height.equalTo(@(kITEM_W));
        make.bottom.equalTo(self.nomalPenBt.mas_top).offset(-kMARGIN);
    }];
    
    
    [self.eraserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nextStepButton.mas_trailing).offset(borderW);
        make.width.height.equalTo(@(kITEM_W));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomHeight-10);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.eraserButton.mas_trailing).offset(borderW);
        make.width.height.equalTo(@(kITEM_W));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomHeight-10);
    }];
    
    [self.colorButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(borderW);
        make.width.equalTo(@(itemW));
        make.height.equalTo(@(kITEM_W));
        make.bottom.equalTo(self.lastStepButton.mas_top).offset(-10);
    }];
    [self.colorButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.colorButton1.mas_trailing).offset(borderW);
        make.width.equalTo(@(itemW));
        make.height.equalTo(@(kITEM_W));
        make.bottom.equalTo(self.lastStepButton.mas_top).offset(-10);
    }];
    [self.colorButton3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.colorButton2.mas_trailing).offset(borderW);
        make.width.equalTo(@(itemW));
        make.height.equalTo(@(kITEM_W));
        make.bottom.equalTo(self.lastStepButton.mas_top).offset(-10);
    }];
    [self.colorButton4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.colorButton3.mas_trailing).offset(borderW);
        make.width.equalTo(@(itemW));
        make.height.equalTo(@(kITEM_W));
        make.bottom.equalTo(self.lastStepButton.mas_top).offset(-10);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@35);
        make.trailing.equalTo(self.lineWidthSlider.mas_leading);
        make.centerY.equalTo(self.lineWidthSlider.mas_centerY);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@35);
        make.leading.equalTo(self.lineWidthSlider.mas_trailing);
        make.centerY.equalTo(self.lineWidthSlider.mas_centerY);
    }];
    [self.lineWidthSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(45);
        make.trailing.equalTo(self.view.mas_trailing).offset(-45);
        make.bottom.equalTo(self.colorButton1.mas_top).offset(-10);
        make.height.equalTo(@35);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Target Action
- (void)saveImage:(UIButton *)sender {
    // 生成截屏
    UIGraphicsBeginImageContextWithOptions(self.signatureView.frame.size, NO, 0.0);
    [self.signatureView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *shotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 保存到相册
    UIImageWriteToSavedPhotosAlbum(shotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if (error) {
        msg = @"保存图片失败";
    } else {
        msg = @"保存图片成功";
    }
}

- (void)changeLineWidth:(UISlider *)sender {
    self.signatureView.lineWidth = sender.value;
}

- (void)changeColor:(UIButton *)sender {
    self.signatureView.lineWidth = self.lineWidthSlider.value;
    self.signatureView.lineColor = sender.backgroundColor;
}

- (void)lastStep:(UIButton *)sender {
    [self.signatureView lastStep];
}

- (void)nextStep:(UIButton *)sender {
    [self.signatureView nextStep];
}

- (void)eraser:(UIButton *)sender {
    self.signatureView.lineWidth = 20;
    self.signatureView.lineColor = kWhiteColor;
}

- (void)clear:(UIButton *)sender {
    [self.signatureView clearScreen];
}

#pragma mark - Lazy Init

- (UIButton *)saveToAlbumBt {
    if (!_saveToAlbumBt) {
        _saveToAlbumBt = [UIButton titleButtonWithTitle:@"保存相册" nTitleColor:kRedColor hTitleColor:kRedColor bgColor:kCommomBackgroundColor];
    }
    return _saveToAlbumBt;
}
- (CMPMSignatureView *)signatureView {
    if (!_signatureView) {
        _signatureView = [[CMPMSignatureView alloc] init];
        _signatureView.lineType = LineTypeSteelPen;
        _signatureView.backgroundColor = kWhiteColor;
    }
    return _signatureView;
}
- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = kOrangeColor;
        _leftLabel.text = @"1";
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = kOrangeColor;
        _rightLabel.text = @"10";
        _rightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightLabel;
}

- (UISlider *)lineWidthSlider {
    if (!_lineWidthSlider) {
        _lineWidthSlider = [[UISlider alloc] init];
        _lineWidthSlider.value = 1;
        _lineWidthSlider.minimumValue = 1;
        _lineWidthSlider.maximumValue = 10;
    }
    return _lineWidthSlider;
}
- (UIButton *)lastStepBt {
    if (!_lastStepBt) {
//        _lastStepBt = [UIButton titleButtonWithTitle:@"上一步" nTitleColor:kRedColor hTitleColor:kRedColor bgColor:kCommomBackgroundColor];
        _lastStepBt = [UIButton imageButtonWithImage:ImageName(@"sign_step_last") hImage:ImageName(@"sign_step_last")];
    }
    return _lastStepBt;
}
- (UIButton *)nextStepBt {
    if (!_nextStepBt) {
//        _nextStepBt = [UIButton titleButtonWithTitle:@"下一步" nTitleColor:kRedColor hTitleColor:kRedColor bgColor:kCommomBackgroundColor];
        _nextStepBt = [UIButton imageButtonWithImage:ImageName(@"sign_step_next") hImage:ImageName(@"sign_step_next")];
    }
    return _nextStepBt;
}
- (UIButton *)nomalPenBt {
    if (!_nomalPenBt) {
        _nomalPenBt = [UIButton imageButtonWithImage:ImageName(@"sign_step_next") hImage:ImageName(@"sign_step_next")];
    }
    return _nomalPenBt;
}
- (UIButton *)steelPenBt {
    if (!_steelPenBt) {
        _steelPenBt = [UIButton imageButtonWithImage:ImageName(@"sign_step_next") hImage:ImageName(@"sign_step_next")];
    }
    return _steelPenBt;
}

- (UIButton *)colorButton1 {
    if (!_colorButton1) {
        _colorButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _colorButton1.backgroundColor = kRedColor;
    }
    return _colorButton1;
}
- (UIButton *)colorButton2 {
    if (!_colorButton2) {
        _colorButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _colorButton2.backgroundColor = kYellowColor;
    }
    return _colorButton2;
}
- (UIButton *)colorButton3 {
    if (!_colorButton3) {
        _colorButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _colorButton3.backgroundColor = kBlueColor;
    }
    return _colorButton3;
}
- (UIButton *)colorButton4 {
    if (!_colorButton4) {
        _colorButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
        _colorButton4.backgroundColor = kBlackColor;
    }
    return _colorButton4;
}
- (UIButton *)eraserButton {
    if (!_eraserButton) {
        _eraserButton = [UIButton titleButtonWithTitle:@"橡皮擦" nTitleColor:kRedColor hTitleColor:kRedColor bgColor:kCommomBackgroundColor];
    }
    return _eraserButton;
}
- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [UIButton titleButtonWithTitle:@"清屏" nTitleColor:kRedColor hTitleColor:kRedColor bgColor:kCommomBackgroundColor];
    }
    return _clearButton;
}

@end
