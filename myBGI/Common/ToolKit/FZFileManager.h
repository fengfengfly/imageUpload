//
//  FZFileManager.h
//  myBGI
//
//  Created by lx on 2017/5/19.
//  Copyright © 2017年 feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZFileManager : NSObject

+ (BOOL)makeDirIfNeed:(NSString*)path;

+ (NSString *)homeDirWithSub:(NSString *)subPath;

+ (NSString*)documentDirWithSub:(NSString*)subPath;

+ (NSString*)cacheDirWithSub:(NSString*)subPath;

+ (BOOL)removeFileAtPath:(NSString *)path;

+ (void)removeFilesAtPath:(NSString *)path confirm:(BOOL (^)(NSDictionary *fileInfo))confirm;

+ (void)asyncRemoveFilesAtPath:(NSString *)path confirm:(BOOL (^)(NSDictionary *fileInfo))confirm;

+ (BOOL)fileExistsAtPath:(NSString *)path;

@end
