//
//  DeliverCountView.m
//  InfoCapture
//
//  Created by lx on 2017/5/5.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "DeliverCountView.h"
#import "HttpManager.h"
#import <MJExtension/MJExtension.h>
#import "MJRefresh.h"

#import "MBProgressHUD+HYExtension.h"
#import "NSString+NilString.h"
#import "NSMutableDictionary+Safe.h"

#import "UIView+SelfController.h"
#import "CalendarView.h"

#import "QueryCountCell.h"

@implementation DeliverCountView
static NSString *DeliverCountCellID = @"DeliverCountCellID";
-(void)awakeFromNib{
    [super awakeFromNib];
    self.dataPage = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"QueryCountCell" bundle:nil] forCellReuseIdentifier:DeliverCountCellID];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.dataPage = 1;
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf reloadDataSource];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf reloadDataSource];
    }];
    self.beginTimeTF.text = [self makeTodayStr];
    self.endTimeTF.text = [self makeTodayStr];
}
- (NSString *)makeTodayStr{
    NSString *dateStr = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *today = [NSDate date];
    dateStr = [dateFormatter stringFromDate:today];
    return dateStr;
}
- (void)showCalendarDateStr:(NSString *)date willSelected:(BOOL (^)(NSString *willDaetStr))willBlock finishBlock:(void(^)(NSString *dateStr))finishBlock{
    UIViewController *controller = [self getCurrentViewController];
    CalendarView *calendarV = [[CalendarView alloc] initWithFrame:controller.view.bounds];
    calendarV.willSelectBlock = willBlock;
    calendarV.selectedBlock = finishBlock;
    [calendarV.calendar selectDate:[calendarV.dateFormatter dateFromString:date] scrollToDate:YES];
    [controller.view addSubview:calendarV];
    
}

- (IBAction)chooseBeginTimeClick:(UIButton *)sender {
    
    [self showCalendarDateStr:self.beginTimeTF.text willSelected:^BOOL(NSString *willDateStr) {
        
        return YES;
    } finishBlock:^(NSString *dateStr) {
        
        self.beginTimeTF.text = dateStr;
        
    }];
}

- (IBAction)chooseEndTimeClick:(UIButton *)sender {
    
    [self showCalendarDateStr:self.endTimeTF.text willSelected:^BOOL(NSString *willDateStr){
        
        return YES;
    } finishBlock:^(NSString *dateStr) {
        
        self.endTimeTF.text = dateStr;
    }];
}

- (IBAction)searchBtnClick:(UIButton *)sender {
    self.dataPage = 1;
    [self reloadDataSource];
}

#pragma mark setter--getter
- (NSMutableArray *)dataSource{
    if (nil == _dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)reloadDataSource{
    NSComparisonResult result = [self.beginTimeTF.text compare:self.self.endTimeTF.text];
    if (result == NSOrderedDescending) {
        [self showStatusBarWarningWithStatus:@"开始时间不能晚于结束时间"];
        return;
    }
    [MBProgressHUD showAnimotionHUDOnView:self];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  kUserManager.userModel.token, @"token",
                                  [NSString stringWithFormat:@"%zd",self.dataPage], @"page",
                                  @"20", @"rows",
                                  nil];
    [param filterNilSetObject:[NSString ifNilStringWithNil:self.beginTimeTF.text]  forKey:@"commonDto.reportTimeStart"];
    [param filterNilSetObject:[NSString ifNilStringWithNil:self.endTimeTF.text]  forKey:@"commonDto.reportTimeEnd"];
    
    NSString *urlStr = (self.countType == DeliverCountTypeProduct)? kQueryDelieverProduct : kQueryDelieverCustom;
    
    [[HttpManager sharedManager] sendPostUrlRequestWithBodyURLString:urlStr parameters:param success:^(id mResponseObject) {
        NSArray *rows = mResponseObject[@"rows"];
        
        NSArray *newDatas = [DeliverCountModel mj_objectArrayWithKeyValuesArray:rows];
        if (self.dataPage == 1) {
            [self.dataSource removeAllObjects];
        }
        if (newDatas.count > 0) {
            [self.dataSource addObjectsFromArray:newDatas];
            
            self.dataPage ++;
        }else{
            [self showStatusBarWarningWithStatus:@"没有更多数据"];
        }
        [self.tableView reloadData];
        [MBProgressHUD hiddenForView:self];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    } failure:^(id mError) {
        if ([mError isKindOfClass:[NSString class]]) {
            [self showStatusBarWarningWithStatus:mError];
        }else{
            [self showStatusBarWarningWithStatus:@"网络错误"];
        }
        [MBProgressHUD hiddenForView:self];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QueryCountCell *cell = [tableView dequeueReusableCellWithIdentifier:DeliverCountCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DeliverCountModel *model = self.dataSource[indexPath.row];
    if (self.countType == DeliverCountTypeProduct) {
        cell.CodeLabel.text = model.productCode;
        cell.titleLabel.text = model.productName;
        cell.badgeLabel.text = model.countNumber;
    }else{
        cell.CodeLabel.text = model.customerCode;
        cell.titleLabel.text = model.customerName;
        cell.badgeLabel.text = model.countNumber;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
