//
//  ProductListViewController.m
//  InfoCapture
//
//  Created by feng on 18/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "ProductListViewController.h"
#import "BaseNavigationController.h"
#import "UserManager.h"
#import "HttpManager.h"
#import "MJRefresh.h"
#import <MJExtension/MJExtension.h>
#import "NSString+NilString.h"
#import "Masonry.h"

#import "ProductListHeader.h"
#import "ProductSearchVC.h"

#import "Masonry.h"

@interface ProductListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *searchResult;
@property (assign, nonatomic) BOOL isSearchResult;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (assign, nonatomic) NSInteger dataPage;
@property (assign, nonatomic) NSInteger searchPage;
@property (strong, nonatomic) ProductListHeader *listHeader;

@property (assign, nonatomic) BOOL confirm;

@end

@implementation ProductListViewController

static NSString *ProductCellID = @"ProductCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.confirm = NO;
    self.title = @"选择产品";
    self.dataPage = 1;
    self.searchPage = 1;
//    self.view.backgroundColor = RGBColor(110, 110, 110, 0.3);
    [MBProgressHUD showAnimationHUDWithImages:nil title:nil onView:self.view];
    [self reloadDataSource];
    [self configTableView];
    
    self.searchBtn.layer.cornerRadius = 5;
    self.searchBtn.layer.masksToBounds = YES;
    
    //自定义navigationBar右边的按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rightBtn sizeToFit];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    rightBtn.hidden = !self.allowMultiSelect;
    
    self.originSelectedArray = self.selectedArray.mutableCopy;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}


- (void)calculateHeader{
    
    CGFloat collectionViewH = self.listHeader.collectionView.contentSize.height;
    
    if (self.tableView.tableHeaderView.frame.size.height != collectionViewH +kListHeaderTopSpace) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, collectionViewH + kListHeaderTopSpace);
        UIView *view=self.tableView.tableHeaderView;
        view.frame = frame;
        [self.tableView beginUpdates];
        self.tableView.tableHeaderView = view;
        [self.tableView endUpdates];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    [super touchesBegan:touches withEvent:event];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willPop{
    if (self.chooseBlock) {
        if (self.confirm) {
            self.chooseBlock(self.selectedArray, self.confirm);
        }else{
            
            self.chooseBlock(self.originSelectedArray, self.confirm);
        }
    }

}

- (void)backBtnClick{
    self.confirm = NO;
    [super backBtnClick];
}

#pragma mark set-getProperty
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

- (NSMutableArray *)selectedArray{
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (void)configTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if (self.allowMultiSelect) {
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kListHeaderH)];
        self.tableView.tableHeaderView = header;
        ProductListHeader *listHeader = [[[NSBundle mainBundle] loadNibNamed:@"ProductListHeader" owner:nil options:nil] firstObject];
        listHeader.frame = header.bounds;
        listHeader.dataSource = self.selectedArray;
        __weak typeof(self) weakSelf = self;
        listHeader.actionBlock = ^(NSIndexPath *indexPath){
            
            [weakSelf.tableView reloadData];
            
        };
        listHeader.collectionView.reSizeBlock = ^(){
            [weakSelf calculateHeader];
        };
        [header addSubview:listHeader];
        self.listHeader = listHeader;
        [listHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header);
            make.top.equalTo(header);
            make.right.equalTo(header);
            make.bottom.equalTo(header);
        }];
        
    }
    
    self.tableView.allowsMultipleSelection = self.allowMultiSelect;
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.dataPage = 1;
        [weakSelf reloadDataSource];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf reloadDataSource];
    }];
}

- (BOOL)containModel:(ProductModel *)product inArray:(NSMutableArray<ProductModel *> *)array remove:(BOOL)ifRemove{
    BOOL flag = NO;
    NSInteger index = 0;
    for (ProductModel *model in array) {
        if ([model.productCode isEqualToString:product.productCode]) {
            flag = YES;
            break;
        }
        index ++;
    }
    if (ifRemove) {
        [array removeObjectAtIndex:index];
    }
    return flag;
}

