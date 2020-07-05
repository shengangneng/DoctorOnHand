//
//  WFRecordVideoViewController.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/25.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFRecordVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WFVideoProgress.h"

@interface WFRecordVideoViewController ()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) NSTimer *timer;           // 定时器
@property (nonatomic, strong) AVCaptureSession *captureSession;                     // 负责输入和输出设置之间的数据传递
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;             // 负责从AVCaptureDevice获得输入数据
@property (nonatomic, strong) AVCaptureMovieFileOutput *captureMovieFileOutput;     // 视频输出流
@property (nonatomic, strong) AVCaptureDevice *captureDevice;                       // 摄像头
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer; // 相机拍摄预览图层
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;  // 后台任务标识

@property (nonatomic, assign) AVPlayer *player;         // 播放器对象

@property (nonatomic, weak) UIButton *finishBtn;        // 完成按钮
@property (nonatomic, copy) NSString *path;     // 文件路径
@property (nonatomic, assign) NSInteger time;   // 录制时长

// Views
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *headerBackButton;       // 返回按钮
@property (nonatomic, strong) UIButton *headerReplyButton;      // 重新拍摄

@property (nonatomic, strong) UIView *middleContentView;        // 录制视频容器
@property (nonatomic, strong) UILabel *middleRECLabel;          // REC
@property (nonatomic, strong) UILabel *middleRecordTimeLabel;   // 录制视频时长标签
@property (nonatomic, strong) UIImageView *middleFocusCursor;   // 聚焦按钮

@property (nonatomic, strong) UIView *middleVideoView;          // 播放器容器
@property (nonatomic, strong) UIView *middlePreviewView;        // 预览视图
@property (nonatomic, strong) UIButton *middlePlayButton;       // 播放按钮
@property (nonatomic, strong) UILabel *middleCurrentLabel;      // 预览视图当前时长
@property (nonatomic, strong) WFVideoProgress *middleProgress;  // 播放进度
@property (nonatomic, strong) UILabel *middleTotalLabel;        // 预览视图总时长

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *bottomLightButton;      // 闪光灯
@property (nonatomic, strong) UIButton *bottomScanButton;       // 拍照按钮
@property (nonatomic, strong) UIButton *bottomFrontButton;      // 切换前后摄像头
// Datas
@property (nonatomic, assign) BOOL torchOn;
@property (nonatomic, assign) BOOL animating;

@end

@implementation WFRecordVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
    // 初始化信息
    [self initVideoInfo];
    
    // 创建控件
    [self creatControl];
}

- (void)setupAttributes {
    self.navigationItem.title = @"拍照";
    self.view.backgroundColor = kWhiteColor;
    [self.headerBackButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomFrontButton addTarget:self action:@selector(cameraSwitchBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomScanButton addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerReplyButton addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomLightButton addTarget:self action:@selector(light:) forControlEvents:UIControlEventTouchUpInside];
    [self.middlePlayButton addTarget:self action:@selector(playBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.headerBackButton];
    [self.headerView addSubview:self.headerReplyButton];
    
    [self.view addSubview:self.middleContentView];
    [self.middleContentView addSubview:self.middleRECLabel];
    [self.middleContentView addSubview:self.middleRecordTimeLabel];
    [self.middleContentView addSubview:self.middleFocusCursor];
    
    [self.view addSubview:self.middleVideoView];
    [self.middleVideoView addSubview:self.middlePreviewView];
    [self.middlePreviewView addSubview:self.middlePlayButton];
    [self.middlePreviewView addSubview:self.middleCurrentLabel];
    [self.middlePreviewView addSubview:self.middleProgress];
    [self.middlePreviewView addSubview:self.middleTotalLabel];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLightButton];
    [self.bottomView addSubview:self.bottomScanButton];
    [self.bottomView addSubview:self.bottomFrontButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopVideoRecoding];
    [self removeRecordTimer];
    if (_player.rate == 1) {
        [_player pause];
    }
    [self removeNotification];
    [self.captureSession stopRunning];
}

- (void)creatControl {
    
}

- (void)initVideoInfo {
    // 初始化会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 设置分辨率
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }
    // 获得输入设备（前置摄像头）
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];
    if (!captureDevice) {
        NSLog(@"取得前置置摄像头时出现问题");
        return;
    }
    self.captureDevice = captureDevice;
    // 添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    NSError *error = nil;
    // 根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@", error.localizedDescription);
        return;
    }
    AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@", error.localizedDescription);
        return;
    }
    
    // 初始化设备输出对象，用于获得输出数据
    _captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    // 不设置这个属性，超过10s的视频会没有声音
    _captureMovieFileOutput.movieFragmentInterval = kCMTimeInvalid;
    
    // 将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    // 将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
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
    btn.enabled = NO;
    if (btn.tag == 1000) {
        if (self.captureMovieFileOutput.isRecording) {
            //重新录制
            [self finishBtnOnClick];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startRecordVideo];
            });
        }else {
            //开始录制
            [self startRecordVideo];
        }
        
    } else if (btn.tag == 1001) {
        if ([btn.titleLabel.text isEqualToString:@"完成录制"]) {
            //完成录制
            [self finishBtnOnClick];
        }else {
            //预览视频
            [self reviewBtnOnClick];
        }
    }
    
    btn.enabled = YES;
}

