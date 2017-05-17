//
//  InfoQueryViewController.m
//  InfoCapture
//
//  Created by feng on 14/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "InfoQueryViewController.h"
#import "QueryViewController.h"
#import "DeliverCountViewController.h"
#import "SampleCountViewController.h"
#import "Masonry.h"

@interface InfoQueryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuList;
@property (strong, nonatomic) NSArray *menuIconList;


@end

@implementation InfoQueryViewController
static NSString *InfoQueryCellID = @"InfoQueryCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查询统计";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    [self.tableView setSeparatorColor:[UIColor groupTableViewBackgroundColor]];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Seter Geter
- (NSArray *)menuList{
    if (_menuList == nil) {
        _menuList = @[@[@"进度查询"], @[@"交付统计", @"收样统计"]];
    }
    return _menuList;
}
- (NSArray *)menuIconList{
    if (_menuIconList == nil) {
        _menuIconList = @[@[@"query_menu"], @[@"deliverCount_menu", @"sampleCount_menu"]];
    }
    return _menuIconList;
}

- (void)goQuery{
    QueryViewController *queryVC = [[UIStoryboard storyboardWithName:@"InfoQuery" bundle:nil] instantiateViewControllerWithIdentifier:@"QueryViewController"];
    [self.navigationController pushViewController:queryVC animated:YES];
}

- (void)goDeliverCount{
    DeliverCountViewController *deliverCountVC = [[UIStoryboard storyboardWithName:@"InfoQuery" bundle:nil] instantiateViewControllerWithIdentifier:@"DeliverCountViewController"];
    [self.navigationController pushViewController:deliverCountVC animated:YES];
}

- (void)goSampleCount{
    SampleCountViewController *sampleCountVC = [[UIStoryboard storyboardWithName:@"InfoQuery" bundle:nil] instantiateViewControllerWithIdentifier:@"SampleCountViewController"];
    [self.navigationController pushViewController:sampleCountVC animated:YES];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self goQuery];
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                [self goDeliverCount];
                break;
            case 1:
                [self goSampleCount];
                break;
            
            default:
                break;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 15;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.menuList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *itemArray = self.menuList[section];
    return itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoQueryCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:InfoQueryCellID];
        [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(10);
            make.centerY.equalTo(cell);
        }];
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowRight"]];
        [imageV sizeToFit];
        [cell addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-10);
            make.centerY.equalTo(cell);
        }];
        cell.textLabel.textColor = kBlackFontColor;
    }
//    cell.accessoryType = UITableViewCellAccessoryNone;
    NSString  *imageStr = self.menuIconList[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageStr];
    cell.textLabel.text = self.menuList[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
