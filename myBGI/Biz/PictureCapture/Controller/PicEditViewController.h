//
//  PicEditViewController.h
//  InfoCapture
//
//  Created by lx on 2017/4/24.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseViewController.h"

#import "PicSectionModel.h"
#import "PicCaptureModel.h"
typedef void(^ResultChange)(BOOL haveChange, NSMutableArray *dataArray);
@interface PicEditViewController : BaseViewController
@property (strong, nonatomic) NSMutableArray<PicSectionModel *> *dataSource;
@property (copy, nonatomic) ResultChange resultBlock;
@end
