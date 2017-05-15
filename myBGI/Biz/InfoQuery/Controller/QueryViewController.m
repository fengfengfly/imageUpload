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

#import "CustomerListViewController.h"
#import "ProductListViewController.h"
#import "MoreQueryVC.h"
#import "BaseNavigationController.h"

#import "NSString+NilString.h"
#import "UISearchBar+CustomColor.h"
@interface QueryViewController ()<UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
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
@property (strong, nonatomic) UIWindow *tempWindow;
@property (strong, nonatomic) UIView *tempMaskView;
@property (weak, nonatomic) MoreQueryVC *moreQueryVC;
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
    self.moreBtn.layer.cornerRadius = 2;
    self.searchBar.delegate = self;
    [self.searchBar setBarTintColor:[UIColor whiteColor]];
    [self.searchBar setSearchTextFieldBackgroundColor:kBgColor];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
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
        _resultsList = [NSArray arrayWithObjects:@"----", @"高风险", @"低风险", @"正常", @"异常", nil];
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

- (UIView *)tempMaskView{
    if (_tempMaskView == nil) {
        _tempMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tempMaskView.backgroundColor = RGBColor(50, 50, 50, 0.5);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tempMaskViewTap:)];
        [_tempMaskView addGestureRecognizer:tapGesture];
    }
    return _tempMaskView;
}

- (void)configTableView{
    self.tableView.backgroundColor = kBgColor;
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
- (void)searchBtnClick:(id )sender {
    if (self.searchBar.text.length == 0) {
        [self showStatusBarWarningWithStatus:@"请输入查询的样品编号"];
        return;
    }
    [MBProgressHUD showAnimationHUDWithImages:nil title:nil onView:self.view];
    self.productCode = self.searchBar.text;
    [self.tableView.mj_header beginRefreshing];
}
- (IBAction)moreBtnClick:(UIButton *)sender {
//    [self.view addSubview:self.moreQueryView];
    [[UIApplication sharedApplication].delegate.window addSubview:self.tempMaskView];
    if (self.tempWindow == nil) {
        UIWindow *newWindow = [[UIWindow alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH - kLeftSpace, SCREEN_HEIGHT)];
        MoreQueryVC *moreQueryVC = [[UIStoryboard storyboardWithName:@"InfoQuery" bundle:nil] instantiateViewControllerWithIdentifier:@"MoreQueryVC"];
        moreQueryVC.title = @"查询筛选";
        __weak typeof(self) weakSelf = self;
        moreQueryVC.stepsListUp = weakSelf.stepsListUp;
        moreQueryVC.resultsList = weakSelf.resultsList;
        moreQueryVC.backBlock = ^(BOOL doConfirm, NSArray *keyValues){
            [weakSelf tempMaskViewTap:nil];
            if (doConfirm) {
                for (NSDictionary *dic in keyValues) {
                    NSString *key = [dic allKeys].firstObject;
                    NSString *value = [dic allValues].firstObject;
                    [weakSelf setValue:value forKey:key];
                }
                [weakSelf finishQueryMore:nil];
            }
        };
        newWindow.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:moreQueryVC];
        self.tempWindow = newWindow;
        self.moreQueryVC = moreQueryVC;
    }
    [self.moreQueryVC transValue:self];
    [self.tempWindow makeKeyAndVisible];
    [UIView animateWithDuration:0.3 animations:^{
        self.tempWindow.frame = CGRectMake(kLeftSpace, 0, SCREEN_WIDTH - kLeftSpace, SCREEN_HEIGHT);
    }];
}

- (void)tempMaskViewTap:(id)sender{
    [self.tempMaskView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        self.tempWindow.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH - kLeftSpace, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        if (self.moreQueryVC.navigationController.viewControllers.count > 1) {
            [self.moreQueryVC.navigationController popToRootViewControllerAnimated:NO];
        }
        [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    }];
}

- (void)finishQueryMore:(id)sender{
    
    [MBProgressHUD showAnimationHUDWithImages:nil title:nil onView:self.view];
    [self.tableView.mj_header beginRefreshing];
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

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self searchBtnClick:searchBar];
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
    SampleImportModel *model = self.dataSource[indexPath.row];
    NSString *urlPath = model.reportPath;
    if (urlPath.length > 0) {
        [self downloadUrlStr:urlPath fileName:nil];
    }else{
        [self showStatusBarWarningWithStatus:@"所选样本没有报告"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 148;
}


#pragma mark Download Open Report
- (void)downloadUrlStr:(NSString *)urlStr fileName:(NSString *)fileName{
    NSString *httpStr = @"http:";
    urlStr = [httpStr stringByAppendingString:urlStr];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    if (fileName == nil) {
        fileName = [urlStr lastPathComponent];
    }
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths lastObject];
    
    NSString *documentsDirectory = NSTemporaryDirectory();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName]; //docPath为文件名
    
    if ([fileManager fileExistsAtPath:filePath]) {
        //文件已经存在,直接打开
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"是否打开报告" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction  =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self openDocxWithPath:filePath];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else {
        //文件不存在,要下载
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"是否下载并打开报告" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction  =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self hudSelfWithMessage:@"正在下载..."];
            [[HttpManager sharedManager] downloadFileWithUrlStr:urlStr SavePath:documentsDirectory fileName:fileName progress:^(NSProgress *downloadProgress) {
                
            } complete:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                [self hideSelfHUD];
                if (error) {
                    [self showStatusBarWarningWithStatus:@"下载失败"];
        
                }else {
                    NSString *pathStr = [filePath path];
                    [self openDocxWithPath:pathStr];
                }

            }];
            
        }]];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

-(void)openDocxWithPath:(NSString *)filePath {
    
    UIDocumentInteractionController *doc= [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    
    doc.delegate = self;
    [doc presentPreviewAnimated:YES];
}

#pragma mark - UIDocumentInteractionControllerDelegate
//必须实现的代理方法 预览窗口以模式窗口的形式显示，因此需要在该方法中返回一个view controller ，作为预览窗口的父窗口。如果你不实现该方法，或者在该方法中返回 nil，或者你返回的 view controller 无法呈现模式窗口，则该预览窗口不会显示。
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    
    return self;
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    
    return CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)dealloc{
#if DEBUG
    NSLog(@"%s", __func__);
#endif

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
