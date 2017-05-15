//
//  ProductListHeader.h
//  InfoCapture
//
//  Created by lx on 2017/5/8.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BaseView.h"
#import "ProductModel.h"
#import "ProductListHeaderCell.h"

#define kListHeaderH 70

@interface ProductListHeader : BaseView<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (copy, nonatomic) void(^actionBlock)(NSIndexPath *indexPath);
@end
