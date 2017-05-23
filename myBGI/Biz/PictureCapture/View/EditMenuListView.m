//
//  EditMenuListView.m
//  InfoCapture
//
//  Created by lx on 2017/4/24.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "EditMenuListView.h"

@implementation EditMenuListView
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles imgs:(NSArray *)imgs{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self buttontitles:titles imgs:imgs];
        [self addLineView:titles.count];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)buttontitles:(NSArray *)titles imgs:(NSArray *)imgs{
    NSInteger num = titles.count;
    CGFloat width = self.frame.size.width/num;
    CGFloat height = self.frame.size.height;
    for (int i = 0; i < num; i ++) {
        CGRect frame = CGRectMake((i + 1) * width, 0, width, height);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = frame;
        button.backgroundColor = [UIColor clearColor];
        //设置button正常状态下的图片
        [button setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
        //设置button高亮状态下的图片
        [button setImage:[UIImage imageNamed:@"arrowRight"] forState:UIControlStateHighlighted];
        
        NSString *title = titles[i];
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
        button.imageEdgeInsets = UIEdgeInsetsMake(height/4, width/4, height/4, 3 * width/4);
        [button setTitle:title forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        button.titleEdgeInsets = UIEdgeInsetsMake(0, - width/4, 0, 0);
        //设置button正常状态下的标题颜色
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //设置button高亮状态下的标题颜色
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:button];
    }
    
}

- (IBAction)buttonClick:(UIButton *)sender{
    if (self.selectBlock) {
        self.selectBlock(sender.tag);
    }
}

- (void)addLineView:(NSInteger)num{
    CGFloat width = self.frame.size.width/num;
    for (int i = 0; i < num; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width * (i + 1), 0, 0.5, self.frame.size.height)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
