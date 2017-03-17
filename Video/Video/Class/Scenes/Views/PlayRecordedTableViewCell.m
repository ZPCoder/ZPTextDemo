//
//  PlayRecordedTableViewCell.m
//  Video
//
//  Created by 朱鹏 on 16/5/15.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "PlayRecordedTableViewCell.h"

@implementation PlayRecordedTableViewCell


- (void)getValueFormPlayPath:(NSDictionary *)dic {
    
    self.timeLabel.text = [NSString stringWithFormat:@"播放于%@",dic[@"time"]];
    [self.timeLabel NightWithType:UIViewColorTypeClear];
    [self.contentLabel NightWithType:UIViewColorTypeClear];
    [self.imageLabel sd_setImageWithURL:[NSURL URLWithString:dic[@"imageUrl"]]];
     self.contentLabel.text = dic[@"title"];
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
