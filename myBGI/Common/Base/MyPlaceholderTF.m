//
//  MyPlaceholderTF.m
//  myBGI
//
//  Created by lx on 2017/5/16.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "MyPlaceholderTF.h"

@implementation MyPlaceholderTF
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:kPlaceHolderColor}];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
