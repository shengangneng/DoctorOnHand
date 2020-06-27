//
//  WFSignatureLine.h
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/6/27.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LineType) {
    LineTypeNomal,      // 普通线条
    LineTypeSteelPen,   // 钢笔
};

@interface WFSignatureLine : NSObject

@property (nonatomic, assign) LineType lineType;    /** 类型 */
@property (nonatomic, strong) UIBezierPath *path;   /** 路线 */
@property (nonatomic, strong) UIColor *lineColor;   /** 线条颜色 */
@property (nonatomic, assign) CGFloat lineWidth;    /** 线条宽度 */
@property (nonatomic, copy) NSArray<WFSignatureLine *> *linesArray;   /// 如果是钢笔类型，则每一个点都是多个线条组

@end

NS_ASSUME_NONNULL_END
