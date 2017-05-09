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

- (NSURLSessionDataTask *)sendPostJsonRequestWithBodyURLString:(NSString *)bodyURLString
                                                         parameters:(id)parameters
                                                            success:(HttpSuccessResult)successResult
                                                            failure:(HttpFailureResult)failureResult;
//不带缓存
- (NSURLSessionDataTask *)sendPostUrlRequestWithBodyURLString:(NSString *)bodyURLString
                                                   parameters:(id)parameters
                                                      success:(HttpSuccessResult)successResult
                                                      failure:(HttpFailureResult)failureResult;

-(void)uploadWithBaseURLString:(NSString *)baseURLString
                 BodyURLString:(NSString *)bodyURLString
                    parameters:(id)parameters
                     dataBlock:(void(^)(id formData))dataBlock
                      progress:(void(^)(id progress))progress
                       success:(HttpSuccessResult)successResult
                       failure:(HttpFailureResult)failureResult;


@end
