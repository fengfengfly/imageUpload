//
//  DrawLineView.m
//  myBGI
//
//  Created by lx on 2017/5/17.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "DrawLineView.h"

@implementation DrawLineView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.shouldDraw == YES) {
        //1.获取跟View相关联的上下文(uigraphics开头)
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        NSInteger i = self.drawIndex;
        int pointNum = 0;
        switch (i) {
            case 0:
                pointNum = 6;
                break;
            case 1:
            case 2:
                pointNum = 6;
                break;
            default:
                break;
        }
        
        UIBezierPath *path = nil;
        for (int j = 0; j < pointNum ; j ++) {
#if DEBUG
            NSLog(@"x-%lf--y-%lf", self.drawInfo.array[1][4].x,self.drawInfo.array[1][4].y);
#endif
            //2.描述路径
            if (j == 0) {
                //一条路径可以绘制多条线
                path = [UIBezierPath bezierPath];
                //设置起点
                CGPoint point0 = self.drawInfo.array[i][0];
                
                [path moveToPoint:point0];
            }else{
                //添加一根线到某个点
                CGPoint pointj = self.drawInfo.array[i][j];
                [path addLineToPoint:pointj];
                
            }
            
            if (j == pointNum - 1) {
                
                //设置上下文的状态
                CGContextSetLineWidth(ctx, 0.5);
                //设置线的连接样式
                CGContextSetLineJoin(ctx, kCGLineJoinBevel);
                //设置线的顶角样式
                CGContextSetLineCap(ctx, kCGLineCapSquare);
                //设置颜色
                [kSubjectColor set];
                
                //3.把路径添加到上下文
                //UIBezierPath->UIKit -->  CGPathRef->CoreGraphics
                CGContextAddPath(ctx, path.CGPath);
                //4.把上下文当中绘制的内容渲染到跟View关联的layer.(stroke ,fill)
                CGContextStrokePath(ctx);
            }
            
        }
        
    }

}


@end
