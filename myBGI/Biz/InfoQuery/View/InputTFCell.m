//
//  InputTFCell.m
//  myBGI
//
//  Created by lx on 2017/5/11.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "InputTFCell.h"
#import "Masonry.h"

@implementation InputTFCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
    self.textField.delegate = self;
    self.textField.textColor = kSubjectColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

@end
