//
//  BaseViewController.h
//  demoFW
//
//  Created by Steven on 16/4/6.
//  Copyright © 2016年 feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+HUD.h"
#import "JDStatusBarNotification.h"

@interface BaseViewController : UIViewController

- (void)initBackBarButtonItem;
- (void)willPop;
- (void)backBtnClick;

- (void)showStatusBarErrorWithStatus:(NSString *)status;
- (void)showStatusBarWarningWithStatus:(NSString *)status;
- (void)showStatusBarSuccessWithStatus:(NSString *)status;

@end
