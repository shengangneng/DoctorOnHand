//
//  WFFileReaderViewController.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/21.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "CMPMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WFFileReaderViewController : CMPMBaseViewController

/// 导航栏标题（默认缓存目录）
@property (nonatomic, copy) NSString *cacheTitle;
/// 数据源（默认home目录）
@property (nonatomic, strong) NSMutableArray *cacheArray;

@end

NS_ASSUME_NONNULL_END
