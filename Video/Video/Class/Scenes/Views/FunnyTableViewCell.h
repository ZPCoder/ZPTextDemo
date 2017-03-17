//
//  FunnyTableViewCell.h
//  FunnyDemo
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 LS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FunnyModel;

@protocol lsTransSelectionAction <NSObject>

- (void)lsbuttonSelectAction:(UIButton *)sender;

@end

@interface FunnyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *text;

@property (weak, nonatomic) IBOutlet UIImageView *videoImageVIew;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UILabel *gifImageView;

//获取图片大小
@property (nonatomic,assign)CGFloat videoWidth;

@property (nonatomic,assign)CGFloat videoHeight;

-(void)setCellWithModel:(FunnyModel *)model;

//协议
@property (assign, nonatomic) id<lsTransSelectionAction>delegate;

@end
