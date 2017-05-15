//
//  MoreQueryVC.h
//  myBGI
//
//  Created by lx on 2017/5/11.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseViewController.h"

#define kLeftSpace 80

typedef void(^CallBackBlock)(BOOL doConfirm, NSArray *keyValues);

@interface MoreQueryVC : BaseViewController
@property (copy, nonatomic) CallBackBlock backBlock;

@property (copy, nonatomic) NSString *sampleName;
@property (copy, nonatomic) NSString *phoneNum;
@property (copy, nonatomic) NSString *productCode;
@property (copy, nonatomic) NSString *customerCode;
@property (copy, nonatomic) NSString *step;
@property (copy, nonatomic) NSString *result;

@property (strong, nonatomic) NSArray *stepsListUp;//搜索上传字段对照表
@property (strong, nonatomic) NSArray *resultsList;//结果列表

@property (strong, nonatomic) NSArray *keyPaths;
- (void)transValue:(NSObject *)object;
@end
