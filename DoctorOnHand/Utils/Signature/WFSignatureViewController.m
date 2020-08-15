//
//  WFSignatureViewController.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFSignatureViewController.h"
#import "WFSignatureView.h"
#import "UIButton+WFExtension.h"
#import "UIViewController+WFExtention.h"
#import "WFCommomTool.h"
#import "WFColorTableViewCell.h"
#import "WFWidthTableViewCell.h"
#import "UIImage+WFExtension.h"
#import "WFNetworkManager.h"
#import "MPMProgressHUD.h"
#import "WFResponseModel.h"
#import <Photos/Photos.h>

#define kITEM_W     64
#define kITEM_W2    48
#define kMARGIN     20
#define kNOR_PEN_TAG    666
#define kSTE_PEN_TAG    777
#define kERA_SER_TAG    888
#define kANIMATE_DUR    0.1

@interface WFSignatureViewController () <UITableViewDelegate, UITableViewDataSource>
// Views
@property (nonatomic, strong) WFSignatureView *signatureView;   /// 手写板
@property (nonatomic, strong) UIView *widgetBGView;             /// 小物件父视图
@property (nonatomic, strong) UIButton *colorBarBt;             /// 调色盘
@property (nonatomic, strong) UIButton *backBt;                 /// 返回
@property (nonatomic, strong) UIView *colorSubView;             /// 调色盘旁边的小图
@property (nonatomic, strong) UIButton *nomalPenBt;             /// 普通笔
@property (nonatomic, strong) UIButton *steelPenBt;             /// 钢笔
@property (nonatomic, strong) UIButton *eraserBt;               /// 橡皮擦
@property (nonatomic, strong) UIButton *clearAllBt;             /// 清空
@property (nonatomic, strong) UIButton *lastStepBt;             /// 上一步
@property (nonatomic, strong) UIButton *nextStepBt;             /// 下一步
@property (nonatomic, strong) UIButton *saveToAlbumBt;          /// 保存相册
@property (nonatomic, strong) UIButton *uploadBt;               /// 上传
@property (nonatomic, strong) UITableView *colorTableView;      /// 选择颜色值
@property (nonatomic, strong) UITableView *widthTableView;      /// 选择宽度值
// Datas
@property (nonatomic, copy) NSArray *colorsArray;               /// 颜色值数组
@property (nonatomic, copy) NSArray *widthsArray;               /// 宽度数组
@property (nonatomic, weak) UIButton *lastSelectedBt;           /// 记录上次选中的按钮（普通笔、钢笔、橡皮擦）
@property (nonatomic, copy) NSString *registerId;               /// 病人id

@end

@implementation WFSignatureViewController

