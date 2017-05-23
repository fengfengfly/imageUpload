//
//  FZFileManager.m
//  myBGI
//
//  Created by lx on 2017/5/19.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "FZFileManager.h"

#define kNSFM [NSFileManager defaultManager]

@implementation FZFileManager

static dispatch_queue_t FZFileManagerQueue;
+ (dispatch_queue_t)defaultQueue
{
    if (!FZFileManagerQueue) {
        FZFileManagerQueue = dispatch_queue_create("FZFileManager", NULL);
    }
    return FZFileManagerQueue;
}

+ (BOOL)makeDirIfNeed:(NSString*)path {
    BOOL succeeded = YES;
    if (![kNSFM fileExistsAtPath:path]) {
        succeeded = [kNSFM createDirectoryAtPath: path
                  withIntermediateDirectories: YES
                                   attributes: nil
                                        error: nil];
    }
    
    return succeeded;
}

+ (NSString *)homeDirWithSub:(NSString *)subPath{
    NSString *path = NSHomeDirectory();
    NSString *newPath = [path stringByAppendingPathComponent:subPath];
    [self makeDirIfNeed:newPath];
    return newPath;
}

+ (NSString*)documentDirWithSub:(NSString*)subPath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString* newPath = [path stringByAppendingPathComponent:subPath];
    [self makeDirIfNeed:newPath];
    return newPath;
}

+ (NSString*)cacheDirWithSub:(NSString*)subPath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* path = [paths objectAtIndex:0];
    NSString* newPath = [path stringByAppendingPathComponent:subPath];
    
    [self makeDirIfNeed:newPath];
    
    return newPath;
}

#pragma mark - 删除
+ (BOOL)removeFileAtPath:(NSString *)path
{
    NSError *error;
    BOOL succeed = [kNSFM removeItemAtPath:path error:&error];
    return succeed;
}

+ (void)removeFilesAtPath:(NSString *)path confirm:(BOOL (^)(NSDictionary *fileInfo))confirm
{
    
    NSDirectoryEnumerator *enumerate = [kNSFM enumeratorAtPath:path];
    for (NSString *fileName in enumerate)
    {
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSDictionary *fileInfo = [kNSFM attributesOfItemAtPath:filePath error:nil];
        if (confirm(fileInfo)) {
            [kNSFM removeItemAtPath:filePath error:nil];
        }
    }
}

+ (void)asyncRemoveFilesAtPath:(NSString *)path confirm:(BOOL (^)(NSDictionary *fileInfo))confirm
{
    dispatch_async([self defaultQueue], ^{
        [self removeFilesAtPath:path confirm:confirm];
    });
}

+ (BOOL)fileExistsAtPath:(NSString *)path
{
    return [kNSFM fileExistsAtPath:path];
}


@end
