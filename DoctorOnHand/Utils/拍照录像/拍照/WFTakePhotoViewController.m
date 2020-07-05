//
//  WFTakePhotoViewController.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/25.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFTakePhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CMPMCommomTool.h"

@interface WFTakePhotoViewController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;         // 负责输入和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput; // 负责从AVCaptureDevice获得输入数据
@property (nonatomic, strong) AVCaptureDevice *captureDevice;           // 摄像头
@property (nonatomic, strong) AVCaptureStillImageOutput *captureStillImageOutput;   // 照片输出流
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer; // 相机拍摄预览图层
@property (nonatomic, assign) BOOL torchOn;
@property (nonatomic, assign) BOOL animating;
// Views
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *headerBackButton;       // 返回按钮
@property (nonatomic, strong) UIButton *headerReplyButton;      // 重新拍摄

@property (nonatomic, strong) UIView *middleContentView;        // 内容视图
@property (nonatomic, strong) UIImageView *middleImageView;     // 拍摄照片
@property (nonatomic, strong) UIImageView *middleFocusCursor;   // 聚焦按钮

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *bottomLightButton;      // 闪光灯
@property (nonatomic, strong) UIButton *bottomScanButton;       // 拍照按钮
@property (nonatomic, strong) UIButton *bottomFrontButton;      // 切换前后摄像头
@property (nonatomic, strong) UIButton *bottomDownButton;       // 下载按钮


@end

@implementation WFTakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
    // 初始化信息
    [self initCamera];
}

- (void)setupAttributes {
    self.navigationItem.title = @"拍照";
    self.view.backgroundColor = kWhiteColor;
    [self.headerBackButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomFrontButton addTarget:self action:@selector(cameraSwitchBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomScanButton addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerReplyButton addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomLightButton addTarget:self action:@selector(light:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomDownButton addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.headerBackButton];
    [self.headerView addSubview:self.headerReplyButton];
    
    [self.view addSubview:self.middleContentView];
    [self.view addSubview:self.middleImageView];
    [self.middleContentView addSubview:self.middleFocusCursor];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLightButton];
    [self.bottomView addSubview:self.bottomScanButton];
    [self.bottomView addSubview:self.bottomFrontButton];
    [self.bottomView addSubview:self.bottomDownButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

- (void)initCamera {
    // 初始化会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    // 设置分辨率
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    // 获得输入设备,取得后置摄像头
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题");
        return;
    }
    self.captureDevice = captureDevice;
    
    NSError *error = nil;
    // 根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@", error.localizedDescription);
        return;
    }
    
    // 初始化设备输出对象，用于获得输出数据
    _captureStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    // 输出设置
    [_captureStillImageOutput setOutputSettings:outputSettings];
    
    // 将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    
    // 将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureStillImageOutput]) {
        [_captureSession addOutput:_captureStillImageOutput];
    }
    
    // 创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
    // 摄像头方向
    AVCaptureConnection *captureConnection = [self.captureVideoPreviewLayer connection];
    captureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    CALayer *layer = self.middleContentView.layer;
    layer.masksToBounds = YES;
    
    _captureVideoPreviewLayer.frame = layer.bounds;
    // 填充模式
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // 将视频预览层添加到界面中
    [layer insertSublayer:_captureVideoPreviewLayer below:self.middleFocusCursor.layer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
}

- (void)btnOnClick:(UIButton *)btn {
    if (btn.tag == 1000) {
        // 拍摄照片
        [self photoBtnOnClick];
        
    }else if (btn.tag == 1001)  {
        // 重新拍摄
        [self resetPhoto];
    }
}

#pragma mark 拍照
- (void)photoBtnOnClick {
    // 根据设备输出获得连接
    AVCaptureConnection *captureConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    captureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    // 根据连接取得设备输出的数据
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            self.middleImageView.image = image;
            
            self.middleImageView.hidden =
            self.bottomDownButton.hidden =
            self.headerReplyButton.hidden =
            self.torchOn = NO;
        }
    }];
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:1001];
    btn.hidden = NO;
}

// 重新拍摄
- (void)resetPhoto {
    self.middleImageView.hidden =
    self.bottomDownButton.hidden =
    self.headerReplyButton.hidden = YES;
}

#pragma mark - 通知
// 给输入设备添加通知
- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice {
    // 注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
    }];
    
    // 捕获区域发生改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

