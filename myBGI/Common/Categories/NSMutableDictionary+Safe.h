//
//  NSMutableDictionary+Safe.h
//  InfoCapture
//
//  Created by feng on 21/04/2017.
//  Copyright © 2017 feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Safe)
- (void)filterNilSetObject:(id)object forKey:(NSString *)key;
@end
