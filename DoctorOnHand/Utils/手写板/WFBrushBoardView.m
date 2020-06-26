//
//  WFBrushBoardView.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFBrushBoardView.h"
#import "WFBerzierPath.h"

#define MIN_WIDTH   5.0
#define MAX_WIDTH   13.0

@interface WFBrushBoardView ()

@property (nonatomic, copy) NSArray<NSValue *> *points; /// 存放点集合数组
@property (nonatomic, assign) CGFloat currentWidth;     /// 当前半径
@property (nonatomic, strong) UIImage *defaultImage;    /// 初始图片
@property (nonatomic, strong) UIImage *lastImage;       /// 上一张图片

@end

@implementation WFBrushBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kClearColor;
        self.userInteractionEnabled = YES;
        self.currentWidth = 10;
        self.lastImage = self.image;
    }
    return self;
}

#pragma 触摸事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    self.points = @[[NSValue valueWithCGPoint:point],[NSValue valueWithCGPoint:point],[NSValue valueWithCGPoint:point]];
    self.currentWidth = 13.0;
    [self changeImage];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    self.points = @[self.points[1],self.points[2],[NSValue valueWithCGPoint:point]];
    [self changeImage];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.lastImage = self.image;
}


- (void)changeImage {
    UIGraphicsBeginImageContext(self.frame.size);
    [self.lastImage drawInRect:self.bounds];
    
    // 贝塞尔曲线的起始点和末尾点
    CGPoint tempPoint1 = CGPointMake((self.points[0].CGPointValue.x + self.points[1].CGPointValue.x)/2, (self.points[0].CGPointValue.y + self.points[1].CGPointValue.y)/2);
    CGPoint tempPoint2 = CGPointMake((self.points[1].CGPointValue.x + self.points[2].CGPointValue.x)/2, (self.points[1].CGPointValue.y + self.points[2].CGPointValue.y)/2);
    
    int x1 = (int)fabs(tempPoint1.x - tempPoint2.x);
    int x2 = (int)fabs(tempPoint1.y - tempPoint2.y);
    int len = (int)(sqrt(pow(x1, 2) + pow(x2, 2)) * 10);
    
    // 如果仅仅只是点击一下
    if (len == 0) {
        UIBezierPath *zeroPath = [UIBezierPath bezierPathWithArcCenter:self.points[1].CGPointValue radius:MAX_WIDTH/2-2 startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [kBlackColor setFill];
        [zeroPath fill];
        
        // 绘图
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        self.lastImage = self.image;
        UIGraphicsEndImageContext();
        return;
    }
    
    // 如果距离过短，直接画线
    if (len < 1) {
        UIBezierPath *zeroPath = [UIBezierPath bezierPath];
        [zeroPath moveToPoint:tempPoint1];
        [zeroPath addLineToPoint:tempPoint2];
        
        self.currentWidth += 0.05;
        if (self.currentWidth > MAX_WIDTH) {
            self.currentWidth = MAX_WIDTH;
        }
        if (self.currentWidth < MIN_WIDTH) {
            self.currentWidth = MIN_WIDTH;
        }
        
        // 画线
        zeroPath.lineWidth = self.currentWidth;
        zeroPath.lineCapStyle = kCGLineCapRound;
        zeroPath.lineJoinStyle = kCGLineJoinRound;
        kRGBA(0, 0, 0, (self.currentWidth - MIN_WIDTH) / MAX_WIDTH * 0.6 + 0.2).setStroke;
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return;
    }
    
    // 目标直径
    CGFloat aimWidth = 300.0 / (CGFloat)(len * (MAX_WIDTH - MIN_WIDTH));
    // 获取贝塞尔点集合
    NSArray<NSValue *> *curvePoints = [WFBerzierPath curveFactorizationFromPoint:tempPoint1 toPoint:tempPoint2 controlPoint:@[self.points[1]] count:len];
    CGPoint lastPoint = tempPoint1;
    int i = 0;
    while (i < len + 1) {
        UIBezierPath *bPath = [UIBezierPath bezierPath];
        [bPath moveToPoint:lastPoint];
        
        // 省略多余的点
        CGFloat delta = sqrt(pow(curvePoints[i].CGPointValue.x-lastPoint.x,2) + pow(curvePoints[i].CGPointValue.y - lastPoint.y, 2));
        if (delta < 1) {
            i += 1;
            continue;
        }
        
        lastPoint = CGPointMake(curvePoints[i].CGPointValue.x, curvePoints[i].CGPointValue.y);
        [bPath addLineToPoint:CGPointMake(curvePoints[i].CGPointValue.x, curvePoints[i].CGPointValue.y)];
        
        // 计算当前点
        if (self.currentWidth > aimWidth) {
            self.currentWidth -= 0.05;
        } else {
            self.currentWidth += 0.05;
        }
        
        if (self.currentWidth > MAX_WIDTH) {
            self.currentWidth = MAX_WIDTH;
        }
        if (self.currentWidth < MIN_WIDTH) {
            self.currentWidth = MIN_WIDTH;
        }
        
        // 画线
        bPath.lineWidth = self.currentWidth;
        bPath.lineCapStyle = kCGLineCapRound;
        bPath.lineJoinStyle = kCGLineJoinRound;
        kRGBA(0, 0, 0, (self.currentWidth - MIN_WIDTH) / MAX_WIDTH * 0.3 + 0.1).setStroke;
        [bPath stroke];
        i += 1;
    }
    // 保存图片
    self.lastImage = UIGraphicsGetImageFromCurrentImageContext();
    int pointCount = ((int)sqrt(pow(tempPoint2.x - self.points[2].CGPointValue.x, 2) + pow(tempPoint2.y - self.points[2].CGPointValue.y, 2))) * 2;
    NSLog(@"%ld",pointCount);
    CGFloat delX = (tempPoint2.x - self.points[2].CGPointValue.x) / (CGFloat)pointCount;
    CGFloat delY = (tempPoint2.y - self.points[2].CGPointValue.y) / (CGFloat)pointCount;
    
    CGFloat addRadius = self.currentWidth;
    int j = 0;
    
    while (j < pointCount) {
        UIBezierPath *bPath = [UIBezierPath bezierPath];
        [bPath moveToPoint:lastPoint];
        CGPoint newPoint = CGPointMake(lastPoint.x - delX, lastPoint.y - delY);
        lastPoint = newPoint;
        [bPath addLineToPoint:newPoint];
        
        if (addRadius > aimWidth) {
            addRadius -= 0.02;
        } else {
            addRadius += 0.02;
        }
        
        if (addRadius > MAX_WIDTH) {
            addRadius = MAX_WIDTH;
        }
        if (addRadius < 0) {
            addRadius = 0;
        }
        bPath.lineWidth = addRadius;
        bPath.lineCapStyle = kCGLineCapRound;
        bPath.lineJoinStyle = kCGLineJoinRound;
        kRGBA(0, 0, 0, (self.currentWidth - MIN_WIDTH) / MAX_WIDTH * 0.05 + 0.05).setStroke;
        [bPath stroke];
        j += 1;
    }
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
