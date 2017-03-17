//
//  NewsTableViewCell.m
//  Video
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "NewsTableViewCell.h"
#import "NewsModel.h"
#import <UIImageView+WebCache.h>
#import "MSQShare.h"


@implementation NewsTableViewCell

- (void)cellDataWithModel:(NewsModel *)model {
    
    [self.myImage sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.titleLabel.text = model.title;
    self.time.text       = model.ptime;
    self.myImage.layer.masksToBounds   = YES;
    self.myImage.layer.cornerRadius    = 5;
    self.userImage.backgroundColor     = [UIColor blackColor];
    self.userImage.alpha               = 0.1;
//    self.userImage.layer.masksToBounds = YES;
//    self.userImage.layer.cornerRadius  = self.userImage.frame.size.height/2;
//    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.sectiontitle]];
//    [self.titleLabel shine];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (IBAction)collectAction:(UIButton *)sender {
//}
//- (IBAction)shareAction:(UIButton *)sender {
//    
//    NSLog(@"cell中");
//
////    MSQShare *shar = [[MSQShare alloc]init];
////    shar ShareToAll:<#(NSString *)#> image:<#(UIImage *)#> url:<#(NSString *)#> viewController:<#(UIViewController *)#>
//    
//}
@end
