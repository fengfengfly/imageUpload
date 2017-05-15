//
//  UISearchBar+CustomColor.m
//  myBGI
//
//  Created by lx on 2017/5/12.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "UISearchBar+CustomColor.h"

@implementation UISearchBar (CustomColor)
- (void)setSearchTextFieldBackgroundColor:(UIColor *)backgroundColor
{
    UIView *searchTextField = nil;
    if (SYSTEM_VERSION_GREATER_THAN(@"7.0")) {
        // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
        self.barTintColor = [UIColor whiteColor];
        searchTextField = [[[self.subviews firstObject] subviews] lastObject];
    } else { // iOS6以下版本searchBar内部子视图的结构不一样
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                searchTextField = subView;
            }
        }
    }
    
    searchTextField.backgroundColor = backgroundColor;
}

@end
