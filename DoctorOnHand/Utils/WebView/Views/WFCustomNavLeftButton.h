//
//  WFCustomNavLeftButton.h
//  DoctorOnHand
//
//  Created by sgn on 2020/7/8.
//  Copyright © 2020 sgn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ExitBlock)(UIButton *exitButton);

@interface WFCustomNavLeftButton : UIButton

@property (nonatomic, strong) UIColor *color;   /** 返回按钮颜色，关闭按钮颜色也会相应改变 */
@property (nonatomic, assign) BOOL showExit;    /** 是否展示关闭按钮 */
@property (nonatomic, copy) ExitBlock exitBlock;/** 关闭按钮的回调 */

@end

NS_ASSUME_NONNULL_END
