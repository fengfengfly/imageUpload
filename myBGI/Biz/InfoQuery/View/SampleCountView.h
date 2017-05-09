//
//  SampleCountView.h
//  InfoCapture
//
//  Created by lx on 2017/5/5.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseView.h"

@interface SampleCountView : BaseView<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *timeTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *beginTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@end
