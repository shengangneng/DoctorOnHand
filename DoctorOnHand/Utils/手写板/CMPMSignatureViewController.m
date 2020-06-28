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

#define kITEM_W     32
#define kITEM_W2    24
#define kMARGIN     20

@interface CMPMSignatureViewController ()

@property (nonatomic, strong) UIButton *saveToAlbumBt;          /// 保存相册
@property (nonatomic, strong) CMPMSignatureView *signatureView; /// 手写板
@property (nonatomic, strong) UIButton *colorButton1;       /** 红 */
@property (nonatomic, strong) UIButton *colorButton2;       /** 黄 */
@property (nonatomic, strong) UIButton *colorButton3;       /** 蓝 */
@property (nonatomic, strong) UIButton *colorButton4;       /** 黑 */
@property (nonatomic, strong) UIButton *clearButton;        /** 清空所有数据 */

@property (nonatomic, strong) UIButton *colorBarBt;         /// 调色盘
@property (nonatomic, strong) UIButton *nomalPenBt;         /// 普通笔
@property (nonatomic, strong) UIButton *steelPenBt;         /// 钢笔
@property (nonatomic, strong) UIButton *eraserBt;           /// 橡皮擦
@property (nonatomic, strong) UIButton *lastStepBt;         /// 上一步
@property (nonatomic, strong) UIButton *nextStepBt;         /// 下一步

@end

@implementation CMPMSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.colorButton1 addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorButton2 addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorButton3 addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorButton4 addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.saveToAlbumBt addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.lastStepBt addTarget:self action:@selector(lastStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextStepBt addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.eraserBt addTarget:self action:@selector(eraser:) forControlEvents:UIControlEventTouchUpInside];
    [self.clearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = kCommomBackgroundColor;
    [self.view addSubview:self.signatureView];
    [self.view addSubview:self.saveToAlbumBt];
    [self.view addSubview:self.colorBarBt];
    [self.view addSubview:self.steelPenBt];
    [self.view addSubview:self.nomalPenBt];
    [self.view addSubview:self.eraserBt];
    [self.view addSubview:self.lastStepBt];
    [self.view addSubview:self.nextStepBt];
    
    [self.view addSubview:self.colorButton1];
    [self.view addSubview:self.colorButton2];
    [self.view addSubview:self.colorButton3];
    [self.view addSubview:self.colorButton4];
    [self.view addSubview:self.clearButton];
    
    [self.saveToAlbumBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@32);
        make.trailing.equalTo(self.view.mas_trailing).offset(-kMARGIN);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kMARGIN);
    }];
    [self.signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.nomalPenBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(kMARGIN);
        make.width.height.equalTo(@(kITEM_W));
        make.centerY.equalTo(self.view.mas_centerY).offset(-kMARGIN);
    }];
    [self.steelPenBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(kMARGIN);
        make.width.height.equalTo(@(kITEM_W));
        make.bottom.equalTo(self.nomalPenBt.mas_top).offset(-kMARGIN);
    }];
    [self.colorBarBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(kMARGIN);
        make.width.height.equalTo(@(kITEM_W));
        make.bottom.equalTo(self.steelPenBt.mas_top).offset(-kMARGIN);
    }];
    [self.eraserBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(kMARGIN);
        make.width.height.equalTo(@(kITEM_W));
        make.top.equalTo(self.nomalPenBt.mas_bottom).offset(kMARGIN);
    }];
    
    [self.lastStepBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(28);
        make.width.height.equalTo(@(kITEM_W2));
        make.top.equalTo(self.eraserBt.mas_bottom).offset(30);
    }];
    [self.nextStepBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(28);
        make.width.height.equalTo(@(kITEM_W2));
        make.top.equalTo(self.lastStepBt.mas_bottom).offset(kMARGIN);
    }];
    
    
