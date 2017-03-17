//
//  ArtModel.h
//  Viedo-art
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 王勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtModel : NSObject

//@property (nonatomic,strong)NSNumber *id;
@property (nonatomic,strong)NSString *content; //标题

@property (nonatomic,strong)NSString *file;    //视频网址

@property (nonatomic,strong)NSString *thumb;   //占位图 返回值是url类型的

@property (nonatomic,strong)NSNumber *length;  //视频时长（秒）

@property (nonatomic,strong)NSString *face;    //上传者头像

@property (nonatomic,strong)NSString *nicheng; //上传者名称

@property (nonatomic,strong)NSString *desc;    //上传者简介
@end
