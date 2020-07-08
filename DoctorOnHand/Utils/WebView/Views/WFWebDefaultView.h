//
//  WFWebDefaultView.h
//  DoctorOnHand
//
//  Created by sgn on 2020/7/8.
//  Copyright © 2020 sgn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WFWebDefaultViewDelegate <NSObject>

- (void)webDefaultViewDidRefresh;

@end

typedef NS_ENUM(NSInteger, WebDefaultViewType) {
    WebDefaultViewTypeNoNetwork,    // 无网络
    WebDefaultViewTypeNetworkBusy,  // 网络拥挤
    WebDefaultViewTypeRequestFail,  // 请求失败，服务器挂了
};

@interface WFWebDefaultView : UIView

@property (nonatomic, assign) WebDefaultViewType type;
@property (nonatomic, weak) id<WFWebDefaultViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
