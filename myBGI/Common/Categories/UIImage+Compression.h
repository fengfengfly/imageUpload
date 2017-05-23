//
//  UIImage+Compression.h
//  ColorfulineForChildren
//
//  Created by qch－djh on 16/8/16.
//  Copyright © 2016年 DuanJiaHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compression)

//不等比压缩
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;

//保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailNoScaleWithImage:(UIImage *)image size:(CGSize)asize;

//等比例压缩裁剪
-(UIImage *)imageCompressForTargetSize:(CGSize)targetSize;

@end
