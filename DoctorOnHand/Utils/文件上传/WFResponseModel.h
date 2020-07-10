//
//  WFResponseModel.h
//  DoctorOnHand
//
//  Created by sgn on 2020/7/10.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFResponseModel : NSObject

@property (strong, nonatomic) id msg;// msg可能是NSString，也可能是NSArray（停机维护的时候）
@property (copy,   nonatomic) NSString *code;
@property (strong, nonatomic) NSDictionary *dataobj;

@end

NS_ASSUME_NONNULL_END
