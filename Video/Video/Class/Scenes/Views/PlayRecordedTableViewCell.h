//
//  PlayRecordedTableViewCell.h
//  Video
//
//  Created by 朱鹏 on 16/5/15.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayRecordedTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
- (void)getValueFormPlayPath:(NSDictionary *)dic;

@end
