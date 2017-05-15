//
//  HttpManager.h
//  InfoCapture
//
//  Created by feng on 17/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "BaseHttpManager.h"
#import "UserManager.h"
#import "MBProgressHUD+HYExtension.h"

//请求成功block
typedef void (^HttpSuccessResult)(id mResponseObject);
//请求失败block
typedef void (^HttpFailureResult)(id mError);

@interface HttpManager : BaseHttpManager
+ (instancetype)sharedManager;
//不带缓存请求头json
- (NSURLSessionDataTask *)sendPostJsonRequestWithBodyURLString:(NSString *)bodyURLString
                                                         parameters:(id)parameters
                                                            success:(HttpSuccessResult)successResult
                                                            failure:(HttpFailureResult)failureResult;
//不带缓存请求头x-www-form-urlencoded
- (NSURLSessionDataTask *)sendPostUrlRequestWithBodyURLString:(NSString *)bodyURLString
                                                   parameters:(id)parameters
                                                      success:(HttpSuccessResult)successResult
                                                      failure:(HttpFailureResult)failureResult;

//上传
-(void)uploadWithBaseURLString:(NSString *)baseURLString
                 BodyURLString:(NSString *)bodyURLString
                    parameters:(id)parameters
                     dataBlock:(void(^)(id formData))dataBlock
                      progress:(void(^)(id progress))progress
                       success:(HttpSuccessResult)successResult
                       failure:(HttpFailureResult)failureResult;

//下载
-(void)downloadFileWithUrlStr:(NSString *)urlString SavePath:(NSString *)docPath fileName:(NSString *)fileName progress:(void(^)(NSProgress * downloadProgress))progress complete:(void(^)(NSURLResponse *response, NSURL  *filePath, NSError *error))complete;

@end
