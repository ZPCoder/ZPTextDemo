//
//  DownLoadManager.m
//  DownLoad_Demo
//
//  Created by 朱鹏 on 16/4/15.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "DownLoadManager.h"

@interface DownLoadManager ()<NSURLSessionDownloadDelegate>

//下载任务
@property (nonatomic,strong)NSURLSessionDownloadTask *task;

//通过它来初始化子类对象
@property (nonatomic,strong)NSURLSession *session;

@end

@implementation DownLoadManager

#pragma mark---根据网址进行下载
-(void)downLoadFileWithUrl:(NSString *)urlStr{

    //1.把NSString类型转换为NSURL类型
    //2.把NSURL类型转换为NSURLRequest类型
    //3.通过request来创建一个下载任务

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    self.task = [self.session downloadTaskWithRequest:request];
}

//开始下载
-(void)startDownLoad{

    [self.task resume];
}

//暂停下载
-(void)pauseDownLoad{

    [self.task suspend];
}

#pragma mark-----下载的代理方法

//完成下载
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{

    NSLog(@"完成下载-----");
    //存放下载文件的路径
    NSString *string = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    //拼接文件的名称
    //downloadTask.response.suggestedFilename:从服务器上获取下来的
    NSString *cachesName = [string stringByAppendingPathComponent:downloadTask.response.suggestedFilename];

    //文件管理器
    [[NSFileManager defaultManager]moveItemAtPath:location.path toPath:cachesName error:nil];

    //让下载器失败
    [self.session invalidateAndCancel];
    NSLog(@"----%@",cachesName);
}

//正在下载
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{

    NSLog(@"已完成----%.2f%%",(float)100*totalBytesWritten/totalBytesExpectedToWrite);

}


//懒加载
-(NSURLSession *)session{
    if (!_session) {

        //defaultSessionConfiguration:用来把下载的文件缓存到沙盒
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:nil];
    }
    return _session;
}


#pragma mark -- GCD单例 只被初始化一次

+(instancetype )sharedManger{
    static DownLoadManager *handle = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{

        handle = [[DownLoadManager alloc]init];
    });
    return handle;
}


@end
