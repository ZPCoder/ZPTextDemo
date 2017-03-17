//
//  PlayViewVC.m
//  Video
//
//  Created by xalo on 16/5/5.
//  Copyright © 2016年 毛韶谦. All rights reserved.
//

#import "PlayViewVC.h"

@interface PlayViewVC ()

@property (nonatomic,strong) UIPanGestureRecognizer *pan;
@property (nonatomic,assign) BOOL                   panDirection;     //pan滑动方向是否为水平
@property (nonatomic,strong) MPMusicPlayerController *volume;
@property (nonatomic,strong) PlayViewController     *playViewController;
@property (nonatomic,strong) CAGradientLayer        *topGradient;     //顶部渐变色条
@property (nonatomic,strong) CAGradientLayer        *bottomGradient;  //底部渐变色条
@property (nonatomic,strong) UIImageView            *topImageView;    //用于盛放顶部渐变色条
@property (nonatomic,strong) UIImageView            *bottomImageView; //用于盛放底部渐变色条
@property (nonatomic,assign) BOOL                    isPlayer;        //标记是否播放
@end

@implementation PlayViewVC

+ (PlayViewVC *)shardPlayViewVC {
    
    static PlayViewVC *playViewVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken,^{
        
        playViewVC = [[PlayViewVC alloc]init];
    });
    return playViewVC;
}

- (UIPanGestureRecognizer *)pan {
    
    if (!_pan) {
        
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction)];
    }
    return _pan;
}

- (MPMusicPlayerController *)volume {
    
    if (!_volume) {
        
        _volume = [MPMusicPlayerController applicationMusicPlayer];
    }
    return _volume;
}

- (PlayViewController *)playViewController {
    
    if (!_playViewController) {
        
        _playViewController = [PlayViewController shardPalyViewController];
    }
    return _playViewController;
}

- (CAGradientLayer *)topGradient {
    
    if (!_topGradient) {
        
        _topGradient       = [CAGradientLayer layer];
        _topGradient.frame = self.topImageView.bounds;
        _topGradient.startPoint = CGPointMake(0, 0);
        _topGradient.endPoint   = CGPointMake(0, 1);
        _topGradient.colors     = @[(__bridge id) [UIColor colorWithRed:46 green:46 blue:46
                                                                  alpha:1] .CGColor,
                                    (__bridge id) [UIColor clearColor].CGColor];

    }
    return _topGradient;
}

- (CAGradientLayer *)bottomGradient {
    
    if (!_bottomGradient) {
        
        _bottomGradient       = [CAGradientLayer layer];
        _bottomGradient.frame = self.bottomImageView.bounds;
        _bottomGradient.startPoint = CGPointMake(0, 1);
        _bottomGradient.endPoint   = CGPointMake(0, 1);
        _bottomGradient.colors     = @[(__bridge id) [UIColor blackColor].CGColor,
                                       (__bridge id) [UIColor whiteColor].CGColor];
        _bottomGradient.locations  = @[@(0.7)];
    }
    return _bottomGradient;
}

- (UIImageView *)topImageView {
    
    if (!_topImageView) {
        
        _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _topImageView.alpha = 0.6;
    }
    return _topImageView;
}

-(UIImageView *)bottomImageView {
    
    if (!_bottomImageView) {
        
        _bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kNewsCellH-5, self.view.frame.size.width, 5)];
    }
    return _bottomImageView;
}

