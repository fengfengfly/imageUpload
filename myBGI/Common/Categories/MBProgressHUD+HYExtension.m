//
//  MBProgressHUD+HYExtension.m
//  MBTest
//
//  Created by jsb06 on 16/6/21.
//  Copyright © 2016年 jsb06. All rights reserved.
//

#import "MBProgressHUD+HYExtension.h"
#import <objc/message.h>
#define AnimationImgsArr @[[UIImage imageNamed:@"loading_1"],[UIImage imageNamed:@"loading_2"]]
#define kKeyWindowView [[UIApplication sharedApplication].windows lastObject]
#define kSystemFontOfSize(size) [UIFont systemFontOfSize:size]
#define HYScreenW [UIScreen mainScreen].bounds.size.width
#define HYScreenH [UIScreen mainScreen].bounds.size.height
#define kWarningImgLenght 100
#define kWarningLabelW 320
#define kWarningLabelH 100
#define kSpace 20

#define WidthRateBase6P(a) HYScreenW/1080*a
#define HeightRatebase6P(a) HYScreenH/1920*a

static CGFloat const margin = 10.0f;
// 运行时objc_msgSend
#define HYReloadMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define HYReloadMsgTarget(target) (__bridge void *)(target)

@interface HYReLoadingButton : UIButton
@property (nonatomic, copy) void (^clickWithBlock)();
@property (nonatomic,assign) SEL reLoadAction;
@property (nonatomic,strong) id reLoadtarget;
@end

@implementation HYReLoadingButton
@end

@interface MBProgressHUD (HYExtension)
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) HYReLoadingButton *reLoadingBtn;
@end

@implementation MBProgressHUD (HYExtension)

