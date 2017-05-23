//
//  FFCollectionView.m
//  myBGI
//
//  Created by lx on 2017/5/18.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "FFCollectionView.h"

@implementation FFCollectionView
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.reSizeBlock) {
        self.reSizeBlock();
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
