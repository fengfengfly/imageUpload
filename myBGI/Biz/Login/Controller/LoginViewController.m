//
//  LoginViewController.m
//  InfoCapture
//
//  Created by lx on 2017/4/26.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImage+GradientColor.h"
#import "MBProgressHUD+HYExtension.h"
#import "UserManager.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
     UIImage *backImage = [UIImage gradientImageRect:self.loginBtn.bounds inputPoint0:CGPointMake(0, 0) inputPoint1:CGPointMake(1, 1) inputColor0:RGBColor(0, 120, 155, 1) inputColor1:RGBColor(2, 161, 155, 1)];
    [self.loginBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = self.loginBtn.bounds.size.height / 2;
}

//状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleDefault;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (IBAction)loginBtnClick:(UIButton *)sender {
    NSString *userName = self.userNameTF.text;
    NSString *password = self.pwdTF.text;
    [self.userNameTF resignFirstResponder];
    [self.pwdTF resignFirstResponder];
    if (userName.length == 0) {
        [self showStatusBarWarningWithStatus:@"请输入用户名"];
        return;
    }
    if (password.length == 0) {
        [self showStatusBarWarningWithStatus:@"请输入密码"];
        return;
    }
    
    [MBProgressHUD showAnimationHUDWithImages:nil title:@"正在登录..."];
    [kUserManager loginUser:userName password:password success:^{
        
        
    } fail:^(id mError) {
        if ([mError isKindOfClass:[NSString class]]) {
            
            [MBProgressHUD hiddenWithMessage:(NSString *)mError];
        }
        [MBProgressHUD hiddenWithMessage:@"登录失败请重试"];
        
    }];
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
