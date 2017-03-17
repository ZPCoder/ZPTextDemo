//
//  InfoMovieModel.m
//  Video
//
//  Created by 朱鹏 on 16/5/3.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "InfoMovieModel.h"

@implementation InfoMovieModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"share_link"]) {
        
        ShareMovieModel *model = [[ShareMovieModel alloc] init];
        [model setValuesForKeysWithDictionary:value];
    }
}

@end
