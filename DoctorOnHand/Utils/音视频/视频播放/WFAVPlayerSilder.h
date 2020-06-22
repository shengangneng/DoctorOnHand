//
//  WFAVPlayerSilder.h
//  DoctorOnHand
//
//  Created by shengangneng on 20/6/18.
//  Copyright © 2020年 shengangneng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapChangeValue)(float value);

@interface WFAVPlayerSilder : UIView

@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *bufferView;
@property (nonatomic, strong) UIView *trackView;
@property (nonatomic, strong) UIImageView *slipImgView;
@property (nonatomic, assign) float bufferValue;
@property (nonatomic, assign) float trackValue;
@property (nonatomic, copy) TapChangeValue tapChangeValue;

@end
