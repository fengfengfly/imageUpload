//
//  PicCaptureSectionHeader.m
//  InfoCapture
//
//  Created by feng on 18/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "PicCaptureSectionHeader.h"
#import "PicCaptureModel.h"
@implementation PicCaptureSectionHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.numL.textColor = [UIColor whiteColor];
    self.numBgV.layer.masksToBounds = YES;
    self.numBgV.layer.cornerRadius = 10;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.isExpand = !self.isExpand;
    if (self.statusBlock) {
        
        self.statusBlock(self.section, self.isExpand);
    }
    [self checkShrink];
}

- (void)checkShrink{
    if (self.isExpand) {
        self.numBgV.backgroundColor = kSubjectColor_Red;
        self.indicatorBtn.selected = YES;
    }else{
        self.numBgV.backgroundColor = [UIColor grayColor];
        self.indicatorBtn.selected = NO;
    }
}

- (void)configHeaderSectionModel:(PicSectionModel *)sectionModel isExpand:(BOOL)isExpand section:(NSInteger)section block:(expandChange)block{
    PicCaptureModel *model = sectionModel.itemArray.firstObject;
    self.sectionTitleL.text = [NSString stringWithFormat:@"%@",model.customer.customerName];
    self.numL.text =[NSString stringWithFormat:@"%zd", sectionModel.itemArray.count];
    self.sectionModel = sectionModel;
    self.isExpand = isExpand;
    self.statusBlock = block;
    self.section = section;
    [self checkShrink];
}

@end
