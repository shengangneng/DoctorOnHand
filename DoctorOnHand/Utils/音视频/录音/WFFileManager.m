//
//  WFFileManager.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#define LOCAL_AUDIO_FOLDER @"CZHVoice"

#import "WFFileManager.h"
#import "amrFileCodec.h"

@implementation WFFileManager

+ (NSString *)filePath {
    NSString *path = [WFFileManager folderPath];
    NSString *fileName = [WFFileManager fileName];
    return [path stringByAppendingPathComponent:fileName];
}

+ (NSString *)fileName {
    NSString *fileName = [NSString stringWithFormat:@"voice_%lld.wav",(long long)[NSDate timeIntervalSinceReferenceDate]];
    return fileName;
}

+ (NSString *)folderPath {
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cwFolderPath = [NSString stringWithFormat:@"%@/%@",documentDir, LOCAL_AUDIO_FOLDER];
    BOOL isExist =  [[NSFileManager defaultManager]fileExistsAtPath:cwFolderPath];
    if (!isExist) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cwFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return cwFolderPath;
}


// 转换为amr格式并生成文件到savePath(showSize是否在控制台打印转换后的文件大小)
+ (NSString *)convertWavtoAMRWithVoiceFilePath:(NSString *)voiceFilePath{
    
    NSData *data = [NSData dataWithContentsOfFile:voiceFilePath];
    
    data = EncodeWAVEToAMR(data,1,16);
    
    NSString *amrFilePath = [voiceFilePath stringByReplacingOccurrencesOfString:@"wav" withString:@"amr"];
    
    BOOL isSuccess=[data writeToURL:[NSURL fileURLWithPath:amrFilePath] atomically:YES];
    
    if (isSuccess) {
        NSLog(@"CDPAudioRecorder转换为amr格式成功,大小为%@",[self fileSizeAtPath:amrFilePath]);
    }
    return amrFilePath;
}

+ (NSString *)saveWavWithVoiceUrl:(NSString *)voiceUrl {
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:voiceUrl]];
    
    NSString *folderPath = [WFFileManager folderPath];
    
    NSString *wavPath = [folderPath stringByAppendingPathComponent:[voiceUrl lastPathComponent]];
    
    BOOL isSuccess = [data writeToFile:wavPath atomically:YES];
    
    if (isSuccess) {
        NSLog(@"保存成功%@",wavPath);
        return wavPath;
    } else {
        NSLog(@"保存失败");
        return @"";
    }
}

+ (NSString *)convertAMRToWavWithVoiceFilePath:(NSString *)voiceFilePath {
    NSData *data = [NSData dataWithContentsOfFile:voiceFilePath];
    
    data = DecodeAMRToWAVE(data);
    
    NSString *folderPath = [WFFileManager folderPath];
    
    NSString *wavPath = [folderPath stringByAppendingPathComponent:[voiceFilePath lastPathComponent]];
    
    wavPath = [wavPath stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"];
    
    BOOL isSuccess = [data writeToFile:wavPath atomically:YES];
    
    if (isSuccess) {
        NSLog(@"保存成功%@",wavPath);
        return wavPath;
    } else {
        NSLog(@"保存失败");
        return @"";
    }
}

+ (NSString *)convertAMRToWavWithVoiceUrl:(NSString *)voiceUrl {
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:voiceUrl]];
    
    data = DecodeAMRToWAVE(data);
    
    NSString *folderPath = [WFFileManager folderPath];
    
    NSString *wavPath = [folderPath stringByAppendingPathComponent:[voiceUrl lastPathComponent]];
    
    wavPath = [wavPath stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"];
    
    BOOL isSuccess = [data writeToFile:wavPath atomically:YES];
    
    if (isSuccess) {
        NSLog(@"保存成功%@",wavPath);
        return wavPath;
    } else {
        NSLog(@"保存失败");
        return @"";
    }
}

+ (NSString *)voiceUrlIsExistInLocalWithLastPathComponent:(NSString *)lastPathComponent {
    
    NSString *folderPath = [WFFileManager folderPath];
    
    NSString *wavPath = [folderPath stringByAppendingPathComponent:lastPathComponent];
    
    // 如果后缀是amr格式转成wav
    if ([lastPathComponent hasSuffix:@"amr"]) {
        
        wavPath = [wavPath stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"];
    }
    
    BOOL isSuccess = [[NSFileManager defaultManager] fileExistsAtPath:wavPath];
    
    if (isSuccess) {//存在本地
        NSLog(@"已经存在本地路径%@", wavPath);
        return wavPath;
    } else {
        NSLog(@"音频本地不存在");
        return @"";
    }
}

// 查看文件大小(iOS是按照1000换算的,而不是1024,可查看NSByteCountFormatterCountStyle)
+ (NSString *)fileSizeAtPath:(NSString*)filePath{
    unsigned long long size=0;
    
    NSFileManager* manager =[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        size = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
        if (size >= pow(10,9)) {
            // size >= 1GB
            return [NSString stringWithFormat:@"%.2fGB",size/pow(10,9)];
        } else if (size >= pow(10,6)) {
            // 1GB > size >= 1MB
            return [NSString stringWithFormat:@"%.2fMB",size/pow(10,6)];
        } else if (size >= pow(10,3)) {
            // 1MB > size >= 1KB
            return [NSString stringWithFormat:@"%.2fKB",size/pow(10,3)];
        } else {
            // 1KB > size
            return [NSString stringWithFormat:@"%zdB",size];
        }
    }
    return @"0";
}

+ (BOOL)removeFile:(NSString *)filePath {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return YES;
    }
    
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    if (success) {
        NSLog(@"--%@移除了", filePath);
        return YES;
    } else {
        return NO;
    }
}

@end
