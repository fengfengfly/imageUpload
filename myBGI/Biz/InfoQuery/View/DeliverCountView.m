//
//  DeliverCountView.m
//  InfoCapture
//
//  Created by lx on 2017/5/5.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "DeliverCountView.h"
#import "HttpManager.h"
#import <MJExtension/MJExtension.h>
#import "MJRefresh.h"

#import "MBProgressHUD+HYExtension.h"
#import "NSString+NilString.h"
#import "NSMutableDictionary+Safe.h"

#import "UIView+SelfController.h"
#import "CalendarView.h"

#import "QueryCountCell.h"

@implementation DeliverCountView


static NSString *DeliverCountCellID = @"DeliverCountCellID";
-(void)awakeFromNib{
    [super awakeFromNib];
    self.dataPage = 1;
    self.tableView.backgroundColor = kBgColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"QueryCountCell" bundle:nil] forCellReuseIdentifier:DeliverCountCellID];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.dataPage = 1;
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf reloadDataSource];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf reloadDataSource];
    }];
    self.beginTimeTF.text = [self makeTodayStr];
    self.endTimeTF.text = [self makeTodayStr];
}

- (UIView *)myhitTest:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL resultFlag = NO;
    CGPoint myPoint = [self convertPoint:point fromView:[UIApplication sharedApplication].keyWindow];
    
    switch (self.drawLineV.drawIndex) {
        case 0:
           
            break;
        case 1:
            if ([self.endTimeTF pointInside:[self.endTimeTF convertPoint:myPoint fromView:self] withEvent:event]) {
                resultFlag = YES;
            }
            
            break;
        case 2:
            if ([self.beginTimeTF pointInside:[self.beginTimeTF convertPoint:myPoint fromView:self] withEvent:event]) {
                resultFlag = YES;
            }
           
            break;
        default:
            break;
    }
    if (resultFlag == YES) {
        
        return [self hitTest:myPoint withEvent:event];
    }
    return nil;
    
}


- (void)initDrawInfo{
    //初始化轨迹点数组
    CGFloat x0 = 0;
    CGFloat x1 = self.beginTimeTF.frame.origin.x - 1;
    CGFloat x2 = CGRectGetMaxX(self.beginTimeTF.frame) + 1;
    CGFloat x3 = self.endTimeTF.frame.origin.x - 1;
    CGFloat x4 = CGRectGetMaxX(self.endTimeTF.frame) + 1;
    CGFloat x5 = SCREEN_WIDTH;
    
    CGFloat y0 = self.beginTimeTF.frame.origin.y - 1;
    CGFloat y1 = CGRectGetHeight(self.drawLineV.bounds) - 1;
    
    CGPoint tempPointArray[3][6] = {{CGPointZero, CGPointZero, CGPointZero, CGPointZero,CGPointZero,CGPointZero},
        {CGPointMake(x0, y1),CGPointMake(x1, y1),CGPointMake(x1, y0),CGPointMake(x2, y0),CGPointMake(x2, y1),CGPointMake(x5, y1)},
        {CGPointMake(x0, y1),CGPointMake(x3, y1),CGPointMake(x3, y0),CGPointMake(x4, y0), CGPointMake(x4, y1), CGPointMake(x5, y1)}};
    MyDrawInfo DrawInfo;
    for (int i = 0; i < 3; i ++) {
        for (int j = 0; j < 6; j ++) {
            DrawInfo.array[i][j] = tempPointArray[i][j];
        }
    }
    DrawInfo.didInit = YES;
    self.drawLineV.drawInfo = DrawInfo;
}

- (void)redrawIndex:(NSInteger)index shouldDraw:(BOOL)shouldDraw{
    self.drawLineV.shouldDraw = shouldDraw;
    self.drawLineV.drawIndex = index;
    [self.drawLineV setNeedsDisplay];
    UIColor *bgColor = nil;
    if (shouldDraw == YES) {
        bgColor = [UIColor whiteColor];
    }else{
        bgColor = kBgColor;
    }
    switch (index) {
        case 0:
            
            break;
        case 1:
            self.beginTimeTF.backgroundColor = bgColor;
            break;
        case 2:
            self.endTimeTF.backgroundColor = bgColor;
            break;
        default:
            break;
    }
    
}


