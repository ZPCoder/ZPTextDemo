//
//  MovieTableViewCell.m
//  Video
//
//  Created by 朱鹏 on 16/5/2.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "MovieTableViewCell.h"
#import "MovieModel.h"

@implementation MovieTableViewCell

- (void)setValuesWithCell:(MovieModel *)model {
    
    self.titleL.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.titleL.text = [NSString stringWithFormat:@"%@✨",model.title];
    self.shareL.text = [NSString stringWithFormat:@"%@",model.share_num];
    self.levelL.text = model.rating;
    NSInteger timeS = [model.duration integerValue];
    self.playTime.text = [NSString stringWithFormat:@"时长:%02ld:%02ld",timeS/60,timeS%60];
}
- (IBAction)playButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonSelectAction:)]) {
        
        [self.delegate buttonSelectAction:sender];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
