//
//  NSCharacterSet+WFExtension.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCharacterSet (WFExtension)

+ (NSCharacterSet *)wf_urlAllowCharecterSet;

@end

NS_ASSUME_NONNULL_END
