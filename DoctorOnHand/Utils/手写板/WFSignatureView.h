//
//  WFSignatureView.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSignatureLine.h"
#import "WFSignatureViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WFSignatureView : UIView

@property (nonatomic, strong) UIColor *lineColor;   /// 记录线条颜色
@property (nonatomic, assign) CGFloat lineWidth;    /// 记录线条宽度
@property (nonatomic, assign) LineType lineType;
@property (nonatomic, assign, readonly) BOOL canLastStep;
@property (nonatomic, assign, readonly) BOOL canNextStep;
@property (nonatomic, weak) WFSignatureViewController *targetVC;

- (void)lastStep;       /// 上一步
- (void)nextStep;       /// 下一步
- (void)clearScreen;    /// 清屏

@end

NS_ASSUME_NONNULL_END
