//
//  WFBaseNavigationController.m
//  DoctorOnHand
//
//  Created by sgn on 2020/6/26.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFBaseNavigationController.h"
#import "WFBaseNavigationBar.h"
#import "AppDelegate.h"
#import "WFCustomNavigationBar.h"

const CGFloat kDistanceToPan = 10.0;
const CGFloat kDistanceToStart = 0.0;
const CGFloat kDistanceToLeft = 70.0;
const CGFloat kGestureSpeed = 0.3;

@interface WFBaseNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (strong ,nonatomic) NSMutableArray *screenShotsArray;      // 上一个页面的屏幕快照，可做动画

@end

@implementation WFBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenShotsArray = [NSMutableArray array];
    self.interactivePopGestureRecognizer.enabled = NO;
    self.screenEdgeRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.screenEdgeRecognizer];
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFullScreen;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")]|| [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPagingSwipeGestureRecognizer")]) {
        UIView *aView = otherGestureRecognizer.view;
        if ([aView isKindOfClass:[UIScrollView class]]) {
            UIScrollView *sv = (UIScrollView *)aView;
            if (sv.contentOffset.x==0) {
                if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] && otherGestureRecognizer.state != UIGestureRecognizerStateBegan) {
                    return NO;
                }else{
                    return YES;
                }
            }
        }
        return NO;
    }
    return YES;
}

// 左滑返回手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    return YES;
}

#pragma mark - UIPanGestureRecognizer
- (void)handleEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootVC = appDelegate.window.rootViewController;
    UIViewController *presentedVC = rootVC.presentedViewController;
    if (self.viewControllers.count == 1) {
        return;
    }
    if (gesture.state == UIGestureRecognizerStateBegan) {
        appDelegate.maskBackView.hidden = NO;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point_inView = [gesture translationInView:self.view];
        if (point_inView.x >= 10.0) {
            rootVC.view.transform = CGAffineTransformMakeTranslation(point_inView.x - kDistanceToPan, 0);
            presentedVC.view.transform = CGAffineTransformMakeTranslation(point_inView.x - kDistanceToPan, 0);
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint point_inView = [gesture translationInView:self.view];
        if (point_inView.x >= kDistanceToLeft) {
            [UIView animateWithDuration:kGestureSpeed animations:^{
                rootVC.view.transform = CGAffineTransformMakeTranslation(([UIScreen mainScreen].bounds.size.width), 0);
                presentedVC.view.transform = CGAffineTransformMakeTranslation(([UIScreen mainScreen].bounds.size.width), 0);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                rootVC.view.transform = CGAffineTransformIdentity;
                presentedVC.view.transform = CGAffineTransformIdentity;
                appDelegate.maskBackView.hidden = YES;
            }];
        }
        else {
            [UIView animateWithDuration:kGestureSpeed animations:^{
                rootVC.view.transform = CGAffineTransformIdentity;
                presentedVC.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                appDelegate.maskBackView.hidden = YES;
            }];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.viewControllers.count <= 1) return NO;
    return YES;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[WFCustomNavigationBar class] toolbarClass:nil];
    if (self) {
        self.viewControllers = @[rootViewController];
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count == 0) {
        [super pushViewController:viewController animated:animated];
        return;
    } else if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 截屏并添加到数组，并覆盖在上一次控制器之上
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(appdelegate.window.frame.size.width, appdelegate.window.frame.size.height), YES, 0);
    [appdelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.screenShotsArray addObject:viewImage];
    appdelegate.maskBackView.imgView.image = viewImage;
    [super pushViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *arr = [super popToViewController:viewController animated:animated];
    if (self.screenShotsArray.count > arr.count) {
        for (int i = 0; i < arr.count; i++) {
            [self.screenShotsArray removeLastObject];
        }
    }
    return arr;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.screenShotsArray removeLastObject];
    UIImage *image = [self.screenShotsArray lastObject];
    if (image) appdelegate.maskBackView.imgView.image = image;
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    return viewController;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.screenShotsArray.count > 2) {
        [self.screenShotsArray removeObjectsInRange:NSMakeRange(1, self.screenShotsArray.count - 1)];
    }
    UIImage *image = [self.screenShotsArray lastObject];
    if (image) appdelegate.maskBackView.imgView.image = image;
    return [super popToRootViewControllerAnimated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Lazy Init
- (UIScreenEdgePanGestureRecognizer *)screenEdgeRecognizer {
    if (!_screenEdgeRecognizer) {
        _screenEdgeRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanGesture:)];
        _screenEdgeRecognizer.edges = UIRectEdgeLeft;
    }
    return _screenEdgeRecognizer;
}

@end
