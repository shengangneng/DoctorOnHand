//
//  CMPMSignatureView.h
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/23.
//  Copyright © 2019年 jifenzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSignatureLine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPMSignatureView : UIView

@property (nonatomic, strong) UIColor *lineColor;   /** 记录线条颜色 */
@property (nonatomic, assign) CGFloat lineWidth;    /** 记录线条宽度 */
@property (nonatomic, assign) LineType lineType;
@property (nonatomic, assign, readonly) BOOL canLastStep;
@property (nonatomic, assign, readonly) BOOL canNextStep;

- (void)lastStep;       /** 上一步 */
- (void)nextStep;       /** 下一步 */
- (void)clearScreen;    /** 清屏 */

@end

NS_ASSUME_NONNULL_END
