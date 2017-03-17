//
//  LHFileReadAndWriteTools.h
//  GraduationProject
//
//  Created by 朱鹏 on 16/4/7.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSQFileReadAndWriteTools : NSObject


//将一个字典写入文件
+ (BOOL)writeDictionary:(NSMutableDictionary *)dic toFilePath:(NSString *)filePath;

//将一个数组写入文件
+ (BOOL)writeArray:(NSMutableArray *)arr toFilePath:(NSString *)filePath;

//将一个字符串写入文件
+ (BOOL)writeString:(NSString *)str toFilePath:(NSString *)filePath;

//从文件中读取字典
+ (NSMutableDictionary *)readDictionaryWithFilePath:(NSString *)filePath;

//从文件中读取数组
+ (NSMutableArray *)readArrayWithFilePath:(NSString *)filePath;

//从文件中读取字符串
+ (NSString *)readStringWithFilePath:(NSString *)filePath;


@end
