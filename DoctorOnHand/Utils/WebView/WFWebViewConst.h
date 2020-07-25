//
//  WFWebViewConst.h
//  DoctorOnHand
//
//  Created by sgn on 2020/7/8.
//  Copyright © 2020 sgn. All rights reserved.
//

#ifndef WFWebViewConst_h
#define WFWebViewConst_h

static NSString *const kNative = @"native";                                     // 桥接名称

// JS调用原生方法名
static NSString *const kGetAccountInfo = @"getAccountInfo";                     // 获取用户信息
static NSString *const kClearCache = @"clearCache";                             // 清除本地缓存
static NSString *const kTakePhoto = @"takePhoto";                               // 拍照
static NSString *const kHandWriting = @"handWriting";                           // 手写板
static NSString *const kRecordSound = @"recordSound";                           // 录音
static NSString *const kRecordVideo = @"recordVideo";                           // 录像
static NSString *const kPreviewImg = @"previewImg";                             // 图片预览
static NSString *const kPlaySound = @"playSound";                               // 播放音频setConfigUrl
static NSString *const kPlayVideo = @"playVideo";                               // 播放视频
static NSString *const kLogout = @"logout";                                     // 退出登录
static NSString *const kSetConfigUrl = @"setConfigUrl";                         // 点击确定传入配置给壳
static NSString *const kGetConfigUrl = @"getConfigUrl";                         // 调出配置页面


#endif /* WFWebViewConst_h */
