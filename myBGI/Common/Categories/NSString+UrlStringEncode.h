//
//  NSString+UrlStringEncode.h
//  InfoCapture
//
//  Created by feng on 20/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString (UrlStringEncode)
+ (NSString *)encodeStringUTF8:(NSString *)urlStr;
+ (NSString *)urlStr:(NSString *)urlStr addParamFromDic:(NSDictionary *)dic;

@end
