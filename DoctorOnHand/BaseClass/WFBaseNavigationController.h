//
//  WFBaseNavigationController.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFBaseNavigationController : UINavigationController

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *screenEdgeRecognizer;   // 自定义滑动手势用于右滑返回

@end

NS_ASSUME_NONNULL_END
