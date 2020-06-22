//
//  WFAVPlayerControlView.h
//  DoctorOnHand
//
//  Created by shengangneng on 20/6/18.
//  Copyright © 2020年 shengangneng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFAVPlayerSilder.h"

@interface WFAVPlayerControlView : UIView

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *shrinkScreenButton;
@property (nonatomic, strong) WFAVPlayerSilder *playerSilder;

@property (nonatomic, strong) UIView *bottomView;

// 是否锁屏
@property (nonatomic, assign) BOOL isLock;
// 菜单是否显示
@property (nonatomic, assign) BOOL menuShow;

@end
