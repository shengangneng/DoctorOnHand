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
#import "CMPMCommomTool.h"
#import "WFColorTableViewCell.h"
#import "WFWidthTableViewCell.h"

#define kITEM_W     64
#define kITEM_W2    48
#define kMARGIN     20
#define kNOR_PEN_TAG    666
#define kSTE_PEN_TAG    777

@interface CMPMSignatureViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *saveToAlbumBt;          /// 保存相册
@property (nonatomic, strong) CMPMSignatureView *signatureView; /// 手写板

@property (nonatomic, strong) UIButton *backBt;             /// 返回
@property (nonatomic, strong) UIButton *colorBarBt;         /// 调色盘
@property (nonatomic, strong) UIButton *nomalPenBt;         /// 普通笔
@property (nonatomic, strong) UIButton *steelPenBt;         /// 钢笔
@property (nonatomic, strong) UIButton *eraserBt;           /// 橡皮擦
@property (nonatomic, strong) UIButton *clearAllBt;         /// 清空
@property (nonatomic, strong) UIButton *lastStepBt;         /// 上一步
@property (nonatomic, strong) UIButton *nextStepBt;         /// 下一步

@property (nonatomic, strong) UITableView *colorTableView;  /// 选择颜色值
@property (nonatomic, strong) UITableView *widthTableView;  /// 选择宽度值
@property (nonatomic, copy) NSArray *colorsArray;           /// 颜色值数组
@property (nonatomic, copy) NSArray *widthsArray;           /// 宽度数组

@end

@implementation CMPMSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colorsArray = @[kRGBA(255, 0, 0, 1),kRGBA(22, 120, 255, 1),kRGBA(248, 231, 28, 1),kRGBA(126, 221, 33, 1),kRGBA(0, 0, 0, 1),kRGBA(255, 255, 255, 1)];
    self.widthsArray = @[@6,@10,@16,@24];
    
    [self.backBt addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveToAlbumBt addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorBarBt addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.nomalPenBt addTarget:self action:@selector(changePen:) forControlEvents:UIControlEventTouchUpInside];
    [self.steelPenBt addTarget:self action:@selector(changePen:) forControlEvents:UIControlEventTouchUpInside];
    [self.eraserBt addTarget:self action:@selector(eraser:) forControlEvents:UIControlEventTouchUpInside];
    [self.clearAllBt addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.lastStepBt addTarget:self action:@selector(lastStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextStepBt addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = kCommomBackgroundColor;
    [self.view addSubview:self.signatureView];
    [self.view addSubview:self.backBt];
    [self.view addSubview:self.saveToAlbumBt];
    [self.view addSubview:self.colorBarBt];
    [self.view addSubview:self.steelPenBt];
    [self.view addSubview:self.nomalPenBt];
    [self.view addSubview:self.eraserBt];
    [self.view addSubview:self.clearAllBt];
    [self.view addSubview:self.lastStepBt];
    [self.view addSubview:self.nextStepBt];
    [self.view addSubview:self.colorTableView];
    [self.view addSubview:self.widthTableView];
    
    [self.saveToAlbumBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(kITEM_W));
        make.trailing.equalTo(self.view.mas_trailing).offset(-kMARGIN);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kMARGIN);
    }];
    [self.backBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(kMARGIN);
        make.top.equalTo(self.view.mas_top).offset(kStatusBarHeight + 10);
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
    [self.clearAllBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(kMARGIN);
        make.width.height.equalTo(@(kITEM_W));
        make.top.equalTo(self.eraserBt.mas_bottom).offset(kMARGIN);
    }];
    
    [self.lastStepBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(28);
        make.width.height.equalTo(@(kITEM_W2));
        make.top.equalTo(self.clearAllBt.mas_bottom).offset(30);
    }];
    [self.nextStepBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(28);
        make.width.height.equalTo(@(kITEM_W2));
        make.top.equalTo(self.lastStepBt.mas_bottom).offset(kMARGIN);
    }];
    [self.colorTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@54);
        make.height.equalTo(@324);
        make.top.equalTo(self.colorBarBt.mas_top).offset(-15);
        make.leading.equalTo(self.colorBarBt.mas_trailing).offset(50);
    }];
    [self.widthTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@56);
        make.height.equalTo(@224);
        make.top.equalTo(self.colorBarBt.mas_top).offset(-25);
        make.leading.equalTo(self.colorTableView.mas_trailing).offset(20);
    }];
    
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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
    NSString *message = error ? @"保存图片失败" : @"保存图片成功";
    [CMPMCommomTool showTextWithTitle:message inView:self.view animation:YES];
}

- (void)changeColor:(UIButton *)sender {
    self.signatureView.lineColor = sender.backgroundColor;
}