/* 关联相关 */
static char hudKey;
static char bgViewKey;
static char ReLoadingBtnKey;
- (id)bgView {
    return objc_getAssociatedObject(self, &bgViewKey);
}
- (void)setBgView:(UIView *)bgView {
    objc_setAssociatedObject(self, &bgViewKey, bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)hud {
    return objc_getAssociatedObject(self, &hudKey);
}
- (void)setHud:(UIView *)hud {
    objc_setAssociatedObject(self, &hudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HYReLoadingButton *)reLoadingBtn {
    return objc_getAssociatedObject(self, &ReLoadingBtnKey);
}
- (void)setReLoadingBtn:(HYReLoadingButton *)reLoadingBtn {
    objc_setAssociatedObject(self, &ReLoadingBtnKey, reLoadingBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/* 没有黑色背景 */
+ (void)showHUD {
    [self showHUDOnView:nil];
}
+ (void)showHUDOnView:(UIView *)view {
    [self showHUDWithMessage:nil onView:view];
}
+ (void)showHUDWithMessage:(NSString *)message {
    [self showHUDWithMessage:message deltail:nil onView:nil];
}
+ (void)showHUDWithMessage:(NSString *)message onView:(UIView *)view {
    [self showHUDWithMessage:message deltail:nil onView:view];
}
+ (void)showHUDWithMessage:(NSString *)message deltail:(NSString *)deltail {
    [self showHUDWithMessage:message deltail:deltail onView:nil];
}
+ (void)showHUDWithMessage:(NSString *)message deltail:(NSString *)deltail onView:(UIView *)view {
    MBProgressHUD *hud = [self showMessage:message detail:deltail showView:view img:nil isCustomImage:NO time:0.0 dimBackground:NO isAutoDismis:NO];
    hud.mode = MBProgressHUDModeIndeterminate;
}
+ (void)showError:(NSString *)error {
    [self showError:error onView:nil];
}
+ (void)showError:(NSString *)error onView:(UIView *)view {
    [self showMessage:error detail:nil showView:view img:@"error.png" isCustomImage:NO time:1.0 dimBackground:NO isAutoDismis:YES];
}
+ (void)showSuccess:(NSString *)Success {
    [self showSuccess:Success onView:nil];
}
+ (void)showSuccess:(NSString *)Success onView:(UIView *)view {
     [self showMessage:Success detail:nil showView:view img:@"success.png"  isCustomImage:NO time:1.0 dimBackground:NO isAutoDismis:YES];
}
+ (void)showIcon:(NSString *)icon {
    [self showMessage:nil icon:icon];
}
+ (void)showMessage:(NSString *)message icon:(NSString *)icon {
    [self showMessage:message icon:icon view:nil];
}
+ (void)showMessage:(NSString *)message icon:(NSString *)icon view:(UIView *)view {
    [self showMessage:message detail:nil showView:view img:icon isCustomImage:YES time:1.0 dimBackground:NO isAutoDismis:YES];
}

+ (void)showAnimotionHUD {
    [self showAnimotionHUDOnView:nil];
}
+ (void)showAnimotionHUDOnView:(UIView *)view {
    [self showAnimationHUDWithImages:nil title:nil onView:view];
}
+ (void)showAnimationHUDWithImages:(NSArray<UIImage *> *)images title:(NSString *)title {
    [self showAnimationHUDWithImages:images title:title onView:nil];
}

+ (void)showAnimationHUDWithImages:(NSArray *)images title:(NSString *)title onView:(UIView *)view {
    [self showAnimationHUDWithImages:images title:title showView:view dimBackground:NO];
}

/*  有黑色背景 */
+ (void)showBlackBackgroundHUD {
    [self showBlackBackgroundHUDOnView:nil];
}
+ (void)showBlackBackgroundHUDOnView:(UIView *)view {
    [self showBlackBackgroundHUDMessage:nil onView:view ];
}
+ (void)showBlackBackgroundHUDWithMessage:(NSString *)message {
    [self showBlackBackgroundHUDMessage:message onView:nil];
}
+ (void)showBlackBackgroundHUDMessage:(NSString *)message onView:(UIView *)view {
    [self showBlackBackgroundHUDMessage:message deltail:nil onView:view];
}
+ (void)showBlackBackgroundHUDWithMessage:(NSString *)message deltail:(NSString *)deltail {
    [self showBlackBackgroundHUDMessage:message deltail:deltail onView:nil];
}
+ (void)showBlackBackgroundHUDMessage:(NSString *)message deltail:(NSString *)deltail onView:(UIView *)view {
    MBProgressHUD *hud = [self showMessage:message detail:deltail showView:view img:nil isCustomImage:NO time:0.0 dimBackground:YES isAutoDismis:NO];
    hud.mode = MBProgressHUDModeIndeterminate;
}
+ (void)showBlackBackgroundError:(NSString *)error {
     [self showBlackBackgroundError:error onView:nil];
}
+ (void)showBlackBackgroundError:(NSString *)error onView:(UIView *)view {
    [self showMessage:error detail:nil showView:view img:@"error.png" isCustomImage:NO time:1.0 dimBackground:YES isAutoDismis:YES];
}
+ (void)showBlackBackgroundSuccess:(NSString *)Success {
    [self showBlackBackgroundSuccess:Success onView:nil];
}
+ (void)showBlackBackgroundSuccess:(NSString *)Success onView:(UIView *)view{
    [self showMessage:Success detail:nil showView:view img:@"success.png" isCustomImage:NO time:1.0 dimBackground:YES isAutoDismis:YES];
}
+ (void)showBlackBackgroundIcon:(NSString *)icon {
    [self showBlackBackgroundMessage:nil icon:icon];
}
+ (void)showBlackBackgroundMessage:(NSString *)message icon:(NSString *)icon {
    [self showBlackBackgroundMessage:message icon:icon view:nil];
}
+ (void)showBlackBackgroundMessage:(NSString *)message icon:(NSString *)icon view:(UIView *)view {
     [self showMessage:message detail:nil showView:view img:icon isCustomImage:YES time:1.0 dimBackground:YES isAutoDismis:YES];
}

+ (void)showAnimotionBlackBackgroundHUD {
    [self showAnimotionBlackBackgroundHUDOnView:nil];
}
+ (void)showAnimotionBlackBackgroundHUDOnView:(UIView *)view {
    [self showAnimationBlackBackgroundHUDWithImages:nil title:nil toView:view];
}
+ (void)showAnimationBlackBackgroundHUDWithImages:(NSArray *)images title:(NSString *)title {
    [self showAnimationBlackBackgroundHUDWithImages:images title:title toView:nil];
}
+ (void)showAnimationBlackBackgroundHUDWithImages:(NSArray *)images title:(NSString *)title toView:(UIView *)view {
    [self showAnimationHUDWithImages:images title:title showView:view dimBackground:YES];
}

/*  隐藏  */
+ (BOOL)hidden {
  return  [self hideHUDForView:kKeyWindowView animated:YES];
}
+ (BOOL)hiddenForView:(UIView *)view {
   return [self hideHUDForView:view animated:YES];
}
+ (void)hiddenWithMessage:(NSString *)message {
    ![self hideHUDForView:kKeyWindowView animated:NO] ? : [self showText:message];
}
+ (void)hiddenWithSuccessStatus:(NSString *)message {
    ![self hideHUDForView:kKeyWindowView animated:NO] ? : [self showSuccess:message];
}
+ (void)hiddenWithErrowStatus:(NSString *)message {
    ![self hideHUDForView:kKeyWindowView animated:NO] ? : [self showError:message];
}
+ (void)hiddenForView:(UIView *)view Message:(NSString *)message {
    ![self hideHUDForView:view animated:NO] ? : [self showText:message onView:view];
}
+ (void)hiddenForView:(UIView *)view successStatus:(NSString *)message {
    ![self hideHUDForView:view animated:NO] ? : [self showSuccess:message onView:view];
}
+ (void)hiddenForView:(UIView *)view errowStatus:(NSString *)message {
    ![self hideHUDForView:view animated:NO] ? : [self showError:message onView:view];
}

+ (instancetype)showMessage:(NSString *)message detail:(NSString *)detail showView:(UIView *)view img:(NSString *)imgName isCustomImage:(BOOL)isCustomImage time:(float)time dimBackground:(BOOL)bg isAutoDismis:(BOOL)dismiss
{
   MBProgressHUD *hud = view ?  [self showHUDAddedTo:view animated:YES] :[self showHUDAddedTo:kKeyWindowView animated:YES];
    hud.label.text = message;
    if (!isCustomImage) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", imgName]]];
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.font = kSystemFontOfSize(15);
    hud.removeFromSuperViewOnHide = YES;
    if (detail) {
        hud.detailsLabel.text = detail;
    }
    if (bg) {
        hud.customView.backgroundColor = [UIColor colorWithWhite:0.f alpha:.2f];
        hud.animationType = MBProgressHUDAnimationFade;
    } else {
        hud.animationType = MBProgressHUDAnimationZoomOut;
    }
    if (dismiss) {
        [hud hideAnimated:YES afterDelay:time];
    }
    return hud;
}

+(void)showText:(NSString *)text {
    [self showText:text onView:nil];
}

+(void)showText:(NSString *)text onView:(UIView *)view {
    MBProgressHUD *hud = view ?  [self showHUDAddedTo:view animated:YES] :[self showHUDAddedTo:kKeyWindowView animated:YES];
    hud.detailsLabel.font = kSystemFontOfSize(15);
    hud.detailsLabel.text = text;
    hud.mode = MBProgressHUDModeText;
    hud.margin = margin;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    hud.animationType = MBProgressHUDAnimationZoom;
    [hud hideAnimated:YES afterDelay:1.5];
}

+ (void)showAnimationHUDWithImages:(NSArray *)images title:(NSString *)title showView:(UIView *)view dimBackground:(BOOL)bg {
    UIImageView *actionImage = [[UIImageView alloc] init];
    actionImage.frame = CGRectMake(0, 0, WidthRateBase6P(338), HeightRatebase6P(345));
    images = images ? images : AnimationImgsArr;
    [actionImage setAnimationImages:images];
    [actionImage setAnimationDuration:images.count * 0.1];
    [actionImage startAnimating];
    MBProgressHUD *hud = view ?  [self showHUDAddedTo:view animated:YES] :[self showHUDAddedTo:kKeyWindowView animated:YES];
    hud.backgroundColor = bg ? RGBColor(115, 115, 115, 0.4):[UIColor clearColor];
    hud.customView = actionImage;
    if (!title) {
        title = @"努力加载中...";
    }
    hud.label.text = title;
    hud.label.font = kSystemFontOfSize(18);
    hud.label.textColor = [UIColor darkGrayColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor clearColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationZoomOut;
}

#pragma mark - 无数据界面提示
+ (void)showNoDataView:(UIView *)view {
    [self showNoDataView:view title:@"没有相关数据..." imageName:@"no-wifi"];
}

+ (void)showNoDataView:(UIView *)view title:(NSString *)title imageName:(NSString *)imageName {
    [self showNoDataView:view title:title imageName:imageName reloadTarget:nil reloadAction:nil];
}

+ (void)showNoDataView:(UIView *)view title:(NSString *)title imageName:(NSString *)imageName reloadBlock:(void (^)())reloadBlock {
    [self showNoDataView:view title:title imageName:imageName block:reloadBlock action:nil addTarget:nil];
}

+ (void)showNoDataView:(UIView *)view title:(NSString *)title imageName:(NSString *)imageName reloadTarget:(id)target reloadAction:(SEL)action {
    [self showNoDataView:view title:title imageName:imageName block:nil action:action addTarget:target];
}

+ (void)showNoDataView:(UIView *)view title:(NSString *)title imageName:(NSString *)imageName  block:(void (^)())reload action:(SEL)action addTarget:(id)target {
    [self tipView:view title:title message:nil imageName:imageName block:reload action:action addTarget:target];
}

#pragma mark - 无网络页面提示 默认图片
+ (void)showNetworkErrorView:(UIView *)view reloadBlock:(void (^)())reloadBlock {
    [self showNetworkErrorView:view title:@"加载失败!" message:@"请检查您的网络是否正常" reloadBlock:reloadBlock];
}

+ (void)showNetworkErrorView:(UIView *)view title:(NSString *)title message:(NSString *)message reloadBlock:(void (^)())reloadBlock {
    [self showNetworkErrorView:view title:title message:message block:reloadBlock action:nil addTarget:nil];
}

+ (void)showNetworkErrorView:(UIView *)view reloadTarget:(id)target reloadAction:(SEL)action {
    [self showNetworkErrorView:view title:@"加载失败!" message:@"请检查您的网络是否正常" reloadTarget:target reloadAction:action];
}

+ (void)showNetworkErrorView:(UIView *)view title:(NSString *)title message:(NSString *)message reloadTarget:(id)target reloadAction:(SEL)action {
    [self showNetworkErrorView:view title:title message:message block:nil action:action addTarget:target];
}

+ (void)showNetworkErrorView:(UIView *)view title:(NSString *)title message:(NSString *)message block:(void (^)())reload action:(SEL)action addTarget:(id)target {
    [self tipView:view title:title message:message imageName:@"no-wifi" block:reload action:action addTarget:target];
}

+ (void)tipView:(UIView *)view title:(NSString *)title message:(NSString *)message imageName:(NSString *)imageName block:(void (^)())reload action:(SEL)action addTarget:(nullable id)target {
    MBProgressHUD *hud = [[self alloc] init];
    [hud tipView:view title:title message:message imageName:imageName block:reload action:action addTarget:target hud:hud];
}


- (void)tipView:(UIView *)view title:(NSString *)title message:(NSString *)message imageName:(NSString *)imageName block:(void (^)())reload action:(SEL)action addTarget:(nullable id)target hud:(MBProgressHUD *)hud{
    self.hud = hud;
    CGFloat padding = 15;
    
    // 背景
    CGRect bgViewFrame = CGRectMake(0, 0, HYScreenW, HYScreenH);
    UIView *bgView = [[UIView alloc] initWithFrame:bgViewFrame];
    self.bgView = bgView;
    bgView.backgroundColor = view.backgroundColor;
    [view addSubview:bgView];
    [view bringSubviewToFront:bgView];
    
    // 图片
    CGFloat imgW = WidthRateBase6P(517);
    CGFloat imgH = HeightRatebase6P(315);
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake((bgViewFrame.size.width-imgW)/2, (bgView.frame.size.height-imgH)/2 - (kWarningLabelH + kSpace)/2, imgW, imgH)];
    imageView.image = [UIImage imageNamed:imageName];
    [bgView addSubview:imageView];
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:18];
    CGSize titleMaxSize = CGSizeMake(bgViewFrame.size.width, MAXFLOAT);
    CGSize titleSize = [self sizeWithText:title andFont:titleLabel.font andMaxSize:titleMaxSize];
    CGFloat titleX = (bgViewFrame.size.width - titleSize.width) * 0.5;
    CGFloat titleY = CGRectGetMaxY(imageView.frame) + padding;
    titleLabel.frame = CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor darkGrayColor];
    [bgView addSubview:titleLabel];
    
    // msg
    UILabel *msgLabel = [[UILabel alloc] init];
    if (message) {
        CGSize msgMaxSize = CGSizeMake(bgViewFrame.size.width, MAXFLOAT);
        msgLabel.font = [UIFont systemFontOfSize:14];
        CGSize msgSize = [self sizeWithText:message andFont:msgLabel.font andMaxSize:msgMaxSize];
        CGFloat msgX = (bgViewFrame.size.width - msgSize.width) * 0.5;
        CGFloat msgY = CGRectGetMaxY(titleLabel.frame) + padding / 2;
        msgLabel.frame = CGRectMake(msgX, msgY, msgSize.width, msgSize.height);
        [msgLabel setTextAlignment:NSTextAlignmentCenter];
        msgLabel.textColor = [UIColor darkGrayColor];
        msgLabel.text = message;
        [bgView addSubview:msgLabel];
    }
    
    // 刷新按钮
    if (reload || action) {
        CGFloat refreshBtnW = 100;
        CGFloat refreshBtnH = 35;
        CGFloat refreshBtnX = (bgViewFrame.size.width - refreshBtnW) * 0.5;
        CGFloat refreshBtnY;
        if (message) {
            refreshBtnY = CGRectGetMaxY(msgLabel.frame) + padding;
        }else {
            refreshBtnY = CGRectGetMaxY(titleLabel.frame) + padding;
        }
        HYReLoadingButton *reLoadingBtn = [[HYReLoadingButton alloc] init];
        self.reLoadingBtn = reLoadingBtn;
        reLoadingBtn.frame = CGRectMake(refreshBtnX, refreshBtnY, refreshBtnW, refreshBtnH);
        [reLoadingBtn setTitle:@"刷  新" forState:UIControlStateNormal];
        [reLoadingBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        reLoadingBtn.layer.borderWidth = 1;
        reLoadingBtn.layer.borderColor = reLoadingBtn.titleLabel.textColor.CGColor;
        reLoadingBtn.layer.cornerRadius = 5;
        reLoadingBtn.layer.masksToBounds = YES;
        reLoadingBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [bgView addSubview:reLoadingBtn];
        reLoadingBtn.clickWithBlock = reload;
        reLoadingBtn.reLoadAction = action;
        reLoadingBtn.reLoadtarget = target;
        [reLoadingBtn addTarget:self action:@selector(reLoadingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)reLoadingBtnClick:(HYReLoadingButton *)btn{
    if (btn.clickWithBlock) {
        btn.clickWithBlock();
        [self.bgView removeFromSuperview];
    }
    
    if ([btn.reLoadtarget respondsToSelector:btn.reLoadAction]) {
        HYReloadMsgSend(HYReloadMsgTarget(btn.reLoadtarget), btn.reLoadAction, btn);
//        objc_msgSend(btn.reLoadtarget, btn.reLoadAction,btn);
        [self.bgView removeFromSuperview];
    }
}

- (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font andMaxSize:(CGSize)maxSize {
    NSDictionary *atts = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:atts context:nil].size;
}
@end
