//
//  BaseView.m
//  demoFW
//
//  Created by Steven on 16/4/6.
//  Copyright © 2017年 denomics. All rights reserved.
//

#import "BaseView.h"


@implementation BaseView

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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
