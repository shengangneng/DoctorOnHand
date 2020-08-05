//
//  WFFileReader.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/21.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFFileReader : NSObject

/**
 *  @brief 文件阅读：图片浏览、文档查看、音视频播放
 *  @param filePath 文件路径
 *  @param target   UIViewController
 */
- (void)fileReadWithFilePath:(NSString *)filePath target:(id)target;

/**
 *  @brief 内存释放
 */
- (void)releaseWFFileReader;

@end

NS_ASSUME_NONNULL_END
