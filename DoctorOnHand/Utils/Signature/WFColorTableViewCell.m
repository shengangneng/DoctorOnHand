//
//  WFColorTableViewCell.m
//  DoctorOnHand
//
//  Created by sgn on 2020/7/6.
//  Copyright © 2020 shengangneng. All rights reserved.
//

#import "WFColorTableViewCell.h"

@interface WFColorTableViewCell ()

@property (nonatomic, strong) UIView *colorView;

@end

@implementation WFColorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.colorView.backgroundColor = color;
    if ([color isEqual:kRGBA(255, 255, 255, 1)]) {
        // 如果是白色，则给一个borderColor
        self.colorView.layer.borderWidth = 1;
        self.colorView.layer.borderColor = kRGBA(215, 215, 215, 1).CGColor;
    } else {
        self.colorView.layer.borderWidth = 1;
        self.colorView.layer.borderColor = color.CGColor;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.colorView = [[UIView alloc] init];
        self.colorView.layer.cornerRadius = 12;
        [self addSubview:self.colorView];
        [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@24);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

@end
