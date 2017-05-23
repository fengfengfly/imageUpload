//
//  DrawLineView.h
//  myBGI
//
//  Created by lx on 2017/5/17.
//  Copyright © 2017年 feng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef struct{
    CGPoint array[3][6];
    BOOL didInit;//是否初始化成功
}MyDrawInfo;

@interface DrawLineView : UIView
@property (assign, nonatomic) BOOL shouldDraw;
@property (assign, nonatomic) NSInteger drawIndex;
@property (assign, nonatomic) MyDrawInfo drawInfo;
@end
