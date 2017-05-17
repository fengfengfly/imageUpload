//
//  PictureCaptureViewcontroller.m
//  InfoCapture
//
//  Created by feng on 14/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "PictureCaptureViewcontroller.h"
#import "UIImage+Compression.h"
#import "UIImage+FixOrientation.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

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

#import "PictureCaptureSelectionVC.h"
#import "PicEditViewController.h"

#define kNumOfLine 4

typedef NS_ENUM(NSInteger, EditType) {
    EditTypeSingle,
    EditTypeMulti
};
@interface PictureCaptureViewcontroller ()<UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate, UIActionSheetDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIImagePickerController *ipc;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) PictureCaptureHeader *captureHeader;

@property (strong, nonatomic) NSMutableArray<PicSectionModel *> *dataSource;
@property (strong, nonatomic) PicCaptureModel *addingModel;
@property (strong, nonatomic) NSArray *inputStyles;
@property (assign, nonatomic) NSInteger selectStyleIndex;
@property (assign, nonatomic) NSInteger expandSection;

@property (strong, nonatomic) EditMenuListView *singleMenuListV;
@property (strong, nonatomic) EditMenuListView *multMenuListV;
//@property (assign, nonatomic) EditType editType;

@property (assign, nonatomic) CGFloat oldOffsetY;
@property (weak, nonatomic) IBOutlet UIButton *dragBtn;

@end

@implementation PictureCaptureViewcontroller

static NSString *SectionHeaderID = @"SectionHeaderID";
static NSString *PicCellID = @"PicCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"拍照采集";
    
    self.captureHeader.customerTF.delegate = self;
    self.captureHeader.productTF.delegate = self;
    self.captureHeader.inputStyleTF.delegate = self;
    
    [self configCollectionView];
    
    //captureHeader Action
//    self.captureHeader.customerTF.inputView = [[UIView alloc]initWithFrame:CGRectZero];
//    self.captureHeader.productTF.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    //初始化默认为双输
    self.selectStyleIndex = 1;
    self.captureHeader.inputStyleTF.text = @"双输";
    self.addingModel.readNum = self.selectStyleIndex + 1;
    [self.captureHeader.customerTF addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    UITapGestureRecognizer *tapCustomer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCustomers)];
    UITapGestureRecognizer *tapProduct = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProducts)];
    
    //监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [self.captureHeader.customerV addGestureRecognizer:tapCustomer];
    [self.captureHeader.productV addGestureRecognizer:tapProduct];
    [self.captureHeader.cameraBtn addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.captureHeader.albumBtn addTarget:self action:@selector(albumClick:) forControlEvents:UIControlEventTouchUpInside];
    // 初始化pickerView
    // set the frame to zero
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    [pickerView selectRow:1  inComponent:0 animated:YES];
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
    
    //2.自定义navigationBar右边的按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"批量管理" forState:(UIControlStateNormal)];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rightBtn sizeToFit];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(showMultiMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
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
//    self.collectionView.contentInset = UIEdgeInsetsMake(260, 0, 0 ,0);
    self.captureHeader.frame = CGRectMake(0, -kCaptureHeaderH, SCREEN_WIDTH, kCaptureHeaderH);
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

