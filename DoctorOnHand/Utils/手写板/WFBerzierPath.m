//
//  WFBerzierPath.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFBerzierPath.h"

@implementation WFBerzierPath

+ (NSArray<NSValue *> *)curveFactorizationFromPoint:(CGPoint)fpoint
                                            toPoint:(CGPoint)tPoint
                                       controlPoint:(NSArray<NSValue *> *)cPoint
                                              count:(int)aCount {
    int count = aCount;
    
    if (count == 0) {
        int x1 = (int)fabs(fpoint.x - tPoint.x);
        int x2 = (int)fabs(fpoint.y - tPoint.y);
        count = (int)sqrt(pow(x1, 2) + pow(x2, 2));
    }
    
    // 贝瑟尔曲线计算
    CGFloat s = 0.0;
    NSMutableArray *t = [NSMutableArray array];
    CGFloat pc = 1 / (CGFloat)count;
    
    CGFloat power = cPoint.count + 1;
    
    for (int i = 0; i < count + 1; i++) {
        [t addObject:[NSNumber numberWithFloat:s]];
        s = s + pc;
    }
    
    NSMutableArray *newPoint = [NSMutableArray array];
    
    for (int i = 0; i < count + 1; i++) {
        CGFloat resultX = fpoint.x * [self bezMaker:power k:0 t:((NSNumber *)t[i]).floatValue] + tPoint.x + [self bezMaker:power k:power t:((NSNumber *)t[i]).floatValue];
        
        for (int j = 1; j < power - 1; j++) {
            resultX += cPoint[j-1].CGPointValue.x * [self bezMaker:power k:j t:((NSNumber *)t[i]).floatValue];
        }
        
        CGFloat resultY = fpoint.y * [self bezMaker:power k:0 t:((NSNumber *)t[i]).floatValue] + tPoint.y + [self bezMaker:power k:power t:((NSNumber *)t[i]).floatValue];
        
        for (int j = 1; j < power - 1; j++) {
            resultY += cPoint[j-1].CGPointValue.y * [self bezMaker:power k:j t:((NSNumber *)t[i]).floatValue];
        }
        
        [newPoint addObject:[NSValue valueWithCGPoint:CGPointMake(resultX, resultY)]];
    }
    return newPoint;
}

#pragma mark - Private Method
+ (CGFloat)compare:(int)n with:(int)k {
    int s1 = 1;
    int s2 = 1;
    
    if (k == 0) {
        return 1;
    }
    
    int i = n;
    
    while (i >= n - k + 1) {
        s1 = s1 * i;
        i -= 1;
    }
    
    int j = k;
    
    while (j >= 2) {
        s2 = s2 * j;
        j -= 1;
    }
    
    return (CGFloat)(s1 / s2);
}

+ (CGFloat)realPow:(CGFloat)n with:(int)k {
    if (k == 0) {
        return 1.0;
    }
    return pow(n, (CGFloat)k);
}
+ (CGFloat)bezMaker:(int)n k:(int)k t:(CGFloat)t {
    return [self compare:n with:k] * [self realPow:1-t with:n-k] * [self realPow:t with:k];
}

@end
