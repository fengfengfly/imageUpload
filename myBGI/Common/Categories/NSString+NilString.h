//
//  NSString+NilString.h
//  InfoCapture
//
//  Created by lx on 2017/5/4.
//  Copyright © 2017年 feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NilString)
+ (NSString *)ifNilWithNilString:(NSString *)str;
+ (NSString *)ifNilStringWithNil:(NSString *)str;
@end
