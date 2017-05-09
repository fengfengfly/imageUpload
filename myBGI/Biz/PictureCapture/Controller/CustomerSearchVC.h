//
//  CustomerSearchVC.h
//  InfoCapture
//
//  Created by lx on 2017/5/5.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomerModel.h"
typedef void(^ChooseSearchCustomer)(CustomerModel *model);
@interface CustomerSearchVC : BaseViewController
@property (copy, nonatomic) ChooseSearchCustomer chooseBlock;

@end
