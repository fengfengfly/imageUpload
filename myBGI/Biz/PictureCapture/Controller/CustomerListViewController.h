//
//  CustomerListViewController.h
//  InfoCapture
//
//  Created by feng on 18/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomerModel.h"
typedef void(^ChooseCustomer)(CustomerModel *model);
@interface CustomerListViewController : BaseViewController
@property (copy, nonatomic) ChooseCustomer chooseBlock;
@end
