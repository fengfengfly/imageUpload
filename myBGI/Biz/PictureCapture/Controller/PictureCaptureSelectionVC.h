//
//  PictureCaptureSelectionVC.h
//  InfoCapture
//
//  Created by lx on 2017/5/7.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseViewController.h"
#import "PicSectionModel.h"
#import "PicCaptureModel.h"

@interface PictureCaptureSelectionVC : BaseViewController
@property (strong, nonatomic) NSMutableArray<PicSectionModel *> *dataSource;
@property (strong, nonatomic) NSMutableArray<PicSectionModel *> *origDataSource;
@property (copy, nonatomic) void(^finishBlock)();
@end
