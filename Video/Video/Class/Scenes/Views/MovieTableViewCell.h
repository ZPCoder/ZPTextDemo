//
//  MovieTableViewCell.h
//  Video
//
//  Created by 朱鹏 on 16/5/2.
//  Copyright © 2016年 朱鹏 All rights reserved.
//
@class MovieModel;
#import <UIKit/UIKit.h>

@protocol TransSelectionAction <NSObject>

- (void)buttonSelectAction:(UIButton *)sender;

@end

@interface MovieTableViewCell : UITableViewCell

@property (assign, nonatomic) id<TransSelectionAction>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UIButton *playerButton;
@property (strong, nonatomic) IBOutlet UILabel *playTime;
@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UILabel *shareL;
@property (strong, nonatomic) IBOutlet UILabel *levelL;

- (void)setValuesWithCell:(MovieModel *)model;
@end
