//
//  PictureCaptureSelectionVC.m
//  InfoCapture
//
//  Created by lx on 2017/5/7.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "PictureCaptureSelectionVC.h"


#import "PicCaptureSectionHeader.h"
#import "PicCaptureCell.h"
#import "PicEditViewController.h"

#define kLineNum 4

@interface PictureCaptureSelectionVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (assign, nonatomic) NSInteger expandSection;
@property (strong, nonatomic) PicCaptureModel *addingModel;
@property (assign, nonatomic) NSInteger selectStyleIndex;
@end

@implementation PictureCaptureSelectionVC
static NSString *SectionHeaderID = @"SectionHeaderID";
static NSString *PicCellID = @"PicCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择编辑";
    [self configCollectionView];
    [self turnMultiEditMode];
    
    self.selectStyleIndex = 1;//双输
    //自定义navigationBar右边的按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"选择全部" forState:(UIControlStateNormal)];
    [rightBtn setTitle:@"全不选" forState:(UIControlStateSelected)];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rightBtn sizeToFit];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(selectAllClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightBarItem;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnClick{
    [super backBtnClick];
    if (self.finishBlock) {
        self.finishBlock();
    }
}

- (void)turnMultiEditMode{
    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView reloadData];
    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    [self showStatusBarWarningWithStatus:@"进入多选模式"];
}

- (void)selectAllClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [self selectItemsOfSection:self.expandSection];
    }else{
        [self deSelectItemsOfSection:self.expandSection];
    }
}
- (IBAction)editBtnClick:(UIButton *)sender {
    NSArray *indexPaths =self.collectionView.indexPathsForSelectedItems;
    if (indexPaths.count == 0) {
        [self showStatusBarWarningWithStatus:@"请选择编辑对象"];
        return;
    }
    [self editCell:indexPaths];
    
}
- (IBAction)deleteBtnClick:(UIButton *)sender {
    NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
    if (indexPaths.count == 0) {
        [self showStatusBarWarningWithStatus:@"请选择删除对象"];
        return;
    }
    [self deleteCell:indexPaths];
}

- (void)configCollectionView{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PicCaptureSectionHeader class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SectionHeaderID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PicCaptureCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:PicCellID];
}

- (void)selectItemsOfSection:(NSInteger)section{
    NSInteger num = [self.collectionView numberOfItemsInSection:section];
    for (int i = 0; i < num; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:(UICollectionViewScrollPositionNone)];
    }
}

- (void)deSelectItemsOfSection:(NSInteger)section{
    NSInteger num = [self.collectionView numberOfItemsInSection:section];
    for (int i = 0; i < num; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}

//删除多个
- (void)deleteCell: (NSArray<NSIndexPath *> *)senders{
    
    NSIndexPath *indexPath = senders.firstObject;
    NSInteger sectionFlag = indexPath.section;
    
    NSMutableArray *sectionModelArray = [NSMutableArray array];
    [sectionModelArray addObject:self.dataSource[sectionFlag]];
    NSMutableArray *indexSetArray = [NSMutableArray array];
    NSMutableIndexSet *muIndexSetFlag = [NSMutableIndexSet indexSet];
    [indexSetArray addObject:muIndexSetFlag];
    for (NSIndexPath *indexPath in senders) {//遍历需要删除的path
#if DEBUG
        NSLog(@"删除，section:%zd ,   row: %zd",indexPath.section,indexPath.row);
#endif
        if (indexPath.section == sectionFlag) {
            
            [muIndexSetFlag addIndex:indexPath.row];
        }else{
            sectionFlag = indexPath.section;
            muIndexSetFlag = [NSMutableIndexSet indexSet];
            [indexSetArray addObject:muIndexSetFlag];
            [sectionModelArray addObject:self.dataSource[sectionFlag]];
            [muIndexSetFlag addIndex:indexPath.row];
        }
    }
    
    //删除cell；
    NSMutableIndexSet *nullSectionIndexSet = [NSMutableIndexSet indexSet];
    int i = 0;
    for (PicSectionModel *sectionModel in sectionModelArray) {//遍历section删除item
        NSMutableIndexSet *muIndexSet = indexSetArray[i];
        NSMutableArray *secArray = sectionModel.itemArray;
        [secArray removeObjectsAtIndexes:muIndexSet];
        if (secArray.count == 0) {//记录空section的index
            [nullSectionIndexSet addIndex:[self.dataSource indexOfObject:sectionModel]];
            //从原数据源删除空section
            [self.origDataSource removeObject:sectionModel];
        }
    }
    
    //移除空section
    [self.dataSource removeObjectsAtIndexes:nullSectionIndexSet];
    [self.collectionView reloadData];
    
}

//编辑多个
- (void)editCell:(NSArray<NSIndexPath *> *)senders{
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSIndexPath *indexPath in senders) {//取出section中的item
        
        PicSectionModel *sectionModel = [self.dataSource objectAtIndex:indexPath.section];
        [muArray addObject:sectionModel.itemArray[indexPath.row]];
    }
    for (NSIndexPath *indepath in senders) {//从数据源中移除要编辑的item
        PicSectionModel *sectionModel = self.dataSource[indepath.section];
        [sectionModel.itemArray removeObjectAtIndex:indepath.row];
        if (sectionModel.itemArray.count == 0) {//移除整个section
            [self.dataSource removeObject:sectionModel];
            [self.origDataSource removeObject:sectionModel];
        }
    }
    
    PicSectionModel *sectionModel = [PicSectionModel new];
    sectionModel.itemArray = muArray;
    NSMutableArray *dataSource = [NSMutableArray arrayWithObjects:sectionModel, nil];
    PicEditViewController *editVC = [[UIStoryboard storyboardWithName:@"PictureCapture" bundle:nil] instantiateViewControllerWithIdentifier:@"PicEditViewController"];
    editVC.dataSource = dataSource;
    __weak typeof(self) weakSelf = self;
    editVC.resultBlock = ^(BOOL haveChange, NSMutableArray *dataArray){
        for (PicSectionModel *sectionModel in dataArray) {
            for (PicCaptureModel *model in sectionModel.itemArray) {
                weakSelf.addingModel = model;
                [weakSelf addModelToDataSource];
            }
        }
        if (self.finishBlock) {
            self.finishBlock();
        }
//        [weakSelf.collectionView reloadData];
    };
    [self.navigationController pushViewController:editVC animated:YES];
}

