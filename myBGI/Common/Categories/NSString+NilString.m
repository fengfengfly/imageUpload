//
//  NSString+NilString.m
//  InfoCapture
//
//  Created by lx on 2017/5/4.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "NSString+NilString.h"

@implementation NSString (NilString)
+ (NSString *)ifNilWithNilString:(NSString *)str{
    if (str == nil) {
         return @"";
    }
    return str;
}
+ (NSString *)ifNilStringWithNil:(NSString *)str{
    if (str.length == 0) {
        return nil;
    }
    return str;
}
@end
