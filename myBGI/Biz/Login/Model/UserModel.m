//
//  UserModel.m
//  InfoCapture
//
//  Created by feng on 17/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@synthesize ID = _ID;
@synthesize loginId = _loginId;
@synthesize token = _token;
@synthesize passWord = _passWord;
@synthesize userName = _userName;
@synthesize realName = _realName;

@synthesize isLogin = _isLogin;

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}

- (void)setIsLogin:(BOOL)isLogin{
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _isLogin = isLogin;
}

- (BOOL)isLogin{
    if (_isLogin == NO) {
        _isLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
    }
    return _isLogin;
}

- (void)setID:(NSString *)ID{
    [[NSUserDefaults standardUserDefaults] setObject:ID forKey:@"id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _ID = ID;
}

- (NSString *)ID{
    if (_ID == nil || _ID.length == 0) {
        _ID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ID"];
    }
    return _ID;
}

- (void)setLoginId:(NSString *)loginId{
    [[NSUserDefaults standardUserDefaults] setObject:loginId forKey:@"loginId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _loginId = loginId;
    
}

- (NSString *)loginId{
    if (_loginId == nil || _loginId.length == 0) {
        _loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginId"];
    }
    return _loginId;
}

- (void)setToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _token = token;
    
}
- (NSString *)token{
    if (_token == nil || _token.length == 0) {
        _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    }
//    _token = @"880d11a6-5637-4c9a-aba6-b60fe92e685e";
    return _token;
}

- (void)setPassWord:(NSString *)passWord{
    [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:@"passWord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _passWord = passWord;
}
- (NSString *)passWord{
    if (_passWord == nil || _passWord.length == 0) {
        _passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"];
    }
    return _passWord;
}

- (void)setRealName:(NSString *)realName{
    [[NSUserDefaults standardUserDefaults] setObject:realName forKey:@"realName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _realName = realName;
}
- (NSString *)realName{
    if (_realName == nil || _realName.length == 0) {
        _realName = [[NSUserDefaults standardUserDefaults] objectForKey:@"realName"];
    }
    return _realName;
}

- (void)setUserName:(NSString *)userName{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _userName = userName;
}
-(NSString *)userName{
    if (_userName == nil || _userName.length == 0) {
        _userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    }
    return _userName;
}


@end
