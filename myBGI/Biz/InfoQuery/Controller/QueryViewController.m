//
//  QueryViewController.m
//  InfoCapture
//
//  Created by feng on 14/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "QueryViewController.h"
#import "SampleImportModel.h"
#import "MJRefresh.h"
#import <MJExtension/MJExtension.h>
#import "UserManager.h"
#import "NSMutableDictionary+Safe.h"
#import "HttpManager.h"
#import "QuerySampleCell.h"

#import "MoreQueryView.h"
#import "CustomerListViewController.h"
#import "ProductListViewController.h"

#import "SimplePopupView.h"
#import "UIView+SimplePopupView.h"
#import "NSString+NilString.h"
@interface QueryViewController ()<UITableViewDelegate, UITableViewDataSource, SimplePopupViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *searchResult;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) NSInteger dataPage;
@property (assign, nonatomic) NSInteger searchPage;
@property (assign, nonatomic) BOOL isSearchResult;

@property (strong, nonatomic) NSString *sampleNumStr;
@property (strong, nonatomic) NSString *productCode;
@property (strong, nonatomic) NSString *sampleName;
@property (strong, nonatomic) NSString *customerCode;
@property (strong, nonatomic) NSString *step;
@property (strong, nonatomic) NSString *phoneNum;
@property (strong, nonatomic) NSString *result;

@property (strong, nonatomic) NSArray *stepsList;//返回字段对照表
@property (strong, nonatomic) NSArray *stepsListUp;//搜索上传字段对照表
@property (strong, nonatomic) NSArray *resultsList;
@property (strong, nonatomic) MoreQueryView *moreQueryView;
@property (strong, nonatomic) SimplePopupView *stepsListV;
@property (strong, nonatomic) SimplePopupView *resultsListV;

@end

static NSString *QueryCellID = @"QueryCellID";
@implementation QueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"进度查询";
    self.dataPage = 1;
    self.searchPage = 1;
    
    [self configTableView];
    self.moreBtn.layer.masksToBounds = YES;
    self.moreBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.moreBtn.layer.borderWidth = 0.5;
    self.moreBtn.layer.cornerRadius = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)stepsList{
    if (_stepsList == nil) {
        _stepsList = [NSArray arrayWithObjects:@"----", @"样本停测", @"检测失败", @"商务是否卡报告", @"已出报告", @"基因检测", @"样本接收", @"样品运输", @"已采样", nil];
    }
    return _stepsList;
}

- (NSArray *)stepsListUp{
    if (_stepsListUp == nil) {
        _stepsListUp = [NSArray arrayWithObjects:@"----", @"已采样", @"样本运输", @"样本接收", @"基因检测", @"已出报告", @"商务不允许发放", @"检测失败", @"样本停测", nil];
    }
    return _stepsListUp;
}

- (NSArray *)resultsList{
    if (_resultsList == nil) {
        _resultsList = [NSArray arrayWithObjects:@"----", @"高风险",@"低风险", nil];
    }
    return _resultsList;
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

- (MoreQueryView *)moreQueryView{
    if (_moreQueryView == nil) {
        _moreQueryView = [[[NSBundle mainBundle] loadNibNamed:@"MoreQueryView" owner:nil options:nil] firstObject];
        _moreQueryView.frame = self.view.bounds;
        [_moreQueryView.finishBtn addTarget:self action:@selector(finishQueryMore:) forControlEvents:UIControlEventTouchUpInside];
        [_moreQueryView.cancelBtn addTarget:self action:@selector(cancelQueryMore:) forControlEvents:UIControlEventTouchUpInside];
        [self addActionToQueryView:_moreQueryView];
    }
    
    return _moreQueryView;
}

- (void)configTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QuerySampleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:QueryCellID];
    
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
- (IBAction)searchBtnClick:(UIButton *)sender {
    if (self.searchTF.text.length == 0) {
        [self showStatusBarWarningWithStatus:@"请输入查询的样品编号"];
        return;
    }
    [MBProgressHUD showAnimationHUDWithImages:nil title:nil onView:self.view];
    self.productCode = self.searchTF.text;
    [self.tableView.mj_header beginRefreshing];
}
- (IBAction)moreBtnClick:(UIButton *)sender {
    [self.view addSubview:self.moreQueryView];
}

- (void)finishQueryMore:(id)sender{
    [self.moreQueryView removeFromSuperview];
    
    self.productCode = self.moreQueryView.productTF.text;
    self.sampleName = self.moreQueryView.nameTF.text;
//    if (self.moreQueryView.statusTF.text.length > 0) {
//        
//        self.step =[NSString stringWithFormat:@"%zd",[self.stepsListUp indexOfObject:self.moreQueryView.statusTF.text] - 1];
//    }else{
//        self.step = nil;
//    }
    self.result = self.moreQueryView.resultTF.text;
    self.phoneNum = self.moreQueryView.phoneTF.text;
    
    [MBProgressHUD showAnimationHUDWithImages:nil title:nil onView:self.view];
    [self.tableView.mj_header beginRefreshing];
}

- (void)cancelQueryMore:(id)sender{
    [self.moreQueryView removeFromSuperview];
}