- (NSString *)makeTodayStr{
    NSString *dateStr = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *today = [NSDate date];
    dateStr = [dateFormatter stringFromDate:today];
    return dateStr;
}
- (void)showCalendarDateStr:(NSString *)date willSelected:(BOOL (^)(NSString *willDaetStr))willBlock finishBlock:(void(^)(NSString *dateStr, BOOL isConfirm))finishBlock{
    UIViewController *controller = [self getCurrentViewController];
    CalendarView *calendarV = [[CalendarView alloc] initWithFrame:controller.view.bounds contentFrame:[self convertRect:self.tableView.frame toView:controller.view]];
    calendarV.willSelectBlock = willBlock;
    calendarV.selectedBlock = finishBlock;
    calendarV.myHitTestBlock = ^UIView *(CGPoint point, UIEvent *event){
        return [self myhitTest:point withEvent:event];
    };
    [calendarV.calendar selectDate:[calendarV.dateFormatter dateFromString:date] scrollToDate:YES];
    [controller.view addSubview:calendarV];
    [calendarV showContent];
    
    
}

- (IBAction)beginTimeClick:(UIButton *)sender {
    [self redrawIndex:1 shouldDraw:YES];
    [self showCalendarDateStr:self.beginTimeTF.text willSelected:^BOOL(NSString *willDateStr) {
        
        return YES;
    } finishBlock:^(NSString *dateStr, BOOL isConfirm) {
        if (isConfirm) {
            
            self.beginTimeTF.text = dateStr;
        }
        [self redrawIndex:1 shouldDraw:NO];
        
    }];
}

- (IBAction)endTimeClick:(UIButton *)sender {
    [self redrawIndex:2 shouldDraw:YES];
    [self showCalendarDateStr:self.endTimeTF.text willSelected:^BOOL(NSString *willDateStr){
        
        return YES;
    } finishBlock:^(NSString *dateStr, BOOL isConfirm) {
        if (isConfirm == YES) {
            
            self.endTimeTF.text = dateStr;
        }
        [self redrawIndex:2 shouldDraw:NO];
    }];
}

- (IBAction)searchBtnClick:(UIButton *)sender {
    self.dataPage = 1;
    [self reloadDataSource];
}

#pragma mark setter--getter
- (NSMutableArray *)dataSource{
    if (nil == _dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)reloadDataSource{
    NSComparisonResult result = [self.beginTimeTF.text compare:self.self.endTimeTF.text];
    if (result == NSOrderedDescending) {
        [self showStatusBarWarningWithStatus:@"开始时间不能晚于结束时间"];
        return;
    }
    [MBProgressHUD showAnimotionHUDOnView:self];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  kUserManager.userModel.token, @"token",
                                  [NSString stringWithFormat:@"%zd",self.dataPage], @"page",
                                  @"20", @"rows",
                                  nil];
    [param filterNilSetObject:[NSString ifNilStringWithNil:self.beginTimeTF.text]  forKey:@"commonDto.reportTimeStart"];
    [param filterNilSetObject:[NSString ifNilStringWithNil:self.endTimeTF.text]  forKey:@"commonDto.reportTimeEnd"];
    
    NSString *urlStr = (self.countType == DeliverCountTypeProduct)? kQueryDelieverProduct : kQueryDelieverCustom;
    
    [[HttpManager sharedManager] sendPostUrlRequestWithBodyURLString:urlStr parameters:param success:^(id mResponseObject) {
        NSArray *rows = mResponseObject[@"rows"];
        
        NSArray *newDatas = [DeliverCountModel mj_objectArrayWithKeyValuesArray:rows];
        if (self.dataPage == 1) {
            [self.dataSource removeAllObjects];
        }
        if (newDatas.count > 0) {
            [self.dataSource addObjectsFromArray:newDatas];
            
            self.dataPage ++;
        }else{
            [self showStatusBarWarningWithStatus:@"没有更多数据"];
        }
        [self.tableView reloadData];
        [MBProgressHUD hiddenForView:self];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    } failure:^(id mError) {
        if ([mError isKindOfClass:[NSString class]]) {
            [self showStatusBarWarningWithStatus:mError];
        }else{
            [self showStatusBarWarningWithStatus:@"网络错误"];
        }
        [MBProgressHUD hiddenForView:self];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QueryCountCell *cell = [tableView dequeueReusableCellWithIdentifier:DeliverCountCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DeliverCountModel *model = self.dataSource[indexPath.row];
    if (self.countType == DeliverCountTypeProduct) {
        cell.codeLabel.text = model.productCode;
        cell.titleLabel.text = model.productName;
        cell.badgeLabel.text = model.countNumber;
    }else{
        cell.codeLabel.text = model.customerCode;
        cell.titleLabel.text = model.customerName;
        cell.badgeLabel.text = model.countNumber;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && self.dataSource.count != 0) {
        return 15;
    }
    return 0;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
