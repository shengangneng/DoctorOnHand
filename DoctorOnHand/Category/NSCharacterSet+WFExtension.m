//
//  NSCharacterSet+WFExtension.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "NSCharacterSet+WFExtension.h"

@implementation NSCharacterSet (WFExtension)

+ (NSCharacterSet *)wf_urlAllowCharecterSet {
    return [[NSCharacterSet characterSetWithCharactersInString:@"\"%<>[\\]^`{|} "] invertedSet];
}

@end
