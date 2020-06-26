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
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer; // 相机拍摄预览图层
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;  // 后台任务标识
@property (nonatomic, assign) AVPlayer *player;         // 播放器对象
@property (nonatomic, weak) UIView *container;          // 播放器容器
@property (nonatomic, weak) UIButton *playBtn;          // 播放/暂停按钮
@property (nonatomic, weak) WFVideoProgress *progress;  // 播放进度
@property (nonatomic, weak) UILabel *currentLabel;      // 预览视图当前时长
@property (nonatomic, weak) UILabel *totalLabel;        // 预览视图总时长
@property (nonatomic, weak) UIView *previewView;        // 预览视图
@property (nonatomic, weak) UIView *containerView;      // 录制视频容器
@property (nonatomic, weak) UIImageView *focusCursor;   // 聚焦按钮
@property (nonatomic, weak) UIButton *finishBtn;        // 完成按钮
@property (nonatomic, weak) UIButton *cameraSwitchBtn;  // 摄像头切换按钮
@property (nonatomic, weak) UILabel *recLabel;          // REC标签
@property (nonatomic, weak) UILabel *recordTimeLabel;   // 录制视频时长标签
@property (nonatomic, copy) NSString *path;     // 文件路径
@property (nonatomic, assign) NSInteger time;   // 录制时长

@end

@implementation WFRecordVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"视频";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建控件
    [self creatControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    // 初始化信息
    [self initVideoInfo];
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
    CGFloat btnW = 150.f;
    CGFloat btnH = 40.f;
    CGFloat marginY = 20.f;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;

    // 内容视图
    CGFloat containerViewH = h - 64 - btnH - marginY * 3;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 64 + marginY, w - 20, containerViewH)];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.borderWidth = 1.f;
    containerView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:containerView];
    _containerView = containerView;
    
    // 聚焦图片
    UIImageView *focusCursor = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 75, 75)];
    focusCursor.alpha = 0;
    focusCursor.image = [UIImage imageNamed:@"camera_focus_red"];
    [containerView addSubview:focusCursor];
    _focusCursor = focusCursor;
    
    // 摄像头切换按钮
    CGFloat cameraSwitchBtnW = 50.f;
    CGFloat cameraSwitchBtnMargin = 10.f;
    UIButton *cameraSwitchBtn = [[UIButton alloc] initWithFrame:CGRectMake(containerView.bounds.size.width - cameraSwitchBtnW - cameraSwitchBtnMargin * 2, cameraSwitchBtnMargin, cameraSwitchBtnW, cameraSwitchBtnW)];
    [cameraSwitchBtn setImage:[UIImage imageNamed:@"camera_switch"] forState:UIControlStateNormal];
    [cameraSwitchBtn addTarget:self action:@selector(cameraSwitchBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:cameraSwitchBtn];
    _cameraSwitchBtn = cameraSwitchBtn;
    
    // REC
    UILabel *recLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 17, 60, 40)];
    recLabel.text = @"REC";
    recLabel.font = [UIFont boldSystemFontOfSize:20.f];
    recLabel.textColor = [UIColor redColor];
    [containerView addSubview:recLabel];
    _recLabel = recLabel;
    
    // 录制时间
    UILabel *recordTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(recLabel.frame), CGRectGetMinY(recLabel.frame), 150, 40)];
    recordTimeLabel.text = @"00:00";
    recordTimeLabel.textColor = [UIColor whiteColor];
    recordTimeLabel.font = [UIFont boldSystemFontOfSize:20.f];
    [containerView addSubview:recordTimeLabel];
    _recordTimeLabel = recordTimeLabel;
    
    // 播放器容器
    UIView *container = [[UIView alloc] initWithFrame:containerView.frame];
    container.hidden = YES;
    container.layer.borderWidth = 1.f;
    container.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:container];
    _container = container;
    
    // 预览控制面板
    UIView *previewView = [[UIView alloc] initWithFrame:containerView.frame];
    previewView.hidden = YES;
    [self.view addSubview:previewView];
    _previewView = previewView;
    
    // 黑色透明底
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, previewView.bounds.size.height - 40, previewView.bounds.size.width, 40)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [previewView addSubview:backView];
    
    // 播放开始、停止按钮
    CGFloat playBtnH = 40.f;
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, container.bounds.size.height - playBtnH, playBtnH, playBtnH)];
    [playBtn setImage:[UIImage imageNamed:@"video_recordBtn_nor"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"video_recordBtn_sel"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(playBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [previewView addSubview:playBtn];
    _playBtn = playBtn;
    
    // 播放时长
    UILabel *currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(playBtn.frame) + 10, CGRectGetMinY(playBtn.frame), 56, playBtnH)];
    currentLabel.text = @"00:00";
    currentLabel.textColor = [UIColor whiteColor];
    currentLabel.font = [UIFont boldSystemFontOfSize:18.f];
    [previewView addSubview:currentLabel];
    _currentLabel = currentLabel;
    
    // 播放进度
    CGFloat progressH = 5.f;
    CGFloat progressW = previewView.bounds.size.width - 8 - playBtnH - (56 + 10) * 2 - 20;
    WFVideoProgress *progress = [[WFVideoProgress alloc] initWithFrame:CGRectMake(CGRectGetMaxX(currentLabel.frame), CGRectGetMinY(playBtn.frame) + playBtnH * 0.5 - progressH * 0.5, progressW, progressH)];
    [previewView addSubview:progress];
    _progress = progress;
    
    // 总时长
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(progress.frame) + 10, CGRectGetMinY(playBtn.frame), 56, playBtnH)];
    totalLabel.text = @"00:00";
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.font = [UIFont boldSystemFontOfSize:18.f];
    [previewView addSubview:totalLabel];
    _totalLabel = totalLabel;
    
    // 按钮
    NSArray *titleArray = @[@"录制视频", @"预览视频"];
    CGFloat btnY = CGRectGetMaxY(containerView.frame) + marginY;
    CGFloat margin = (w - btnW * titleArray.count) / (titleArray.count + 1);
    for (int i = 0; i < titleArray.count; i++) {
        CGFloat btnX = margin + (margin + btnW) * i;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.tag = 1000 + i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor orangeColor];
        btn.layer.cornerRadius = 2.0f;
        btn.layer.masksToBounds = YES;
        if (i == 1) {
            btn.hidden = YES;
        }
        [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
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
    
    CALayer *layer = _containerView.layer;
    layer.masksToBounds = YES;
    
    _captureVideoPreviewLayer.frame = layer.bounds;
    // 填充模式
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // 将视频预览层添加到界面中
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
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
    _recordTimeLabel.text = @"00:00";
    UIButton *recordBtn = (UIButton *)[self.view viewWithTag:1000];
    [recordBtn setTitle:@"重新录制" forState:UIControlStateNormal];
    UIButton *reviewBtn = (UIButton *)[self.view viewWithTag:1001];
    reviewBtn.hidden = NO;
    [reviewBtn setTitle:@"完成录制" forState:UIControlStateNormal];
    _container.hidden = YES;
    _previewView.hidden = YES;
    _cameraSwitchBtn.hidden = YES;
    
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
    _recLabel.hidden = NO;
    UIButton *reviewBtn = (UIButton *)[self.view viewWithTag:1001];
    [reviewBtn setTitle:@"视频预览" forState:UIControlStateNormal];
    _cameraSwitchBtn.hidden = NO;
    
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
    _recLabel.hidden = !_recLabel.hidden;
    _recordTimeLabel.text = [NSString stringWithFormat:@"%@", [self strWithTime:_time interval:1.f]];
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
    _container.hidden = NO;
    _previewView.hidden = NO;
    _playBtn.selected = YES;
    _totalLabel.text = [self strWithTime:_time interval:1.f];
    [_progress setProgress:0 duration:0];
    
    // 配置avplayer的item
    [self setPlayerItem];
    
    // 播放
    [self.player play];
}

