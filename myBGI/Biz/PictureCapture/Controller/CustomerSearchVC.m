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
#import "SearchHistoryView.h"

@interface CustomerSearchVC ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) SearchHistoryView *historyView;
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
    [self.historyView.historys removeAllObjects];
    [self.historyView.historys addObjectsFromArray:array];
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
    CGRect frame = CGRectMake(0, 0, kWindowWith, self.view.frame.size.height);
    self.view.frame = frame;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SCREEN_HEIGHT - 64)];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.searchBar.tintColor = [UIColor blueColor];
    self.searchBar.placeholder = @"输入您想要搜索的医院名或编号";
    self.searchBar.delegate = self;
    [self.searchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.navigationItem.titleView = self.searchBar;
    
}

- (void)rightBarButtonItem
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark Setter -- Getter
- (UIView *)historyView{
    if (_historyView == nil) {
        _historyView = [[SearchHistoryView alloc] initWithFrame:self.view.bounds];
        _historyView.backgroundColor = RGBColor(53, 53, 53, 0.5);
        _historyView.historyKey = CUS_SEARCH_HISTORY;
        __weak typeof(self) weakSelf = self;
        _historyView.selBlock = ^(NSString *text){
            weakSelf.searchBar.text = text;
            [weakSelf searchBarSearchButtonClicked:weakSelf.searchBar];
        };
        [self.view addSubview:_historyView];
    }
    return _historyView;
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
    return self.historyView.historys;
}

- (void)reloadDataSource{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"true", @"sampleBase.needPermission",self.searchBar.text,@"sampleBase.customerSimpleQuery",
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
        [self.historyView.historys removeObject:searchBar.text];
        
        if (self.historyView.historys.count >= 8) {
            [self.historyView.historys removeLastObject];
        }
        [self.historyView.historys insertObject:searchBar.text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setValue:self.historyView.historys forKey:CUS_SEARCH_HISTORY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.searchBar resignFirstResponder];
    }
    self.dataPage = 1;
    [self hudSelfWithMessage:@"正在加载..."];
    [self reloadDataSource];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.historyView.tableView reloadData];
    [self hideSelfHUD];
    self.historyView.hidden = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.historyView.hidden = YES;
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
    if (indexPath.row == self.dataSource.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
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
