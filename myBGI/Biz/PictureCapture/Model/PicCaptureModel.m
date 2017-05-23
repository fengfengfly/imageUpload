//
//  PicCaptureModel.m
//  InfoCapture
//
//  Created by feng on 17/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "PicCaptureModel.h"
#import "HttpManager.h"
#import "UserManager.h"
#import "SDImageCache.h"
#import "NSString+NilString.h"
#import "UIImage+Compression.h"

@interface PicCaptureModel()
@property (strong, nonatomic) CustomerModel *bakCustomer;
@property (copy, nonatomic) NSMutableArray *bakProducts;

@end

@implementation PicCaptureModel
- (CustomerModel *)customer{
    if (_customer == nil) {
        _customer = [CustomerModel new];
    }
    return _customer;
}
- (NSMutableArray<ProductModel *> *)productArray{
    if (_productArray == nil) {
        _productArray = [NSMutableArray array];
    }
    return _productArray;
}
- (ReadType)readNum{
    if (_readNum == 0) {
        _readNum = singleRead;
    }
    return _readNum;
}

- (void)savePicture:(UIImage *)image{
    NSString *dir = [FZFileManager homeDirWithSub:kFilePath_upload];
#if DEBUG
    NSLog(@"dir--%@", dir);
#endif
    NSString *dateStr = [self dateStrFromNowDate];
    NSString *fileNameBig = [NSString stringWithFormat:@"%@.jpg", dateStr];
    NSString *fileNameSmall = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *filePathBig = [dir stringByAppendingPathComponent:fileNameBig];
    NSString *filePathSmall = [dir stringByAppendingPathComponent:fileNameSmall];
    BOOL bigSaveResult =[UIImageJPEGRepresentation(image, 1) writeToFile:filePathBig atomically:YES];
    if (bigSaveResult) {
        self.picBigStr = filePathBig;
    }
    UIImage *smallImage = [UIImage thumbnailWithImage:image size:CGSizeMake(244, 326)];
    BOOL smallSaveResult =[UIImageJPEGRepresentation(smallImage, 1) writeToFile:filePathSmall atomically:YES];
    if (smallSaveResult) {
        self.picSmallStr = filePathSmall;
    }
}

- (NSString *)productCodeStr{
    NSMutableString *mutStr = [NSMutableString string];
    for (ProductModel *product in self.productArray) {
        if (product.productCode.length > 0) {
            [mutStr appendFormat:@"%@,",product.productCode];
        }
    }
    if (mutStr.length > 0) {
        [mutStr deleteCharactersInRange:NSMakeRange(mutStr.length - 1, 1)];
    }else{
        return @"";
    }
    return mutStr;
}

- (NSString *)productNameStr{
    NSMutableString *mutStr = [NSMutableString string];
    for (ProductModel *product in self.productArray) {
        if (product.productName.length > 0) {
            [mutStr appendFormat:@"%@,",product.productName];
        }
    }
    if (mutStr.length > 0) {
        [mutStr deleteCharactersInRange:NSMakeRange(mutStr.length - 1, 1)];
    }else{
        return @"";
    }
    return mutStr;
}

- (void)uploadIfSuccess:(UploadSuccess)uploadSuccess fail:(UploadFail)uploadFail{
    NSString *dateStr = [self dateStrFromNowDate];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           dateStr, @"uploadpack",
                           [NSString ifNilWithNilString: kUserManager.userModel.realName], @"username",
                           [NSString ifNilWithNilString:kUserManager.userModel.userName], @"useren",
                           self.customer.customerCode, @"customerCode",
                           [NSNumber numberWithInteger:self.readNum], @"readNum",
                           [NSString ifNilWithNilString:[self productCodeStr]], @"productCode",
                           [NSString ifNilWithNilString:[self productNameStr]], @"productName",
                           [NSNumber numberWithInteger:1], @"uploadWay",
                           nil];
    
    [[HttpManager sharedManager] uploadWithBaseURLString:domainURL BodyURLString:kUploadPic parameters:param dataBlock:^(id formData) {
        self.uploadState = PicStateUploading;
        if ([self.uploadDelegate respondsToSelector:@selector(beginUploadPic)]) {
            [self.uploadDelegate beginUploadPic];
        }
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.picBigStr] name:@"file" error:nil];
//        NSData *data = UIImagePNGRepresentation(self.picture);
//        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(id progress) {
        if ([self.uploadDelegate respondsToSelector:@selector(uploadProgress:)]) {
            [self.uploadDelegate uploadProgress:progress];
        }
    } success:^(id mResponseObject) {
        self.uploadState = PicStateUploadSuccess;
        if ([self.uploadDelegate respondsToSelector:@selector(uploadSuccess:)]) {
            [self.uploadDelegate uploadSuccess:mResponseObject];
        }
        if (uploadSuccess) {
            uploadSuccess();
        }
    } failure:^(id mError) {
        self.uploadState = PicStateUploadFail;
        if ([self.uploadDelegate respondsToSelector:@selector(uploadFail:)]) {
            [self.uploadDelegate uploadFail:mError];
        }
        if (uploadFail) {
            uploadFail();
        }
    }];
    
}

- (NSString *)dateStrFromNowDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    return dateStr;
}

- (void)dealloc{
    [self removePic];
}

- (void)removePic{
    NSFileManager* fileManager=[NSFileManager defaultManager];

    BOOL isHaveSmall=[[NSFileManager defaultManager] fileExistsAtPath:self.picSmallStr];
    BOOL isHaveBig=[[NSFileManager defaultManager] fileExistsAtPath:self.picBigStr];

    if (isHaveBig) {
        BOOL blDele= [fileManager removeItemAtPath:self.picBigStr error:nil];
        
        if (blDele) {
#if DEBUG
            NSLog(@"dele bigPic success");
#endif
            
        }else {
#if DEBUG
            NSLog(@"dele bigPic fail");
#endif
            
        }
        
    }
    
    if (isHaveSmall) {
        BOOL blDele= [fileManager removeItemAtPath:self.picSmallStr error:nil];
        
        if (blDele) {
#if DEBUG
            NSLog(@"dele smallPic success");
#endif
            
        }else {
#if DEBUG
            NSLog(@"dele smallPic fail");
#endif
            
        }
        
    }
    
    [[SDImageCache sharedImageCache] removeImageForKey:[self.picBigStr lastPathComponent] withCompletion:nil];
    [[SDImageCache sharedImageCache] removeImageForKey:[self.picSmallStr lastPathComponent] withCompletion:nil];

}

- (void)backUpSelf{
    self.bakCustomer = self.customer;
    self.bakProducts = self.productArray;
}

- (void)restoreSelf{
    self.customer = self.bakCustomer;
    self.productArray = self.bakProducts;
}

@end
