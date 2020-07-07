//
//  NSCharacterSet+WFExtension.m
//  CommunityMPM
//
//  Created by gangneng shen on 2019/11/26.
//  Copyright © 2019 jifenzhi. All rights reserved.
//

#import "NSCharacterSet+WFExtension.h"

@implementation NSCharacterSet (WFExtension)

+ (NSCharacterSet *)wf_urlAllowCharecterSet {
    return [[NSCharacterSet characterSetWithCharactersInString:@"\"%<>[\\]^`{|} "] invertedSet];
}

@end
