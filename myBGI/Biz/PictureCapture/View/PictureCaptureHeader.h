//
//  PictureCaptureHeader.h
//  InfoCapture
//
//  Created by lx on 2017/4/24.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseView.h"
#define kCaptureHeaderH 210

typedef void(^UserInterectBlock)();
@interface PictureCaptureHeader : BaseView
@property (weak, nonatomic) IBOutlet UITextField *customerTF;
@property (weak, nonatomic) IBOutlet UIView *customerV;
@property (weak, nonatomic) IBOutlet UITextField *productTF;
@property (weak, nonatomic) IBOutlet UIView *productV;
@property (weak, nonatomic) IBOutlet UITextField *inputStyleTF;
@property (weak, nonatomic) IBOutlet UIView *inputStyleV;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *albumBtn;
@property (copy, nonatomic) UserInterectBlock userInterectBlock;

@end
