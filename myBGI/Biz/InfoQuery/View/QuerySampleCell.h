//
//  QuerySampleCell.h
//  InfoCapture
//
//  Created by feng on 21/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleImportModel.h"

@interface QuerySampleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sampleNumL;
@property (weak, nonatomic) IBOutlet UILabel *sampleNameL;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumL;
@property (weak, nonatomic) IBOutlet UILabel *productNameL;
@property (weak, nonatomic) IBOutlet UILabel *customerCodeL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *resultL;

- (void)configCellWithModel:(SampleImportModel *)model;

@end
