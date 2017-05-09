//
//  UIViewController+HUD.h
//  InfoCapture
//
//  Created by lx on 2017/4/26.
//  Copyright © 2017年 feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (HUD)
-(void)hudSelfTextMessage:(NSString *)message;
-(void)hudSelfWithMessage:(NSString *)message;
-(void)hideSelfHUD;

@end
