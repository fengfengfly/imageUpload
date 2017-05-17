//
//  ProductListHeaderCell.m
//  InfoCapture
//
//  Created by lx on 2017/5/8.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "ProductListHeaderCell.h"

@implementation ProductListHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
}

- (void)configCellModel:(ProductModel *)model{
    self.title.text = model.productCode;
}
@end
