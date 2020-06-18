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

@interface CMPMSignatureViewController ()

@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) CMPMSignatureView *signatureView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UISlider *lineWidthSlider;    /** 设置线条宽度 */
@property (nonatomic, strong) UIButton *colorButton1;       /** 红 */
@property (nonatomic, strong) UIButton *colorButton2;       /** 黄 */
@property (nonatomic, strong) UIButton *colorButton3;       /** 蓝 */
@property (nonatomic, strong) UIButton *colorButton4;       /** 黑 */
@property (nonatomic, strong) UIButton *lastStepButton;     /** 上一步 */
@property (nonatomic, strong) UIButton *nextStepButton;     /** 下一步 */
@property (nonatomic, strong) UIButton *eraserButton;       /** 橡皮擦 */
@property (nonatomic, strong) UIButton *clearButton;        /** 清空所有数据 */

@property (nonatomic, strong) UIImageView *imageView;       /** 截屏展示图 */
@property (nonatomic, strong) UIButton *saveToAlbum;        /** 保存到相册 */
@property (nonatomic, strong) UIButton *uploadToSys;        /** 上传服务器 */

@end

@implementation CMPMSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.lineWidthSlider addTarget:self action:@selector(changeLineWidth:) forControlEvents:UIControlEventValueChanged];
    [self.colorButton1 addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorButton2 addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorButton3 addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorButton4 addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sureButton addTarget:self action:@selector(sureImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.lastStepButton addTarget:self action:@selector(lastStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextStepButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.eraserButton addTarget:self action:@selector(eraser:) forControlEvents:UIControlEventTouchUpInside];
    [self.clearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = kCommomBackgroundColor;
    [self.view addSubview:self.sureButton];
    [self.view addSubview:self.signatureView];
    [self.view addSubview:self.leftLabel];
    [self.view addSubview:self.rightLabel];
    [self.view addSubview:self.lineWidthSlider];
    [self.view addSubview:self.colorButton1];
    [self.view addSubview:self.colorButton2];
    [self.view addSubview:self.colorButton3];
    [self.view addSubview:self.colorButton4];
    [self.view addSubview:self.lastStepButton];
    [self.view addSubview:self.nextStepButton];
    [self.view addSubview:self.eraserButton];
    [self.view addSubview:self.clearButton];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.saveToAlbum];
    [self.view addSubview:self.uploadToSys];
    double itemW = 60;
    double borderW = (kScreenWidth - itemW * 4) / 5;
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(itemW));
        make.height.equalTo(@35);
        make.trailing.equalTo(self.view.mas_trailing).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(20+10);
    }];
    [self.signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.sureButton.mas_bottom).offset(10);
        make.bottom.equalTo(self.lineWidthSlider.mas_top).offset(-10);
    }];
    
    [self.lastStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(borderW);
        make.width.equalTo(@(itemW));
        make.height.equalTo(@35);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomHeight-10);
    }];
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.lastStepButton.mas_trailing).offset(borderW);
        make.width.equalTo(@(itemW));
        make.height.equalTo(@35);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomHeight-10);
    }];
    [self.eraserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nextStepButton.mas_trailing).offset(borderW);
        make.width.equalTo(@(itemW));
        make.height.equalTo(@35);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomHeight-10);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.eraserButton.mas_trailing).offset(borderW);
        make.width.equalTo(@(itemW));
        make.height.equalTo(@35);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomHeight-10);
    }];
    
    [self.colorButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(borderW);
        make.width.equalTo(@(itemW));
        make.height.equalTo(@35);
        make.bottom.equalTo(self.lastStepButton.mas_top).offset(-10);
    }];
    [self.colorButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.colorButton1.mas_trailing).offset(borderW);
        make.width.equalTo(@(itemW));
        make.height.equalTo(@35);
        make.bottom.equalTo(self.lastStepButton.mas_top).offset(-10);
    }];
    [self.colorButton3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.colorButton2.mas_trailing).offset(borderW);
        make.width.equalTo(@(itemW));
        make.height.equalTo(@35);
        make.bottom.equalTo(self.lastStepButton.mas_top).offset(-10);
    }];
    [self.colorButton4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.colorButton3.mas_trailing).offset(borderW);
        make.width.equalTo(@(itemW));
        make.height.equalTo(@35);
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
    // 隐藏的控件
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@200);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_top);
    }];
    [self.uploadToSys mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth / 2));
        make.height.equalTo(@35);
        make.top.equalTo(self.view.mas_bottom);
        make.leading.equalTo(self.view.mas_leading);
    }];
    [self.saveToAlbum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth / 2));
        make.height.equalTo(@35);
        make.top.equalTo(self.view.mas_bottom);
        make.trailing.equalTo(self.view.mas_trailing);
    }];
}

#pragma mark - Target Action
- (void)sureImage:(UIButton *)sender {
    // 生成截屏
    UIGraphicsBeginImageContextWithOptions(self.signatureView.frame.size, NO, 0.0);
    [self.signatureView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *shotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 保存到相册
//    UIImageWriteToSavedPhotosAlbum(shotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    if (shotImage) {
        self.imageView.image = shotImage;
        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.4 options:0 animations:^{
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@200);
                make.centerX.equalTo(self.view.mas_centerX);
                make.centerY.equalTo(self.view.mas_centerY);
            }];
            [self.uploadToSys mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(kScreenWidth / 2));
                make.height.equalTo(@35);
                make.top.equalTo(self.imageView.mas_bottom).offset(10);
                make.leading.equalTo(self.view.mas_leading);
            }];
            [self.saveToAlbum mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(kScreenWidth / 2));
                make.height.equalTo(@35);
                make.top.equalTo(self.imageView.mas_bottom).offset(10);
                make.trailing.equalTo(self.view.mas_trailing);
            }];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
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

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton titleButtonWithTitle:@"确认" nTitleColor:kRedColor hTitleColor:kRedColor bgColor:kCommomBackgroundColor];
    }
    return _sureButton;
}
- (CMPMSignatureView *)signatureView {
    if (!_signatureView) {
        _signatureView = [[CMPMSignatureView alloc] init];
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
- (UIButton *)lastStepButton {
    if (!_lastStepButton) {
        _lastStepButton = [UIButton titleButtonWithTitle:@"上一步" nTitleColor:kRedColor hTitleColor:kRedColor bgColor:kCommomBackgroundColor];
    }
    return _lastStepButton;
}
- (UIButton *)nextStepButton {
    if (!_nextStepButton) {
        _nextStepButton = [UIButton titleButtonWithTitle:@"下一步" nTitleColor:kRedColor hTitleColor:kRedColor bgColor:kCommomBackgroundColor];
    }
    return _nextStepButton;
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
// 隐藏的控件
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.borderColor = kRedColor.CGColor;
        _imageView.layer.borderWidth = 1;
    }
    return _imageView;
}
- (UIButton *)saveToAlbum {
    if (!_saveToAlbum) {
        _saveToAlbum = [UIButton titleButtonWithTitle:@"保存相册" nTitleColor:kRedColor hTitleColor:kRedColor bgColor:kCommomBackgroundColor];
    }
    return _saveToAlbum;
}
- (UIButton *)uploadToSys {
    if (!_uploadToSys) {
        _uploadToSys = [UIButton titleButtonWithTitle:@"上传服务器" nTitleColor:kRedColor hTitleColor:kRedColor bgColor:kCommomBackgroundColor];
    }
    return _uploadToSys;
}



@end
