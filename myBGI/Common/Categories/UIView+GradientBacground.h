//
//  UIView+GradientBacground.h
//  InfoCapture
//
//  Created by lx on 2017/4/26.
//  Copyright © 2017年 feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GradientBacground)
- (void)setGradientBackgroundColors:(NSArray<UIColor *>*)colors locations:(NSArray *)locations point0:(CGPoint)point0 point1:(CGPoint)point1;

@end
