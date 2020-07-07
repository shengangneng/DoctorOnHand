//
//  UIViewController+WFExtention.m
//  CommunityMPM
//
//  Created by sgn on 2020/3/2.
//  Copyright © 2020 jifenzhi. All rights reserved.
//

#import "UIViewController+WFExtention.h"


@implementation UIViewController (WFExtention)

- (void)showAlertControllerWithStyle:(UIAlertControllerStyle)style
                               title:(NSString *)title
                             message:(NSString *)message
                           sureTitle:(NSString *)sureTitle
                          sureAction:(void (^)(UIAlertAction *action))sureAction
                           sureStyle:(UIAlertActionStyle)sureStyle
                         cancelTitle:(NSString *)cancelTitle
                        cancelAction:(void (^)(UIAlertAction *action))cancelAction
                         cancelStyle:(UIAlertActionStyle)cancelStyle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    __weak typeof (UIAlertController *) weakAlert = alertController;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:sureTitle style:sureStyle handler:sureAction];
    if (cancelTitle) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:cancelStyle handler:cancelAction];
        [weakAlert addAction:cancel];
    }
    
    [weakAlert addAction:sure];
    [self presentViewController:weakAlert animated:YES completion:nil];
}

@end
