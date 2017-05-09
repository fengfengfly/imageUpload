//
//  UserManager.h
//  InfoCapture
//
//  Created by feng on 17/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#define kUserManager [UserManager sharedManager]
@interface UserManager : NSObject
@property (strong, nonatomic) UserModel *userModel;

+ (UserManager *)sharedManager;
- (void)loginUser:(NSString *)userName password:(NSString *)pwd success:(void(^)())successBlock fail:(void(^)(id mError))failBlock;
- (void)userLogout;
@end