- (void)changePen:(UIButton *)sender {
    if (sender.tag == kNOR_PEN_TAG) {
        self.signatureView.lineType = LineTypeNomal;
    } else if (sender.tag == kSTE_PEN_TAG) {
        self.signatureView.lineType = LineTypeSteelPen;
    }
}

- (void)lastStep:(UIButton *)sender {
    [self.signatureView lastStep];
}

- (void)nextStep:(UIButton *)sender {
    [self.signatureView nextStep];
}

/// 橡皮擦
- (void)eraser:(UIButton *)sender {
    self.signatureView.lineType = LineTypeEraser;
}

/// 清屏
- (void)clear:(UIButton *)sender {
    [self.signatureView clearScreen];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.colorTableView) {
        return self.colorsArray.count;
    } else {
        return self.widthsArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.colorTableView) {
        return 54;
    } else {
        return 56;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.colorTableView) {
        static NSString *identifier = @"ColorCell";
        WFColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[WFColorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.color = self.colorsArray[indexPath.row];
        return cell;
    } else {
        static NSString *identifier = @"WidthCell";
        WFWidthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[WFWidthTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.width = [self.widthsArray[indexPath.row] floatValue];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self changeColor:nil];
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
- (UIButton *)backBt {
    if (!_backBt) {
        _backBt = [UIButton titleButtonWithTitle:@"返回" nTitleColor:kRGBA(20, 120, 255, 1) hTitleColor:kRGBA(20, 120, 255, 1) bgColor:kWhiteColor];
        [_backBt sizeToFit];
    }
    return _backBt;
}
- (UIButton *)colorBarBt {
    if (!_colorBarBt) {
        _colorBarBt = [UIButton buttonWithNomalHignImage:ImageName(@"sign_color_bar") selectImage:ImageName(@"sign_color_bar_h")];
        _colorBarBt.backgroundColor = kRGBA(0, 0, 0, 0.1);
        _colorBarBt.layer.cornerRadius = kITEM_W / 2;
    }
    return _colorBarBt;
}
- (UIButton *)steelPenBt {
    if (!_steelPenBt) {
        _steelPenBt = [UIButton buttonWithNomalHignImage:ImageName(@"sign_steel_pen") selectImage:ImageName(@"sign_steel_pen_h")];
        _steelPenBt.tag = kSTE_PEN_TAG;
        _steelPenBt.backgroundColor = kRGBA(0, 0, 0, 0.1);
        _steelPenBt.layer.cornerRadius = kITEM_W / 2;
    }
    return _steelPenBt;
}
- (UIButton *)nomalPenBt {
    if (!_nomalPenBt) {
        _nomalPenBt = [UIButton buttonWithNomalHignImage:ImageName(@"sign_nor_pen") selectImage:ImageName(@"sign_nor_pen_h")];
        _nomalPenBt.tag = kNOR_PEN_TAG;
        _nomalPenBt.backgroundColor = kRGBA(0, 0, 0, 0.1);
        _nomalPenBt.layer.cornerRadius = kITEM_W / 2;
    }
    return _nomalPenBt;
}
- (UIButton *)eraserBt {
    if (!_eraserBt) {
        _eraserBt = [UIButton buttonWithNomalHignImage:ImageName(@"sign_ear") selectImage:ImageName(@"sign_ear_h")];
        _eraserBt.backgroundColor = kRGBA(0, 0, 0, 0.1);
        _eraserBt.layer.cornerRadius = kITEM_W / 2;
    }
    return _eraserBt;
}
- (UIButton *)clearAllBt {
    if (!_clearAllBt) {
        _clearAllBt = [UIButton buttonWithNomalHignImage:ImageName(@"sign_clear_all") selectImage:ImageName(@"sign_clear_all_h")];
        _clearAllBt.backgroundColor = kRGBA(0, 0, 0, 0.1);
        _clearAllBt.layer.cornerRadius = kITEM_W / 2;
    }
    return _clearAllBt;
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
- (UITableView *)colorTableView {
    if (!_colorTableView) {
        _colorTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _colorTableView.backgroundColor = kWhiteColor;
        _colorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _colorTableView.scrollEnabled = NO;
        _colorTableView.delegate = self;
        _colorTableView.dataSource = self;
        _colorTableView.tableFooterView = [[UIView alloc] init];
    }
    return _colorTableView;
}
- (UITableView *)widthTableView {
    if (!_widthTableView) {
        _widthTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _widthTableView.backgroundColor = kWhiteColor;
        _widthTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _widthTableView.scrollEnabled = NO;
        _widthTableView.delegate = self;
        _widthTableView.dataSource = self;
        _widthTableView.tableFooterView = [[UIView alloc] init];
    }
    return _widthTableView;
}

@end
