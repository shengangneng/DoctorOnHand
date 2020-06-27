//
//  WFBrushBoardView.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFBrushBoardView.h"

// 最小/大宽度
#define kWIDTH_MIN 3
#define kWIDTH_MAX 6

#define kDelta  0.05

@interface WFBrushBoardView ()

// 点集合
@property (nonatomic, copy) NSArray *points;
// 当前宽度
@property (nonatomic, assign) CGFloat currentWidth;
// 上一次图片
@property (nonatomic, strong) UIImage *lastImage;

@property (nonatomic, strong) WFSignatureLine *tempSign;                           /** 用来记录一个线条 */
@property (nonatomic, strong) NSMutableArray<WFSignatureLine *> *lineArray;        /** 记录写下的线条 */
@property (nonatomic, strong) NSMutableArray<WFSignatureLine *> *cancelLineArray;  /** 记录取消的线条，为了可以点击下一步 */


@end

@implementation WFBrushBoardView

#pragma mark - Public Method
- (BOOL)canLastStep {
    if (self.cancelLineArray.count > 0) {
        return YES;
    } else {
        return NO;
    }
}
- (BOOL)canNextStep {
    if (self.lineArray.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)lastStep {
    if (self.canLastStep) {
        WFSignatureLine *line = self.lineArray.lastObject;
        [self.lineArray removeLastObject];
        [self.cancelLineArray addObject:line];
        [self setNeedsDisplay];
    }
}

- (void)nextStep {
    if (self.canNextStep) {
        WFSignatureLine *line = self.cancelLineArray.lastObject;
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

#pragma mark - System Method

- (void)drawRect:(CGRect)rect {
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    [self.lastImage drawInRect:self.bounds];
    
    for (int i = 0; i < self.lineArray.count; i++) {
        WFSignatureLine *roop = self.lineArray[i];
        if (LineTypeNomal == roop.lineType) {
            UIBezierPath *path = roop.path;
            path.lineWidth = roop.lineWidth;
            [roop.lineColor set];
            [path stroke];
        } else if (LineTypeSteelPen == roop.lineType) {
            for (int j = 0; j < roop.linesArray.count; j++) {
                WFSignatureLine *sub = roop.linesArray[j];
                UIBezierPath *path = sub.path;
                path.lineWidth = sub.lineWidth;
                path.lineCapStyle = kCGLineCapRound;
                path.lineJoinStyle = kCGLineJoinRound;
                [sub.lineColor setStroke];
                [path stroke];
            }
        }
    }
    self.lastImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
    self.image = tempImage;
    UIGraphicsEndImageContext();
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - 触摸事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:self];
    if (LineTypeNomal == self.lineType) {
        self.tempSign = [[WFSignatureLine alloc] init];
        self.tempSign.path = [UIBezierPath bezierPath];
        self.tempSign.lineWidth = self.lineWidth;
        self.tempSign.lineColor = self.lineColor;
        [self.tempSign.path moveToPoint:p];
        [self.lineArray addObject:self.tempSign];
        // 每次绘画了新的线条，就移除下一步的所有数据
        [self.cancelLineArray removeAllObjects];
    } else if (LineTypeSteelPen == self.lineType) {
        NSValue *vp = [NSValue valueWithCGPoint:p];
        self.points = @[vp,vp,vp];
        self.currentWidth = kWIDTH_MIN;
        [self changeImage];
    }
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:self];
    if (LineTypeNomal == self.lineType) {
        [self.tempSign.path addLineToPoint:p];
    } else if (LineTypeSteelPen == self.lineType) {
        NSValue *vp = [NSValue valueWithCGPoint:p];
        self.points = @[self.points[1],self.points[2],vp];
        [self changeImage];
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.lastImage =  self.image;
}

/// 画图
- (void)changeImage {
    
    // 设置贝塞尔曲线的起始点和末尾点
    CGPoint p0 = [self.points[0] CGPointValue];
    CGPoint p1 = [self.points[1] CGPointValue];
    CGPoint p2 = [self.points[2] CGPointValue];
    
    CGPoint tempPoint1 = CGPointMake((p0.x + p1.x) * 0.5, (p0.y + p1.y) * 0.5);
    CGPoint tempPoint2 = CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
    
    // 估算贝塞尔曲线长度
    int x1 = fabs(tempPoint1.x - tempPoint2.x);
    int x2 = fabs(tempPoint1.y - tempPoint2.y);
    int len = (int)(sqrt(pow(x1, 2) + pow(x2, 2))*10);
    
    // 目标半径
    CGFloat aimWidth = 300.0/(CGFloat)len * (kWIDTH_MAX - kWIDTH_MIN);
    
    // 获取贝塞尔点集
    NSArray * curvePoints = [self curveFactorizationWithFromPoint:tempPoint1 toPoint:tempPoint2 controlPoints:[NSArray arrayWithObject: self.points[1]] count:len];
    
    // 画每条线段
    CGPoint lastPoint = tempPoint1;
    
    NSMutableArray<WFSignatureLine *> *tempLinesArray = [NSMutableArray arrayWithCapacity:len];
    for (int i = 0; i< len ; i++) {
        
        UIBezierPath *bPath = [UIBezierPath bezierPath];
        [bPath moveToPoint:lastPoint];
        
        // 省略多余点
        CGFloat delta = sqrt(pow([curvePoints[i] CGPointValue].x - lastPoint.x, 2)+ pow([curvePoints[i] CGPointValue].y - lastPoint.y, 2));
        
        if (delta <1) {
            continue;
        }
        
        lastPoint = CGPointMake([curvePoints[i] CGPointValue].x, [curvePoints[i]CGPointValue].y);
        [bPath addLineToPoint:lastPoint];
        
        // 计算当前点
        if (self.currentWidth > aimWidth) {
            self.currentWidth -= kDelta;
        } else {
            self.currentWidth += kDelta;
        }
        
        if (self.currentWidth > kWIDTH_MAX) {
            self.currentWidth = kWIDTH_MAX;
        }
        
        if (self.currentWidth < kWIDTH_MIN) {
            self.currentWidth = kWIDTH_MIN;
        }
        
        // 画线
        WFSignatureLine *line = [[WFSignatureLine alloc] init];
        line.lineColor = [self.lineColor colorWithAlphaComponent:(self.currentWidth - kWIDTH_MIN)/kWIDTH_MAX *0.3 +0.2];
        line.lineWidth = self.currentWidth;
        
        [tempLinesArray addObject:line];
    }
    WFSignatureLine *root = [[WFSignatureLine alloc] init];
    root.lineType = LineTypeSteelPen;
    root.linesArray = tempLinesArray.copy;
    // 保存图片
//    self.lastImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
//    self.image = tempImage;
//    UIGraphicsEndImageContext();
    
}

/**
 *  分解贝塞尔曲线
 */
- (NSArray *)curveFactorizationWithFromPoint:(CGPoint) fPoint toPoint:(CGPoint) tPoint controlPoints:(NSArray *)points count:(int) count {
    
    // 如果分解数量为0，生成默认分解数量
    if (count == 0) {
        int x1 = fabs(fPoint.x - tPoint.x);
        int x2 = fabs(fPoint.y - tPoint.y);
        count = (int)sqrt(pow(x1, 2) + pow(x2, 2));
    }
    
    // 计算贝塞尔曲线
    CGFloat s = 0.0;
    NSMutableArray *t = [NSMutableArray array];
    CGFloat pc = 1/(CGFloat)count;
    
    int power = (int)(points.count + 1);
    
    
    for (int i =0; i<= count + 1; i++) {
        
        [t addObject:[NSNumber numberWithFloat:s]];
        s = s + pc;
        
    }
    
    NSMutableArray *newPoints = [NSMutableArray array];
    
    for (int i = 0; i <= count + 1; i++) {
        CGFloat resultX = fPoint.x * [self bezMakerWithN:power K:0 T:[t[i] floatValue]] + tPoint.x * [self bezMakerWithN:power K:power T:[t[i] floatValue]];
        
        for (int j = 1; j <= power -1; j++) {
            resultX += [points[j-1] CGPointValue].x * [self bezMakerWithN:power K:j T:[t[i] floatValue]];
        }
        
        CGFloat resultY = fPoint.y * [self bezMakerWithN:power K:0 T:[t[i] floatValue]] + tPoint.y * [self bezMakerWithN:power K:power T:[t[i] floatValue]];
        
        for (int j = 1; j <= power -1; j++) {
            
            resultY += [points[j-1] CGPointValue].y * [self bezMakerWithN:power K:j T:[t[i] floatValue]];
            
        }
        
        [newPoints addObject:[NSValue valueWithCGPoint:CGPointMake(resultX, resultY)]];
    }
    return newPoints;
    
}

- (CGFloat)compWithN:(int)n andK:(int)k {
    int s1 = 1;
    int s2 = 1;
    
    if (k == 0) {
        return 1.0;
    }
    
    for (int i = n; i >= n-k+1; i--) {
        s1 = s1*i;
    }
    for (int i = k; i >= 2; i--) {
        s2 = s2 *i;
    }
    
    CGFloat res = (CGFloat)s1/s2;
    return  res;
}

- (CGFloat)realPowWithN:(CGFloat)n K:(int)k {
    if (k == 0) {
        return 1.0;
    }
    return pow(n, (CGFloat)k);
}

- (CGFloat)bezMakerWithN:(int)n K:(int)k T:(CGFloat)t {
    return [self compWithN:n andK:k] * [self realPowWithN:1-t K:n-k] * [self realPowWithN:t K:k];
}

#pragma mark - Lazy Init

- (NSMutableArray<WFSignatureLine *> *)lineArray {
    if (!_lineArray) {
        _lineArray = [NSMutableArray array];
    }
    return _lineArray;
}

- (NSMutableArray<WFSignatureLine *> *)cancelLineArray {
    if (!_cancelLineArray) {
        _cancelLineArray = [NSMutableArray array];
    }
    return _cancelLineArray;
}

@end
