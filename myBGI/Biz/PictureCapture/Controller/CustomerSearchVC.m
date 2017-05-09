//
//  CustomerSearchVC.m
//  InfoCapture
//
//  Created by lx on 2017/5/5.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "CustomerSearchVC.h"
#import "MJRefresh.h"
#import "HttpManager.h"
#import "UserManager.h"
#import <MJExtension/MJExtension.h>

#define CUS_SEARCH_HISTORY @"cus_search_history"

@interface CustomerSearchVC ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *historys;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) BOOL isResult;
@property (assign, nonatomic) NSInteger dataPage;
@end

@implementation CustomerSearchVC
static NSString *CustomerCellID = @"customerCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildView];
    
    [self configTableView];
    self.isResult = YES;
    self.dataPage = 1;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:CUS_SEARCH_HISTORY];
    [self.historys removeAllObjects];
    [self.historys addObjectsFromArray:array];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}
- (void)configTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.dataPage = 1;
        if (self.dataPage == 1 && self.searchBar.text.length == 0) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf reloadDataSource];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.dataPage == 1 && self.searchBar.text.length == 0) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf reloadDataSource];
    }];
}

- (void)buildView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.searchBar.tintColor = [UIColor blueColor];
    self.searchBar.placeholder = @"输入您想要搜索的内容";
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
}

- (void)rightBarButtonItem
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Setter -- Getter

- (NSMutableArray *)historys
{
    if (_historys == nil) {
        _historys = [NSMutableArray array];
    }
    
    return _historys;
}

- (NSMutableArray *)searchResults{
    if (nil == _searchResults) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}

- (NSMutableArray *)dataSource{
    if (self.isResult) {
        return self.searchResults;
    }
    return self.historys;
}

- (void)reloadDataSource{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"true", @"sampleBase.needPermission",
                           self.searchBar.text,@"sampleBase.customerSimpleQuery",
                           kUserManager.userModel.token, @"token",
                           [NSNumber numberWithInteger:self.dataPage], @"page",
                           [NSNumber numberWithInteger:20], @"rows",
                           nil];
    [[HttpManager sharedManager] sendPostUrlRequestWithBodyURLString:kQueryCustomer parameters:param success:^(id mResponseObject) {
        NSArray *rows = mResponseObject[@"rows"];
        NSArray *newDatas = [CustomerModel mj_objectArrayWithKeyValuesArray:rows];
        if (self.dataPage == 1) {
            [self.dataSource removeAllObjects];
        }
        if (newDatas.count > 0) {
            [self.dataSource addObjectsFromArray:newDatas];
            [self.tableView reloadData];
            self.dataPage ++;
        }else{
            [self showStatusBarWarningWithStatus:@"没有更多数据"];
        }
        [MBProgressHUD hiddenForView:self.view];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self hideSelfHUD];
    } failure:^(id mError) {
        [MBProgressHUD hiddenForView:self.view];
        if ([mError isKindOfClass:[NSString class]]) {
            [self showStatusBarWarningWithStatus:mError];
        }else{
            [self showStatusBarWarningWithStatus:@"网络错误"];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self hideSelfHUD];
    }];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length > 0) {
        [self.historys removeObject:searchBar.text];
        
        if (self.historys.count >= 8) {
            [self.historys removeLastObject];
        }
        [self.historys insertObject:searchBar.text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setValue:self.historys forKey:CUS_SEARCH_HISTORY];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    self.dataPage = 1;
    [self hudSelfWithMessage:@"正在加载..."];
    [self reloadDataSource];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}
#pragma -mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomerCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CustomerCellID];
    }
    CustomerModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.customerCode;
    cell.detailTextLabel.text = model.customerName;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    return cell;
}

#pragma -mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerModel *model = self.dataSource[indexPath.row];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.chooseBlock) {
        self.chooseBlock(model);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
/*
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *text = self.historys[indexPath.row];
    if (text.length > 0) {
        [self.historys removeObject:text];
        
        if (self.historys.count >= 8) {
            [self.historys removeLastObject];
        }
        [self.historys insertObject:text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setValue:self.historys forKey:CUS_SEARCH_HISTORY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 200, 20)];
    label.text = @"历史搜索";
    label.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:label];
    
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UIButton *clearHistoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 20, SCREEN_WIDTH - 100, 40)];
    [clearHistoryBtn setTitleColor:GrayFontColor forState:(UIControlStateNormal)];
    [clearHistoryBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [clearHistoryBtn setTitle:@"清空历史搜索" forState:(UIControlStateNormal)];
    clearHistoryBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    clearHistoryBtn.layer.borderWidth = 0.5;
    clearHistoryBtn.backgroundColor = [UIColor whiteColor];
    [clearHistoryBtn addTarget:self action:@selector(clearHistoryBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [footerView addSubview:clearHistoryBtn];
    
    return footerView;
}

- (void)clearHistoryBtnClick
{
    [[NSUserDefaults standardUserDefaults] setValue:@[] forKey:CUS_SEARCH_HISTORY];
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
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
