//
//  MoreQueryView.h
//  InfoCapture
//
//  Created by lx on 2017/4/25.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseView.h"

@interface MoreQueryView : BaseView
@property (weak, nonatomic) IBOutlet UIView *containerV;
@property (weak, nonatomic) IBOutlet UITextField *productTF;
@property (weak, nonatomic) IBOutlet UITextField *customerTF;
@property (weak, nonatomic) IBOutlet UITextField *statusTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *resultTF;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic) UIView *customerAction;
@property (strong, nonatomic) UIView *productAction;
@property (strong, nonatomic) UIButton *statusAction;
@property (strong, nonatomic) UIButton *resultAction;
@end
