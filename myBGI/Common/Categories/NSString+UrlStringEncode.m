//
//  NSString+UrlStringEncode.m
//  InfoCapture
//
//  Created by feng on 20/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "NSString+UrlStringEncode.h"

@implementation NSString (UrlStringEncode)
+ (NSString *)encodeStringUTF8:(NSString *)urlStr{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlStr,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    return encodedString;
}

+ (NSString *)urlStr:(NSString *)urlStr addParamFromDic:(NSDictionary *)dic{
    NSMutableString *muUrlStr = [NSMutableString stringWithString:urlStr];
    NSArray * keys = [dic allKeys];
    //拼接字符串
    for (int j = 0; j < keys.count; j ++)
    {
        
        NSString *string;
        if (j == 0)
        {
            
            //拼接时加？
            string = [NSString stringWithFormat:@"?%@=%@", keys[j], dic[keys[j]]];
            
        }
        else
        {
            //拼接时加&
            string = [NSString stringWithFormat:@"&%@=%@", keys[j], dic[keys[j]]];
        }
        //拼接字符串
        [muUrlStr appendString:string];
        
    }
    
    return [muUrlStr copy];
}


@end
