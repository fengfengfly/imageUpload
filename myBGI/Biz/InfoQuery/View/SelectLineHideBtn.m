//
//  SelectLineHideBtn.m
//  myBGI
//
//  Created by lx on 2017/5/14.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "SelectLineHideBtn.h"
#import "Masonry.h"
#define kBtnLineThick 1
@implementation SelectLineHideBtn

- (void)awakeFromNib{
    [super awakeFromNib];
//    UIView *lineTop = [[UIView alloc] init];
//    UIView *lineLeft = [[UIView alloc] init];
//    UIView *lineBottom = [[UIView alloc] init];
//    UIView *lineRight = [[UIView alloc] init];
//    _lines = @[lineTop, lineLeft, lineBottom, lineRight];
//    for (UIView *line in _lines) {
//        line.backgroundColor = kSubjectColor;
//        [self addSubview:line];
//    }
//    [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.top.equalTo(self);
//        make.right.equalTo(self);
//        make.height.mas_equalTo(kBtnLineThick);
//    }];
//    [lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.top.equalTo(self);
//        make.bottom.equalTo(self);
//        make.width.mas_equalTo(kBtnLineThick);
//    }];
//    
//    [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.bottom.equalTo(self);
//        make.right.equalTo(self);
//        make.height.mas_equalTo(kBtnLineThick);
//    }];
//    [lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self);
//        make.top.equalTo(self);
//        make.right.equalTo(self);
//        make.width.mas_equalTo(kBtnLineThick);
//    }];
    
    self.layer.masksToBounds = YES;
    self.layer.borderColor = kSubjectColor.CGColor;
    self.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = [UIColor redColor].CGColor;
    }else{
        self.layer.borderColor = kSubjectColor.CGColor;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
