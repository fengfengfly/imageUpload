//
//  UIImage+GradientColor.h
//  InfoCapture
//
//  Created by lx on 2017/4/25.
//  Copyright © 2017年 feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GradientColor)
+ (UIImage *)gradientImageRect:(CGRect)rect inputPoint0:(CGPoint)point0 inputPoint1:(CGPoint)point1 inputColor0:(UIColor *)color0 inputColor1:(UIColor *)color1;
@end
