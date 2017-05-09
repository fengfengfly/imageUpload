//
//  PictureCaptureHeader.m
//  InfoCapture
//
//  Created by lx on 2017/4/24.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "PictureCaptureHeader.h"

@implementation PictureCaptureHeader
- (void)awakeFromNib{
    [super awakeFromNib];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.userInteractionEnabled == NO && [self pointInside:point withEvent:event]) {
        if (self.userInterectBlock) {
            self.userInterectBlock();
        }
    }
    return [super hitTest:point withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
