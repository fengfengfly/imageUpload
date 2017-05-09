//
//  ProductListViewController.h
//  InfoCapture
//
//  Created by feng on 18/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductModel.h"

typedef void(^ProductChoose)(NSMutableArray *productArray);
@interface ProductListViewController : BaseViewController
@property (copy, nonatomic) ProductChoose chooseBlock;
@property (assign, nonatomic) BOOL allowMultiSelect;
@property (strong, nonatomic) NSMutableArray *selectedArray;
@end
