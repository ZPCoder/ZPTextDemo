//
//  PlayViewVC.h
//  Video
//
//  Created by xalo on 16/5/5.
//  Copyright © 2016年 毛韶谦. All rights reserved.


#import <UIKit/UIKit.h>

@interface PlayViewVC : UIViewController

+ (PlayViewVC *)shardPlayViewVC;                             //单例

@property (nonatomic,strong)  UIProgressView *volumProgress; //声音显示条
@property (nonatomic,strong)  UIProgressView *lightProgress; //屏幕亮度显示条
@property (nonatomic,strong)  UIButton       *ExitBT;        //退出观看按钮
@property (nonatomic,strong)  UIButton       *playbackBT;    //播放按钮
@property (nonatomic,strong)  UISlider       *rateSlider;    //播放进度条
@property (nonatomic,strong)  UILabel        *time;          //当前播放时间
@property (nonatomic,strong)  UILabel        *allTime;       //播放总时间
@property (nonatomic,strong)  UIButton       *fullScreenBT;  //全屏按钮

- (void)disposeView;

@end