//    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.eraserBt.mas_trailing).offset(borderW);
//        make.width.height.equalTo(@(kITEM_W));
//        make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomHeight-10);
//    }];
//
//    [self.colorButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view.mas_leading).offset(borderW);
//        make.width.equalTo(@(itemW));
//        make.height.equalTo(@(kITEM_W));
//        make.bottom.equalTo(self.lastStepBt.mas_top).offset(-10);
//    }];
//    [self.colorButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.colorButton1.mas_trailing).offset(borderW);
//        make.width.equalTo(@(itemW));
//        make.height.equalTo(@(kITEM_W));
//        make.bottom.equalTo(self.lastStepBt.mas_top).offset(-10);
//    }];
//    [self.colorButton3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.colorButton2.mas_trailing).offset(borderW);
//        make.width.equalTo(@(itemW));
//        make.height.equalTo(@(kITEM_W));
//        make.bottom.equalTo(self.lastStepBt.mas_top).offset(-10);
//    }];
//    [self.colorButton4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.colorButton3.mas_trailing).offset(borderW);
//        make.width.equalTo(@(itemW));
//        make.height.equalTo(@(kITEM_W));
//        make.bottom.equalTo(self.lastStepBt.mas_top).offset(-10);
//    }];
//
//    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@35);
//        make.trailing.equalTo(self.lineWidthSlider.mas_leading);
//        make.centerY.equalTo(self.lineWidthSlider.mas_centerY);
//    }];
//    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@35);
//        make.leading.equalTo(self.lineWidthSlider.mas_trailing);
//        make.centerY.equalTo(self.lineWidthSlider.mas_centerY);
//    }];
//    [self.lineWidthSlider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view.mas_leading).offset(45);
//        make.trailing.equalTo(self.view.mas_trailing).offset(-45);
//        make.bottom.equalTo(self.colorButton1.mas_top).offset(-10);
//        make.height.equalTo(@35);
//    }];
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

- (void)changeColor:(UIButton *)sender {
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
        _saveToAlbumBt = [UIButton buttonWithNomalHignImage:ImageName(@"sign_save_album") selectImage:ImageName(@"sign_save_album")];
        _saveToAlbumBt.layer.cornerRadius = kITEM_W / 2;
        _saveToAlbumBt.backgroundColor = kRGBA(9, 187, 7, 1);
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
- (UIButton *)colorBarBt {
    if (!_colorBarBt) {
        _colorBarBt = [UIButton buttonWithNomalHignImage:ImageName(@"sign_color_bar") selectImage:ImageName(@"sign_color_bar")];
        _colorBarBt.backgroundColor = kRGBA(0, 0, 0, 0.1);
        _colorBarBt.layer.cornerRadius = kITEM_W / 2;
    }
    return _colorBarBt;
}
- (UIButton *)steelPenBt {
    if (!_steelPenBt) {
        _steelPenBt = [UIButton buttonWithNomalHignImage:ImageName(@"sign_steel_pen") selectImage:ImageName(@"sign_steel_pen")];
        _steelPenBt.backgroundColor = kRGBA(0, 0, 0, 0.1);
        _steelPenBt.layer.cornerRadius = kITEM_W / 2;
    }
    return _steelPenBt;
}
- (UIButton *)nomalPenBt {
    if (!_nomalPenBt) {
        _nomalPenBt = [UIButton buttonWithNomalHignImage:ImageName(@"sign_nor_pen") selectImage:ImageName(@"sign_nor_pen")];
        _nomalPenBt.backgroundColor = kRGBA(0, 0, 0, 0.1);
        _nomalPenBt.layer.cornerRadius = kITEM_W / 2;
    }
    return _nomalPenBt;
}
- (UIButton *)eraserBt {
    if (!_eraserBt) {
        _eraserBt = [UIButton buttonWithNomalHignImage:ImageName(@"sign_ear") selectImage:ImageName(@"sign_ear")];
        _eraserBt.backgroundColor = kRGBA(0, 0, 0, 0.1);
        _eraserBt.layer.cornerRadius = kITEM_W / 2;
    }
    return _eraserBt;
}
- (UIButton *)lastStepBt {
    if (!_lastStepBt) {
        _lastStepBt = [UIButton buttonWithNomalHignImage:ImageName(@"sign_last_step") selectImage:ImageName(@"sign_last_step_h")];
        _lastStepBt.backgroundColor = kRGBA(0, 0, 0, 0.1);
        _lastStepBt.layer.cornerRadius = kITEM_W2 / 2;
    }
    return _lastStepBt;
}
- (UIButton *)nextStepBt {
    if (!_nextStepBt) {
        _nextStepBt = [UIButton buttonWithNomalHignImage:ImageName(@"sign_next_step") selectImage:ImageName(@"sign_next_step_h")];
        _nextStepBt.backgroundColor = kRGBA(0, 0, 0, 0.1);
        _nextStepBt.layer.cornerRadius = kITEM_W2 / 2;
    }
    return _nextStepBt;
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
- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [UIButton titleButtonWithTitle:@"清屏" nTitleColor:kRedColor hTitleColor:kRedColor bgColor:kCommomBackgroundColor];
    }
    return _clearButton;
}

@end
