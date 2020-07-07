//
//  UIViewController+CMPMExtention.h
//  CommunityMPM
//
//  Created by sgn on 2020/3/2.
//  Copyright © 2020 jifenzhi. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIViewController (CMPMExtention)

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
