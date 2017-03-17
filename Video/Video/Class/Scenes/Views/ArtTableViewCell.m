//
//  ArtTableViewCell.m
//  Viedo-art
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 王勇. All rights reserved.
//

#import "ArtTableViewCell.h"
#import <UIImageView+WebCache.h>
@implementation ArtTableViewCell

- (void)awakeFromNib {
    // Initialization code
}




-(void)setCellWithArtModel:(ArtModel*)model tableViewTag:(NSInteger )tableViewTag datasource:(NSMutableArray *)datasource{
    
    self.title.text = model.content;
    self.title.autoStart = YES;
    [self.myImage sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    
    if (tableViewTag == 0) {
//        [self.DateArray addObject:model];
        self.DateArray = datasource;
        [self creatButtonWithImage:[UIImage imageNamed:@"collect-1"] Action:@selector(hotAction:) frame:CGRectMake(10, 0, 35, 35)];

    }else if (tableViewTag == 1) {
        self.MVArray = datasource;
        [self creatButtonWithImage:[UIImage imageNamed:@"collect-1"] Action:@selector(MVAction:)frame:CGRectMake(10, 0, 35, 35)];

    }else {
        self.EnArray = datasource;
        [self creatButtonWithImage:[UIImage imageNamed:@"collect-1"] Action:@selector(EnAction:)frame:CGRectMake(10, 0, 35, 35)];

    }
    
    
}

-(void)hotAction:(UIButton*)sender{
    
    ArtModel*model = self.DateArray[self.number];
    CollectionModel *colletModel = [[CollectionModel alloc]init];
    colletModel.title = model.content;
    colletModel.image = model.thumb;
    colletModel.file = model.file;
    colletModel.spare = [CollectManager dateToStringWhitDate];
//    NSLog(@"=====%ld",self.number);
    [[CollectManager sharedManager]insertData:colletModel];
    
    //若用户登录，则上传至云端
    if ([AVUser currentUser].username.length != 0) {
       
        [ArtViewController creatLeanCludeWithString:colletModel.title image:colletModel.image video:colletModel.file userName:[AVUser currentUser].username time:colletModel.spare];
    }else{
        NSLog(@"收藏成功");
    }
    
}
-(void)MVAction:(UIButton*)sender{
    
    ArtModel*model = self.MVArray[self.number];
    CollectionModel *colletModel = [[CollectionModel alloc]init];
    colletModel.title = model.content;
    colletModel.image = model.thumb;
    colletModel.file = model.file;
    colletModel.spare = [CollectManager dateToStringWhitDate];
    //    NSLog(@"=====%@",model.content);
    [[CollectManager sharedManager]insertData:colletModel];
    
    //若用户登录，则上传至云端
    if ([AVUser currentUser].username.length != 0) {
        
        [ArtViewController creatLeanCludeWithString:colletModel.title image:colletModel.image video:colletModel.file userName:[AVUser currentUser].username time:colletModel.spare];
    }else{
        NSLog(@"收藏成功");
    }

}
-(void)EnAction:(UIButton*)sender{
    
    ArtModel*model = self.EnArray[self.number];
    CollectionModel *colletModel = [[CollectionModel alloc]init];
    colletModel.title = model.content;
    colletModel.image = model.thumb;
    colletModel.file = model.file;
    colletModel.spare = [CollectManager dateToStringWhitDate];
    //    NSLog(@"=====%@",model.content);
    [[CollectManager sharedManager]insertData:colletModel];
    
    //若用户登录，则上传至云端
    if ([AVUser currentUser].username.length != 0) {
        
        [ArtViewController creatLeanCludeWithString:colletModel.title image:colletModel.image video:colletModel.file userName:[AVUser currentUser].username time:colletModel.spare];
        NSLog(@"收藏成功");

    }else{
        
        NSLog(@"收藏失败");
    }

}


-(void)creatButtonWithImage:(UIImage*)image Action:(SEL)action frame:(CGRect)frame{
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [btn setImage:[image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    [btn addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    btn.frame = frame;
    [self addSubview:btn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- 懒加载

- (NSMutableArray *)DateArray {
    if (!_DateArray) {
        _DateArray = [[NSMutableArray alloc] init];
    }
    return _DateArray;
}

- (NSMutableArray *)MVArray {
    if (!_MVArray) {
        _MVArray = [[NSMutableArray alloc] init];
    }
    return _MVArray;
}

- (NSMutableArray *)EnArray {
    if (!_EnArray) {
        _EnArray = [[NSMutableArray alloc] init];
    }
    return _EnArray;
}


@end
