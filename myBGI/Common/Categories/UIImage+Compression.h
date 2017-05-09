//
//  UIImage+Compression.h
//  ColorfulineForChildren
//
//  Created by qch－djh on 16/8/16.
//  Copyright © 2016年 DuanJiaHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compression)

//等比例压缩
-(UIImage *)imageCompressForTargetSize:(CGSize)targetSize;

@end
