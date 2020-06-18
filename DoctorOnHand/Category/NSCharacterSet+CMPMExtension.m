//
//  NSCharacterSet+CMPMExtension.m
//  CommunityMPM
//
//  Created by gangneng shen on 2019/11/26.
//  Copyright © 2019 jifenzhi. All rights reserved.
//

#import "NSCharacterSet+CMPMExtension.h"

@implementation NSCharacterSet (CMPMExtension)

+ (NSCharacterSet *)cmpm_urlAllowCharecterSet {
    return [[NSCharacterSet characterSetWithCharactersInString:@"\"%<>[\\]^`{|} "] invertedSet];
}

@end
