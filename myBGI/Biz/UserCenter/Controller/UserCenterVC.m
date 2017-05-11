//
//  UserCenterVC.m
//  myBGI
//
//  Created by lx on 2017/5/10.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "UserCenterVC.h"



@interface UserCenterVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuList;
@property (strong, nonatomic) NSArray *menuIconList;

@end

@implementation UserCenterVC

static NSString *UserCenterCellID = @"UserCenterCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
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
        _menuList = @[@[@"当前版本"], @[@"设置"]];
    }
    return _menuList;
}
- (NSArray *)menuIconList{
    if (_menuIconList == nil) {
        _menuIconList = @[@[@"query_menu"], @[@"deliverCount_menu"]];
    }
    return _menuIconList;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                
                break;
            case 1:
                
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCenterCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UserCenterCellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
