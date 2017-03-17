//
//  NewsModel.m
//  Video
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    NSLog(@"NewsModel.h键值对不匹配%@",key);
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([key isEqualToString:@"videoTopic"]) {
        
        [self.videoTopic setValuesForKeysWithDictionary:value];
    }else {
        
        [super setValue:value forKey:key];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.videoTopic = [[NewsVideoTopicModel alloc]init];
    }
    return self;
}
@end
