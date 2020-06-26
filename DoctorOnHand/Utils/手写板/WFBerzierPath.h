//
//  WFBerzierPath.h
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFBerzierPath : NSObject

+ (NSArray<NSValue *> *)curveFactorizationFromPoint:(CGPoint )fpoint
                                            toPoint:(CGPoint)tPoint
                                       controlPoint:(NSArray<NSValue *> *)cPoint
                                              count:(int)aCount;

@end

NS_ASSUME_NONNULL_END
