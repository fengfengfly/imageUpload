//
//  PicCaptureModel.h
//  InfoCapture
//
//  Created by feng on 17/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CustomerModel.h"
#import "ProductModel.h"
#import "FZFileManager.h"

typedef NS_ENUM(NSInteger, ReadType){
    singleRead = 1,
    doubleRead = 2
};

typedef NS_ENUM(NSInteger, PicUploadState) {
    PicStateNormal,
    PicStateWaitUpload,
    PicStateUploading,
    PicStateUploadFail,
    PicStateUploadSuccess
};

typedef void(^UploadSuccess)();
typedef void(^UploadFail)();

@protocol PicCaptureUploadDelegate <NSObject>
- (void)beginUploadPic;
- (void)uploadSuccess:(id)response;
- (void)uploadFail:(id)error;
- (void)uploadProgress:(id)progress;

@end

@interface PicCaptureModel : NSObject
@property (strong, nonatomic) CustomerModel *customer;
@property (strong, nonatomic) NSMutableArray<ProductModel *> *productArray;

@property (strong, nonatomic) NSString *picBigStr;
@property (strong, nonatomic) NSString *picSmallStr;

@property (assign, nonatomic) ReadType readNum;
@property (assign, nonatomic) PicUploadState uploadState;
@property (weak, nonatomic) id<PicCaptureUploadDelegate> uploadDelegate;
@property (copy, nonatomic) UploadSuccess uploadSuccess;

- (void)savePicture:(UIImage *)image serial:(NSInteger)serial;
- (NSString *)productCodeStr;
- (NSString *)productNameStr;
- (void)uploadIfSuccess:(UploadSuccess)uploadSuccess fail:(UploadFail)uploadFail;
- (void)backUpSelf;
- (void)restoreSelf;
@end