// 开始录制
- (void)startRecordVideo {
    // 更新界面
    self.middleRecordTimeLabel.text = @"00:00";
    UIButton *recordBtn = (UIButton *)[self.view viewWithTag:1000];
    [recordBtn setTitle:@"重新录制" forState:UIControlStateNormal];
    UIButton *reviewBtn = (UIButton *)[self.view viewWithTag:1001];
    reviewBtn.hidden = NO;
    [reviewBtn setTitle:@"完成录制" forState:UIControlStateNormal];
    _middleVideoView.hidden = YES;
    _middlePreviewView.hidden = YES;
    _bottomFrontButton.hidden = YES;
    
    // 如果正在预览，则先暂停
    if (_player.rate == 1) {
        [_player pause];
    }
    
    // 根据设备输出获得连接
    AVCaptureConnection *captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
    // 如果正在录制，则重新录制，先暂停
    [self stopVideoRecoding];
    
    // 如果支持多任务则则开始多任务
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    }
    
    // 预览图层和视频方向保持一致
    captureConnection.videoOrientation = [self.captureVideoPreviewLayer connection].videoOrientation;
    
    // 添加路径
    _path = [self getPath];
    NSURL *fileUrl = [NSURL fileURLWithPath:_path];
    [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    
    // 添加定时器
    [self removeRecordTimer];
    [self addRecordTimer];
}

// 完成录制
- (void)finishBtnOnClick {
    // 更新界面
    self.middleRECLabel.hidden = NO;
    UIButton *reviewBtn = (UIButton *)[self.view viewWithTag:1001];
    [reviewBtn setTitle:@"视频预览" forState:UIControlStateNormal];
    _bottomFrontButton.hidden = NO;
    
    // 结束录制
    [self stopVideoRecoding];
    
    // 移除定时器
    [self removeRecordTimer];
    
    // 配置avplayer的item
    [self setPlayerItem];
}

// 配置avplayer的item
- (void)setPlayerItem {
    if (_player) {
        [self removeNotification];
        [self removeObserverFromPlayerItem:self.player.currentItem];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:_path]];
        [self addObserverToPlayerItem:playerItem];
        [_player replaceCurrentItemWithPlayerItem:playerItem];
        [self addNotification];
    }
}

// 结束录制
- (void)stopVideoRecoding {
    if ([self.captureMovieFileOutput isRecording]) [self.captureMovieFileOutput stopRecording];
}

