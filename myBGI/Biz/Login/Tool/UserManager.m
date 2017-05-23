//
//  UserManager.m
//  InfoCapture
//
//  Created by feng on 17/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "UserManager.h"
#import "HttpManager.h"
#import <MJExtension/MJExtension.h>

@implementation UserManager
static UserManager *defaultManager = nil;
+ (UserManager *)sharedManager
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
         if(defaultManager == nil){
             defaultManager = [[self alloc] init];
        }
     });
    return defaultManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [super allocWithZone:zone];
    });
    return defaultManager;
}

- (id)copyWithZone:(NSZone *)zone
{
    return defaultManager;
}

- (UserModel *)userModel{
    if (_userModel == nil) {
        _userModel = [UserModel new];
    }
    return _userModel;
}

- (void)loginSuccess:(NSDictionary *)response{
    
}

- (void)loginUser:(NSString *)userName password:(NSString *)pwd success:(void(^)())successBlock fail:(void(^)(id mError))failBlock{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"user.userName", pwd, @"user.passWord", nil];
    [[HttpManager sharedManager] sendPostUrlRequestWithBodyURLString:kLoginUrl parameters:param success:^(id mResponseObject) {
        
        if ([mResponseObject[@"object"] isKindOfClass:[NSDictionary class]]) {
            UserModel *model = [UserModel mj_objectWithKeyValues:mResponseObject[@"object"]];
            model.isLogin = YES;
            self.userModel = model;
            
            //发送自动登陆状态通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            if (successBlock) {
                successBlock();
            }
        }else{
            failBlock(@"登录失败");
        }
    } failure:^(id mError) {
        if (failBlock) {
            failBlock(mError);
        }
    }];
}

- (void)userLogout{
    self.userModel.isLogin = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //移除UserDefaults中存储的用户信息
    [userDefaults removeObjectForKey:CUS_SEARCH_HISTORY];
    [userDefaults removeObjectForKey:PRD_SEARCH_HISTORY];
    [userDefaults removeObjectForKey:@"id"];
    [userDefaults removeObjectForKey:@"loginId"];
    [userDefaults removeObjectForKey:@"passWord"];
    [userDefaults removeObjectForKey:@"realName"];
    [userDefaults removeObjectForKey:@"userName"];
    [userDefaults removeObjectForKey:@"isLogin"];
    [userDefaults removeObjectForKey:@"rows"];
    
    [userDefaults synchronize];
    //发送自动登陆状态通知
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];

}

@end
