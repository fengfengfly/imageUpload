//
//  QuerySampleCell.m
//  InfoCapture
//
//  Created by feng on 21/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "QuerySampleCell.h"

@implementation QuerySampleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.statusBgV.layer.masksToBounds = YES;
    self.statusBgV.layer.cornerRadius = 2;
    self.resultBgv.layer.masksToBounds = YES;
    self.resultBgv.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.productNameL.textColor = RGBColor(0, 150, 150, 1);
    self.statusL.textColor = [UIColor whiteColor];
}

- (void)configCellWithModel:(SampleImportModel *)model{
    self.sampleNumL.text = model.sampleNum;
    self.sampleNameL.text = model.sampleName;
    self.phoneNumL.text = model.phoneNum.length > 0 ? model.phoneNum : model.connectPhone;
    self.productNameL.text = model.productName;
    self.customerCodeL.text = model.customerCode;
    
    if (model.result.length > 0) {
        self.resultL.hidden = NO;
        self.resultBgv.hidden = NO;
        self.resultL.text = model.result;
        UIColor *bgColor = [UIColor yellowColor];
        if ([model.result containsString:@"高"] || [model.result containsString:@"异"]) {
            bgColor = kSubjectColor_Red;
        }else if ([model.result containsString:@"正"]) {
            bgColor = kBgColor;
        }
        self.resultBgv.backgroundColor = bgColor;
    }else{
        self.resultBgv.hidden = YES;
        self.resultL.hidden = YES;
    }
}

@end
