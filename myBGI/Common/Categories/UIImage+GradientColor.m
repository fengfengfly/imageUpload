//
//  UIImage+GradientColor.m
//  InfoCapture
//
//  Created by lx on 2017/4/25.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "UIImage+GradientColor.h"

@implementation UIImage (GradientColor)
+ (UIImage *)gradientImageRect:(CGRect)rect inputPoint0:(CGPoint)point0 inputPoint1:(CGPoint)point1 inputColor0:(UIColor *)color0 inputColor1:(UIColor *)color1{
    CIFilter *ciFilter = [CIFilter filterWithName:@"CILinearGradient"];
    CIVector *vector0 = [CIVector vectorWithX:rect.size.width * point0.x Y:rect.size.height * (1 - point0.y)];
    CIVector *vector1 = [CIVector vectorWithX:rect.size.width * point1.x Y:rect.size.height * (1 - point1.y)];
    [ciFilter setValue:vector0 forKey:@"inputPoint0"];
    [ciFilter setValue:vector1 forKey:@"inputPoint1"];
    [ciFilter setValue:[CIColor colorWithCGColor:color0.CGColor] forKey:@"inputColor0"];
    [ciFilter setValue:[CIColor colorWithCGColor:color1.CGColor] forKey:@"inputColor1"];
    
    CIImage *ciImage = ciFilter.outputImage;
    CIContext *con = [CIContext contextWithOptions:nil];
    CGImageRef resultCGImage = [con createCGImage:ciImage
                                         fromRect:rect];
    UIImage *resultUIImage = [UIImage imageWithCGImage:resultCGImage];
    return resultUIImage;
}
@end
