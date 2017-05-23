//
//  FFCollectionView.h
//  myBGI
//
//  Created by lx on 2017/5/18.
//  Copyright © 2017年 feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFCollectionView : UICollectionView
@property (copy, nonatomic) void(^reSizeBlock)();
@end
