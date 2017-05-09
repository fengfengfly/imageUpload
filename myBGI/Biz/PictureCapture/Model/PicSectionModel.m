//
//  PicSectionModel.m
//  InfoCapture
//
//  Created by lx on 2017/4/24.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "PicSectionModel.h"

@implementation PicSectionModel
- (NSMutableArray *)itemArray{
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

@end
