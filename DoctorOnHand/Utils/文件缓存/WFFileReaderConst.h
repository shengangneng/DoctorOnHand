//
//  WFFileReaderConst.h
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/21.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#ifndef WFFileReaderConst_h
#define WFFileReaderConst_h

static NSString *const WFFileReaderTitle = @"缓存文件";

static NSString *const WFFileReaderAudioDurationValueChangeNotificationName = @"AudioDurationValueChangeNotificationName";
static NSString *const WFFileReaderAudioStopNotificationName = @"AudioStopNotificationName";

/**
 *  默认显示文件
 *  视频：.avi、.dat、.mkv、.flv、.vob、.mp4、.m4v、.mpg、.mpeg、.mpe、.3pg、.mov、.swf、.wmv、.asf、.asx、.rm、.rmvb
 *  音频：.wav、.aif、.au、.mp3、.ram、.wma、.mmf、.amr、.aac、.flac、.midi、.mp3、.oog、.cd、.asf、.rm、.real、.ape、.vqf
 *  图片：.jpg、.png、.jpeg、.gif、.bmp
 *  文档：.txt、.sh、.doc、.docx、.xls、.xlsx、.pdf、.hlp、.wps、.rtf、.html、@".htm", .iso、.rar、.zip、.exe、.mdf、.ppt、.pptx
 */

/// 视频文件
#define WFFileReaderVideoArray @[@".avi", @".dat", @".mkv", @".flv", @".vob", @".mp4", @".m4v", @".mpg", @".mpeg", @".mpe", @".3pg", @".mov", @".swf", @".wmv", @".asf", @".asx", @".rm", @".rmvb"]
/// 音频文件
#define WFFileReaderAudioArray @[@".wav", @".aif", @".au", @".mp3", @".ram", @".wma", @".mmf", @".amr", @".aac", @".flac", @".midi", @".mp3", @".oog", @".cd", @".asf", @".rm", @".real", @".ape", @".vqf"]
/// 图片文件
#define WFFileReaderImageArray @[@".jpg", @".png", @".jpeg", @".gif", @".bmp"]
/// 文档文件
#define WFFileReaderDocumentArray @[@".txt", @".sh", @".doc", @".docx", @".xls", @".xlsx", @".pdf", @".hlp", @".wps", @".rtf", @".html", @".htm", @".iso", @".rar", @".zip", @".exe", @".mdf", @".ppt", @".pptx"]

/// 不能删除系统文件及文件夹
#define WFFileReaderSystemArray @[@"/tmp", @"/Library/Preferences", @"/Library/Caches/Snapshots", @"/Library/Caches", @"/Library", @"/Documents"]


/// 文件类型
typedef NS_ENUM(NSInteger, WFFileReaderType) {
    /// 文件类型 0未知
    WFFileReaderTypeUnknow = 0,
    /// 文件类型 1视频
    WFFileReaderTypeVideo = 1,
    /// 文件类型 2音频
    WFFileReaderTypeAudio = 2,
    /// 文件类型 3图片
    WFFileReaderTypeImage = 3,
    /// 文件类型 4文档
    WFFileReaderTypeDocument = 4,
};


#endif /* WFFileReaderConst_h */
