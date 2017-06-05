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

/**
 从根目录拼接并生成目录路径

 @param subPath 子路径
 @return 最终路径
 */
+ (NSString *)homeDirWithSub:(NSString *)subPath;

+ (NSString*)documentDirWithSub:(NSString*)subPath;

+ (NSString*)cacheDirWithSub:(NSString*)subPath;

+ (double)folderSizeAtPath:(NSString *)path;

+ (BOOL)removeFileAtPath:(NSString *)path;

+ (void)removeFilesAtPath:(NSString *)path confirm:(BOOL (^)(NSDictionary *fileInfo))confirm;

+ (void)asyncRemoveFilesAtPath:(NSString *)path confirm:(BOOL (^)(NSDictionary *fileInfo))confirm;

+ (BOOL)fileExistsAtPath:(NSString *)path;

@end
