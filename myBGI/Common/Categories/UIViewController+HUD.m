//
//  UIViewController+HUD.m
//  InfoCapture
//
//  Created by lx on 2017/4/26.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "UIViewController+HUD.h"

@implementation UIViewController (HUD)

-(void)hudSelfTextMessage:(NSString *)message
{
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
//    HUD.contentColor=[UIColor whiteColor];
//    HUD.bezelView.color=[UIColor blackColor];
    HUD.mode=MBProgressHUDModeText;
    HUD.labelText=message;
    HUD.removeFromSuperViewOnHide=YES;
    [[self getView] addSubview:HUD];
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}

-(void)hudSelfWithMessage:(NSString *)message
{
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:[self getView]];
    HUD.backgroundColor = [UIColor colorWithWhite:0.f alpha:.2f];
//    HUD.bezelView.color = [UIColor blackColor];
//    HUD.contentColor=[UIColor whiteColor];
    HUD.labelText=message;
    HUD.removeFromSuperViewOnHide=YES;
    [[self getView] addSubview:HUD];
    [HUD show:YES];
}

-(void)hideSelfHUD
{
    [MBProgressHUD hideHUDForView:[self getView] animated:YES];
}
-(UIView *)getView
{
    UIView *view;
    if (self.navigationController.view) {
        view=self.navigationController.view;
    }else
    {
        view=self.view;
    }
    return view;
}
@end
