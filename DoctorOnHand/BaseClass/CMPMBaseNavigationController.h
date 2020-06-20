//
//  CMPMBaseNavigationController.h
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/7.
//  Copyright © 2019年 jifenzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMPMBaseNavigationController : UINavigationController

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *screenEdgeRecognizer;   // 自定义滑动手势用于右滑返回

@end

NS_ASSUME_NONNULL_END
