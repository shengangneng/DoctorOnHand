//
//  WFBrushBoardView.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSignatureLine.h"

NS_ASSUME_NONNULL_BEGIN

@interface WFBrushBoardView : UIImageView

@property (nonatomic, strong) UIColor *lineColor;           /// 记录线条颜色
@property (nonatomic, assign) CGFloat lineWidth;            /// 记录线条宽度
@property (nonatomic, assign, readonly) BOOL canLastStep;   /// 是否能上一步
@property (nonatomic, assign, readonly) BOOL canNextStep;   /// 是否能下一步
@property (nonatomic, assign) LineType lineType;

- (void)lastStep;       /// 上一步
- (void)nextStep;       /// 下一步
- (void)clearScreen;    /// 清屏

@end

NS_ASSUME_NONNULL_END
