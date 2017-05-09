//
//  UserModel.h
//  InfoCapture
//
//  Created by feng on 17/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *loginId;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *passWord;
@property (strong, nonatomic) NSString *realName;
@property (strong, nonatomic) NSString *userName;

@property (assign, nonatomic) BOOL isLogin;

/*
{
    msg = "\U767b\U5f55\U6210\U529f";
    msgStr = "<null>";
    object =     {
        id = fb91537555244166b9bec88f0312013a;
        insertListSql = "<null>";
        loginId = "<null>";
        orderBy = "<null>";
        passWord = "<null>";
        realName = "\U4ed8\U5764";
        token = de325f6c08ba4af6a900fb105383f4d6;
        userName = fukun;
    };
    rows =     (
    );
    success = 1;
    total = "<null>";
}
 */
@end
