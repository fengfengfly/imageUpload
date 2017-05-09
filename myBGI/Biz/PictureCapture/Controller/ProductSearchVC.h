//
//  ProductSearchVC.h
//  InfoCapture
//
//  Created by lx on 2017/5/5.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductModel.h"
typedef void(^ChooseSearchProduct)(ProductModel *model);
@interface ProductSearchVC : BaseViewController
@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (copy, nonatomic) ChooseSearchProduct chooseBlock;
@end
