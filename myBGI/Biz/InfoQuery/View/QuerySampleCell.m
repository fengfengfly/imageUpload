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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.productNameL.textColor = RGBColor(0, 150, 150, 150);
    self.statusL.backgroundColor = RGBColor(0, 150, 150, 150);
    self.statusL.textColor = [UIColor whiteColor];
}

- (void)configCellWithModel:(SampleImportModel *)model{
    self.sampleNumL.text = model.sampleNum;
    self.sampleNameL.text = model.sampleName;
    self.phoneNumL.text = model.phoneNum;
    self.productNameL.text = model.productName;
    self.customerCodeL.text = model.customerCode;
    
    if (model.result.length > 0) {
        self.resultL.hidden = NO;
        self.resultL.text = model.result;
        UIColor *bgColor = [UIColor yellowColor];
        if ([model.result containsString:@"高"]) {
            bgColor = [UIColor redColor];
        }
        self.resultL.backgroundColor = bgColor;
    }else{
        self.resultL.hidden = YES;
    }
}

@end
