//
//  WFFileReaderModel.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/21.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFFileReaderConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface WFFileReaderModel : NSObject

/// 文件路径
@property (nonatomic, strong) NSString *filePath;
/// 文件名称
@property (nonatomic, strong) NSString *fileName;
/// 文件大小
@property (nonatomic, strong) NSString *fileSize;
/// 文件类型（0未知、1视频、2音频、3图片、4文档）
@property (nonatomic, assign) WFFileReaderType fileType;
/// 音频文件进度
@property (nonatomic, assign) float fileProgress;
/// 音频文件进度显示
@property (nonatomic, assign) BOOL fileProgressShow;

@end

NS_ASSUME_NONNULL_END
