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
#import "FFCollectionView.h"
#define kListHeaderH 70
#define kListHeaderTopSpace 22

@interface ProductListHeader : BaseView<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet FFCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (copy, nonatomic) void(^actionBlock)(NSIndexPath *indexPath);

@end
