//
//  MoreQueryView.m
//  InfoCapture
//
//  Created by lx on 2017/4/25.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "MoreQueryView.h"
#import "UITextField+RightImg.h"

@implementation MoreQueryView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = RGBColor(113, 113, 113, 0.3);
    self.containerV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.containerV.layer.borderWidth = 1.f;
    [UITextField setRightViewWithTextField:self.productTF imageName:@"arrowDown"];
    [UITextField setRightViewWithTextField:self.customerTF imageName:@"arrowDown"];
    [UITextField setRightViewWithTextField:self.statusTF imageName:@"arrowDown"];
    [UITextField setRightViewWithTextField:self.resultTF imageName:@"arrowDown"];
    self.finishBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.masksToBounds = YES;
    self.finishBtn.layer.borderWidth = 0.5;
    self.cancelBtn.layer.borderWidth = 0.5;
    self.finishBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.finishBtn.layer.cornerRadius = 4;
    self.cancelBtn.layer.cornerRadius = 4;
    
    [self.customerTF addSubview:self.customerAction];
    [self.productTF addSubview:self.productAction];
    [self.statusTF addSubview:self.statusAction];
    [self.resultTF addSubview:self.resultAction];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.customerAction.frame = self.customerTF.bounds;
    self.productAction.frame = self.productTF.bounds;
    self.statusAction.frame = self.statusTF.bounds;
    self.resultAction.frame = self.resultTF.bounds;
}

- (UIView *)customerAction{
    if (_customerAction == nil) {
        _customerAction = [[UIView alloc] initWithFrame:self.customerTF.bounds];
        _customerAction.backgroundColor = [UIColor clearColor];
    }
    return _customerAction;
    
}

- (UIView *)productAction{
    if (_productAction == nil) {
        _productAction = [[UIView alloc] initWithFrame:self.productTF.bounds];
        _productAction.backgroundColor = [UIColor clearColor];
    }
    return _productAction;
    
}

- (UIButton *)statusAction{
    if (_statusAction == nil) {
        _statusAction = [[UIButton alloc] initWithFrame:self.statusTF.bounds];
        _statusAction.backgroundColor = [UIColor clearColor];
    }
    return _statusAction;
    
}

- (UIButton *)resultAction{
    if (_resultAction == nil) {
        _resultAction = [[UIButton alloc] initWithFrame:self.resultTF.bounds];
        _resultAction.backgroundColor = [UIColor clearColor];
    }
    return _resultAction;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
