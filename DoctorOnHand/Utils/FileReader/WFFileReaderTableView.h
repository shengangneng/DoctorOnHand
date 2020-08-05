//
//  WFFileReaderTableView.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/21.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFFileReaderTableView : UITableView

/// 数据源
@property (nonatomic, strong) NSMutableArray *cacheDatas;
/// 响应回调
@property (nonatomic, copy) void (^itemClick)(NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END
