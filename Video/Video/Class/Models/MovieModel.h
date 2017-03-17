//
//  MovieModel.h
//  Video
//
//  Created by 朱鹏 on 16/5/2.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject

@property (strong, nonatomic) NSNumber *duration;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSNumber *like_num;
@property (strong, nonatomic) NSNumber *postid;
@property (strong, nonatomic) NSNumber *publish_time;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSString *request_url;
@property (strong, nonatomic) NSNumber *share_num;
@property (strong, nonatomic) NSString *title;

@end
