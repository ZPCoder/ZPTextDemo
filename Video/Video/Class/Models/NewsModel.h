//
//  NewsModel.h
//  Video
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsVideoTopicModel.h"

@interface NewsModel : NSObject

@property (nonatomic,strong) NSString *cover;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSNumber *length;
@property (nonatomic,strong) NSString *m3u8_url;
@property (nonatomic,strong) NSString *mp4_url;
@property (nonatomic,strong) NSString *playCount;
@property (nonatomic,strong) NSString *playersize;
@property (nonatomic,strong) NSString *prompt;
@property (nonatomic,strong) NSString *ptime;
@property (nonatomic,strong) NSString *replyBoard;
@property (nonatomic,strong) NSString *replyCount;
@property (nonatomic,strong) NSString *replyid;
@property (nonatomic,strong) NSString *sectiontitle;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *topicDesc;
@property (nonatomic,strong) NSString *topicImg;
@property (nonatomic,strong) NSString *topicName;
@property (nonatomic,strong) NSString *topicSid;
@property (nonatomic,strong) NSString *vid;
@property (nonatomic,retain) NewsVideoTopicModel *videoTopic;
@property (nonatomic,strong) NSString *videosource;
@end
