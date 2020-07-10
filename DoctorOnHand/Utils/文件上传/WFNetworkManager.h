//
//  WFNetworkManager.h
//  DoctorOnHand
//
//  Created by sgn on 2020/7/10.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <AFNetworking.h>

typedef NS_ENUM(NSInteger, WFRequestType) {
    WFRequestTypeGET,
    WFRequestTypePOST,
    WFRequestTypeDELETE
};

NS_ASSUME_NONNULL_BEGIN

#define kNetworkChangedNotification @"NetworkChangeNotification"            /** 监听网络通知 */

@interface WFNetworkManager : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) Reachability *reachability;                   /** 监听网络 */

+ (instancetype)shareManager;

- (void)other_requestManager;   // 其他设置

- (void)requestWithType:(WFRequestType)requestType
                    URL:(NSString *)url
                headers:(NSDictionary *)headers
                 params:(_Nullable id)params
                success:(void(^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

- (NSString *)handleError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
