//
//  LHFileReadAndWriteTools.m
//  GraduationProject
//
//  Created by 朱鹏 on 16/4/7.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "MSQFileReadAndWriteTools.h"

@implementation MSQFileReadAndWriteTools

//将一个字典写入文件
+ (BOOL)writeDictionary:(NSMutableDictionary *)dic toFilePath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return  [fileManager createFileAtPath:filePath contents:data attributes:nil];
}

//将一个数组写入文件
+ (BOOL)writeArray:(NSMutableArray *)arr toFilePath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    return  [fileManager createFileAtPath:filePath contents:data attributes:nil];
}

//将一个字符串写入文件
+ (BOOL)writeString:(NSString *)str toFilePath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return  [fileManager createFileAtPath:filePath contents:data attributes:nil];
}

//从文件中读取字典
+ (NSMutableDictionary *)readDictionaryWithFilePath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSData *data = [fileManager contentsAtPath:filePath];
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        return dic;
    } else {
        return nil;
    }
    
}

//从文件中读取数组
+ (NSMutableArray *)readArrayWithFilePath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSData *data = [fileManager contentsAtPath:filePath];
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        return arr;
    } else {
        return nil;
    }
}

//从文件中读取字符串
+ (NSString *)readStringWithFilePath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    } else {
        return nil;
    }
}


@end
