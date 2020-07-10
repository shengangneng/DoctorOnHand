//
//  WFUploadViewController.m
//  DoctorOnHand
//
//  Created by sgn on 2020/7/10.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFUploadViewController.h"
#import "UIButton+WFExtension.h"
#import <TZImagePickerController.h>

@interface WFUploadViewController () <TZImagePickerControllerDelegate>
// Views
@property (nonatomic, strong) UIButton *selectImageBt;
@property (nonatomic, strong) UIButton *selectVideoBt;
@property (nonatomic, strong) UIButton *uploadBt;

// Datas
@property (nonatomic, strong) id selectedItem;

@end

@implementation WFUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupSubViews];
    [self setupConstraints];
}

- (void)setupAttributes {
    self.view.backgroundColor = kWhiteColor;
    [self.selectImageBt addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectVideoBt addTarget:self action:@selector(selectVideo:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self.view addSubview:self.selectImageBt];
    [self.view addSubview:self.selectVideoBt];
}

- (void)setupConstraints {
    
}

- (void)selectImage:(UIButton *)sender {
    
    // MaxImagesCount  可以选着的最大条目数
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    // 是否显示可选原图按钮
    imagePicker.allowPickingOriginalPhoto = NO;
    // 是否允许显示视频
    imagePicker.allowPickingVideo = NO;
    // 是否允许显示图片
    imagePicker.allowPickingImage = YES;
    // 设置 模态弹出模式。 iOS 13默认非全屏
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    // 这是一个navigation 只能present
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)selectVideo:(UIButton *)sender {
    // MaxImagesCount  可以选着的最大条目数
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    // 是否显示可选原图按钮
    imagePicker.allowPickingOriginalPhoto = YES;
    // 是否允许显示视频
    imagePicker.allowPickingVideo = NO;
    // 是否允许显示图片
    imagePicker.allowPickingImage = YES;
    // 设置 模态弹出模式。 iOS 13默认非全屏
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    // 这是一个navigation 只能present
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark -
// 选择照片的回调
- (void)imagePickerController:(TZImagePickerController *)picker
      didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                sourceAssets:(NSArray *)assets
       isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
}

// 选择视频的回调
- (void)imagePickerController:(TZImagePickerController *)picker
        didFinishPickingVideo:(UIImage *)coverImage
                 sourceAssets:(PHAsset *)asset {
    
}

- (UIButton *)selectImageBt {
    if (!_selectImageBt) {
        _selectImageBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectImageBt setTitle:@"选择图片" forState:UIControlStateNormal];
        [_selectImageBt setTitle:@"选择图片" forState:UIControlStateHighlighted];
        _selectImageBt.backgroundColor = kWhiteColor;
        _selectImageBt.layer.cornerRadius = 33;
        _selectImageBt.hidden = YES;
        _selectImageBt.frame = CGRectMake(kScreenWidth/2 - 33, 17, 66, 66);
    }
    return _selectImageBt;
}

- (UIButton *)selectVideoBt {
    if (!_selectVideoBt) {
        _selectVideoBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectVideoBt setTitle:@"选择视频" forState:UIControlStateNormal];
        [_selectVideoBt setTitle:@"选择视频" forState:UIControlStateHighlighted];
        _selectVideoBt.backgroundColor = kWhiteColor;
        _selectVideoBt.layer.cornerRadius = 33;
        _selectVideoBt.hidden = YES;
        _selectVideoBt.frame = CGRectMake(kScreenWidth/2 - 33, 17, 66, 66);
    }
    return _selectVideoBt;
}

@end