- (instancetype)initWithRegisterId:(NSString *)rId {
    self = [super init];
    if (self) {
        self.registerId = rId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
    [self setupConstraints];
}

- (void)setupAttributes {
    self.view.backgroundColor = kCommomBackgroundColor;
    self.colorsArray = @[kRGBA(255, 0, 0, 1),kRGBA(22, 120, 255, 1),kRGBA(248, 231, 28, 1),kRGBA(126, 221, 33, 1),kRGBA(0, 0, 0, 1),kRGBA(255, 255, 255, 1)];
    self.widthsArray = @[@6,@10,@16,@24];
    // 设置点击事件
    [self.backBt addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveToAlbumBt addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.uploadBt addTarget:self action:@selector(upload:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorBarBt addTarget:self action:@selector(selectColorBar:) forControlEvents:UIControlEventTouchUpInside];
    [self.nomalPenBt addTarget:self action:@selector(changePen:) forControlEvents:UIControlEventTouchUpInside];
    [self.steelPenBt addTarget:self action:@selector(changePen:) forControlEvents:UIControlEventTouchUpInside];
    [self.eraserBt addTarget:self action:@selector(changePen:) forControlEvents:UIControlEventTouchUpInside];
    [self.clearAllBt addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [self.lastStepBt addTarget:self action:@selector(lastStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextStepBt addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    // 选中普通笔
    [self changePen:self.nomalPenBt];
}

- (void)setupSubViews {
    [self.view addSubview:self.signatureView];
    [self.view addSubview:self.widgetBGView];
    [self.view addSubview:self.backBt];
    [self.view addSubview:self.saveToAlbumBt];
    [self.view addSubview:self.uploadBt];
    [self.widgetBGView addSubview:self.colorBarBt];
    [self.colorBarBt addSubview:self.colorSubView];
    [self.widgetBGView addSubview:self.steelPenBt];
    [self.widgetBGView addSubview:self.nomalPenBt];
    [self.widgetBGView addSubview:self.eraserBt];
    [self.widgetBGView addSubview:self.clearAllBt];
    [self.widgetBGView addSubview:self.lastStepBt];
    [self.widgetBGView addSubview:self.nextStepBt];
    [self.view addSubview:self.colorTableView];
    [self.view addSubview:self.widthTableView];
}

- (void)setupConstraints {
    [self.saveToAlbumBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(kITEM_W));
        make.trailing.equalTo(self.view.mas_trailing).offset(-kMARGIN);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kMARGIN);
    }];
    [self.uploadBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(kITEM_W));
        make.trailing.equalTo(self.view.mas_trailing).offset(-kMARGIN);
        make.bottom.equalTo(self.saveToAlbumBt.mas_top).offset(-kMARGIN);
    }];
    [self.backBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(kMARGIN);
        make.top.equalTo(self.view.mas_top).offset(kStatusBarHeight + 10);
    }];
    [self.signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.widgetBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self.view);
        make.width.equalTo(@(kMARGIN+kITEM_W));
    }];
    [self.nomalPenBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.widgetBGView.mas_leading).offset(kMARGIN);
        make.width.height.equalTo(@(kITEM_W));
        make.centerY.equalTo(self.view.mas_centerY).offset(-kMARGIN);
    }];
    [self.steelPenBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.widgetBGView.mas_leading).offset(kMARGIN);
        make.width.height.equalTo(@(kITEM_W));
        make.bottom.equalTo(self.nomalPenBt.mas_top).offset(-kMARGIN);
    }];
    [self.colorBarBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.widgetBGView.mas_leading).offset(kMARGIN);
        make.width.height.equalTo(@(kITEM_W));
        make.bottom.equalTo(self.steelPenBt.mas_top).offset(-kMARGIN);
    }];
    [self.colorSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(self.signatureView.lineWidth));
        make.bottom.trailing.equalTo(self.colorBarBt);
    }];
    [self.eraserBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.widgetBGView.mas_leading).offset(kMARGIN);
        make.width.height.equalTo(@(kITEM_W));
        make.top.equalTo(self.nomalPenBt.mas_bottom).offset(kMARGIN);
    }];
    [self.clearAllBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.widgetBGView.mas_leading).offset(kMARGIN);
        make.width.height.equalTo(@(kITEM_W));
        make.top.equalTo(self.eraserBt.mas_bottom).offset(kMARGIN);
    }];
    [self.lastStepBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.widgetBGView.mas_leading).offset(28);
        make.width.height.equalTo(@(kITEM_W2));
        make.top.equalTo(self.clearAllBt.mas_bottom).offset(30);
    }];
    [self.nextStepBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.widgetBGView.mas_leading).offset(28);
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

#pragma mark - Public Method

