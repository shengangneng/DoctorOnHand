//
//  WFSignatureViewController.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WFSignatureViewController : WFBaseViewController

- (void)animateWidgetHide:(BOOL)hide;
- (instancetype)initWithRegisterId:(NSString *)rId;

@end

NS_ASSUME_NONNULL_END
