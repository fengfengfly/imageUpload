//
//  MoreQueryVC.m
//  myBGI
//
//  Created by lx on 2017/5/11.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "MoreQueryVC.h"
#import "Masonry.h"
#import "InputTFCell.h"
#import "Masonry.h"

#import "CustomerListViewController.h"
#import "ProductListViewController.h"

#import "SingleSelectVC.h"

@interface MoreQueryVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuList;
@property (strong, nonatomic) NSArray *placeholderList;

@end

@implementation MoreQueryVC
static NSString *CellIDTF = @"CellIDTF";
static NSString *CellIDDetail = @"CellIDDetail";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.menuList = @[@"姓名:", @"手机号:", @"产品:", @"客户:", @"状态:", @"结果:"];
    self.placeholderList = @[@"请输入姓名", @"请输入手机号", @"请选择产品", @"请选择客户", @"请选择状态", @"请选择结果"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"InputTFCell" bundle:nil] forCellReuseIdentifier:CellIDTF];
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 40)];
    self.tableView.tableFooterView = footer;
    footer.backgroundColor = [UIColor whiteColor];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    
    [resetBtn setTitleColor:GrayFontColor forState:UIControlStateHighlighted];
    [confirmBtn setTitleColor:GrayFontColor forState:UIControlStateHighlighted];
    
    [resetBtn setTitleColor:kSubjectColor forState:UIControlStateNormal];
    [confirmBtn setTitleColor:kSubjectColor forState:UIControlStateNormal];
    
    
    [resetBtn sizeToFit];
    [confirmBtn sizeToFit];
    
    
    [resetBtn addTarget:self action:@selector(resetClick:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [footer addSubview:resetBtn];
    [footer addSubview:confirmBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [footer addSubview:lineView];
    
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(footer);
        make.left.equalTo(footer);
        make.centerY.equalTo(footer);
        make.width.equalTo(resetBtn);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(resetBtn.mas_right).offset(20);
        make.right.equalTo(footer);
        make.centerY.equalTo(footer);
        make.width.equalTo(resetBtn);
        make.height.equalTo(footer);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer).offset(14);
        make.right.equalTo(footer).offset(0);
        make.top.equalTo(footer);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark setter getter
- (NSArray *)keyPaths{
    
    if (_keyPaths == nil) {
        _keyPaths = @[@"sampleName",
                      @"phoneNum",
                      @"productCode",
                      @"customerCode",
                      @"step",
                      @"result"];
    }
    return _keyPaths;
}

- (void)transValue:(NSObject *)object{
    for (NSString *key in self.keyPaths) {
        [self setValue:[object valueForKey:key] forKey:key];
    }
    [self.tableView reloadData];
}

#pragma mark Action
- (void)cancelClick:(UIButton *)sender{
    if (self.backBlock) {
        self.backBlock(NO, nil);
    }
}

- (void)resetClick:(UIButton *)sender{
    for (NSString *key in self.keyPaths) {
        [self setValue:nil forKey:key];
    }
    [self.tableView reloadData];
}

- (void)confirmClick:(UIButton *)sender{
    if (self.backBlock) {
        
        InputTFCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.sampleName = nameCell.textField.text;
        InputTFCell *phoneCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        self.phoneNum = phoneCell.textField.text;
        
        NSMutableArray *mutArray = [NSMutableArray array];
        for (NSString *key in self.keyPaths) {
            NSString *value = [self valueForKey:key];
            NSDictionary *dic = nil;
            if (value.length > 0) {
                dic = [NSDictionary dictionaryWithObjectsAndKeys:value, key, nil];
            }else{
                dic = [NSDictionary dictionaryWithObjectsAndKeys:@"", key, nil];
            }
            [mutArray addObject:dic];
        }
        self.backBlock(YES, mutArray);
    }
}

#pragma mark Actions
- (void)showCustomers:(NSIndexPath *)indexPath{
    
    CustomerListViewController *customerListVC = [[UIStoryboard storyboardWithName:@"PictureCapture" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomerListViewController"];
    
    customerListVC.chooseBlock = ^(CustomerModel *model){
        self.customerCode = model.customerCode;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    [self.navigationController pushViewController:customerListVC animated:YES];
}

- (void)showProducts:(NSIndexPath *)indexPath{
    
    ProductListViewController *productListVC = [[UIStoryboard storyboardWithName:@"PictureCapture" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductListViewController"];
    productListVC.allowMultiSelect = NO;
    productListVC.chooseBlock = ^(NSMutableArray *productArray){
        ProductModel *model = productArray.firstObject;
        self.productCode = model.productCode;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    [self.navigationController pushViewController:productListVC animated:YES];
}

- (void)showSteps:(NSIndexPath *)indexPath{
    SingleSelectVC *selectVC = [[UIStoryboard storyboardWithName:@"InfoQuery" bundle:nil] instantiateViewControllerWithIdentifier:@"SingleSelectVC"];
    selectVC.dataSource = self.stepsListUp;
    selectVC.selectBlock = ^(NSIndexPath *indexPath){
        if (indexPath.row == 0) {
            
            self.step = @"";
        }else{
            self.step = [NSString stringWithFormat:@"%zd", indexPath.row - 1];
            
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.navigationController pushViewController:selectVC animated:YES];

}

- (void)showResults:(NSIndexPath *)indexPath{
    SingleSelectVC *selectVC = [[UIStoryboard storyboardWithName:@"InfoQuery" bundle:nil] instantiateViewControllerWithIdentifier:@"SingleSelectVC"];
    selectVC.dataSource = self.resultsList;
    selectVC.selectBlock =^(NSIndexPath *indexPath){
        if (indexPath.row == 0) {
            self.result = @"";
        }else{
            
            self.result = self.resultsList[indexPath.row];
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.navigationController pushViewController:selectVC animated:YES];

}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [self showProducts:indexPath];
    }
    if (indexPath.row == 3) {
        [self showCustomers:indexPath];
    }
    if (indexPath.row == 4) {
        [self showSteps:indexPath];
    }
    if (indexPath.row == 5) {
        [self showResults:indexPath];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuList.count;
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    NSString *key = self.keyPaths[indexPath.row];
    NSString *value = [self valueForKey:key];
    
    NSString *title = self.menuList[indexPath.row];
    NSString *placeholder = self.placeholderList[indexPath.row];
    
    if (indexPath.row < 2) {
        
        InputTFCell *inputCell = (InputTFCell *)[tableView dequeueReusableCellWithIdentifier:CellIDTF forIndexPath:indexPath];
        inputCell.titleL.text = title;
        inputCell.textField.text = value;
        inputCell.textField.placeholder = placeholder;
        [inputCell.textField setValue:GrayFontColor forKeyPath:@"_placeholderLabel.textColor"];
        cell = inputCell;
        
    }else{
        NSString *detailText = nil;
        if (value.length > 0) {
            if (indexPath.row == 4) {
                detailText = self.stepsListUp[value.integerValue + 1];
            }else{
                
                detailText = value;
            }
        }else{
            detailText = placeholder;
        }
        cell = [tableView dequeueReusableCellWithIdentifier:CellIDDetail];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIDDetail];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.textColor = GrayFontColor;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = title;
        cell.detailTextLabel.text = detailText;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
