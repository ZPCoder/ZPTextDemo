//
//  DownLoadManager.h
//  DownLoad_Demo
//
//  Created by 朱鹏 on 16/4/15.
//  Copyright © 2016年 LS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadManager : NSObject


//通过网址进行下载
-(void)downLoadFileWithUrl:(NSString *)urlStr;

//单例
+(instancetype )sharedManger;

//开始下载
-(void)startDownLoad;


//暂停下载
-(void)pauseDownLoad;

@end
