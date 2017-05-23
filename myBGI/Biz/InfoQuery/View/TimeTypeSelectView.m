//
//  TimeTypeSelectView.m
//  myBGI
//
//  Created by lx on 2017/5/14.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "TimeTypeSelectView.h"

@implementation TimeTypeSelectView
static NSString *CellID = @"CellID";
- (instancetype)initWithFrame:(CGRect)frame contentFrame:(CGRect)contentframe{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *contentView = [[UIView alloc] initWithFrame:contentframe];
        contentView.backgroundColor = RGBColor(105, 105, 105, 0);
        contentView.clipsToBounds = YES;
        [self addSubview:contentView];
        self.contentView = contentView;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.myHitTestBlock) {
        CGPoint contentPoint = [self.contentView convertPoint:point fromView:self];
        if (![self.contentView pointInside:contentPoint withEvent:event]) {
            
            CGPoint windoPoint = [self convertPoint:point toView:nil];
            UIView *myHitTestView = self.myHitTestBlock(windoPoint, event);
            if (myHitTestView != nil) {
                if (self.selectedBlock) {
                    self.selectedBlock(nil, NO);
                }
                [self removeFromSuperview];
                return myHitTestView;
            }
        }
        
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.selectedBlock) {
        
        self.selectedBlock(nil, NO);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = self.dropBeginFrame;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)showWithDataSource:(NSArray *)dataSource{
    self.dataSource = dataSource;
    CGFloat tableH = kTimeTypeCellH * 3;
    
    self.dropBeginFrame = CGRectMake(0, - tableH, self.contentView.frame.size.width, tableH);
    self.dropEndFrame = CGRectMake(0, 0, self.contentView.frame.size.width, tableH);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.dropBeginFrame];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.frame = self.dropEndFrame;
        self.contentView.backgroundColor = RGBColor(105, 105, 105, 0.4);
    }];
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = self.dropBeginFrame;
    } completion:^(BOOL finished) {
        if (self.superview) {
            
            [self removeFromSuperview];
        }
    }];
    if (self.selectedBlock) {
        self.selectedBlock(indexPath, YES);
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.tintColor = kSubjectColor;
        cell.textLabel.font = kMidFont;
    }
    if (indexPath.row == self.selectedIndex) {
         cell.textLabel.textColor = kSubjectColor;
        
    }else{
         cell.textLabel.textColor = kBlackFontColor;;
    }
    NSString *title = self.dataSource[indexPath.row];
    cell.textLabel.text = title;
    if (indexPath.row == self.dataSource.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kTimeTypeCellH;
}

- (void)dealloc{
#if DEBUG
    NSLog(@"%s", __func__);
#endif

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
