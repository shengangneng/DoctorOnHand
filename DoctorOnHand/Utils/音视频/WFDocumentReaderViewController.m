//
//  WFDocumentReaderViewController.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/7/10.
//  Copyright © 2020 sgn. All rights reserved.
//

#import "WFDocumentReaderViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface WFDocumentReaderViewController () <UIDocumentInteractionControllerDelegate>

// 文档查看（文档、图片、视频）
@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@end

@implementation WFDocumentReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.documentController presentPreviewAnimated:YES];
}

- (void)fileReadWithFilePath:(NSString *)filePath {
    [self fileDocumentReadWithFilePath:filePath];
}

#pragma mark - 文件阅读

- (void)fileDocumentReadWithFilePath:(NSString *)filePath {
        
    NSURL *url = [NSURL fileURLWithPath:filePath];
    if (self.documentController == nil) {
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.documentController.delegate = self;
    }
}

- (void)dealloc {
    if (self.documentController) {
        self.documentController = nil;
    }
}

#pragma mark UIDocumentInteractionController

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller {
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller {
    return self.view.frame;
}

// 点击预览窗口的“Done”(完成)按钮时调用
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)_controller {
    
}

@end
