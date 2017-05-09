//
//  PicCaptureCell.h
//  InfoCapture
//
//  Created by feng on 18/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicCaptureModel.h"
#import "UIImageView+WebCache.h"

typedef NS_ENUM(NSInteger,CellState){
    
    
    NormalState,
    
    DeleteState
    
};

@interface PicCaptureCell : UICollectionViewCell<PicCaptureUploadDelegate>
@property (assign, nonatomic) CellState cellState;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *productL;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIView *hudView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *selectStatusBtn;


- (void)configCellModel:(PicCaptureModel *)model multiSelect:(BOOL)isMulti;
@end
