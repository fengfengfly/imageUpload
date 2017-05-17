//
//  HttpManager.m
//  InfoCapture
//
//  Created by feng on 17/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "HttpManager.h"
#import "NSString+UrlStringEncode.h"

@implementation HttpManager
+ (instancetype)sharedManager {
    static HttpManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[HttpManager alloc] init];
    });
    
    return _sharedManager;
}

- (void)sendUrlGetRequest:(NSString *)action params:(NSDictionary *)params success:(HttpSuccessResult)successResult failure:(HttpFailureResult)failureResult
{
    AFHTTPSessionManager *client = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: domainURL]];
    client.requestSerializer=[AFHTTPRequestSerializer serializer];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [client GET:(NSString *)action parameters:(id)params progress:^(NSProgress * downloadProgress){
        
    }success:^(NSURLSessionDataTask *task, id responseObject){
        if (successResult) {
            successResult(responseObject);
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        if (failureResult) {
            failureResult(error);
        }
    }];
}
//不带缓存Json请求头
- (NSURLSessionDataTask *)sendPostJsonRequestWithBodyURLString:(NSString *)bodyURLString
                                                         parameters:(id)parameters
                                                            success:(HttpSuccessResult)successResult
                                                            failure:(HttpFailureResult)failureResult
{
    return [self postHttpRequestWithBaseURLString:domainURL bodyURLString:bodyURLString isCache:NO isHttpReq:NO parameters:parameters success:successResult failure:failureResult];
}

//不带缓存请求头x-www-form-urlencoded
- (NSURLSessionDataTask *)sendPostUrlRequestWithBodyURLString:(NSString *)bodyURLString
                                                   parameters:(id)parameters
                                                      success:(HttpSuccessResult)successResult
                                                      failure:(HttpFailureResult)failureResult
{
    return [self postHttpRequestWithBaseURLString:domainURL bodyURLString:bodyURLString isCache:NO isHttpReq:YES parameters:parameters success:successResult failure:failureResult];
}



- (NSURLSessionDataTask *)postHttpRequestWithBaseURLString:(NSString *)baseURLString
                                             bodyURLString:(NSString *)bodyURLString
                                                   isCache:(BOOL)isCache isHttpReq:(BOOL)isHttpReq
                                                parameters:(id)parameters
                                                   success:(HttpSuccessResult)successResult
                                                   failure:(HttpFailureResult)failureResult
{
    
    //创建http client
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    
    // 设置超时时间
    [sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    sessionManager.requestSerializer.timeoutInterval = 10.f;
    [sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
//    if (!isData) {
//        [sessionManager.requestSerializer setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    }
    if(isHttpReq){
        sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];; //（未加密）此处规定请求格式
    }else{
        sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];; //（未加密）此处规定请求格式
    }
    
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer]; //（未加密）此处规定返回格式
    
    
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    return [sessionManager POST:bodyURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSNumber *success = responseObject[@"success"];
        
        if (success.integerValue == 1 || success == nil) {
            if (successResult) successResult(responseObject);
        } else {
            if (failureResult) {
                NSString *msg = responseObject[@"msg"];
                if ([msg isKindOfClass:[NSString class]] && [msg containsString:@"登录"]) {
                    [kUserManager userLogout];
                }
                failureResult(msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureResult) failureResult(error);
        
        
    }];
}
//上传
-(void)uploadWithBaseURLString:(NSString *)baseURLString
                     BodyURLString:(NSString *)bodyURLString
                    parameters:(id)parameters
                          dataBlock:(void(^)(id formData))dataBlock
                      progress:(void(^)(id progress))progress
                       success:(HttpSuccessResult)successResult
                       failure:(HttpFailureResult)failureResult
{
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [manager.requestSerializer setValue: @"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //（未加密）此处规定返回格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    //    NSDictionary *dictM = @{}
    //2.发送post请求上传文件
    /*
     第一个参数:请求路径
     第二个参数:字典(非文件参数)
     第三个参数:constructingBodyWithBlock 处理要上传的文件数据
     第四个参数:进度回调
     第五个参数:成功回调 responseObject:响应体信息
     第六个参数:失败回调
     */
    NSString *urlStr = [NSString urlStr:bodyURLString addParamFromDic:parameters];
    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedString = [NSString encodeStringUTF8:urlStr];
    [manager POST:encodedString parameters:nil constructingBodyWithBlock:^(id _Nonnull formData) {
        
        //使用formData来拼接数据
        /*
         第一个参数:二进制数据 要上传的文件参数
         第二个参数:服务器规定的
         第三个参数:该文件上传到服务器以什么名称保存
         */
        //[formData appendPartWithFileData:imageData name:@"file" fileName:@"xxxx.png" mimeType:@"image/png"];
        
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/Cehae/Desktop/Snip20160227_128.png"] name:@"file" fileName:@"123.png" mimeType:@"image/png" error:nil];
        dataBlock(formData);
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
#if DEBUG
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
#endif

        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if DEBUG
        NSLog(@"uploadSuccess");
#endif
        if (successResult) successResult(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureResult) failureResult(error);
#if DEBUG
        NSLog(@"%@",error);
#endif

    }];
    
}

//文件下载
-(void)downloadFileWithUrlStr:(NSString *)urlString SavePath:(NSString *)docPath fileName:(NSString *)fileName progress:(void(^)(NSProgress * downloadProgress))progress complete:(void(^)(NSURLResponse *response, NSURL  *filePath, NSError *error))complete{
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *path = [docPath stringByAppendingPathComponent:fileName];
#if DEBUG
        NSLog(@"filPath -- %@", path);
#endif

        return [NSURL fileURLWithPath:path];//这里返回的是文件下载到哪里的路径 要注意的是必须是携带协议file://
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {

        }else {
            NSString *name = [filePath path];
#if DEBUG
            NSLog(@"finish_filePath -- %@", name);
#endif
        }
        if (complete) {
            complete(response, filePath, error);
        }
    }];
    [task resume];//开始下载 要不然不会进行下载的
    
}


@end