- (void)addActionToQueryView:(MoreQueryView *)moreQueryView{
    
    UITapGestureRecognizer *tapCustomer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCustomers)];
    UITapGestureRecognizer *tapProduct = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProducts)];
   
    [moreQueryView.customerAction addGestureRecognizer:tapCustomer];
    [moreQueryView.productAction addGestureRecognizer:tapProduct];
    [moreQueryView.statusAction addTarget:self action:@selector(showSteps:) forControlEvents:UIControlEventTouchUpInside];
    [moreQueryView.resultAction addTarget:self action:@selector(showResults:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showCustomers{
    [self.moreQueryView.customerTF resignFirstResponder];
    CustomerListViewController *customerListVC = [[UIStoryboard storyboardWithName:@"PictureCapture" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomerListViewController"];
    
    customerListVC.chooseBlock = ^(CustomerModel *model){
        
        self.moreQueryView.customerTF.text = model.customerName;
        self.customerCode = model.customerCode;
        
    };
    
    [self.navigationController pushViewController:customerListVC animated:YES];
}

- (void)showProducts{
    [self.moreQueryView.productTF resignFirstResponder];
    ProductListViewController *productListVC = [[UIStoryboard storyboardWithName:@"PictureCapture" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductListViewController"];
    productListVC.allowMultiSelect = NO;
    productListVC.chooseBlock = ^(NSMutableArray *productArray){
        self.moreQueryView.productTF.text = [self productCodeStr:productArray];
    };
    
    [self.navigationController pushViewController:productListVC animated:YES];
}

- (void)showSteps:(id)sender{
    if (self.stepsListV == nil) {
        SimplePopupView *popView = nil;
        UIButton *btn = (UIButton *)sender;
        
        PopViewDirection direction = PopViewDirectionTop;
        popView = [[SimplePopupView alloc]initWithFrame:CGRectMake(50, 50, 140, 220) andDirection:direction andTitles:self.stepsListUp andImages:nil trianglePecent:1];
        
        popView.delegate = self;
        popView.popColor = [UIColor whiteColor];
        popView.cellColor = [UIColor lightGrayColor];
        popView.CornerRadius = 0;
        popView.edgeLength = 0;
        popView.popTintColor = [UIColor blackColor];
        [btn showPopView:popView AtPoint:CGPointMake(1, 0.7)];
        self.stepsListV = popView;
    }
    
    [self.stepsListV show];
}

- (void)showResults:(id)sender{
    if (self.resultsListV == nil) {
        SimplePopupView *popView = nil;
        UIButton *btn = (UIButton *)sender;
        
        PopViewDirection direction = PopViewDirectionTop;
        popView = [[SimplePopupView alloc]initWithFrame:CGRectMake(50, 50, 100, 80) andDirection:direction andTitles:self.resultsList andImages:nil trianglePecent:1];
        
        popView.delegate = self;
        popView.popColor = [UIColor whiteColor];
        popView.cellColor = [UIColor lightGrayColor];
        popView.CornerRadius = 0;
        popView.edgeLength = 0;
        popView.popTintColor = [UIColor blackColor];
        [btn showPopView:popView AtPoint:CGPointMake(0.8, 1)];
        self.resultsListV = popView;
    }
    
    [self.resultsListV show];
}

#pragma mark - SimplePopupViewDelegate
-(void)simplePopupView:(SimplePopupView *)popView clickAtIndexPath:(NSIndexPath *)indexPath{
    if(popView == self.stepsListV){
        if (indexPath.row == 0) {
            self.moreQueryView.statusTF.text = @"";
            self.step = @"";
        }else{
            self.step = [NSString stringWithFormat:@"%zd", indexPath.row - 1];
            self.moreQueryView.statusTF.text = self.stepsListUp[indexPath.row];
        }
    }
    if (popView == self.resultsListV) {
        if (indexPath.row == 0) {
            self.moreQueryView.resultTF.text = @"";
        }else{
            
            self.moreQueryView.resultTF.text = self.resultsList[indexPath.row];
        }
        
    }
    
}

- (void)popViewDidDismiss{

}


- (NSString *)productCodeStr:(NSArray *)productArray{
    NSMutableString *mutStr = [NSMutableString string];
    for (ProductModel *product in productArray) {
        if (product.productCode.length > 0) {
            [mutStr appendFormat:@"%@,",product.productCode];
        }
    }
    if (mutStr.length > 0) {
        [mutStr deleteCharactersInRange:NSMakeRange(mutStr.length - 1, 1)];
    }else{
        return @"";
    }
    return mutStr;
}

- (void)reloadDataSource{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           kUserManager.userModel.token, @"token",
                           [NSString stringWithFormat:@"%zd",self.dataPage], @"page",
                           @"20", @"rows",
                           nil];
    [param filterNilSetObject:[NSString ifNilStringWithNil:self.sampleNumStr]  forKey:@"sampleImport.sampleNumStr"];
    [param filterNilSetObject:[NSString ifNilStringWithNil:self.productCode]  forKey:@"sampleImport.productCode"];
    [param filterNilSetObject:[NSString ifNilStringWithNil:self.sampleName] forKey:@"sampleImport.sampleName"];
    [param filterNilSetObject:[NSString ifNilStringWithNil:self.customerCode] forKey:@"sampleImport.customerCode"];
    [param filterNilSetObject:[NSString ifNilStringWithNil:self.step] forKey:@"sampleImport.step"];
    [param filterNilSetObject:[NSString ifNilStringWithNil:self.phoneNum] forKey:@"sampleImport.phoneNum"];
    [param filterNilSetObject:[NSString ifNilStringWithNil:self.result] forKey:@"sampleImport.result"];
    
    [[HttpManager sharedManager] sendPostUrlRequestWithBodyURLString:kQuerySample parameters:param success:^(id mResponseObject) {
        NSArray *rows = mResponseObject[@"rows"];
        NSArray *newDatas = [SampleImportModel mj_objectArrayWithKeyValuesArray:rows];
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
    QuerySampleCell *cell = [tableView dequeueReusableCellWithIdentifier:QueryCellID forIndexPath:indexPath];
    SampleImportModel *model = self.dataSource[indexPath.row];
    cell.statusL.text = self.stepsList[[model.step rangeOfString:@"1"].location + 1];
    [cell configCellWithModel:model];
    
    return cell;
}

#pragma -mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 148;
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
