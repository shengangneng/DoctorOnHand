//
//  WFFileReaderTableViewCell.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/21.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFFileReaderModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const reuseWFFileReaderDirectoryCell = @"WFFileReaderDirectoryCell";
static CGFloat const heightWFFileReaderDirectoryCell = 60.0;

@interface WFFileReaderTableViewCell : UITableViewCell

/// 数据源
@property (nonatomic, strong) WFFileReaderModel *model;

@end

NS_ASSUME_NONNULL_END
