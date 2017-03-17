//
//  PlayViewVC.h
//  Video
//
//  Created by 朱鹏 on 16/5/5.
//  Copyright © 2016年 朱鹏 All rights reserved.


#import <UIKit/UIKit.h>

@protocol PlayViewDelegate <NSObject>

- (void)playOrSuspend:(BOOL)sender;
@end

@interface PlayViewVC : UIViewController



+ (PlayViewVC *)shardPlayViewVC;                                    //单例


@property (nonatomic,strong)  UIProgressView         *lightProgress;  //屏幕亮度显示条
@property (nonatomic,strong)  UIButton               *ExitBT;        //退出观看按钮
@property (nonatomic,strong)  UIButton               *playbackBT;    //播放按钮
@property (nonatomic,strong)  UISlider               *rateSlider;    //播放进度条
@property (nonatomic,strong)  UILabel                *time;          //当前播放时间
@property (nonatomic,strong)  UILabel                *allTime;       //播放总时间
@property (nonatomic,strong)  UIButton               *fullScreenBT;  //全屏按钮
@property (nonatomic,strong)  UIView                 *mview;
@property (strong, nonatomic) UIProgressView         *progressView;
@property (nonatomic,weak) id<PlayViewDelegate>      delegate;       //点击屏幕后判断是否暂停
@property (nonatomic,strong) UIActivityIndicatorView *activityView; //小菊花
@property (nonatomic,strong) UIButton                *rebroadcast;   //重播按钮
- (void)disposeView;

@end
