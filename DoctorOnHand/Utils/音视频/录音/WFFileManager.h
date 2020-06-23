//
//  WFFileManager.h
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFFileManager : NSObject

+ (NSString *)folderPath;
/// 音频文件保存的整个路径
+ (NSString *)filePath;
/// 删除文件
+ (BOOL)removeFile:(NSString *)filePath;
/// 转换本地wav为本地amr
+ (NSString *)convertWavtoAMRWithVoiceFilePath:(NSString *)voiceFilePath;
/// 把网络地址保存到本地
+ (NSString *)saveWavWithVoiceUrl:(NSString *)voiceUrl;
/// 转换本地amr为wav本地音频
+ (NSString *)convertAMRToWavWithVoiceFilePath:(NSString *)voiceFilePath;
/// 转换网络amr为wav本地音频
+ (NSString *)convertAMRToWavWithVoiceUrl:(NSString *)voiceUrl;
/// 本地已经有，返回本地路径
+ (NSString *)voiceUrlIsExistInLocalWithLastPathComponent:(NSString *)lastPathComponent;
@end