- (void)animateWidgetHide:(BOOL)hide {
    if (hide) {
        // 缩起调色盘
        self.colorTableView.hidden = self.widthTableView.hidden = YES;
        self.colorBarBt.selected = YES;
        self.colorBarBt.backgroundColor = kRGBA(22, 120, 255, 1);
//        [UIView animateWithDuration:kANIMATE_DUR animations:^{
//            [self.widgetBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.bottom.equalTo(self.view);
//                make.width.equalTo(@(kMARGIN+kITEM_W));
//                make.leading.equalTo(self.view.mas_leading).offset(-(kMARGIN+kITEM_W));
//            }];
//            [self.view layoutIfNeeded];
//        }];
    } else {
//        [UIView animateWithDuration:kANIMATE_DUR animations:^{
//            [self.widgetBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.leading.top.bottom.equalTo(self.view);
//                make.width.equalTo(@(kMARGIN+kITEM_W));
//            }];
//            [self.view layoutIfNeeded];
//        }];
    }
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveImage:(UIButton *)sender {
    if (!self.signatureView.canLastStep) {
        // 如果不能往后退了，说明已经恢复了白板，不能上传
        [WFCommomTool showTextWithTitle:@"您还未写入任何内容" inView:self.view animation:YES];
        return;
    }
    // 生成截屏
    UIGraphicsBeginImageContextWithOptions(self.signatureView.frame.size, NO, 0.0);
    [self.signatureView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *shotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 保存到相册
    UIImageWriteToSavedPhotosAlbum(shotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)upload:(UIButton *)sender {
    if (!self.signatureView.canLastStep) {
        // 如果不能往后退了，说明已经恢复了白板，不能上传
        [WFCommomTool showTextWithTitle:@"您还未写入任何内容" inView:self.view animation:YES];
        return;
    }
    UIGraphicsBeginImageContextWithOptions(self.signatureView.frame.size, NO, 0.0);
    [self.signatureView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *shotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    NSString *url = [NSString stringWithFormat:@"http://%@/md/v1/assistants/upload/%@/4",self.registerId,kAppDelegate.backHost];
    NSDictionary *params = @{@"type":@"4",
                             @"remark":@"手写"};
    NSData *imagedata = [UIImage compressImage:shotImage toSize:shotImage.size toByte:kImageUploadMaxLength];
    // 创建一个无重复的字符串作为图片名
    CFUUIDRef uniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, uniqueID);
    NSString *imageName = (__bridge NSString *)uniqueIDString;
    CFRelease(uniqueID);
    CFRelease(uniqueIDString);
    [MPMProgressHUD showProgressHUD];
    [[WFNetworkManager shareManager] form_reqeustManager];
    [[WFNetworkManager shareManager].manager POST:url parameters:params
                                          headers:@{@"Authorization":[NSString stringWithFormat:@"Bearer %@",kSafeString(kAppDelegate.loginModel.token)]} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imagedata
                                    name:@"files"
                                fileName:[NSString stringWithFormat:@"%@.png",imageName]
                                mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        DLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [MPMProgressHUD dismiss];
        WFResponseModel *response = [WFResponseModel mj_objectWithKeyValues:responseObject];
        [WFCommomTool showTextWithTitle:responseObject[@"message"] inView:self.view animation:YES];
        if (response.code.intValue == 200) {
            [self.signatureView clearScreen];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 上传失败
        [MPMProgressHUD dismiss];
        [WFCommomTool showTextWithTitle:error.localizedDescription inView:self.view animation:YES];
    }];
}

- (void)changeColor:(UIColor *)color width:(CGFloat)width {
    self.signatureView.lineColor = color;
    self.signatureView.lineWidth = width;
    [self.colorSubView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(width));
    }];
    self.colorSubView.backgroundColor = color;
    self.colorSubView.layer.cornerRadius = width / 2;
    if ([color isEqual:kRGBA(255, 255, 255, 1)]) {
        self.colorSubView.layer.borderColor = kRGBA(215, 215, 215, 1).CGColor;
    } else {
        self.colorSubView.layer.borderColor = color.CGColor;
    }
    [self.colorSubView layoutIfNeeded];
}

- (void)selectColorBar:(UIButton *)sender {
    BOOL hidden = self.colorTableView.hidden;
    self.colorTableView.hidden = self.widthTableView.hidden = !hidden;
    sender.selected = !sender.selected;
    if (hidden) {
        sender.backgroundColor = kRGBA(0, 0, 0, 0.1);
    } else {
        sender.backgroundColor = kRGBA(22, 120, 255, 1);
    }
}

/// 钢笔、普通笔、橡皮切换
- (void)changePen:(UIButton *)sender {
    if (sender == self.lastSelectedBt) {
        return;
    }
    if (self.lastSelectedBt) {
        self.lastSelectedBt.selected = NO;
        self.lastSelectedBt.backgroundColor = kRGBA(0, 0, 0, 0.1);
        sender.selected = YES;
        sender.backgroundColor = kRGBA(22, 120, 255, 1);
        self.lastSelectedBt = sender;
    } else {
        self.lastSelectedBt = sender;
        self.lastSelectedBt.selected = YES;
        self.lastSelectedBt.backgroundColor = kRGBA(22, 120, 255, 1);
    }
    if (sender.tag == kNOR_PEN_TAG) {
        self.signatureView.lineType = LineTypeNomal;
    } else if (sender.tag == kSTE_PEN_TAG) {
        self.signatureView.lineType = LineTypeSteelPen;
    } else if (sender.tag == kERA_SER_TAG) {
        self.signatureView.lineType = LineTypeEraser;
    }
}

/// 上一步
- (void)lastStep:(UIButton *)sender {
    [self.signatureView lastStep];
}

/// 下一步
- (void)nextStep:(UIButton *)sender {
    [self.signatureView nextStep];
}

/// 清屏
- (void)clear:(UIButton *)sender {
    __weak typeof(self) weakself = self;
    [self showAlertControllerWithStyle:UIAlertControllerStyleAlert title:@"确定清空手写板吗？" message:nil sureTitle:@"确定" sureAction:^(UIAlertAction *action) {
        __strong typeof(weakself) strongself = weakself;
        [strongself.signatureView clearScreen];
    } sureStyle:UIAlertActionStyleDefault cancelTitle:@"取消" cancelAction:nil cancelStyle:UIAlertActionStyleDefault];
}

#pragma mark - Save Image

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if ([error.domain isEqualToString:@"ALAssetsLibraryErrorDomain"]) {
        [self showAlertControllerWithStyle:UIAlertControllerStyleAlert title:@"开启照片访问权限" message:[NSString stringWithFormat:@"%@%@%@",@"请到【设置-隐私-照片】中允许",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],@"访问相册"] sureTitle:@"去开启" sureAction:^(UIAlertAction *action) {
            NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if (@available(iOS 10.0, *)) {
                if ([[UIApplication sharedApplication] canOpenURL:settingURL]) {
                    [[UIApplication sharedApplication] openURL:settingURL options:@{} completionHandler:nil];
                }
            } else {
                if ([[UIApplication sharedApplication] canOpenURL:settingURL]) {
                    [[UIApplication sharedApplication] openURL:settingURL];
                }
            }
        } sureStyle:UIAlertActionStyleDefault cancelTitle:@"取消" cancelAction:nil cancelStyle:UIAlertActionStyleDefault];
        return;
    }
    NSString *message = error ? @"保存图片失败" : @"保存图片成功";
    [WFCommomTool showTextWithTitle:message inView:self.view animation:YES];
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
    if (tableView == self.colorTableView) {
        UIColor *color = self.colorsArray[indexPath.row];
        [self changeColor:color width:self.signatureView.lineWidth];
    } else {
        NSNumber *width = self.widthsArray[indexPath.row];
        [self changeColor:self.signatureView.lineColor width:width.floatValue];
    }
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
- (UIButton *)uploadBt {
    if (!_uploadBt) {
        _uploadBt = [UIButton buttonWithNomalHignImage:ImageName(@"sign_upload") selectImage:ImageName(@"sign_save_album")];
        _uploadBt.layer.cornerRadius = kITEM_W / 2;
        _uploadBt.backgroundColor = kRGBA(9, 187, 7, 1);
    }
    return _uploadBt;
}

- (WFSignatureView *)signatureView {
    if (!_signatureView) {
        _signatureView = [[WFSignatureView alloc] init];
        _signatureView.lineType = LineTypeSteelPen;
        _signatureView.backgroundColor = kWhiteColor;
        _signatureView.targetVC = self;
    }
    return _signatureView;
}
- (UIView *)widgetBGView {
    if (!_widgetBGView) {
        _widgetBGView = [[UIView alloc] init];
        _widgetBGView.backgroundColor = kWhiteColor;
    }
    return _widgetBGView;
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
- (UIView *)colorSubView {
    if (!_colorSubView) {
        _colorSubView = [[UIView alloc] init];
        _colorSubView.backgroundColor = kBlackColor;
        _colorSubView.layer.cornerRadius = self.signatureView.lineWidth / 2;
        _colorSubView.layer.borderWidth = 1;
    }
    return _colorSubView;
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
        _eraserBt.tag = kERA_SER_TAG;
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
