//
//  SampleCountView.h
//  InfoCapture
//
//  Created by lx on 2017/5/5.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseView.h"
#import "DeliverCountModel.h"
#import "DrawLineView.h"

typedef NS_ENUM(NSInteger, SampleCountType) {
    SampleCountTypeProduct = 0,
    SampleCountTypeCustomer
};

@interface SampleCountView : BaseView<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *timeTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *beginTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) SampleCountType countType;
@property (assign, nonatomic) NSInteger dataPage;
@property (strong, nonatomic) NSArray *timeTypes;
@property (assign, nonatomic) NSInteger selectTypeIndex;
@property (weak, nonatomic) IBOutlet DrawLineView *drawLineV;
- (void)initDrawInfo;
@end
