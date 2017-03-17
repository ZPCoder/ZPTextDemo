//
//  NewsTableViewCell.h
//  Video
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsModel;

@interface NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet RQShineLabel *titleLabel;
- (void)cellDataWithModel:(NewsModel *)model;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;


@end
