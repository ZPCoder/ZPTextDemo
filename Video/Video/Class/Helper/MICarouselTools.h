//
//  LHICarouselTools.h
//  DemoText
//
//  Created by 朱鹏 on 16/4/4.
//  Copyright © 2016年 朱鹏 All rights reserved.
//
@class iCarousel;
#import <UIKit/UIKit.h>

typedef void (^selectedImageViewTag)(NSInteger);
typedef void (^currentImageViewTag)(NSInteger);

@interface MICarouselTools : UIView

//点击的图片
@property (copy, nonatomic) selectedImageViewTag seletedImageViewTag;
//当前图片
@property (copy, nonatomic) currentImageViewTag currentImageViewTag;

//根据一组视图初始化一个木马旋转视图
- (instancetype)initWithFrame:(CGRect)frame photosArray:(NSArray<UIImageView *> *)photosArray titleArray:(NSArray<NSString *> *)titleArray;

//根据一组视图的URL初始化一个木马旋转视图
- (instancetype)initWithFrame:(CGRect)frame photosURLArray:(NSArray<NSURL *> *)photosURLArray titleArray:(NSArray<NSString *> *)titleArray;

@end
