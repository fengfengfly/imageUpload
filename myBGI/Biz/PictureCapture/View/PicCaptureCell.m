//
//  PicCaptureCell.m
//  InfoCapture
//
//  Created by feng on 18/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "PicCaptureCell.h"

@implementation PicCaptureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.delBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.selectStatusBtn.selected = selected;
}

- (void)setCellState:(CellState)cellState{
    if (cellState == NormalState) {
        self.delBtn.hidden = YES;
    }else{
        self.delBtn.hidden = NO;
    }
    _cellState = cellState;
}

- (void)configCellModel:(PicCaptureModel *)model multiSelect:(BOOL)isMulti{
    if ([[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[model.picSmallStr lastPathComponent]] != nil) {
        self.imgV.image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[model.picSmallStr lastPathComponent]];
    }else{
        UIImage *image = [UIImage imageWithContentsOfFile:model.picSmallStr];
        [[SDImageCache sharedImageCache] storeImage:image forKey:[model.picSmallStr lastPathComponent] toDisk:NO completion:nil];
        self.imgV.image = image;
    }
    model.uploadDelegate = self;
    self.selectStatusBtn.hidden = !isMulti;
    [self checkUploadState:model.uploadState];
    self.productL.text = [model productCodeStr];
}

- (void)checkUploadState:(PicUploadState)uploadState{
    if (uploadState == PicStateWaitUpload || uploadState == PicStateUploading) {
        if (self.hudView.hidden == YES) {
            self.hudView.hidden = NO;
            [self.activityIndicator startAnimating];
        }
        
    }else{
        
        if (self.hudView.hidden == NO) {
            self.hudView.hidden = YES;
            [self.activityIndicator stopAnimating];
        }
    }
    
}

#pragma mark PicCaptureUploadDelegate
- (void)beginUploadPic{
    [self checkUploadState:PicStateUploading];
    
}

- (void)uploadProgress:(id)progress{
    
}

- (void)uploadSuccess:(id)response{
    [self checkUploadState:PicStateUploadSuccess];
    
}

- (void)uploadFail:(id)error{
    
}

@end