// 添加定时器
- (void)addRecordTimer {
    _time = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(recordTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

// 定时器事件
- (void)recordTimerAction {
    _time ++;
    self.middleRECLabel.hidden = !self.middleRECLabel.hidden;
    self.middleRecordTimeLabel.text = [NSString stringWithFormat:@"%@", [self strWithTime:_time interval:1.f]];
}

// 移除定时器
- (void)removeRecordTimer {
    [_timer invalidate];
    _timer = nil;
}

// 时长长度转时间字符串
- (NSString *)strWithTime:(double)time interval:(CGFloat)interval {
    int minute = (time * interval) / 60;
    int second = (int)(time * interval) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minute, second];
}

// 预览视频
- (void)reviewBtnOnClick {
    // 更新界面
    _middleVideoView.hidden = NO;
    _middlePreviewView.hidden = NO;
    _middlePlayButton.selected = YES;
    _middleTotalLabel.text = [self strWithTime:_time interval:1.f];
    [_middleProgress setProgress:0 duration:0];
    
    // 配置avplayer的item
    [self setPlayerItem];
    
    // 播放
    [self.player play];
}

// 预览视频开始、停止按钮
- (void)playBtnOnClick:(UIButton *)btn {
    if (self.player.rate == 0) {
        // 暂停
        if ([self.middleCurrentLabel.text isEqualToString:_middleTotalLabel.text]) {
            [self reviewBtnOnClick];
        }else {
            [self.player play];
        }
        btn.selected = YES;
        
    } else if (self.player.rate == 1) {
        // 正在播放
        [self.player pause];
        btn.selected = NO;
    }
}

// 视频路径
- (NSString *)getPath {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", dateStr]];
    
    return path;
}

#pragma mark - 视频输出代理
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    NSLog(@"开始录制...");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    NSLog(@"视频录制完成.");
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

#pragma mark - 私有方法
// 取得指定位置的摄像头
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position {
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    
    return nil;
}

#pragma mark 切换前后摄像头
- (void)cameraSwitchBtnOnClick {
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

- (void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

#pragma mark - 通知
// 给输入设备添加通知
- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice {
    // 注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
    }];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    // 捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

// 改变设备属性的统一操作方法
- (void)changeDeviceProperty:(void (^)(AVCaptureDevice *))propertyChange {
    AVCaptureDevice *captureDevice = [self.captureDeviceInput device];
    NSError *error;
    // 注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    } else {
        NSLog(@"设置设备属性过程发生错误，错误信息：%@", error.localizedDescription);
    }
}

// 捕获区域改变
- (void)areaChange:(NSNotification *)notification {
    NSLog(@"捕获区域改变");
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

// 设置聚焦光标位置
- (void)setFocusCursorWithPoint:(CGPoint)point {
    self.middleFocusCursor.center = point;
    self.middleFocusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.middleFocusCursor.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.middleFocusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.middleFocusCursor.alpha = 0;
    }];
}

#pragma mark - 监控
// 给播放器添加进度更新
- (void)addProgressObserver {
    // 进度回调
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        NSLog(@"当前已经播放%.2fs.", current);
        _middleCurrentLabel.text = [self strWithTime:(int)current interval:1.f];
        if (current) {
            [self.middleProgress setProgress:(current / _time) duration:1.f];
        }
        if ((int)current == _time) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.middlePlayButton.selected = NO;
                self.middleVideoView.hidden = YES;
                self.middlePreviewView.hidden = YES;
            });
        }
    }];
}

// 给AVPlayerItem添加监控
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if(status == AVPlayerStatusReadyToPlay) {
            NSLog(@"正在播放...，视频总长度:%.2f", CMTimeGetSeconds(playerItem.duration));
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = playerItem.loadedTimeRanges;
        //本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        NSLog(@"共缓冲：%.2f", totalBuffer);
    }
}

// 给AVPlayerItem添加监控
- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem {
    // 监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

// 添加播放器通知
- (void)addNotification {
    // 给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

// 播放完成通知
- (void)playbackFinished:(NSNotification *)notification {
    NSLog(@"视频播放完成.");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.middlePlayButton.selected = NO;
        self.middleVideoView.hidden = YES;
        self.middlePreviewView.hidden = YES;
    });
}

- (void)dealloc {
    [self removeObserverFromPlayerItem:_player.currentItem];
    
    [self removeNotification];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Target Action

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)light:(UIButton *)sender {
    self.torchOn = !self.torchOn;
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

#pragma mark - Layz Init
- (AVPlayer *)player {
    if (!_player) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:_path]];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        _player.volume = 1.0f;
        // 创建播放器层
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.frame = self.middleVideoView.bounds;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.middleVideoView.layer addSublayer:playerLayer];
        [self addProgressObserver];
        [self addObserverToPlayerItem:playerItem];
    }
    
    return _player;
}
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