- (void)reloadDataSource{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"true", @"sampleFile.needPermission",[NSString ifNilWithNilString:self.searchTF.text], @"sampleFile.productSimpleQuery",
                           kUserManager.userModel.token, @"token",
                           [NSNumber numberWithInteger:self.dataPage], @"page",
                           [NSNumber numberWithInteger:20], @"rows",
                           nil];
    [[HttpManager sharedManager] sendPostUrlRequestWithBodyURLString:kQueryProduct parameters:param success:^(id mResponseObject) {
        NSArray *rows = mResponseObject[@"rows"];
        NSArray *newDatas = [ProductModel mj_objectArrayWithKeyValuesArray:rows];
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
        if ([mError isKindOfClass:[NSString class]]) {
            [self showStatusBarWarningWithStatus:mError];
        }else{
            [self showStatusBarWarningWithStatus:@"网络错误"];
        }
        [MBProgressHUD hiddenForView:self.view];
    }];
}


- (IBAction)searchBtnClick:(UIButton *)sender {
//    [self.searchTF resignFirstResponder];
//    [MBProgressHUD showAnimationHUDWithImages:nil title:nil onView:self.view];
//    [self.tableView.mj_header beginRefreshing];
    
    UIViewController *controller = self;
    ProductSearchVC *productSearchVC = [[UIStoryboard storyboardWithName:@"PictureCapture" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductSearchVC"];
    productSearchVC.chooseBlock = ^(ProductModel *model){
        if (![self containModel:model inArray:self.selectedArray remove:NO]) {
            [self.selectedArray addObject:model];
            
            if (self.allowMultiSelect == YES) {//如果多选刷新界面
                
                [self.listHeader.collectionView reloadData];
                [self.tableView reloadData];
            }else{//如果单选直接确定选择
                [self confirmBtnClick:nil];
            }
        }
        
    };
    BaseNavigationController *navigationController = [[BaseNavigationController alloc] initWithRootViewController:productSearchVC];
    [controller.navigationController presentViewController:navigationController animated:NO completion:nil];
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.allowMultiSelect) {//如果单选直接跳回
        ProductModel *model = self.dataSource[indexPath.row];
        BOOL checkResult = [self containModel:model inArray:self.selectedArray remove:NO];
        if (!checkResult) {
            [self.selectedArray addObject:model];
        }
        [self confirmBtnClick:nil];
    }else{//如果多选刷新界面
        ProductModel *model = self.dataSource[indexPath.row];
        BOOL checkResult = [self containModel:model inArray:self.selectedArray remove:NO];
        if (!checkResult) {
            [self.selectedArray addObject:model];
            [self.listHeader.collectionView reloadData];
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductModel *model = self.dataSource[indexPath.row];
    if (self.allowMultiSelect) {
        BOOL checkResult = [self containModel:model inArray:self.selectedArray remove:YES];
        if (checkResult) {
            [self.listHeader.collectionView reloadData];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue2) reuseIdentifier:ProductCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tintColor = kSubjectColor;
    }
    
    ProductModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.productCode;
    cell.detailTextLabel.text = model.productName;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    if (self.allowMultiSelect) {
        BOOL checkResult = [self containModel:model inArray:self.selectedArray remove:NO];
        if (checkResult) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition: UITableViewScrollPositionNone];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = kSubjectColor;
            cell.detailTextLabel.textColor = kSubjectColor;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (indexPath.row == self.dataSource.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
- (void)confirmBtnClick:(UIButton *)sender {
//    NSArray *selPaths = [self.tableView indexPathsForSelectedRows];
//    NSMutableArray *selArray = [NSMutableArray array];
//    for (NSIndexPath *indexpath in selPaths) {
//        [selArray addObject:self.dataSource[indexpath.row]];
//    }
    
    self.confirm = YES;
    [self.navigationController popViewControllerAnimated:YES];
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