// 预览视频开始、停止按钮
- (void)playBtnOnClick:(UIButton *)btn {
    if (self.player.rate == 0) {
        // 暂停
        if ([_currentLabel.text isEqualToString:_totalLabel.text]) {
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
    [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)]];
}

- (void)tapScreen:(UITapGestureRecognizer *)tapGesture {
    CGPoint point = [tapGesture locationInView:self.containerView];
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
    self.focusCursor.center = point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha = 0;
    }];
}

#pragma mark - 监控
// 给播放器添加进度更新
- (void)addProgressObserver {
    // 进度回调
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        NSLog(@"当前已经播放%.2fs.", current);
        _currentLabel.text = [self strWithTime:(int)current interval:1.f];
        if (current) {
            [self.progress setProgress:(current / _time) duration:1.f];
        }
        if ((int)current == _time) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _playBtn.selected = NO;
                _container.hidden = YES;
                _previewView.hidden = YES;
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
        _playBtn.selected = NO;
        _container.hidden = YES;
        _previewView.hidden = YES;
    });
}

- (void)dealloc {
    [self removeObserverFromPlayerItem:_player.currentItem];
    
    [self removeNotification];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Layz Init
- (AVPlayer *)player {
    if (!_player) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:_path]];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        _player.volume = 1.0f;
        //创建播放器层
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.frame = _container.bounds;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [_container.layer addSublayer:playerLayer];
        [self addProgressObserver];
        [self addObserverToPlayerItem:playerItem];
    }
    
    return _player;
}

@end
