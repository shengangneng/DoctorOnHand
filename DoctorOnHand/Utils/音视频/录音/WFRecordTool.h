//
//  WFRecordTool.h
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WFRecordToolDelegate <NSObject>

/**
 * 准备中
 */
- (void)prepareToRecording;

/**
 * 录音中
 */
- (void)recording;

/**
 * 录音失败
 */
- (void)recordingFailed:(NSString *)failedMessage;

@end

@interface WFRecordTool : NSObject

@property (nonatomic,copy, readonly) NSString *recordPath;
@property (nonatomic,assign) BOOL isRecording;
///代理
@property (nonatomic, weak) id<WFRecordToolDelegate> delegate;

+ (instancetype)shareRecordTool;

/**
 *  开始录音
 */
- (void)beginRecordWithRecordPath:(NSString *)recordPath;

/**
 *  结束录音
 */
- (void)endRecord;

/**
 *  暂停录音
 */
- (void)pauseRecord;

/**
 *  删除录音
 */
- (void)deleteRecord;

/**
 *  返回分贝值
 */
- (float)updateLevels;

@end
