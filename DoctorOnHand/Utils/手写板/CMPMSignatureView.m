//
//  CMPMSignatureView.m
//  CommunityMPM
//
//  Created by shengangneng on 2019/4/23.
//  Copyright © 2019年 jifenzhi. All rights reserved.
//

#import "CMPMSignatureView.h"

@interface CMPMSignatureView ()

@property (nonatomic, strong) SignatureLine *tempSign;                           /** 用来记录一个线条 */
@property (nonatomic, strong) NSMutableArray<SignatureLine *> *lineArray;        /** 记录写下的线条 */
@property (nonatomic, strong) NSMutableArray<SignatureLine *> *cancelLineArray;  /** 记录取消的线条，为了可以点击下一步 */

@end

@implementation CMPMSignatureView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineArray = [NSMutableArray array];
        self.cancelLineArray = [NSMutableArray array];
        self.lineWidth = 1;
        self.lineColor = kBlackColor;
    }
    return self;
}

- (BOOL)canNextStep {
    if (self.cancelLineArray.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)canLastStep {
    if (self.lineArray.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.lineArray.count > 0) {
        for (int i = 0; i < self.lineArray.count; i++) {
            SignatureLine *manager = self.lineArray[i];
            UIBezierPath *path = manager.path;
            path.lineWidth = manager.lineWidth;
            [manager.lineColor set];
            [path stroke];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint startPoint = [touch locationInView:self];
    self.tempSign = [[SignatureLine alloc] init];
    self.tempSign.path = [UIBezierPath bezierPath];
    self.tempSign.lineWidth = self.lineWidth;
    self.tempSign.lineColor = self.lineColor;
    [self.tempSign.path moveToPoint:startPoint];
    [self.lineArray addObject:self.tempSign];
    // 每次绘画了新的线条，就移除下一步的所有数据
    [self.cancelLineArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint currentPoint = [touch locationInView:self];
    [self.tempSign.path addLineToPoint:currentPoint];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint currentPoint = [touch locationInView:self];
    [self.tempSign.path addLineToPoint:currentPoint];
    [self setNeedsDisplay];
}

#pragma mark - Public Method
- (void)lastStep {
    if (self.canLastStep) {
        SignatureLine *line = self.lineArray.lastObject;
        [self.lineArray removeLastObject];
        [self.cancelLineArray addObject:line];
        [self setNeedsDisplay];
    }
}

- (void)nextStep {
    if (self.canNextStep) {
        SignatureLine *line = self.cancelLineArray.lastObject;
        [self.lineArray addObject:line];
        [self.cancelLineArray removeLastObject];
        [self setNeedsDisplay];
    }
}

- (void)clearScreen {
    [self.lineArray removeAllObjects];
    [self.cancelLineArray removeAllObjects];
    [self setNeedsDisplay];
}

@end

@implementation SignatureLine

@end
