//
//  UITextField+RightImg.m
//  InfoCapture
//
//  Created by lx on 2017/4/25.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "UITextField+RightImg.h"

@implementation UITextField (RightImg)
+ (void)setRightViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName{
    
    UIImageView *rightView = [[UIImageView alloc]init];
    rightView.image = [UIImage imageNamed:imageName];
    rightView.frame = CGRectMake(0, 0, textField.frame.size.height, textField.frame.size.height);
    rightView.contentMode = UIViewContentModeCenter;
    textField.rightView = rightView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
}

@end
