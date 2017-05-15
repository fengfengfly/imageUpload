//
//  SingleSelectVC.h
//  myBGI
//
//  Created by lx on 2017/5/14.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseViewController.h"

@interface SingleSelectVC : BaseViewController
@property (strong, nonatomic) NSArray *dataSource;
@property (copy, nonatomic)  void(^selectBlock)(NSIndexPath *indexPath);
@end