- (UIView *)middleVideoView {
    if (!_middleVideoView) {
        _middleVideoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight - kTopHeight - kBottomHeight - 100)];
        _middleVideoView.layer.borderColor = kWhiteColor.CGColor;
        _middleVideoView.layer.cornerRadius = 1;
        _middleVideoView.layer.masksToBounds = YES;
        _middleVideoView.layer.borderWidth = 1.5;
        _middleVideoView.hidden = YES;
    }
    return _middleVideoView;
}
- (UILabel *)middleRECLabel {
    if (_middleRECLabel) {
        _middleRECLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 17, 60, 40)];
        _middleRECLabel.text = @"REC";
        _middleRECLabel.font = SystemFont(20);
        _middleRECLabel.textColor = kRedColor;
    }
    return _middleRECLabel;
}
- (UILabel *)middleRecordTimeLabel {
    if (!_middleRecordTimeLabel) {
        _middleRecordTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.middleRECLabel.frame), CGRectGetMinY(self.middleRECLabel.frame), 150, 40)];
        _middleRecordTimeLabel.text = @"00:00";
        _middleRecordTimeLabel.textColor = kWhiteColor;
        _middleRecordTimeLabel.font = SystemFont(20);
    }
    return _middleRecordTimeLabel;
}
- (UIView *)middlePreviewView {
    if (!_middlePreviewView) {
        _middlePreviewView = [[UIView alloc] initWithFrame:self.middleVideoView.frame];
        _middlePreviewView.hidden = YES;
        // 黑色透明底
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, _middlePreviewView.bounds.size.height - 40, _middlePreviewView.bounds.size.width, 40)];
        backView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5f];
        [_middlePreviewView addSubview:backView];
    }
    return _middlePreviewView;
}
#define playBtnH 40.f
- (UIButton *)middlePlayButton {
    if (!_middlePlayButton) {
        _middlePlayButton = [[UIButton alloc] initWithFrame:CGRectMake(8, self.middleVideoView.bounds.size.height - playBtnH, playBtnH, playBtnH)];
        [_middlePlayButton setImage:[UIImage imageNamed:@"video_recordBtn_nor"] forState:UIControlStateNormal];
        [_middlePlayButton setImage:[UIImage imageNamed:@"video_recordBtn_sel"] forState:UIControlStateSelected];
    }
    return _middlePlayButton;
}
- (UILabel *)middleCurrentLabel {
    if (!_middleCurrentLabel) {
        _middleCurrentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.middlePlayButton.frame) + 10, CGRectGetMinY(self.middlePlayButton.frame), 56, playBtnH)];
        _middleCurrentLabel.text = @"00:00";
        _middleCurrentLabel.textColor = kWhiteColor;
        _middleCurrentLabel.font = SystemFont(18);
    }
    return _middleCurrentLabel;
}
- (WFVideoProgress *)middleProgress {
    if (!_middleProgress) {
        // 播放进度
        CGFloat progressH = 5.f;
        CGFloat progressW = self.middlePreviewView.bounds.size.width - 8 - playBtnH - (56 + 10) * 2 - 20;
        _middleProgress = [[WFVideoProgress alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.middleCurrentLabel.frame), CGRectGetMinY(self.middlePlayButton.frame) + playBtnH * 0.5 - progressH * 0.5, progressW, progressH)];
    }
    return _middleProgress;
}
- (UILabel *)middleTotalLabel {
    if (!_middleTotalLabel) {
        _middleTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.middleProgress.frame) + 10, CGRectGetMinY(self.middlePlayButton.frame), 56, playBtnH)];
        _middleTotalLabel.text = @"00:00";
        _middleTotalLabel.textColor = kWhiteColor;
        _middleTotalLabel.font = SystemFont(18);
    }
    return _middleTotalLabel;
}

@end
