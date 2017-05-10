//
//  SampleCountView.m
//  InfoCapture
//
//  Created by lx on 2017/5/5.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "SampleCountView.h"

#import "HttpManager.h"
#import <MJExtension/MJExtension.h>
#import "MJRefresh.h"

#import "MBProgressHUD+HYExtension.h"
#import "NSString+NilString.h"
#import "NSMutableDictionary+Safe.h"

#import "QueryCountCell.h"

@implementation SampleCountView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static NSString *SampleCountCellID = @"SampleCountCellID";
-(void)awakeFromNib{
    [super awakeFromNib];
    self.dataPage = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QueryCountCell" bundle:nil] forCellReuseIdentifier:SampleCountCellID];
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
    
    //初始化pickerView
    self.selectTypeIndex = 0;
    NSString *type = self.timeTypes[self.selectTypeIndex];
    self.timeTypeTF.text = type;
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    [pickerView selectRow:0  inComponent:0 animated:YES];
    // set change the inputView (default is keyboard) to UIPickerView
    self.timeTypeTF.inputView = pickerView;
    self.timeTypeTF.delegate = self;
    // add a toolbar with Cancel & Done button
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneInputStyle:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelInputStyle:)];
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:@"请选择日期类型" style:UIBarButtonItemStylePlain target:nil action:nil];
    titleButton.tintColor = [UIColor blackColor];
    // the middle button is to make the Done button align to right
    [toolBar setItems:@[cancelButton,flexibleButton,titleButton,flexibleButton,doneButton]];
    self.timeTypeTF.inputAccessoryView = toolBar;
    
}


- (void)doneInputStyle:(id)sender{
    self.timeTypeTF.text = self.timeTypes[self.selectTypeIndex];
    
    [self.timeTypeTF resignFirstResponder];
}
- (void)cancelInputStyle:(id)sender{
    [self.timeTypeTF resignFirstResponder];
}

- (IBAction)timeTypeClick:(UIButton *)sender {
   
}
- (IBAction)beginTimeClick:(UIButton *)sender {
    
}
- (IBAction)endTimeClick:(UIButton *)sender {
    
}

- (IBAction)searchBtnClick:(UIButton *)sender {
    self.dataPage = 1;
    [self reloadDataSource];
}

#pragma mark setter--getter
- (NSArray *)timeTypes{
    if (_timeTypes == nil) {
        _timeTypes = [NSArray arrayWithObjects:@"到样时间", @"录入时间", @"上传时间", nil];
    }
    return _timeTypes;
}

- (NSMutableArray *)dataSource{
    if (nil == _dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)reloadDataSource{
    [MBProgressHUD showAnimotionHUDOnView:self];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  kUserManager.userModel.token, @"token",
                                  [NSString stringWithFormat:@"%zd",self.dataPage], @"page",
                                  @"20", @"rows",
                                  nil];
    [param filterNilSetObject:[NSNumber numberWithInteger:self.selectTypeIndex] forKey:@"commonDto.searchTimeType"];
    [param filterNilSetObject:[NSString ifNilStringWithNil:self.beginTimeTF.text]  forKey:@"commonDto.searchTimeStart"];
    [param filterNilSetObject:[NSString ifNilStringWithNil:self.endTimeTF.text]  forKey:@"commonDto.searchTimeEnd"];
    
    NSString *urlStr = (self.countType == SampleCountTypeProduct)? kQueryReceiveProduct: kQueryReceiveCustom;
    
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

#pragma mark UITextFieldDelegate

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QueryCountCell *cell = [tableView dequeueReusableCellWithIdentifier:SampleCountCellID];
    DeliverCountModel *model = self.dataSource[indexPath.row];
    if (self.countType == SampleCountTypeProduct) {
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

#pragma mark UIPickerView DataSource Method


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = self.timeTypes.count;
            break;
        default:
            break;
    }
    
    return result;
}

#pragma mark UIPickerView Delegate Method

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = nil;
    switch (component) {
        case 0:
            title = self.timeTypes[row];
            break;
        default:
            break;
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectTypeIndex = row;
}
@end
