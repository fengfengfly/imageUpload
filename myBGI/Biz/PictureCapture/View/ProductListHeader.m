//
//  ProductListHeader.m
//  InfoCapture
//
//  Created by lx on 2017/5/8.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "ProductListHeader.h"

@implementation ProductListHeader
static NSString *CellID = @"CellID";
- (void)awakeFromNib{
    [super awakeFromNib];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProductListHeaderCell" bundle:nil] forCellWithReuseIdentifier:CellID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductListHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    ProductModel *model = self.dataSource[indexPath.row];
    [cell configCellModel:model];
    return cell;
}


#pragma mark UICollectionViewDelegate


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.collectionView reloadData];
    if (self.actionBlock) {
        self.actionBlock(indexPath);
        
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kProductCellW, kProductCellH);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