-(UIButton *)fullScreenBT {
    
    if (!_fullScreenBT) {
        
        _fullScreenBT = [UIButton buttonWithType:UIButtonTypeSystem];
        [_fullScreenBT addTarget:self action:@selector(fullScreenBTAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _fullScreenBT;
}


-(UILabel *)allTime {
    
    if (!_allTime) {
        
        _allTime = [[UILabel alloc]init];
    }
    return _allTime;
}

-(UILabel *)time {
    
    if (!_time) {
        
        _time = [[UILabel alloc]init];
    }
    return _time;
}


-(UIButton *)playbackBT {
    
    if (!_playbackBT) {
        
        _playbackBT = [UIButton buttonWithType:UIButtonTypeSystem];
        [_playbackBT addTarget:self action:@selector(playbackBTAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playbackBT;
}

-(UIButton *)ExitBT {
    
    if (!_ExitBT) {
        
        _ExitBT = [UIButton buttonWithType:UIButtonTypeSystem];
        [_ExitBT addTarget:self action:@selector(ExitBTAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ExitBT;
}

- (UIProgressView *)lightProgress {
    
    if (!_lightProgress) {
        
        _lightProgress = [[UIProgressView alloc]init];
    }
    return _lightProgress;
}


- (UIProgressView *)volumProgress {
    
    if (!_volumProgress) {
        
        _volumProgress = [[UIProgressView alloc]init];
        
    }
    return _volumProgress;
}

- (UISlider *)rateSlider {
    
    if (!_rateSlider) {
        
        _rateSlider = [[UISlider alloc]init];
        [_rateSlider addTarget:self action:@selector(rateSliderAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _rateSlider;
}

//播放按钮方法，实现暂停和播放
- (void)playbackBTAction:(UIButton *)sender {
    
    if (self.isPlayer) {
        
        [self.playViewController pauseVideo];
        self.isPlayer =! self.isPlayer;
    }else {
        
        [self.playViewController palyVideo];
        self.isPlayer =! self.isPlayer;
    }
}

//点击退出播放方法（出现界面白屏，通过视图层级没有移除掉cell和其他视图，why）同时出现不能第二次点击
- (void)ExitBTAction:(UIButton *)sender {
    
//    self.playViewController.item = nil;
//    [self.playViewController.player pause];
//    [self.playViewController.plaryLayer removeFromSuperlayer];
//    [self.playViewController.view removeFromSuperview];
//    [self.view removeFromSuperview];
    [self.playViewController recoverPalyWindowAndView];
    [self verticalOfControl];
//    NSArray *arry = self.view.subviews;
//    for (UIView *view in arry) {
//        
//        [self.view willRemoveSubview:view];
//    }
    
}


//滑竿控制视频进度
- (void)rateSliderAction:(UISlider *)sender {
    
     [self.playViewController sliderValueAndControlVideo:sender];
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self disposeView];
    
    //为程序添加平移手势实现控制声音音量，屏幕亮度，视屏快进快退
    [self.view addGestureRecognizer:self.pan];
    
    //为视图上添加渐变条
//    [self.topImageView.layer addSublayer:self.topGradient];
//    [self.bottomImageView.layer addSublayer:self.bottomGradient];
//    [self.view addSubview:self.topImageView];
//    [self.view addSubview:self.bottomImageView];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//配置相关按钮
- (void)disposeView {
    
    
    CGFloat width  = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    self.fullScreenBT.frame  = CGRectMake (width - 50, height - 40, 30, 30);
    self.lightProgress.frame = CGRectMake (width - 40, 40, 30, 100);
    self.volumProgress.frame = CGRectMake (40, 40, 30, 100);
    self.ExitBT.frame        = CGRectMake (width - 50, 20, 30, 30);
    self.allTime.frame       = CGRectMake (30, height - 60, 50, 30);
    self.rateSlider.frame    = CGRectMake (100, height - 60, 300, 30);
    self.time.frame          = CGRectMake (420, height - 60, 50, 30);
    self.playbackBT.frame    = CGRectMake (width/2, height/2, 50, 30);
//    self.playbackBT.center   = self.view.center;
    [self.view addSubview:self.fullScreenBT];
    [self.view addSubview:self.lightProgress];
    
    
    
    //配置位置信息
//    [self verticalOfControl];
    
    [self.fullScreenBT setTitle:@"全屏" forState:UIControlStateNormal];
    [self.ExitBT       setTitle:@"退出" forState:UIControlStateNormal];
    [self.playbackBT   setTitle:@"播放" forState:UIControlStateNormal];
    NSLog(@"NSStringFromCGRect %@",NSStringFromCGRect(self.view.frame));
    
    //添加按钮
    [self.view addSubview:self.volumProgress];
    [self.view addSubview:self.lightProgress];
    [self.view addSubview:self.ExitBT];
    [self.view addSubview:self.playbackBT];
    [self.view addSubview:self.time];
    [self.view addSubview:self.allTime];
    [self.view addSubview:self.fullScreenBT];
    [self.view addSubview:self.rateSlider];
    
    //设置声音显示条，将其旋转竖直放置，设置显示颜色和轨道颜色
    self.volumProgress.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.volumProgress.progressTintColor = [UIColor whiteColor];
    self.volumProgress.trackTintColor    = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    self.volumProgress.progress          = 0;
    [self setVolume:self.volumProgress veloctyPoint:CGPointZero];
    
    //设置亮度显示条，将其旋转竖直放置，设置显示颜色和轨道颜色
    self.lightProgress.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.lightProgress.progressTintColor = [UIColor whiteColor];
    self.lightProgress.trackTintColor    = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    self.lightProgress.progress          = 0;
    self.lightProgress.progress          = [UIScreen mainScreen].brightness;
    
    self.time.text = @"00:00";
    self.rateSlider.value = 0;
    self.rateSlider.minimumValue = 0;

}

//正常竖屏情况下各个空间的位置信息
- (void)verticalOfControl {
    
    CGFloat width  = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    //配置位置信息
    self.playbackBT.frame    = CGRectMake (width/2, height/2 - 300, 50, 30);
    self.volumProgress.frame = CGRectMake (20, 60, 30, 300);
    self.lightProgress.frame = CGRectMake (width - 50, 60, 30, 100);
    self.ExitBT.frame        = CGRectMake (width - 50, 5, 30, 50);
    self.allTime.frame       = CGRectMake (50, height - 580, 100, 30);
    self.rateSlider.frame    = CGRectMake (100, height - 580, 200, 30);
    self.time.frame          = CGRectMake (width - 110, height - 580, 100, 30);
    self.fullScreenBT.frame  = CGRectMake (width - 60, height - 570, 30, 30);

}


//当强制旋转屏幕后更改各个空间的位置
- (void)twittelatorChangerFamer {
    
    self.fullScreenBT.frame  = CGRectMake (550, 650, 30, 30);
    self.lightProgress.frame = CGRectMake (500, 500, 30, 100);
    self.volumProgress.frame = CGRectMake (100, 500, 30, 300);
    self.ExitBT.frame        = CGRectMake (20, 350, 30, 30);
    self.allTime.frame       = CGRectMake (20, 650, 30, 30);
    self.rateSlider.frame    = CGRectMake (80, 650, 400, 30);
    self.time.frame          = CGRectMake (500, 650, 100, 30);
    self.playbackBT.frame    = CGRectMake (300, 450, 50, 30);
}

- (void)fullScreenBTAction:(UIButton *)sender {
    
    //    点击全屏播放
    [self.playViewController setScreenRotation];
    //更改空间的位置
    [self twittelatorChangerFamer];
}


- (BOOL)shouldAutorotate {
    
    return NO;
}

- (void)panAction {
    
    //    //根据在view上Pan的位置，确定是调音量还是亮度
    //    CGPoint locationPoint = [pan locationInView:self];
    //
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [self.pan velocityInView:self.view];
    
    // 判断是垂直移动还是水平移动
    switch (self.pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                self.panDirection = YES;
                self.playViewController.isDragSlider = YES;
            }
            else if (x < y){ // 垂直移动
                self.panDirection = NO;
    
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case 1:{
                    
//                    PlayViewController *paly = [PlayViewController shardPalyViewController];
//                    [paly panControllerVolum:veloctyPoint.x / 20];
                    self.rateSlider.value += veloctyPoint.x / 100;

                    break;
                }
                case 0:{

                    CGPoint point = [self.pan locationInView:self.view];
                    if (point.x > self.view.frame.size.width/2 ) {
                        
                        self.lightProgress.hidden = NO;
                        [[UIScreen mainScreen] setBrightness: self.lightProgress.progress+(veloctyPoint.y / 100)];
                        self.lightProgress.progress -= veloctyPoint.y / 20000;

                    }else {
                        
                        self.lightProgress.hidden = NO;
                        [self setVolume:self.volumProgress veloctyPoint:veloctyPoint];
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case 0:{
                    
                    self.lightProgress.hidden = YES;
                    self.volumProgress.hidden = YES;
                    break;
                }
                case 1:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

//声音设置调用方法
- (void)setVolume:(UIProgressView *)progress veloctyPoint:(CGPoint)point {
    
    progress.progress -= point.y/20000;
    if (point.y != 0) {
        
        self.volume.volume = point.y / 100;
    }
}
//竖屏幕下约束
- (void)verticalViewRestraint {
    
    //    @property (nonatomic,strong) PlayViewController     *playViewController;
    //    @property (nonatomic,strong) CAGradientLayer        *topGradient;     //顶部渐变色条
    //    @property (nonatomic,strong) CAGradientLayer        *bottomGradient;  //底部渐变色条
    //    @property (nonatomic,strong) UIImageView            *topImageView;    //用于盛放顶部渐变色条
    //    @property (nonatomic,strong) UIImageView            *bottomImageView; //用于盛放底部渐变色条
    
    
    //    @property (weak, nonatomic) IBOutlet UIProgressView *volumProgress; //声音显示条
    //    @property (weak, nonatomic) IBOutlet UIProgressView *lightProgress; //屏幕亮度显示条
    //    @property (weak, nonatomic) IBOutlet UIButton       *ExitBT;        //退出观看按钮
    //    @property (weak, nonatomic) IBOutlet UIButton       *playbackBT;    //播放按钮
    //    @property (weak, nonatomic) IBOutlet UISlider       *rateSlider;    //播放进度条
    //    @property (weak, nonatomic) IBOutlet UILabel        *time;          //当前播放时间
    //    @property (weak, nonatomic) IBOutlet UILabel        *allTime;       //播放总时间
    //    @property (weak, nonatomic) IBOutlet UIButton       *fullScreenBT;  //全屏按钮
    
    
    
    //    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.equalTo(self.view.mas_left).offset(0);
    ////        make.right.equalTo(self.view.mas_right).offset(0);
    ////        make.top.equalTo(self.view.mas_top).offset(0);
    //        make.height.mas_equalTo(10);
    //    }];
    //    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.equalTo(self.view.mas_left).offset(0);
    //        make.right.equalTo(self.view.mas_right).offset(0);
    //        make.top.equalTo(self.view.mas_bottom).offset(0);
    //        make.height.mas_equalTo(10);
    //    }];
    //    [self.volumProgress mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.equalTo(self.view.mas_left).offset(30);
    ////        make.right.equalTo(self.view.mas_right).offset(0);
    //        make.top.equalTo(self.view.mas_bottom).offset(30);
    //        make.height.mas_equalTo(100);
    //    }];
    //    [self.lightProgress mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    ////        make.left.equalTo(self.view.mas_left).offset(30);
    //                make.right.equalTo(self.view.mas_right).offset(30);
    //        make.top.equalTo(self.view.mas_bottom).offset(30);
    //        make.height.mas_equalTo(100);
    //    }];
    //
    //    [self.ExitBT mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.equalTo(self.view.mas_left).offset(30);
    //                make.right.equalTo(self.view.mas_right).offset(30);
    ////        make.top.equalTo(self.view.mas_bottom).offset(30);
    ////        make.height.mas_equalTo(100);
    //    }];
    //    [self.playbackBT mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.equalTo(self.view.mas_left).offset(20);
    ////        make.right.equalTo(self.view.mas_right).offset(30);
    //                make.top.equalTo(self.view.mas_bottom).offset(10);
    //        //        make.height.mas_equalTo(100);
    //    }];
    //
    //    [self.rateSlider mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.equalTo(self.view.mas_left).offset(50);
    //        //        make.right.equalTo(self.view.mas_right).offset(30);
    //        make.top.equalTo(self.view.mas_bottom).offset(40);
    //                make.width.mas_equalTo(300);
    //    }];
    //
    //
    //    [self.allTime mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.equalTo(self.view.mas_left).offset(80);
    //        //        make.right.equalTo(self.view.mas_right).offset(30);
    //        make.top.equalTo(self.view.mas_bottom).offset(40);
    //        //        make.height.mas_equalTo(100);
    //    }];
    //
    //    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    ////        make.left.equalTo(self.view.mas_left).offset(80);
    //                make.right.equalTo(self.view.mas_right).offset(30);
    //        make.top.equalTo(self.view.mas_bottom).offset(40);
    //        //        make.height.mas_equalTo(100);
    //    }];
    //
    //    [self.fullScreenBT mas_makeConstraints:^(MASConstraintMaker *make) {
    //        
    //        //        make.left.equalTo(self.view.mas_left).offset(80);
    //        make.right.equalTo(self.view.mas_right).offset(10);
    //        make.top.equalTo(self.view.mas_bottom).offset(10);
    //        //        make.height.mas_equalTo(100);
    //    }];
}


@end
