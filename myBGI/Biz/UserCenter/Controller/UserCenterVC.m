//
//  UserCenterVC.m
//  myBGI
//
//  Created by lx on 2017/5/10.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "UserCenterVC.h"

#import "UserManager.h"
#import "Masonry.h"
#import "HttpManager.h"
#import "Masonry.h"

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
        _menuList = @[@[@"当前版本"], @[@"退出当前账号"]];
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
            {
                UIAlertController *alertCtrler = [UIAlertController alertControllerWithTitle:@"确定退出当前用户?" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self hudSelfWithMessage:@"正在退出登录..."];
                    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:kUserManager.userModel.token,@"user.token", nil];
                    
                    [[HttpManager sharedManager] sendPostUrlRequestWithBodyURLString:kLogoutUrl parameters:param success:^(id mResponseObject) {
                        [self hideSelfHUD];
                        [kUserManager userLogout];
                    } failure:^(id mError) {
                        NSString *msg = [mError isKindOfClass:[NSString class]]? mError:@"网络错误";
                        [self showStatusBarWarningWithStatus:msg];
                        
                        [self hideSelfHUD];
                    }];
                    
                }];
                [alertCtrler addAction:cancelAction];
                [alertCtrler addAction:confirmAction];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self presentViewController:alertCtrler animated:YES completion:nil];
                });
            }
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UserCenterCellID];
        cell.textLabel.textColor = kBlackFontColor;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            cell.textLabel.text = self.menuList[indexPath.section][indexPath.row];
            
            NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"v%@", versionString];
            [cell.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell).offset(-12);
                make.centerY.equalTo(cell);
            }];
            [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell).offset(12);
                make.centerY.equalTo(cell);
            }];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:17];
            titleLabel.textColor = kSubjectColor;
            titleLabel.text = @"退出当前账号";
            [titleLabel sizeToFit];
            [cell addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell);
            }];
        }
    }
    
//    NSString  *imageStr = self.menuIconList[indexPath.section][indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:imageStr];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
