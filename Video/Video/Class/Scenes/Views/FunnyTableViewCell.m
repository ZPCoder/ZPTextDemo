//
//  FunnyTableViewCell.m
//  FunnyDemo
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "FunnyTableViewCell.h"

@implementation FunnyTableViewCell

//播放按钮
- (IBAction)playBtn:(UIButton *)sender {
    NSLog(@"点击播放按钮");
    sender.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(lsbuttonSelectAction:)]) {

        [self.delegate lsbuttonSelectAction:sender];
    }
}

-(void)setCellWithModel:(FunnyModel *)model{

    self.text.text = model.text;
    if (model.gif) { //如果是gif类型
        NSArray *gifArray = model.gif[@"gif_thumbnail"];

        NSString *gifStr = [NSString stringWithFormat:@"%@",gifArray.firstObject];

        [self.videoImageVIew sd_setImageWithURL:[NSURL URLWithString:gifStr]];
        
        //隐藏视频LOGO
        self.playBtn.hidden = YES;
        self.gifImageView.hidden  = NO;

    }else if (model.image){//如果是图片类型

        NSArray *imageArray = model.image[@"big"];

        //判断图片大小 裁剪占位图片frame
        CGFloat height = [model.image[@"height"]floatValue];
        if (height > kHeight) {

            NSURL *strURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imageArray.firstObject]];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{

                UIImageView *tempImageView = [[UIImageView alloc]init];
                [tempImageView sd_setImageWithURL:strURL];
                while (!tempImageView.image) {
                
                    [tempImageView sd_setImageWithURL:strURL];

                    if (tempImageView.image) {
                        break;
                    }
                }
                tempImageView.userInteractionEnabled = YES;
                UIImage *tempImage = [self imageFromImage:tempImageView.image inRect:CGRectMake(0, 0, kWidth*3, kHeight)];

                dispatch_async(dispatch_get_main_queue(), ^{

                    self.videoImageVIew.image = tempImage;

                    self.gifImageView.hidden = YES;
                    self.playBtn.hidden = YES;

                });

            });

        }else{  //大小合适直接使用

            [self.videoImageVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageArray.firstObject]]];
            //隐藏另外两张LOGO图
            self.gifImageView.hidden = YES;
            self.playBtn.hidden = YES;

        }

    } else{  //如果是视频类型

        NSArray *array =model.video[@"thumbnail"];
        NSString *videoStr = [NSString stringWithFormat:@"%@",array.firstObject];
/*
//        [self.videoImageVIew sd_setImageWithURL:[NSURL URLWithString:videoStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//            self.videoWidth = image.size.width;
//            self.videoHeight = image.size.height;
////        调整图片大小 ---缩略图
//
////            if (height>240) {
////                height = 240;
////                width = kWidth*240/kHeight;
////                self.videoImageVIew.frame = CGRectMake(0, 0, width, height);
////            }
//
//        }];
//        //手动约束
//        [self.videoImageVIew mas_remakeConstraints:^(MASConstraintMaker *make) {
////            make.top.equalTo(self.contentView.mas_top).with.offset(10);
////            make.left.equalTo(self.contentView.mas_left).with.offset(100);
////            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
////            make.right.equalTo(self.contentView.mas_right).with.offset(-100);
//            make.centerX.equalTo(self.contentView.mas_centerX);
//            make.centerY.equalTo(self.contentView.mas_centerY);
//            make.width.mas_equalTo(self.videoWidth);
//            make.height.mas_equalTo(self.videoHeight);
//        }];
 */
        [self.videoImageVIew sd_setImageWithURL:[NSURL URLWithString:videoStr]];
        //隐藏gifLOGO
        self.gifImageView.hidden = YES;
        self.playBtn.hidden = NO;

    }
}

/**截取图片的方法*/
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

#pragma mark --懒加载
- (UIImageView *)videoImageVIew {
    if (!_videoImageVIew) {
        _videoImageVIew = [[UIImageView alloc] init];
        [self.contentView addSubview:_videoImageVIew];

        [_videoImageVIew mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        }];
    }
    return _videoImageVIew;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
