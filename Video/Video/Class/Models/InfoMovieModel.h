//
//  InfoMovieModel.h
//  Video
//
//  Created by 朱鹏 on 16/5/3.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareMovieModel.h"

@interface InfoMovieModel : NSObject

@property (strong, nonatomic) NSDictionary *download_link;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSNumber *duration;
@property (strong, nonatomic) NSDictionary *editor;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSNumber *publish_time;
@property (strong, nonatomic) ShareMovieModel *share_lin;
@property (strong, nonatomic) NSString *title;

@end
