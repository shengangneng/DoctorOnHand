//
//  WFWebViewUIConfiguration.h
//  DoctorOnHand
//
//  Created by sgn on 2020/7/8.
//  Copyright © 2020 sgn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFWebViewUIConfiguration : NSObject

+ (instancetype)defaultUIConfiguration;

@property (nonatomic, copy) NSString *title;                                /** 标题 */
@property (nonatomic, assign) BOOL navHidden;                               /** 导航栏是否隐藏 */
@property (nonatomic, assign) BOOL needExit;                                /** 是否需要在第二层级展示关闭按钮 */
@property (nonatomic, assign) NSTimeInterval lastUpdateTime;                /** 记录上次调用H5刷新时间 */
@property (nonatomic, strong) UIColor *backButtonColor;                     /** 设置返回按钮颜色 */
@property (nonatomic, strong) UIColor *navColor;                            /** 背景色 */
@property (nonatomic, assign) BOOL hasTabbar;                               /** 根据这个属性来修改Webview的Frame */
@property (nonatomic, assign) BOOL webViewScrollEnabled;                    /** WebView是否支持滚动 */
@property (nonatomic, copy) NSString *reusedIdentifier;                     /** 重用标示 */
@property (nonatomic, assign) BOOL needPicture;                             /** 相册 */
@property (nonatomic, assign) BOOL nExit;                                    /// 是否直接关闭

@end
