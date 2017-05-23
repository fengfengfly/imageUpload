//
//  PicCaptureSectionHeader.h
//  InfoCapture
//
//  Created by feng on 18/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicSectionModel.h"

typedef void(^expandChange)(NSInteger section, BOOL isExpand);
@interface PicCaptureSectionHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *numBgV;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *sectionTitleL;
@property (weak, nonatomic) IBOutlet UIButton *indicatorBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (assign, nonatomic) BOOL isExpand;
@property (weak, nonatomic) PicSectionModel *sectionModel;
@property (copy, nonatomic) expandChange statusBlock;
@property (assign, nonatomic) NSInteger section;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorBtnWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparate;
@property (weak, nonatomic) IBOutlet UIView *topSeparate;

- (void)configHeaderSectionModel:(PicSectionModel *)sectionModel isExpand:(BOOL)isExpand section:(NSInteger)section block:(expandChange)block;
@end
