//
//  UIImage+Corner.h
//  
//
//  Created by lx on 2017/5/11.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Corner)
- (UIImage *)roundedImageWithRadius:(CGFloat)radius;
//图片剪切
- (void)cornerImageWithSize:(CGSize)size radius:(CGFloat)radius fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *image))completion;
@end
