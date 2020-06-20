//
//  CMPMMaskBackView.h
//  CommunityMPM
//
//  Created by gangneng shen on 2019/10/10.
//  Copyright © 2019 jifenzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMPMMaskBackView : UIView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) NSMutableArray *arrayImage;

- (void)showEffectChange:(CGPoint)pt;
- (void)restore;
- (void)removeObserver;
- (void)addObserver;

@end

NS_ASSUME_NONNULL_END
