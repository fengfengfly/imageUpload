//
//  PicEditViewController.m
//  InfoCapture
//
//  Created by lx on 2017/4/24.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "PicEditViewController.h"

#import "IQKeyboardManager.h"

#import "CustomerListViewController.h"
#import "ProductListViewController.h"

#import "PicSectionModel.h"
#import "PicCaptureModel.h"
#import "PicCaptureSectionHeader.h"
#import "PicCaptureCell.h"
#import "PictureCaptureHeader.h"

#import "CustomPopOverView.h"
#import "EditMenuListView.h"
#define kNumOfLine 4

@interface PicEditViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) PictureCaptureHeader *captureHeader;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) PicCaptureModel *currentModel;
@property (strong, nonatomic) PicSectionModel *currentSection;

@property (strong, nonatomic) NSArray *inputStyles;
@property (assign, nonatomic) NSInteger selectStyleIndex;

@end

@implementation PicEditViewController

static NSString *SectionHeaderID = @"SectionHeaderID";
static NSString *PicCellID = @"PicCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑数据";
    self.selectStyleIndex = 1;
    self.currentSection = self.dataSource.firstObject;
    self.currentModel = self.currentSection.itemArray.firstObject;
    
    self.captureHeader.customerTF.delegate = self;
    self.captureHeader.productTF.delegate = self;
    self.captureHeader.inputStyleTF.delegate = self;
    
    [self configCollectionView];
    
    //captureHeader Action
    //    self.captureHeader.customerTF.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    //    self.captureHeader.productTF.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.captureHeader.customerTF addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    UITapGestureRecognizer *tapCustomer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCustomers)];
    UITapGestureRecognizer *tapProduct = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProducts)];
    
    [self.captureHeader.customerV addGestureRecognizer:tapCustomer];
    [self.captureHeader.productV addGestureRecognizer:tapProduct];
    self.captureHeader.cameraBtn.hidden = YES;
    self.captureHeader.albumBtn.hidden = YES;
    // 初始化pickerView
    // set the frame to zero
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    // set change the inputView (default is keyboard) to UIPickerView
    self.captureHeader.inputStyleTF.inputView = pickerView;
    
    // add a toolbar with Cancel & Done button
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneInputStyle:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelInputStyle:)];
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:@"请选择输入方式" style:UIBarButtonItemStylePlain target:nil action:nil];
    titleButton.tintColor = [UIColor blackColor];
    // the middle button is to make the Done button align to right
    [toolBar setItems:@[cancelButton,flexibleButton,titleButton,flexibleButton,doneButton]];
    self.captureHeader.inputStyleTF.inputAccessoryView = toolBar;
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([object isKindOfClass:[UITextField class]]) {
        if ([keyPath isEqualToString:@"text"]) {
            NSString *newText = [change valueForKey:NSKeyValueChangeNewKey];
            if (newText.length > 0) {
                
            }else{
                
            }
            
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [IQKeyboardManager sharedManager].enable = YES;
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.captureHeader.frame = CGRectMake(0, -kCaptureHeaderH + 60, SCREEN_WIDTH, kCaptureHeaderH - 60);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.captureHeader.customerTF removeObserver:self forKeyPath:@"text" context:nil];
}

- (void)backBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
    if (self.resultBlock) {
        self.resultBlock(YES, self.dataSource);
    }
    
}

#pragma mark get-setProperty

- (void)setCurrentModel:(PicCaptureModel *)currentModel{
    self.captureHeader.customerTF.text = currentModel.customer.customerName;
    self.captureHeader.productTF.text = currentModel.productCodeStr;
    if (currentModel.readNum > 0) {
        
        self.captureHeader.inputStyleTF.text = self.inputStyles[currentModel.readNum - 1];
    }
    _currentModel = currentModel;
}

- (NSArray *)inputStyles{
    if (_inputStyles == nil) {
        _inputStyles = @[@"单输",@"双输"];
    }
    return _inputStyles;
}
-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (PictureCaptureHeader *)captureHeader{
    if (_captureHeader == nil) {
        PictureCaptureHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"PictureCaptureHeader" owner:nil options:nil] firstObject];
        header.frame = CGRectMake(0, - kCaptureHeaderH + 60, SCREEN_WIDTH, kCaptureHeaderH - 60);
        _captureHeader = header;
    }
    return _captureHeader;
}

- (void)configCollectionView{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PicCaptureSectionHeader class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SectionHeaderID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PicCaptureCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:PicCellID];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(kCaptureHeaderH - 60, 0, 0 ,0);
    [self.collectionView addSubview:self.captureHeader];
}


#pragma mark - textField detegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    return NO;
//}
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//
//}

