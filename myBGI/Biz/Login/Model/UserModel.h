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
@property (strong, nonatomic) NSArray *rows;//权限菜单列表

@property (assign, nonatomic) BOOL isLogin;

/*
 {
     msg = "\U767b\U5f55\U6210\U529f";
     object =     {
         id = 6baa467a2a2b415a91f86cc548a5c9ce;
         realName = "\U4ed8\U5764";
         token = 157f9c2e75484619a9c3d3c0da306cc5;
         userName = fukun;
     };
     rows =     (
     {
         systemCode = S021;
         text = "\U91c7\U96c6\U4e2d\U5fc3";
     },
     {
         systemCode = S021;
         text = "\U67e5\U8be2\U7edf\U8ba1";
     }
     );
     success = 1;
 }
 */
@end
