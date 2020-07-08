//
//  UIViewController+WFExtention.h
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIViewController (WFExtention)

- (void)showAlertControllerWithStyle:(UIAlertControllerStyle)style
                               title:(NSString *)title
                             message:(NSString *)message
                           sureTitle:(NSString *)sureTitle
                          sureAction:(void (^)(UIAlertAction *action))sureAction
                           sureStyle:(UIAlertActionStyle)sureStyle
                         cancelTitle:(NSString *)cancelTitle
                        cancelAction:(void (^)(UIAlertAction *action))cancelAction
                         cancelStyle:(UIAlertActionStyle)cancelStyle;

@end