- (void)showCustomers{
    
    CustomerListViewController *customerListVC = [[UIStoryboard storyboardWithName:@"PictureCapture" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomerListViewController"];
    
    customerListVC.chooseBlock = ^(CustomerModel *model){
        
        if (![model.customerCode isEqualToString:self.captureHeader.customerTF.text]) {
            self.captureHeader.customerTF.text = model.customerName;
//            self.currentModel.customer = model;
//            [self changeSection];
            [self changeAllSection:model];
            
        }
    };
    
    [self.navigationController pushViewController:customerListVC animated:YES];
}

- (void)showProducts{
    if (self.captureHeader.customerTF.text.length == 0) {
        [self showStatusBarWarningWithStatus:@"请先选择医院"];
        return;
    }
    
    ProductListViewController *productListVC = [[UIStoryboard storyboardWithName:@"PictureCapture" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductListViewController"];
    productListVC.allowMultiSelect = YES;
    if (self.currentModel.productArray.count > 0) {
        
        productListVC.selectedArray = self.currentModel.productArray;
    }
    productListVC.chooseBlock = ^(NSMutableArray *productArray, BOOL isConfirm){
        self.currentModel.productArray = productArray;
        
        if (isConfirm == YES) {
            self.captureHeader.productTF.text = [self.currentModel productCodeStr];
            [self changeAllProduct:productArray];
        }
    };
    
    [self.navigationController pushViewController:productListVC animated:YES];
}
- (void)doneInputStyle:(id)sender{
    self.captureHeader.inputStyleTF.text = self.inputStyles[self.selectStyleIndex];
    self.currentModel.readNum = self.selectStyleIndex + 1;
    [self.captureHeader.inputStyleTF resignFirstResponder];
}
- (void)cancelInputStyle:(id)sender{
    [self.captureHeader.inputStyleTF resignFirstResponder];
}

#pragma mark UICollectionViewDataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    PicCaptureSectionHeader *cell = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        cell = (PicCaptureSectionHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SectionHeaderID forIndexPath:indexPath];
        cell.userInteractionEnabled = NO;
        cell.indicatorBtn.hidden = YES;
        cell.uploadBtn.hidden = YES;
        cell.indicatorBtnWidthConstraint.constant = 0;
    }
    PicSectionModel *sectionModel = self.dataSource[indexPath.section];
    
    [cell configHeaderSectionModel:sectionModel isExpand:YES section:indexPath.section block:^void(NSInteger section, BOOL isExpand) {
        
        
    }];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return  self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    PicSectionModel *sectionModel = self.dataSource[section];
    
    NSArray *itemArray = sectionModel.itemArray;
    return itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PicCaptureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PicCellID forIndexPath:indexPath];
    PicSectionModel *sectionModel = self.dataSource[indexPath.section];
    PicCaptureModel *model = sectionModel.itemArray[indexPath.row];
    [cell configCellModel:model multiSelect:NO];
    return cell;
}


#pragma mark UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PicSectionModel *sectionModel = self.dataSource[indexPath.section];
    NSMutableArray *itemArray = sectionModel.itemArray;
    PicCaptureModel *model = itemArray[indexPath.row];
    self.currentModel = model;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 60)/kNumOfLine, 100);
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


#pragma mark UIPickerView DataSource Method

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = self.inputStyles.count;//根据数组的元素个数返回几行数据
            break;
        default:
            break;
    }
    
    return result;
}

#pragma mark UIPickerView Delegate Method

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = nil;
    switch (component) {
        case 0:
            title = self.inputStyles[row];
            break;
        default:
            break;
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectStyleIndex = row;
}


#pragma mark Model EditAction
- (void)changeAllProduct:(NSMutableArray *)productArray{//编辑应用于所有,需求方案一
    for (PicSectionModel *sectionModel in self.dataSource) {
        for (PicCaptureModel *model in sectionModel.itemArray) {
            model.productArray = [productArray mutableCopy];
        }
    }
    
    [self.collectionView reloadData];
}
- (void)changeAllSection:(CustomerModel *)customer{//编辑应用于所有,需求方案一
    for (PicSectionModel *sectionModel in self.dataSource) {
        for (PicCaptureModel *model in sectionModel.itemArray) {
            model.customer = customer;
        }
    }
    
    [self.collectionView reloadData];
}
- (void)changeSection{//编辑应用于当前,需求方案二
    [self.currentSection.itemArray removeObject:self.currentModel];
    if (self.currentSection.itemArray.count == 0) {
        [self.dataSource removeObject:self.currentSection];
    }
    BOOL hasKnownSection = NO;
    
    for (PicSectionModel *sectionModel in self.dataSource) {
        PicCaptureModel *knownModel = sectionModel.itemArray.firstObject;
        
        if ([knownModel.customer.customerCode isEqualToString:self.currentModel.customer.customerCode]) {
            
            [sectionModel.itemArray addObject:self.currentModel];
            self.currentSection = sectionModel;
            hasKnownSection = YES;
            break;
        }
    }
    if (hasKnownSection == NO) {
        
        PicSectionModel *sectionModel = [PicSectionModel new];
        [sectionModel.itemArray addObject:self.currentModel];
        self.currentSection = sectionModel;
        [self.dataSource addObject:sectionModel];
        
    }
    [self.collectionView reloadData];
}

@end
