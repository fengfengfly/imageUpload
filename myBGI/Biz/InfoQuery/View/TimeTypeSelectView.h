//
//  TimeTypeSelectView.h
//  myBGI
//
//  Created by lx on 2017/5/14.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseView.h"
#define kTimeTypeCellH 40
@interface TimeTypeSelectView : BaseView<UITableViewDelegate, UITableViewDataSource>
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;
@property (copy, nonatomic) BOOL(^willSelectBlock)(NSIndexPath *indexPath);
@property (copy, nonatomic) void(^selectedBlock)(NSIndexPath *indexPath);
@property (strong, nonatomic) UIView *contentView;
@property (assign, nonatomic) CGRect dropBeginFrame;
@property (assign, nonatomic) CGRect dropEndFrame;

- (instancetype)initWithFrame:(CGRect)frame contentFrame:(CGRect)contentframe;
- (void)showWithDataSource:(NSArray *)dataSource;
@end