//当键盘出现
- (void)keyboardDidShow:(NSNotification *)notification
{
    
}
- (IBAction)dragBtnClick:(UIButton *)sender {
    [self.collectionView setContentOffset:CGPointMake(0, -kCaptureHeaderH) animated:YES];
    self.dragBtn.hidden = YES;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取tableView的Y方向偏移量
    CGFloat offSet_Y = self.collectionView.contentOffset.y;
#if DEBUG
    
    NSLog(@"offset_y--%f",offSet_Y);
#endif
    
    if (offSet_Y > 0 && self.dragBtn.hidden == YES) {//header消失
        
//        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.dragBtn.hidden = NO;
    }
    else{//header显示
        self.dragBtn.hidden = YES;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 获取开始拖拽时tableview偏移量
    self.oldOffsetY = self.collectionView.contentOffset.y;
}

#pragma mark get-setProperty
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
-(PicCaptureModel *)addingModel{
    if (_addingModel == nil) {
        _addingModel = [[PicCaptureModel alloc] init];
#if kOffLineDebug
        _addingModel.customer = [CustomerModel new];
        _addingModel.customer.customerCode = @"123";
        _addingModel.customer.customerName = @"OffLineDebug";
#endif
    }
    return _addingModel;
}
- (UIImagePickerController *)ipc
{
    if (_ipc == nil) {
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.navigationBar.barStyle = UIBarStyleBlack;
        _ipc.navigationBar.translucent = YES;
        _ipc.navigationBar.tintColor = [UIColor whiteColor];
        _ipc.delegate = self;
    }
    
    return _ipc;
}

- (EditMenuListView *)singleMenuListV{
    if (_singleMenuListV == nil) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH - 20, 44);
//        NSArray *titles = @[@"修改", @"上传", @"删除"];
        
//        _singleMenuListV = [[EditMenuListView alloc] initWithFrame:frame titles:titles imgs:nil];
        _singleMenuListV = [[NSBundle mainBundle] loadNibNamed:@"EditMenuListView" owner:nil options:nil].firstObject;
        _singleMenuListV.frame = frame;
        _singleMenuListV.bounds = frame;
    }
    return _singleMenuListV;
}

- (EditMenuListView *)multMenuListV{
    if (_multMenuListV == nil) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH - 20, 44);
//        NSArray *titles = @[@"全选", @"批量修改", @"批量上传", @"批量删除"];
        
//        _multMenuListV = [[EditMenuListView alloc] initWithFrame:frame titles:titles imgs:nil];
        _multMenuListV = [[[NSBundle mainBundle] loadNibNamed:@"EditMenuListView" owner:nil options:nil] objectAtIndex:1];
        _multMenuListV.frame = frame;
        _multMenuListV.bounds = frame;
    }
    return _multMenuListV;
}

- (PictureCaptureHeader *)captureHeader{
    if (_captureHeader == nil) {
        PictureCaptureHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"PictureCaptureHeader" owner:nil options:nil] firstObject];
        header.frame = CGRectMake(0, 0, SCREEN_WIDTH, kCaptureHeaderH);
        _captureHeader = header;
        __weak typeof(self) weakSelf = self;
        header.userInterectBlock = ^(){
            if (weakSelf.collectionView.allowsMultipleSelection == YES) {
                [weakSelf turnSingleEditMode];
                
            }
        };
    }
    return _captureHeader;
}

- (void)configCollectionView{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PicCaptureSectionHeader class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SectionHeaderID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PicCaptureCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:PicCellID];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(kCaptureHeaderH, 0, 0 ,0);
    [self.collectionView addSubview:self.captureHeader];
    self.dragBtn.hidden = YES;
}