- (void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

// 移除所有通知
- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 设备连接成功
- (void)deviceConnected:(NSNotification *)notification {
    NSLog(@"设备已连接...");
}

// 设备连接断开
- (void)deviceDisconnected:(NSNotification *)notification {
    NSLog(@"设备已断开.");
}

// 捕获区域改变
- (void)areaChange:(NSNotification *)notification {
    NSLog(@"捕获区域改变...");
}

#pragma mark - 私有方法
// 取得指定位置的摄像头
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position {
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    
    return nil;
}

#pragma mark - Target Action

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)light:(UIButton *)sender {
    self.torchOn = !self.torchOn;
}

- (void)download:(UIButton *)sender {
    // 保存到相册
    UIImageWriteToSavedPhotosAlbum(self.middleImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark - Save Image

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = error ? @"保存图片失败" : @"保存图片成功";
    [self resetPhoto];
    [CMPMCommomTool showTextWithTitle:message inView:self.view animation:YES];
}

- (void)setTorchOn:(BOOL)torchOn {
    // 如果是前置摄像头，就直接不起作用
    AVCaptureDevicePosition position = [[self.captureDeviceInput device] position];
    if (position == AVCaptureDevicePositionFront) {
        self.bottomLightButton.selected = _torchOn = NO;
        return;
    }
    _torchOn = torchOn;
    AVCaptureDevice *device = self.captureDevice;
    if ([device hasTorch] && [device hasFlash]) {
        [device lockForConfiguration:nil];
        if (torchOn) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        self.bottomLightButton.selected = torchOn;
        [device unlockForConfiguration];
    }
}

#pragma mark 切换前后摄像头
- (void)cameraSwitchBtnOnClick {
    self.torchOn = NO;
    AVCaptureDevice *currentDevice = [self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    // 获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:toChangeDevice error:nil];
    
    // 改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    // 移除原有输入对象
    [self.captureSession removeInput:self.captureDeviceInput];
    // 添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        self.captureDeviceInput = toChangeDeviceInput;
    }
    // 提交会话配置
    [self.captureSession commitConfiguration];
}

// 改变设备属性的统一操作方法
- (void)changeDeviceProperty:(void (^)(AVCaptureDevice *))propertyChange {
    AVCaptureDevice *captureDevice = [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
        
    }else {
        NSLog(@"设置设备属性过程发生错误，错误信息：%@", error.localizedDescription);
    }
}

// 设置闪光灯模式
- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}

// 设置聚焦模式
- (void)setFocusMode:(AVCaptureFocusMode)focusMode {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

// 设置曝光模式
- (void)setExposureMode:(AVCaptureExposureMode)exposureMode {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}

// 设置聚焦点
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

// 添加点按手势，点按时聚焦
- (void)addGenstureRecognizer {
    [self.middleContentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)]];
}

- (void)tapScreen:(UITapGestureRecognizer *)tapGesture {
    CGPoint point = [tapGesture locationInView:self.middleContentView];
    // 将UI坐标转化为摄像头坐标
    CGPoint cameraPoint = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

// 设置聚焦光标位置
- (void)setFocusCursorWithPoint:(CGPoint)point {
    if (self.animating) {
        return;
    }
    self.animating = YES;
    self.middleFocusCursor.center = point;
    self.middleFocusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.middleFocusCursor.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.middleFocusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.middleFocusCursor.alpha = 0;
        self.animating = NO;
    }];
}

- (void)dealloc {
    [self removeNotification];
}

