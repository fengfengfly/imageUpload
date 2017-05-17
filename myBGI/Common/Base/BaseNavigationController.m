//
//  BaseNavigationController.m
//  InfoCapture
//
//  Created by feng on 18/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)pushViewController:(BaseViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 非根控制器
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 非根控制器才需要设置返回按钮
        // 设置返回按钮
        [self initBackBarButtonItemVC:viewController];
        
    }
    // 跳转
    [super pushViewController:viewController animated:animated];
    
}

- (void)initBackBarButtonItemVC:(BaseViewController *)viewController
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"navigation_back"] forState:(UIControlStateNormal)];
    
    if ([viewController respondsToSelector:@selector(backBtnClick)]) {
        
        [backBtn addTarget:viewController action:@selector(backBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    [backBtn sizeToFit];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    UIBarButtonItem *backBbi = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    viewController.navigationItem.leftBarButtonItem = backBbi;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.childViewControllers[0];
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
