//
//  WFWidthTableViewCell.m
//  DoctorOnHand
//
//  Created by 沈港能 on 2020/7/6.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFWidthTableViewCell.h"

@interface WFWidthTableViewCell ()

@property (nonatomic, strong) UIView *widthView;

@end

@implementation WFWidthTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.widthView = [[UIView alloc] init];
        self.widthView.backgroundColor = kRGBA(153, 153, 153, 1);
        [self addSubview:self.widthView];
        [self.widthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@10);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (void)setWidth:(CGFloat)width {
    _width = width;
    self.widthView.layer.cornerRadius = width / 2;
    [self.widthView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(width));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self layoutIfNeeded];
}

@end
