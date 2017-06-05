//
//  ProductListViewController.h
//  InfoCapture
//
//  Created by feng on 18/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductModel.h"

typedef void(^ProductChoose)(NSMutableArray *productArray, BOOL isConfirm);//isConfirm 判断确定选择或者取消(点击了返回)
@interface ProductListViewController : BaseViewController
@property (copy, nonatomic) ProductChoose chooseBlock;
@property (assign, nonatomic) BOOL allowMultiSelect;
@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (strong, nonatomic) NSMutableArray *originSelectedArray;
@property (assign, nonatomic) BOOL showClearBtn;
@end
