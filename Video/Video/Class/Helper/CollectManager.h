//
//  CollectManager.h
//  Video
//
//  Created by 朱鹏 on 16/5/12.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectManager : NSObject

+(CollectManager*)sharedManager;

@property (nonatomic,retain)NSManagedObjectContext *context;

//增
-(void)insertData:(CollectionModel*)data;

//添加
-(NSArray*)selectedData;

//删除
-(void)deleteData:(CollectionModel*)model;

- (void)deledataAllData;
//查
//时间（date）转转字符串  *date = [NSDate dateWithTimeIntervalSince1970:<#(NSTimeInterval)#>]
+ (NSString *)dateToStringWhitDate;

@end
