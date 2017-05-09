//
//  EditMenuListView.h
//  InfoCapture
//
//  Created by lx on 2017/4/24.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseView.h"

typedef void (^selectIndex)(NSInteger index);
@interface EditMenuListView : BaseView
@property (copy, nonatomic) selectIndex selectBlock;
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles imgs:(NSArray *)imgs;
@end
