//
//  ArtTableViewCell.h
//  Viedo-art
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 王勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtModel.h"
@interface ArtTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet RQShineLabel *title;

@property (nonatomic,strong)NSMutableArray *DateArray;        //热门页面数据收集数组
@property (nonatomic,strong)NSMutableArray *MVArray;          //MV页面数据收集数组
@property (nonatomic,strong)NSMutableArray *EnArray;


@property (nonatomic,assign)NSInteger number;

-(void)setCellWithArtModel:(ArtModel*)model tableViewTag:(NSInteger )tableViewTag datasource:(NSMutableArray *)datasource;
@end
