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

#import "UserManager.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *loginIcon;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    self.loginIcon.layer.masksToBounds = YES;
    self.loginIcon.layer.cornerRadius = self.loginIcon.frame.size.width/2;
    
     UIImage *backImage = [UIImage gradientImageRect:self.loginBtn.bounds inputPoint0:CGPointMake(0, 0) inputPoint1:CGPointMake(1, 1) inputColor0:RGBColor(0, 120, 155, 1) inputColor1:RGBColor(2, 161, 155, 1)];
    
//    [self.loginBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    
    CALayer *sublayer =[CALayer layer];
    sublayer.backgroundColor =[UIColor whiteColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(3, 10);
    sublayer.shadowRadius =22;
    sublayer.shadowColor =[UIColor blackColor].CGColor;
    sublayer.shadowOpacity =0.8;
    sublayer.frame = self.loginBtn.bounds;
    sublayer.cornerRadius =22;
    [self.loginBtn.layer addSublayer:sublayer];
    
    CALayer *imageLayer =[CALayer layer];
    imageLayer.frame = sublayer.bounds;
    imageLayer.cornerRadius =self.loginBtn.bounds.size.height / 2;
    imageLayer.contents =(id)backImage.CGImage;
    imageLayer.masksToBounds =YES;
    [sublayer addSublayer:imageLayer];
    
//    self.loginBtn.imageView.backgroundColor = [UIColor clearColor];
//    self.loginBtn.layer.shadowOffset =  CGSizeMake(1, 10);
//    self.loginBtn.layer.shadowOpacity = 0.8;
//    self.loginBtn.layer.shadowColor =  [UIColor blackColor].CGColor;
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
