//
//  ArtViewController.h
//  OurTeamVideo
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtViewController : UIViewController

//向云端传输数据
+(void)creatLeanCludeWithString:(NSString*)string image:(NSString*)image video:(NSString*)video userName:(NSString*)userName time:(NSString *)time;
//投诉云存储；
+ (void)creatLeanCludeWithReason:(NSString *)reason video:(NSString *)video;


@end
