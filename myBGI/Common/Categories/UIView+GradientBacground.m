//
//  UIView+GradientBacground.m
//  InfoCapture
//
//  Created by lx on 2017/4/26.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "UIView+GradientBacground.h"

@implementation UIView (GradientBacground)
//locations为NSNumber 如gradientLayer.locations = @[@0.3, @0.5, @1.0];

- (void)setGradientBackgroundColors:(NSArray<UIColor *>*)colors locations:(NSArray *)locations point0:(CGPoint)point0 point1:(CGPoint)point1{
    
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColors addObject:(__bridge id)color.CGColor];
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = cgColors;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = point0;
    gradientLayer.endPoint = point1;
    gradientLayer.frame = self.bounds;
    [self.layer addSublayer:gradientLayer];
}
@end
