//
//  ProductListHeaderCell.h
//  InfoCapture
//
//  Created by lx on 2017/5/8.
//  Copyright © 2017年 feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
#define kProductCellH 30
#define kProductCellW 80

@interface ProductListHeaderCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
- (void)configCellModel:(ProductModel *)model;
@end
