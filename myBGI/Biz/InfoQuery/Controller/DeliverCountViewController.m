//
//  DeliverCountViewController.m
//  InfoCapture
//
//  Created by feng on 14/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "DeliverCountViewController.h"
#import "iCarousel.h"
#import "DeliverCountView.h"

@interface DeliverCountViewController ()<iCarouselDataSource, iCarouselDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet iCarousel *carouselView;
@property (strong, nonatomic) DeliverCountView *productView;
@property (strong, nonatomic) DeliverCountView *customerView;

@end

@implementation DeliverCountViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title = @"交付统计";
    
    //初始化iCarousel
    self.carouselView.dataSource = self;
    self.carouselView.delegate = self;
    self.carouselView.decelerationRate = 1.0;
    self.carouselView.scrollSpeed = 1.0;
    self.carouselView.type = iCarouselTypeLinear;
    self.carouselView.pagingEnabled = YES;
    self.carouselView.clipsToBounds = YES;
    self.carouselView.bounceDistance = 0.2;
    
    [self.carouselView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.productView initDrawInfo];
    [self.customerView initDrawInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark setter--getter
- (DeliverCountView *)productView{
    if (_productView == nil) {
        _productView = [[[NSBundle mainBundle] loadNibNamed:@"DeliverCountView" owner:nil options:nil] firstObject];
        _productView.frame = self.carouselView.frame;
        _productView.countType = DeliverCountTypeProduct;
    }
    return _productView;
}

- (DeliverCountView *)customerView{
    if (_customerView == nil) {
        _customerView = [[[NSBundle mainBundle] loadNibNamed:@"DeliverCountView" owner:nil options:nil] firstObject];
        _customerView.frame = self.carouselView.frame;
        _customerView.countType = DeliverCountTypeCustomer;
    }
    return _customerView;
}

- (IBAction)segmentClick:(UISegmentedControl *)sender {
    
    [self.carouselView scrollToItemAtIndex:sender.selectedSegmentIndex animated:YES];
    
}

#pragma mark iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 2;
}
//加载对应index的view
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    UIView *carouselView = view;
    
    switch (index) {
        case 0:
        {
            
            carouselView = self.productView;
            self.productView.frame = self.carouselView.frame;
            
        }
            break;
            
        case 1:
        {
            
            carouselView = self.customerView;
            self.customerView.frame = self.carouselView.frame;
        }
            break;
            
        default:
            break;
    }
    
    return carouselView;
}

#pragma mark - iCarouselDelegate

- (void)carouselDidScroll:(iCarousel *)carousel
{
    
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    
    //    NSLog(@"%s", __func__);
    [carousel.visibleItemViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        
        
    }];
    self.segment.selectedSegmentIndex = carousel.currentItemIndex;
    
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
