//
//  NSMutableDictionary+Safe.m
//  InfoCapture
//
//  Created by feng on 21/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"

@implementation NSMutableDictionary (Safe)
- (void)filterNilSetObject:(id)object forKey:(NSString *)key{
    if (object == nil || key == nil) {
        return;
    }
    [self setObject:object forKey:key];
}
@end
