//
//  SearchHistoryView.h
//  myBGI
//
//  Created by lx on 2017/6/5.
//  Copyright © 2017年 feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHistoryView : UIView<UITableViewDelegate, UITableViewDataSource>
@property (copy, nonatomic) void(^selBlock)(NSString *text);
@property (strong, nonatomic) NSString *historyKey;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *historys;
@end