#pragma mark - textField detegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    return NO;
//}
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    
//}
#pragma mark Actions
- (void)showCustomers{
    
    CustomerListViewController *customerListVC = [[UIStoryboard storyboardWithName:@"PictureCapture" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomerListViewController"];
    
    customerListVC.chooseBlock = ^(CustomerModel *model){
        
        self.addingModel.customer = model;
        self.captureHeader.customerTF.text = model.customerName;
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
    if (self.addingModel.productArray.count > 0) {
        
        productListVC.selectedArray = self.addingModel.productArray;
    }
    productListVC.chooseBlock = ^(NSMutableArray *productArray, BOOL isConfirm){
        self.addingModel.productArray = productArray;
        if (isConfirm == YES) {
            self.captureHeader.productTF.text = [self.addingModel productCodeStr];
        }
        
    };
    
    [self.navigationController pushViewController:productListVC animated:YES];
}
- (void)doneInputStyle:(id)sender{
    self.captureHeader.inputStyleTF.text = self.inputStyles[self.selectStyleIndex];
    self.addingModel.readNum = self.selectStyleIndex + 1;
    [self.captureHeader.inputStyleTF resignFirstResponder];
}
- (void)cancelInputStyle:(id)sender{
    [self.captureHeader.inputStyleTF resignFirstResponder];
}

- (void)addPicture:(UIButton *)sender{
    
    if (self.captureHeader.customerTF.text.length == 0) {
        [self showStatusBarWarningWithStatus:@"请先选择表单的医院"];
        return;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
    [actionSheet showInView:self.view];
}

- (void)takePhoto{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.ipc.sourceType = sourceType;
        [self presentViewController:_ipc animated:YES completion:nil];
    } else {
#if DEBUG
        NSLog(@"模拟器无法使用相机");
#endif
    }

}


- (void)cameraClick:(UIButton *)sender {
    if (self.captureHeader.customerTF.text.length == 0) {
        [self showStatusBarWarningWithStatus:@"请先选择表单的医院"];
        return;
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        
        //无权限
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        NSString *alertStr = [NSString stringWithFormat:@"请在%@的\"设置-隐私-相机\"选项，\r允许%@使用你的相机。",[UIDevice currentDevice].model,appName];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertStr message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
        
    }else {
        [self takePhoto];
    }
    
}
- (void)albumClick:(UIButton *)sender {
    if (self.captureHeader.customerTF.text.length == 0) {
        [self showStatusBarWarningWithStatus:@"请先选择表单的医院"];
#if kOffLineDebug == 0
        return;
#endif
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//    imagePickerVc.isSelectOriginalPhoto = _isSelectLogoOriginalPhoto;
//    imagePickerVc.selectedAssets = _selectedLogoAssets; // optional, 可选的
    
    // You can get the photos by block, the same as by delegate.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & photo & originalPhoto or not
    // 设置是否可以选择视频/图片/原图
    // imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingImage = NO;
    // imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)sectionUploadBtnClick:(UIButton *)sender{
    NSInteger section = sender.tag;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否上传此医院下所有图片?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *finishAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self uploadAllSection:section];
        
    }];
    [alertController addAction:finishAction];
    [alertController addAction:continueAction];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    UIImage *compressImage = [image imageCompressForTargetSize:CGSizeMake(1920, 1080)];
    
//    NSData *imageData = UIImageJPEGRepresentation(compressImage, 0.00001);
//    UIImage *nowImage = [UIImage imageWithData:imageData];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"继续添加?" message:@"继续添加所选医院和产品的表单" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *finishAction = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        UIImage *fixedOrientImg = [UIImage fixOrientation:image];
        [self.addingModel savePicture:fixedOrientImg];
        [self addModelToDataSource];
        [self.collectionView reloadData];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.addingModel savePicture:image];
        [self addModelToDataSource];
        
        __weak typeof(self) weakSelf = self;
        [picker dismissViewControllerAnimated:NO completion:^{
            [weakSelf takePhoto];
        }];
        
    }];
    [alertController addAction:finishAction];
    [alertController addAction:continueAction];
    [picker presentViewController:alertController animated:YES completion:^{
        
    }];
}

#pragma mark TZImagePickerControllerDelegate
// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    // NSLog(@"cancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ((UIImagePickerController *)picker == _ipc) {
        
        [self.collectionView reloadData];
    }
}

// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
//    CustomerModel *model = [CustomerModel new];
//    model.customerName=@"123";
//    model.customerCode=@"123";
//    self.addingModel.customer = model;
    [[TZImageManager manager] getOriginalPhotoWithAsset:assets.firstObject completion:^(UIImage *photo, NSDictionary *info) {
        [self.addingModel savePicture:photo];
        [self addModelToDataSource];
        [self.collectionView reloadData];
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark UICollectionViewDataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    PicCaptureSectionHeader *cell= nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        cell = (PicCaptureSectionHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SectionHeaderID forIndexPath:indexPath];
        [cell.uploadBtn addTarget:self action:@selector(sectionUploadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.uploadBtn.tag = indexPath.section;
    PicSectionModel *sectionModel = self.dataSource[indexPath.section];
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
    PicSectionModel *sectionModel = self.dataSource[section];
    if (section != self.expandSection) {
        return 0;
    }
    NSArray *itemArray = sectionModel.itemArray;
    return itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PicCaptureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PicCellID forIndexPath:indexPath];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.numberOfTouchesRequired = 1;
    [cell addGestureRecognizer:longPress];
    
    PicSectionModel *sectionModel = self.dataSource[indexPath.section];
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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否上传点击图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *finishAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        PicSectionModel *sectionModel = self.dataSource[indexPath.section];
        PicCaptureModel *model = sectionModel.itemArray[indexPath.row];
        [self uploadModel:model sectionModel:sectionModel];
    }];
    [alertController addAction:finishAction];
    [alertController addAction:continueAction];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 60)/kNumOfLine, 100);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 10);
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


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = self.inputStyles.count;
            break;
        default:
            break;
    }
    
    return result;
}

#pragma mark UIPickerView Delegate Method

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

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self albumClick:nil];
            break;
        case 1:
            [self cameraClick:nil];
            break;
        case 2:
            
            break;
            
        default:
            break;
    }
}

#pragma mark Model EditAction
- (void)singleEditMenu:(UIView *)locationView indexPath:(NSIndexPath *)indexPath{
    
    CustomPopOverView *view = [CustomPopOverView popOverView];
    view.content = self.singleMenuListV;
    __weak typeof(self) weakSelf = self;
    self.singleMenuListV.selectBlock = ^(NSInteger index){
        switch (index) {
            case 0://修改
                [weakSelf editCell:[NSArray arrayWithObjects:indexPath, nil]];
                break;
            case 1://上传
            {
                PicSectionModel *sectionModel = weakSelf.dataSource[indexPath.section];
                PicCaptureModel *model = sectionModel.itemArray[indexPath.row];
                [weakSelf uploadModel:model sectionModel:sectionModel];
            }
                break;
            case 2://删除
                [weakSelf deleteCell:[NSArray arrayWithObjects:indexPath, nil]];
                break;
            
            default:
                break;
        }
        [view dismiss];
    };
    CPAlignStyle style = CPAlignStyleLeft;
    switch (indexPath.row%kNumOfLine) {
        case 0:
            style = CPAlignStyleLeft;
            break;
        case 1:
            style = CPAlignStyleCenter;
            break;
        case 2:
            style = CPAlignStyleRight;
        default:
            break;
    }
    [view showFrom:locationView alignStyle:style];
}

- (void)showMultiMenu:(id)sender{
    UIButton *button = (UIButton *)sender;
    [self multiEditMenu:button indexPaths:self.collectionView.indexPathsForSelectedItems];
}

- (void)multiEditMenu:(UIView *)locationView indexPaths:(NSArray *)indexPaths{
    CustomPopOverView *view = [CustomPopOverView popOverView];
    view.content = self.multMenuListV;
    __weak typeof(self) weakSelf = self;
    self.multMenuListV.selectBlock = ^(NSInteger index){
        switch (index) {
            case 0://全选
                [weakSelf selectItemsOfSection:weakSelf.expandSection];
                break;
            case 1://批量修改
                [weakSelf editCell:weakSelf.collectionView.indexPathsForSelectedItems];
                break;
            case 2://批量上传
                [weakSelf uploadSelectedModels];
                break;
            case 3://批量删除
                if (weakSelf.collectionView.indexPathsForSelectedItems.count == 0) {
                    [weakSelf showStatusBarWarningWithStatus:@"请选择要删除的对象"];
                }else{
                    
                    [weakSelf deleteCell:weakSelf.collectionView.indexPathsForSelectedItems];
                }
                break;
                
            default:
                break;
        }
        [view dismiss];
    };
    [view showFrom:locationView alignStyle:CPAlignStyleRight];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
//        [self turnMultiEditMode];
        PictureCaptureSelectionVC *picSelectionVC = [[UIStoryboard storyboardWithName:@"PictureCapture" bundle:nil] instantiateViewControllerWithIdentifier:@"PictureCaptureSelectionVC"];
        UICollectionViewCell *cell = (UICollectionViewCell *)longPress.self.view;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        picSelectionVC.dataSource = [NSMutableArray arrayWithObject:self.dataSource[indexPath.section]];
        picSelectionVC.defaultSelRow = indexPath.row;
        
        picSelectionVC.finishBlock = ^(){
            [self.collectionView reloadData];
        };
        picSelectionVC.origDataSource = self.dataSource;
        [self.navigationController pushViewController:picSelectionVC animated:YES];
        
    }
}

