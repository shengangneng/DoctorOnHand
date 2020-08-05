//
//  WFFileManager.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/23.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#define LOCAL_AUDIO_FOLDER @"Audio"
#define LOCAL_VIDEO_FOLDER @"Video"

#import "WFFileManager.h"
#import "amrFileCodec.h"
#import "lame.h"

@implementation WFFileManager

+ (NSString *)audioFilePath {
    NSString *path = [WFFileManager voiceFolderPath];
    NSString *fileName = [WFFileManager audioFileName];
    return [path stringByAppendingPathComponent:fileName];
}

+ (NSString *)videoFilePath {
    NSString *path = [WFFileManager videoFolderPath];
    NSString *fileName = [WFFileManager videoFileName];
    return [path stringByAppendingPathComponent:fileName];
}

+ (NSString *)audioFileName {
    NSString *fileName = [NSString stringWithFormat:@"audio_%lld.wav",(long long)[NSDate timeIntervalSinceReferenceDate]];
    return fileName;
}

+ (NSString *)videoFileName {
    NSString *fileName = [NSString stringWithFormat:@"video_%lld.mp4",(long long)[NSDate timeIntervalSinceReferenceDate]];
    return fileName;
}

+ (NSString *)voiceFolderPath {
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cwFolderPath = [NSString stringWithFormat:@"%@/%@",documentDir, LOCAL_AUDIO_FOLDER];
    BOOL isExist =  [[NSFileManager defaultManager]fileExistsAtPath:cwFolderPath];
    if (!isExist) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cwFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return cwFolderPath;
}

+ (NSString *)videoFolderPath {
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cwFolderPath = [NSString stringWithFormat:@"%@/%@",documentDir, LOCAL_VIDEO_FOLDER];
    BOOL isExist =  [[NSFileManager defaultManager]fileExistsAtPath:cwFolderPath];
    if (!isExist) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cwFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return cwFolderPath;
}

// 转换为amr格式并生成文件到savePath(showSize是否在控制台打印转换后的文件大小)
+ (NSString *)convertWavtoAMRWithVoiceFilePath:(NSString *)voiceFilePath {
    
    NSData *data = [NSData dataWithContentsOfFile:voiceFilePath];
    
    data = EncodeWAVEToAMR(data,1,16);
    
    NSString *amrFilePath = [voiceFilePath stringByReplacingOccurrencesOfString:@"wav" withString:@"amr"];
    
    BOOL isSuccess = [data writeToURL:[NSURL fileURLWithPath:amrFilePath] atomically:YES];
    
    if (isSuccess) {
        NSLog(@"CDPAudioRecorder转换为amr格式成功,大小为%@",[self fileSizeAtPath:amrFilePath]);
    }
    return amrFilePath;
}

+ (NSString *)convertWavToMp3fromPath:(NSString *)wavpath {
    NSString *pathUrl = [NSString stringWithFormat:@"%@",wavpath];//存储录音pcm格式音频地址
    NSString * mp3Url = pathUrl;
    NSString *mp3FilePath = [wavpath stringByReplacingOccurrencesOfString:@"wav" withString:@"mp3"];//存放Mp3地址
    if (!mp3Url || !mp3FilePath) {
        return 0;
    }
    @try {
        int read, write;
        FILE *pcm = fopen([mp3Url cStringUsingEncoding:1], "rb"); //source 被转换的音频文件位置
        //音频不能为空
        if (!pcm) {
            return nil;
        }
        fseek(pcm, 4*1024, SEEK_CUR); //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        lame_t lame = lame_init();
        lame_set_num_channels(lame,1);
        lame_set_in_samplerate(lame, 44100.0); //11025.0
        //lame_set_VBR(lame, vbr_default);
        lame_set_brate(lame, 8);
        lame_set_mode(lame, 3);
        lame_set_quality(lame, 2);//
        lame_init_params(lame);
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            fwrite(mp3_buffer, write, 1, mp3);
        } while (read != 0);
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功: %@",mp3FilePath);
    }
    return mp3FilePath;
    
}

+ (NSString *)saveWavWithVoiceUrl:(NSString *)voiceUrl {
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:voiceUrl]];
    
    NSString *folderPath = [WFFileManager voiceFolderPath];
    
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
    
    NSString *folderPath = [WFFileManager voiceFolderPath];
    
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
    
    NSString *folderPath = [WFFileManager voiceFolderPath];
    
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
    
    NSString *folderPath = [WFFileManager voiceFolderPath];
    
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
