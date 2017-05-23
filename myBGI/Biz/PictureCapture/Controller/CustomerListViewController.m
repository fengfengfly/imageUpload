//
//  CustomerListViewController.m
//  InfoCapture
//
//  Created by feng on 18/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "CustomerListViewController.h"
#import "MJRefresh.h"
#import "HttpManager.h"
#import "UserManager.h"
#import <MJExtension/MJExtension.h>
#import "CustomerSearchVC.h"
#import "BaseNavigationController.h"
#import "NSString+NilString.h"
#import "Masonry.h"
@interface CustomerListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *searchResult;
@property (strong, nonatomic, readonly) NSMutableArray *dataSource;
@property (assign, nonatomic) NSInteger dataPage;
@property (assign, nonatomic) NSInteger searchPage;
@property (assign, nonatomic) BOOL isSearchResult;

@end

@implementation CustomerListViewController
static NSString *CustomerCellID = @"customerCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择医院";
    self.dataPage = 1;
    self.searchPage = 1;
    
//    [MBProgressHUD showAnimationHUDWithImages:nil title:nil onView:self.view];
    [self reloadDataSource];
    [self configTableView];
    
    self.searchBtn.layer.cornerRadius = 5;
    self.searchBtn.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
}
- (void)dealloc{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
    
}
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)searchResult{
    if (_searchResult == nil) {
        _searchResult = [NSMutableArray array];
    }
    return _searchResult;
}
- (NSMutableArray *)dataSource{
    if (self.isSearchResult) {
        
        return self.searchResult;
    }
    return self.dataArray;
}
- (IBAction)searchBtnClick:(UIButton *)sender {
//    [self.searchTF resignFirstResponder];
//    [MBProgressHUD showAnimationHUDWithImages:nil title:nil onView:self.view];
//    [self.tableView.mj_header beginRefreshing];
    UIViewController *controller = self;
    
    CustomerSearchVC *customerSearchVC = [[UIStoryboard storyboardWithName:@"PictureCapture" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomerSearchVC"];
    customerSearchVC.chooseBlock = ^(CustomerModel *model){
        if (self.chooseBlock) {
            [self.navigationController popViewControllerAnimated:NO];
            self.chooseBlock(model);
        }
    };
    BaseNavigationController *navigationController = [[BaseNavigationController alloc] initWithRootViewController:customerSearchVC];
    [controller.navigationController presentViewController:navigationController animated:NO completion:nil];
}

- (void)configTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
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
}

- (void)reloadDataSource{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"true", @"sampleBase.needPermission",[NSString ifNilWithNilString: self.searchTF.text],@"sampleBase.customerSimpleQuery",
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
    } failure:^(id mError) {
        [MBProgressHUD hiddenForView:self.view];
        if ([mError isKindOfClass:[NSString class]]) {
            [self showStatusBarWarningWithStatus:mError];
        }else{
            [self showStatusBarWarningWithStatus:@"网络错误"];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
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
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    if (indexPath.row == self.dataSource.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionV = [[UIView alloc] init];
    sectionV.backgroundColor = kBgColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = kBlackFontColor;
    label.text = @"医院列表";
    [label sizeToFit];
    
    [sectionV addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionV).offset(10);
        make.centerY.equalTo(sectionV);
    }];
    
    return sectionV;
}
#pragma -mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerModel *model = self.dataSource[indexPath.row];
    if (self.chooseBlock) {
        self.chooseBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
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