- (void)turnMultiEditMode{
    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView reloadData];
    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    self.captureHeader.userInteractionEnabled = NO;
    [self showStatusBarWarningWithStatus:@"进入多选模式"];
}

- (void)turnSingleEditMode{
    self.collectionView.allowsMultipleSelection = NO;
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    [self.collectionView reloadData];
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    self.captureHeader.userInteractionEnabled = YES;
    [self showStatusBarWarningWithStatus:@"已退出多选模式"];
}

- (void)selectItemsOfSection:(NSInteger)section{
    NSInteger num = [self.collectionView numberOfItemsInSection:section];
    for (int i = 0; i < num; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:(UICollectionViewScrollPositionNone)];
    }
}
//上传选中
- (void)uploadSelectedModels{
    [self hudSelfWithMessage:@"正在上传"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
            PicSectionModel *sectionModel = self.dataSource[indexPath.section];
            PicCaptureModel *model = sectionModel.itemArray[indexPath.row];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:sectionModel, @"sectionModel", model, @"model", nil];
            [tempArray addObject:dic];
        }
        BOOL isLast = NO;
        NSInteger flag = 0;
        // 创建信号量，并且设置值为0
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        for (NSDictionary *dic in tempArray) {
            
            if (flag == tempArray.count - 1) {
                isLast = YES;
            }
#if DEBUG
            NSLog(@"currentThread--%@\nstart--%@",[NSThread currentThread],[NSDate date]);
#endif
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            PicSectionModel *sectionModel = [dic objectForKey:@"sectionModel"];
            PicCaptureModel *model = [dic objectForKey:@"model"];
            NSMutableArray *itemArray = sectionModel.itemArray;
            
            __weak typeof(self) weakSelf = self;
            [model uploadIfSuccess:^{
                if (isLast) {
                    [weakSelf hideSelfHUD];
                }
                [itemArray removeObject:model];
                if (itemArray.count == 0) {
                    
                    [weakSelf.dataSource removeObject:sectionModel];
                }
                dispatch_semaphore_signal(semaphore);
                [weakSelf.collectionView reloadData];
            } fail:^{
                if (isLast) {
                    [weakSelf hideSelfHUD];
                }
                dispatch_semaphore_signal(semaphore);
                [weakSelf.collectionView reloadData];
            }];
            
            [NSThread sleepForTimeInterval:1.5];
#if DEBUG
            NSLog(@"end--%@",[NSDate date]);
#endif
            flag ++;
        }


    });
    [self turnSingleEditMode];
}
//单个上传
- (void)uploadModel:(PicCaptureModel *)model sectionModel:(PicSectionModel *)sectionModel{
    [self hudSelfWithMessage:@"正在上传"];
    NSMutableArray *itemArray = sectionModel.itemArray;
    
    __weak typeof(self) weakSelf = self;
    [model uploadIfSuccess:^{
        [weakSelf hideSelfHUD];
        [itemArray removeObject:model];
        if (itemArray.count == 0) {
            
            [weakSelf.dataSource removeObject:sectionModel];
        }
        [weakSelf.collectionView reloadData];
    } fail:^{
        [weakSelf hideSelfHUD];
        [weakSelf.collectionView reloadData];
    }];
}
//上传整组
- (void)uploadAllSection:(NSInteger)section{
    [self hudSelfWithMessage:@"正在上传"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PicSectionModel *sectionModel = self.dataSource[section];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (PicCaptureModel *model in sectionModel.itemArray) {
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:sectionModel, @"sectionModel", model, @"model", nil];
            [tempArray addObject:dic];
        }
        BOOL isLast = NO;
        NSInteger flag = 0;
        // 创建信号量，并且设置值为0
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        for (NSDictionary *dic in tempArray) {
            
            if (flag == tempArray.count - 1) {
                isLast = YES;
            }
#if DEBUG
            NSLog(@"currentThread--%@\nstart--%@",[NSThread currentThread],[NSDate date]);
#endif
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            PicSectionModel *sectionModel = [dic objectForKey:@"sectionModel"];
            PicCaptureModel *model = [dic objectForKey:@"model"];
            NSMutableArray *itemArray = sectionModel.itemArray;
            
            __weak typeof(self) weakSelf = self;
            [model uploadIfSuccess:^{
                if (isLast) {
                    [weakSelf hideSelfHUD];
                }
                [itemArray removeObject:model];
                if (itemArray.count == 0) {
                    
                    [weakSelf.dataSource removeObject:sectionModel];
                }
                dispatch_semaphore_signal(semaphore);
                [weakSelf.collectionView reloadData];
            } fail:^{
                if (isLast) {
                    [weakSelf hideSelfHUD];
                }
                dispatch_semaphore_signal(semaphore);
                [weakSelf.collectionView reloadData];
            }];
            
            [NSThread sleepForTimeInterval:1.5];
#if DEBUG
            NSLog(@"end--%@",[NSDate date]);
#endif
            flag ++;
        }
        
        
    });

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
        }
    }

    //移除空section
    [self.dataSource removeObjectsAtIndexes:nullSectionIndexSet];
    [self.collectionView reloadData];
    
}
//编辑多个
- (void)editCell:(NSArray<NSIndexPath *> *)senders{
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSIndexPath *indexPath in senders) {
        
        PicSectionModel *sectionModel = [self.dataSource objectAtIndex:indexPath.section];
        [muArray addObject:sectionModel.itemArray[indexPath.row]];
    }
    for (NSIndexPath *indepath in senders) {
        PicSectionModel *sectionModel = self.dataSource[indepath.section];
        [sectionModel.itemArray removeObjectAtIndex:indepath.row];
        if (sectionModel.itemArray.count == 0) {
            [self.dataSource removeObject:sectionModel];
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
        [weakSelf.collectionView reloadData];
    };
    [self.navigationController pushViewController:editVC animated:YES];
}
//添加到数据源
- (void)addModelToDataSource{
    BOOL hasKnownSection = NO;
    for (PicSectionModel *sectionModel in self.dataSource) {
        PicCaptureModel *knownModel = sectionModel.itemArray.firstObject;
        if ([knownModel.customer.customerCode isEqualToString:self.addingModel.customer.customerCode]) {
            [sectionModel.itemArray addObject:self.addingModel];
            self.expandSection = [self.dataSource indexOfObject:sectionModel];
            hasKnownSection = YES;
            break;
        }
    }
    if (hasKnownSection == NO) {
        
        PicSectionModel *sectionModel = [PicSectionModel new];
        [sectionModel.itemArray addObject:self.addingModel];
        [self.dataSource addObject:sectionModel];
        self.expandSection = [self.dataSource indexOfObject:sectionModel];
    }
    [self addModelSuccess];
    
}
//添加成功
- (void)addModelSuccess{
    PicCaptureModel *newModel = [PicCaptureModel new];
    newModel.customer.customerCode = [self.addingModel.customer.customerCode copy];
    newModel.customer.customerName = [self.addingModel.customer.customerName copy];
    newModel.productArray = [self.addingModel.productArray mutableCopy];
    newModel.readNum = self.selectStyleIndex + 1;
    self.addingModel = newModel;
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
