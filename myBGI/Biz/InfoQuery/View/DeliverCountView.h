//
//  DeliverCountView.h
//  InfoCapture
//
//  Created by lx on 2017/5/5.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseView.h"
#import "DeliverCountModel.h"
#import "DrawLineView.h"
typedef NS_ENUM(NSInteger, DeliverCountType){
    DeliverCountTypeProduct = 0,
    DeliverCountTypeCustomer
};;

@interface DeliverCountView : BaseView<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *beginTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (assign, nonatomic) NSInteger dataPage;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) DeliverCountType countType;
@property (weak, nonatomic) IBOutlet DrawLineView *drawLineV;
- (void)initDrawInfo;
@end
