//
//  WFRecordAudioViewController.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFRecordAudioViewController.h"
#import "WFRecordVoiceButton.h"
#import "WFAudioPlayer.h"

@interface WFRecordAudioViewController () <WFRecordVoiceButtonDelegate>

@property (nonatomic, strong) UIView *recordView;
@property (nonatomic, strong) UIButton *recordBt;
@property (nonatomic, strong) UIButton *deleteBt;
@property (nonatomic, strong) UIButton *saveBt;
@property (nonatomic, strong) UIButton *cancelBt;

@end

@implementation WFRecordAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
    [self setupConstraints];
    WFRecordVoiceButton *recordButton = [[WFRecordVoiceButton alloc] init];
    recordButton.frame = CGRectMake(16, kScreenHeight - 300, kScreenWidth - 32, 50);
    recordButton.delegate = self;
    [self.view addSubview:recordButton];
}

- (void)setupAttributes {
    self.view.backgroundColor = kMainLightGrayColor;
    [self.deleteBt addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBt addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBt addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setupSubViews {
    [self.view addSubview:self.recordView];
    [self.recordView addSubview:self.recordBt];
    [self.recordView addSubview:self.deleteBt];
    [self.recordView addSubview:self.saveBt];
    [self.recordView addSubview:self.cancelBt];
}

- (void)setupConstraints {
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@620);
        make.height.equalTo(@360);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    [self.recordBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@160);
        make.centerX.equalTo(self.recordView.mas_centerX);
        make.centerY.equalTo(self.recordView.mas_centerY);
    }];
    [self.deleteBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.trailing.equalTo(self.recordBt.mas_leading).offset(-76);
        make.centerY.equalTo(self.recordView.mas_centerY);
    }];
    [self.saveBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.leading.equalTo(self.recordBt.mas_trailing).offset(76);
        make.centerY.equalTo(self.recordView.mas_centerY);
    }];
    [self.cancelBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@32);
        make.top.equalTo(self.recordView.mas_top).offset(4);
        make.trailing.equalTo(self.recordView.mas_trailing).offset(-4);
    }];
}

#pragma mark - Target Action
- (void)delete:(UIButton *)sender {
    
}

- (void)save:(UIButton *)sender {
    
}

- (void)cancel:(UIButton *)sender {
    
}

#pragma 录制按钮代理
- (void)continueRecordingWithButton:(WFRecordVoiceButton *)button {
    
    DLog(@"持续录制");
}

- (void)didBeginRecordWithButton:(WFRecordVoiceButton *)button {
    DLog(@"开始录制");
    /// 开始录制停止播放
    [[WFAudioPlayer shareAudioPlayer] stopCurrentAudio];
}

- (void)didCancelRecordWithButton:(WFRecordVoiceButton *)button {
    DLog(@"取消录制");
}

- (void)didFinishedRecordWithButton:(WFRecordVoiceButton *)button audioLocalPath:(NSString *)audioLocalPath {
    DLog(@"结束录制返回路径=%@", audioLocalPath);
    
    //转换成amr的路径，文件大小大概只有原来的1/10，所以上传到服务器比较快，播放的时候记得转换成wav的
//    if (audioLocalPath.length > 0) {
//        self.audioLocalPath = audioLocalPath;
//
//        self.playButton.hidden = NO;
//        self.deleteButton.hidden = NO;
//    }
}

- (void)willCancelRecordWithButton:(WFRecordVoiceButton *)button {
    DLog(@"将要取消录制");
}

#pragma mark - Lazy Init
- (UIView *)recordView {
    if (!_recordView) {
        _recordView = [[UIView alloc] init];
        _recordView.backgroundColor = kWhiteColor;
        _recordView.layer.cornerRadius = 10;
    }
    return _recordView;
}
- (UIButton *)recordBt {
    if (!_recordBt) {
        _recordBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBt.layer.backgroundColor = kWhiteColor.CGColor;
        _recordBt.layer.shadowColor = kRGBA(0, 0, 0, 0.1).CGColor;
        _recordBt.layer.shadowOffset = CGSizeMake(0,1);
        _recordBt.layer.shadowOpacity = 1;
        _recordBt.layer.shadowRadius = 3;
        _recordBt.layer.cornerRadius = 80;
        [_recordBt setImage:ImageName(@"record_audio_n") forState:UIControlStateNormal];
        [_recordBt setImage:ImageName(@"record_audio_h") forState:UIControlStateHighlighted];
        [_recordBt setImage:ImageName(@"record_audio_h") forState:UIControlStateSelected];
    }
    return _recordBt;
}
- (UIButton *)deleteBt {
    if (!_deleteBt) {
        _deleteBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBt.backgroundColor = kWhiteColor;
        [_deleteBt setImage:ImageName(@"record_delete") forState:UIControlStateNormal];
        [_deleteBt setImage:ImageName(@"record_delete") forState:UIControlStateHighlighted];
        [_deleteBt setImage:ImageName(@"record_delete") forState:UIControlStateSelected];
    }
    return _deleteBt;
}

- (UIButton *)saveBt {
    if (!_saveBt) {
        _saveBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBt.backgroundColor = kWhiteColor;
        [_saveBt setImage:ImageName(@"record_save") forState:UIControlStateNormal];
        [_saveBt setImage:ImageName(@"record_save") forState:UIControlStateHighlighted];
        [_saveBt setImage:ImageName(@"record_save") forState:UIControlStateSelected];
    }
    return _saveBt;
}
- (UIButton *)cancelBt {
    if (!_cancelBt) {
        _cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBt.backgroundColor = kWhiteColor;
        [_cancelBt setImage:ImageName(@"record_cancel") forState:UIControlStateNormal];
        [_cancelBt setImage:ImageName(@"record_cancel") forState:UIControlStateHighlighted];
        [_cancelBt setImage:ImageName(@"record_cancel") forState:UIControlStateSelected];
    }
    return _cancelBt;
}

@end
