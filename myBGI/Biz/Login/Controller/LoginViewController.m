//
//  LoginViewController.m
//  InfoCapture
//
//  Created by lx on 2017/4/26.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImage+GradientColor.h"
#import "UIImage+Corner.h"
#import "MBProgressHUD+HYExtension.h"
#import "Masonry.h"

#import "UserManager.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *loginIcon;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.loginIcon.layer.masksToBounds = YES;
    self.loginIcon.layer.cornerRadius = self.loginIcon.frame.size.width/2;
    
    self.pwdTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:RGBColor(153, 153, 153, 1)}];
    self.userNameTF.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"邮箱/登录名" attributes:@{NSForegroundColorAttributeName:RGBColor(153, 153, 153, 1)}];
    
}

//状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleDefault;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIImage *backImage = [UIImage gradientImageRect:self.loginBtn.bounds inputPoint0:CGPointMake(0, 0) inputPoint1:CGPointMake(1, 1) inputColor0:RGBColor(0, 120, 155, 0.8) inputColor1:RGBColor(2, 161, 155, 0.8)];
    
    CALayer *sublayer =[CALayer layer];
    sublayer.backgroundColor =[UIColor clearColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 20);
    sublayer.shadowRadius =25;
    sublayer.shadowColor =RGBColor(167, 183, 184, 1).CGColor;
    sublayer.shadowOpacity =0.9;
    sublayer.frame = self.loginBtn.bounds;
    sublayer.cornerRadius =25;
    [self.loginBtn.layer addSublayer:sublayer];
    
    CALayer *imageLayer =[CALayer layer];
    imageLayer.frame = sublayer.bounds;
    imageLayer.cornerRadius =self.loginBtn.bounds.size.height / 2;
    imageLayer.contents =(id)backImage.CGImage;
    imageLayer.masksToBounds =YES;
    [sublayer addSublayer:imageLayer];
    [self.loginBtn bringSubviewToFront:self.loginBtn.titleLabel];
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
        [MBProgressHUD hiddenWithMessage:@"登录成功"];
        
    } fail:^(id mError) {
        if ([mError isKindOfClass:[NSString class]]) {
            
            [MBProgressHUD hiddenWithMessage:(NSString *)mError];
        }else{
            
            [MBProgressHUD hiddenWithMessage:@"登录失败请重试"];
        }
        
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
