//
//  WFNetworkManager.m
//  DoctorOnHand
//
//  Created by sgn on 2020/7/10.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFNetworkManager.h"
#import "WFResponseModel.h"

static WFNetworkManager *instance;

@implementation WFNetworkManager

+ (instancetype)shareManager {
    if (!instance) {
        instance = [[WFNetworkManager alloc] init];
    }
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
        // 监听网络变化，如果需要获取网络变化，在此类里面统一分发通知
        [instance.reachability startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(netChange:) name:kReachabilityChangedNotification object:nil];
    });
    return instance;
}

- (void)other_requestManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    instance.manager = manager;
}

- (id)copyWithZone:(NSZone *)zone {
    return instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return instance;
}

- (void)requestWithType:(WFRequestType)requestType
                    URL:(NSString *)url
                headers:(NSDictionary *)headers
                 params:(_Nullable id)params
                success:(void(^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                failure:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    
    switch (requestType) {
        case WFRequestTypeGET:{
            [instance.manager GET:url parameters:params headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(task,error);
            }];
        }break;
        case WFRequestTypePOST:{
            [instance.manager POST:url parameters:params headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                
                WFResponseModel *response = [WFResponseModel mj_objectWithKeyValues:responseObject];
                
                
                if (response.code.intValue == 200 || response.code.intValue == 202) {
                    success(task,responseObject);
                } else {
                    NSString *message = nil;
                    if ([response.msg isKindOfClass:[NSString class]] && ((NSString *)response.msg).length != 0) {
                        message = (NSString *)response.msg;
                    } else {
                        message = @"错误信息为空";
                    }
                    NSError *error = [NSError errorWithDomain:@"DoctorOnHand" code:[response.code integerValue] userInfo:@{NSLocalizedDescriptionKey:message}];
                    failure(task,error);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(task,error);
            }];
        }break;
        case WFRequestTypeDELETE:{
            [instance.manager DELETE:url parameters:params headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(task,error);
            }];
        }break;
        default:{
            [instance.manager POST:url parameters:params headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(task,error);
            }];
        }break;
    }
}

- (NSString *)handleError:(NSError *)error {
    if (!error) {
        return (@"网络连接失败");
    } else {
        if (NSURLErrorNotConnectedToInternet == error.code) {
            return (@"网络状况太差，请检查网络后重试");
        } else if (NSURLErrorBadServerResponse == error.code) {
            return (@"请求失败");
        } else if (NSURLErrorTimedOut == error.code) {
            return (@"网络请求超时");
        } else if (NSURLErrorCannotConnectToHost == error.code) {
            return (@"连接不上服务器");
        } else {
            return (@"网络连接失败");
        }
    }
}

#pragma mark - NetworkChangeNotification
- (void)netChange:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkChangedNotification object:notification.object];
}

- (Reachability *)reachability {
    if (!_reachability) {
        _reachability = [Reachability reachabilityForInternetConnection];
    }
    return _reachability;
}

@end