#pragma mark - Lazy Init
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, kTopHeight);
        _headerView.backgroundColor = kRGBA(69, 74, 73, 1);
    }
    return _headerView;
}
- (UIButton *)headerBackButton {
    if (!_headerBackButton) {
        _headerBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerBackButton.frame = CGRectMake(12, kStatusBarHeight+(kTopHeight - kStatusBarHeight - 35)/2, 50, 35);
        [_headerBackButton setTitle:(@"返回") forState:UIControlStateNormal];
        [_headerBackButton setTitle:(@"返回") forState:UIControlStateHighlighted];
        [_headerBackButton setTitleColor:kWhiteColor forState:UIControlStateHighlighted];
        [_headerBackButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    }
    return _headerBackButton;
}

- (UIButton *)headerReplyButton {
    if (!_headerReplyButton) {
        _headerReplyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerReplyButton.frame = CGRectMake(kScreenWidth - 62, kStatusBarHeight+(kTopHeight - kStatusBarHeight - 35)/2, 50, 35);
        _headerReplyButton.tag = 1001;
        _headerReplyButton.hidden = YES;
        [_headerReplyButton setTitle:(@"重拍") forState:UIControlStateNormal];
        [_headerReplyButton setTitle:(@"重拍") forState:UIControlStateHighlighted];
        [_headerReplyButton setTitleColor:kWhiteColor forState:UIControlStateHighlighted];
        [_headerReplyButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    }
    return _headerReplyButton;
}
- (UIView *)middleContentView {
    if (!_middleContentView) {
        _middleContentView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight - kTopHeight - kBottomHeight - 100)];
        _middleContentView.backgroundColor = kWhiteColor;
    }
    return _middleContentView;
}
- (UIImageView *)middleFocusCursor {
    if (!_middleFocusCursor) {
        _middleFocusCursor = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 40, 40)];
        _middleFocusCursor.alpha = 0;
        _middleFocusCursor.image = [UIImage imageNamed:@"camera_focus"];
    }
    return _middleFocusCursor;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, kScreenHeight - kBottomHeight - 100, kScreenWidth, kBottomHeight + 100);
        _bottomView.backgroundColor = kRGBA(69, 74, 73, 1);
    }
    return _bottomView;
}

- (UIButton *)bottomLightButton {
    if (!_bottomLightButton) {
        _bottomLightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomLightButton.frame = CGRectMake(16, 35, 40, 40);
        [_bottomLightButton setImage:ImageName(@"camera_light_n") forState:UIControlStateNormal];
        [_bottomLightButton setImage:ImageName(@"camera_light_h") forState:UIControlStateHighlighted];
        [_bottomLightButton setImage:ImageName(@"camera_light_h") forState:UIControlStateSelected];
    }
    return _bottomLightButton;
}

- (UIButton *)bottomScanButton {
    if (!_bottomScanButton) {
        _bottomScanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomScanButton.layer.cornerRadius = 33;
        _bottomScanButton.layer.masksToBounds = YES;
        _bottomScanButton.layer.borderWidth = 0.5;
        _bottomScanButton.layer.borderColor = kWhiteColor.CGColor;
        _bottomScanButton.backgroundColor = kClearColor;
        _bottomScanButton.frame = CGRectMake(kScreenWidth/2 - 33, 17, 66, 66);
        _bottomScanButton.tag = 1000;
        CALayer *smaLayer = [CALayer layer];
        smaLayer.frame = CGRectMake(6, 6, 54, 54);
        smaLayer.cornerRadius = 27;
        smaLayer.backgroundColor = kWhiteColor.CGColor;
        
        [_bottomScanButton.layer addSublayer:smaLayer];
    }
    return _bottomScanButton;
}

- (UIButton *)bottomFrontButton {
    if (!_bottomFrontButton) {
        _bottomFrontButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomFrontButton.frame = CGRectMake(kScreenWidth - 56, 30, 40, 40);
        [_bottomFrontButton setImage:ImageName(@"front_cammer") forState:UIControlStateNormal];
        [_bottomFrontButton setImage:ImageName(@"front_cammer") forState:UIControlStateHighlighted];
    }
    return _bottomFrontButton;
}

- (UIImageView *)middleImageView {
    if (!_middleImageView) {
        _middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight - kTopHeight - kBottomHeight - 100)];
        _middleImageView.layer.borderColor = kWhiteColor.CGColor;
        _middleImageView.layer.cornerRadius = 1;
        _middleImageView.layer.masksToBounds = YES;
        _middleImageView.layer.borderWidth = 1.5;
        _middleImageView.hidden = YES;
        _middleImageView.contentMode = UIViewContentModeScaleAspectFill;
        _middleImageView.clipsToBounds = YES;
    }
    return _middleImageView;
}
- (UIButton *)bottomDownButton {
    if (!_bottomDownButton) {
        _bottomDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomDownButton.backgroundColor = kWhiteColor;
        _bottomDownButton.layer.cornerRadius = 33;
        _bottomDownButton.hidden = YES;
        _bottomDownButton.frame = CGRectMake(kScreenWidth/2 - 33, 17, 66, 66);
        [_bottomDownButton setImage:ImageName(@"camera_down") forState:UIControlStateNormal];
        [_bottomDownButton setImage:ImageName(@"camera_down") forState:UIControlStateHighlighted];
    }
    return _bottomDownButton;
}

@end
