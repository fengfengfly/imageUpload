//
//  BaseViewController.m
//  demoFW
//
//  Created by Steven on 16/4/6.
//  Copyright © 2016年 colorfuline. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+GradientColor.h"

@interface BaseViewController () <UIGestureRecognizerDelegate, MBProgressHUDDelegate, UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    self.navigationItem.title = self.title;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIImage *backImage = [UIImage gradientImageRect:CGRectMake(0, 0, SCREEN_WIDTH, 64) inputPoint0:CGPointMake(0, 0) inputPoint1:CGPointMake(1, 1) inputColor0:RGBColor(0, 120, 155, 1) inputColor1:RGBColor(2, 161, 155, 1)];
    [self.navigationController.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
     [self setNeedsStatusBarAppearanceUpdate];
}

//状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
    
}


- (void)initBackBarButtonItem
{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"navigation_back"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *backBbi = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBbi;
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - JDStatusBarNotification

- (void)showStatusBarErrorWithStatus:(NSString *)status
{
    [JDStatusBarNotification showWithStatus:status
                               dismissAfter:2.0
                                  styleName:JDStatusBarStyleError];
}

- (void)showStatusBarWarningWithStatus:(NSString *)status
{
    [JDStatusBarNotification showWithStatus:status
                               dismissAfter:2.0
                                  styleName:JDStatusBarStyleWarning];
}

- (void)showStatusBarSuccessWithStatus:(NSString *)status
{
    [JDStatusBarNotification showWithStatus:status
                               dismissAfter:2.0
                                  styleName:JDStatusBarStyleSuccess];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL isRootViewController = (self == self.navigationController.viewControllers.firstObject);
    
    if (isRootViewController) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