//添加到数据源
- (void)addModelToDataSource{
    BOOL hasKnownSection = NO;
    for (PicSectionModel *sectionModel in self.origDataSource) {
        PicCaptureModel *knownModel = sectionModel.itemArray.firstObject;
        if ([knownModel.customer.customerCode isEqualToString:self.addingModel.customer.customerCode]) {
            [sectionModel.itemArray addObject:self.addingModel];
            self.expandSection = [self.origDataSource indexOfObject:sectionModel];
            hasKnownSection = YES;
            break;
        }
    }
    if (hasKnownSection == NO) {
        
        PicSectionModel *sectionModel = [PicSectionModel new];
        [sectionModel.itemArray addObject:self.addingModel];
        [self.origDataSource addObject:sectionModel];
        self.expandSection = [self.origDataSource indexOfObject:sectionModel];
    }
    
    
}

#pragma mark UICollectionViewDataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    PicCaptureSectionHeader *cell= nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        cell = (PicCaptureSectionHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SectionHeaderID forIndexPath:indexPath];
        cell.userInteractionEnabled = NO;
        cell.indicatorBtn.hidden = YES;
        cell.uploadBtn.hidden = YES;
        cell.indicatorBtnWidthConstraint.constant = 0;
    }
    
    PicSectionModel *sectionModel = self.dataSource[self.expandSection];
    __weak typeof(self) weakSelf = self;
    [cell configHeaderSectionModel:sectionModel isExpand:(indexPath.section == self.expandSection) section:indexPath.section block:^void(NSInteger section, BOOL isExpand) {
        if (isExpand) {
            
            weakSelf.expandSection = section;
        }else{
            weakSelf.expandSection = -1;
        }
        [weakSelf.collectionView reloadData];
        
    }];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return  self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    PicSectionModel *sectionModel = self.dataSource[self.expandSection];
    if (section != self.expandSection) {
        return 0;
    }
    NSArray *itemArray = sectionModel.itemArray;
    return itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PicCaptureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PicCellID forIndexPath:indexPath];
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//    longPress.numberOfTouchesRequired = 1;
//    [cell addGestureRecognizer:longPress];
    
    PicSectionModel *sectionModel = self.dataSource[self.expandSection];
    PicCaptureModel *model = sectionModel.itemArray[indexPath.row];
    [cell configCellModel:model multiSelect:collectionView.allowsMultipleSelection];
    return cell;
}


#pragma mark UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    if (collectionView.allowsMultipleSelection == NO) {
    //
    //        PicCaptureCell *cell = (PicCaptureCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //        [self singleEditMenu:cell.imgV indexPath:indexPath];
    //    }
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否上传点击图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *finishAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        PicSectionModel *sectionModel = self.dataSource[indexPath.section];
//        PicCaptureModel *model = sectionModel.itemArray[indexPath.row];
//        
//    }];
//    [alertController addAction:finishAction];
//    [alertController addAction:continueAction];
//    [self presentViewController:alertController animated:YES completion:^{
//        
//    }];
    
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 60)/kLineNum, 100);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    //设置区头高度
    
    CGSize size = CGSizeMake(SCREEN_WIDTH, 40);
    
    return size;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
