//
//  SearchHistoryView.m
//  myBGI
//
//  Created by lx on 2017/6/5.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "SearchHistoryView.h"

@implementation SearchHistoryView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:tableView];
        self.tableView = tableView;
    }
    return self;
}
- (NSMutableArray *)historys
{
    if (_historys == nil) {
        _historys = [NSMutableArray array];
    }
    
    return _historys;
}
#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = self.historys[indexPath.row];
    if (text.length > 0) {
        [self.historys removeObject:text];
        
        if (self.historys.count >= 8) {
            [self.historys removeLastObject];
        }
        [self.historys insertObject:text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setValue:self.historys forKey:self.historyKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (self.selBlock) {
            self.selBlock(text);
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    label.text = @"历史搜索：";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = kGrayFontColor;
    [headerView addSubview:label];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 39, tableView.frame.size.width - 20, 0.5)];
    lineView.backgroundColor = tableView.separatorColor;
    [headerView addSubview:lineView];
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    footerView.backgroundColor = [UIColor whiteColor];
    if (self.historys.count == 0) {
        return footerView;
    }
    UIButton *clearHistoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    [clearHistoryBtn setTitleColor:kGrayFontColor forState:(UIControlStateNormal)];
    [clearHistoryBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [clearHistoryBtn setTitle:@"清空历史搜索" forState:(UIControlStateNormal)];
    clearHistoryBtn.layer.borderColor = tableView.separatorColor.CGColor;
    clearHistoryBtn.layer.borderWidth = 0.5;
    clearHistoryBtn.backgroundColor = [UIColor whiteColor];
    [clearHistoryBtn addTarget:self action:@selector(clearHistoryBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [footerView addSubview:clearHistoryBtn];
    
    return footerView;
}

- (void)clearHistoryBtnClick
{
    [[NSUserDefaults standardUserDefaults] setValue:@[] forKey:self.historyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.historys removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.textLabel.text = self.historys[indexPath.row];
    
    return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
