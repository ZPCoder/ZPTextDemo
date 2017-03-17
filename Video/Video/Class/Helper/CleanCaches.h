//
//  CleanCaches.h
//  GraduationProject
//
//  Created by 朱鹏 on 16/4/18.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CleanCaches : NSObject

/**
 *  返回path路径下文件的文件大小。
 */
+ (double)sizeWithFilePath:(NSString *)path;

/**
 *  删除path路径下的文件。
 */
+ (void)clearCachesWithFilePath:(NSString *)path;
/**
 * 删除文件夹下所有文件
 */
+ (void)clearSubfilesWithFilePath:(NSString *)path;
/**
 *  获取沙盒Library的文件目录。
 */
+ (NSString *)LibraryDirectory;

/**
 *  获取沙盒Document的文件目录。
 */
+ (NSString *)DocumentDirectory;

/**
 *  获取沙盒Preference的文件目录。
 */
+ (NSString *)PreferencePanesDirectory;

/**
 *  获取沙盒Caches的文件目录。
 */
+ (NSString *)CachesDirectory;


@end
