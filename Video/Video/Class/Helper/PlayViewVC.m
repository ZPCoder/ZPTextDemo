//
//  PlayViewVC.m
//  Video
//
//  Created by 朱鹏 on 16/5/5.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "PlayViewVC.h"

@interface PlayViewVC ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIPanGestureRecognizer  *pan;
@property (nonatomic,strong) UITapGestureRecognizer  *fullTap;
@property (nonatomic,assign) BOOL                    panDirection;     //pan滑动方向是否为水平
@property (nonatomic,strong) MPMusicPlayerController *volume;
@property (nonatomic,strong) PlayViewController      *playViewController;
@property (nonatomic,strong) CAGradientLayer         *topGradient;     //顶部渐变色条
@property (nonatomic,strong) CAGradientLayer         *bottomGradient;  //底部渐变色条
@property (nonatomic,strong) UIImageView             *topImageView;    //用于盛放顶部渐变色条
@property (nonatomic,strong) UIImageView             *bottomImageView; //用于盛放底部渐变色条
@property (nonatomic,assign) BOOL                    isPlayer;        //标记是否播放
@property (nonatomic,strong) UIViewController        *fullPlayerView;  //全屏播放界面
@property (nonatomic,assign) CGRect                  smallRect;
@property (nonatomic,assign) BOOL                    isFullPlayer;    //用于判断是否是全屏播放
@property (nonatomic,strong) NSTimer                 *timer;
@end

@implementation PlayViewVC

- (UIButton *)rebroadcast {
    
    if (!_rebroadcast) {
        
        _rebroadcast = [UIButton buttonWithType:UIButtonTypeSystem];
        [_rebroadcast addTarget:self action:@selector(rebroadcastBTAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rebroadcast;
}

- (UIProgressView *)progressView {
    
    if (!_progressView) {
        
        _progressView = [[UIProgressView alloc]init];
        [self.rateSlider addSubview:_progressView];
        [_progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.rateSlider.mas_left).offset(0);
            make.top.equalTo(self.rateSlider.mas_top).offset(self.rateSlider.frame.size.height/2 - 10);
//            make.top.equalTo(self.rateSlider.mas_top).offset(20);

            make.right.equalTo(self.rateSlider.mas_right).offset(0);
            
        }];
        

    }
    return _progressView;
}

- (UIView *)mview {
    
    if (!_mview) {
        
        _mview = [[UIView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap:)];
        [_mview addGestureRecognizer:tap];
    }
    return _mview;
}

- (UIViewController *)fullPlayerView {
    
    if (!_fullPlayerView) {
        
        _fullPlayerView = [[UIViewController alloc]init];
        [_fullPlayerView.view addGestureRecognizer:self.pan];
        [_fullPlayerView.view addGestureRecognizer:self.fullTap];
        [self.pan requireGestureRecognizerToFail:self.fullTap];
        _fullPlayerView.view.userInteractionEnabled = YES;
    }
    return _fullPlayerView;
}

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
        _pan.delegate = self;
    }
    return _pan;
}

- (UITapGestureRecognizer *)fullTap {
    
    if (!_fullTap) {
        
        _fullTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap:)];
        _fullTap.delegate = self;
        
    }
    return _fullTap;
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



- (UISlider *)rateSlider {
    
    if (!_rateSlider) {
        
        _rateSlider = [[UISlider alloc]init];
        [_rateSlider addTarget:self action:@selector(rateSliderAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _rateSlider;
}

- (UIActivityIndicatorView *)activityView {
    
    if (!_activityView) {
        
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    }
    return _activityView;
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

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

//退出全屏，
- (void)ExitBTAction:(UIButton *)sender {
    
    PlayViewController *player = [PlayViewController shardPalyViewController];
    if ([sender.superview isEqual:self.fullPlayerView.view]) {
        
        [self.fullPlayerView dismissViewControllerAnimated:nil completion:nil];
        //将播放窗口重新添加到原来位置，将原有的控件展示层移隐藏掉（添加原有的控件显示层出现问题，frame有问题，重新新建了一个）重新添加一个新的控件展示层
        CGRect rect = self.smallRect;
        rect.origin.x = 0;
        rect.origin.y = 0;
        player.plaryLayer.frame = rect;
        self.view.hidden = YES;
        self.mview.frame = rect;
        
        [player.view.layer addSublayer:player.plaryLayer];
        [player.view addSubview:self.mview];
        
        //重新设置约束
        [self setFrameOfControllerWithPalyer:self.mview];
        [player pauseVideo];
    } else {
        
        [player pauseVideo];
        player.view.hidden = YES;
    }
    
}

//全屏按钮
- (void)fullScreenBTAction:(UIButton *)sender {
    
    if (!self.isFullPlayer) {
        
        PlayViewController *player = [PlayViewController shardPalyViewController];
        
//        CGFloat rect = player.smallPlay;
        
        self.smallRect   = player.smallPlay;
        
        [self.fullPlayerView.view.layer addSublayer:player.plaryLayer];
        
        //旋转屏幕，设置大小
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        self.fullPlayerView.view.transform = CGAffineTransformMakeRotation(M_PI/2);
        self.fullPlayerView.view.frame     = CGRectMake(0, 0, kScreenW, kScreenH);
        player.plaryLayer.frame        = CGRectMake(0, 0, kScreenH, kScreenW);
        player.plaryLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self presentViewController:self.fullPlayerView animated:nil completion:nil];
        self.view.frame = self.smallRect;
        
        //重新设置frame
        [self setFrameOfControllerWithPalyer:self.fullPlayerView.view];
        self.isFullPlayer = YES;

    }else {
        
        [self.fullPlayerView dismissViewControllerAnimated:nil completion:nil];
        
        //将播放窗口重新添加到原来位置，将原有的控件展示层移隐藏掉（添加原有的控件显示层出现问题，frame有问题，重新新建了一个）重新添加一个新的控件展示层
        
        CGRect rect = self.smallRect;
        rect.origin.x = 0;
        rect.origin.y = 0;
        PlayViewController *player = [PlayViewController shardPalyViewController];
        player.plaryLayer.frame   = rect;
        self.view.hidden = YES;
        self.mview.frame = rect;
        [player.view.layer addSublayer:player.plaryLayer];
        [player.view addSubview:self.mview];
        
        //重新设置约束
        [self setFrameOfControllerWithPalyer:self.mview];
        self.isFullPlayer = NO;

    }
    
}

//配置相关按钮
- (void)disposeView {
    
    
    //添加约束,固定frame
    [self setFrameOfControllerWithPalyer:self.view];
    
    //配置
//    [self.fullScreenBT setTitle:@"全屏" forState:UIControlStateNormal];
    [self.ExitBT       setTitle:@"X" forState:UIControlStateNormal];
    [self.rebroadcast   setTitle:@"重播" forState:UIControlStateNormal];
    
    
    //设置亮度显示条，将其旋转竖直放置，设置显示颜色和轨道颜色
    self.lightProgress.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.lightProgress.progressTintColor = [UIColor whiteColor];
    self.lightProgress.trackTintColor    = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    self.lightProgress.progress          = [UIScreen mainScreen].brightness;
    self.lightProgress.hidden            = YES;
    
    //缓存条
    self.progressView.progressTintColor    = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    self.progressView.trackTintColor       = [UIColor clearColor];
    
    
    self.time.text = @"00:00";
    self.rateSlider.value = 0;
    self.rateSlider.minimumValue = 0;
    self.rateSlider.minimumTrackTintColor = [UIColor whiteColor];
    self.rateSlider.maximumTrackTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
    [self.rateSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];

    
    [self.playbackBT setImage:[UIImage imageNamed:@"kr-video-player-play"] forState:UIControlStateNormal];
    [self.playbackBT setImage:[UIImage imageNamed:@"kr-video-player-pause"] forState:UIControlStateSelected];
    [self.fullScreenBT setImage:[UIImage imageNamed:@"kr-video-player-fullscreen"] forState:UIControlStateNormal];
//    [self.rebroadcast setImage:[UIImage imageNamed:@"chongbo"] forState:UIControlStateNormal];
    self.rebroadcast.hidden = YES;
//    [[UIImage imageNamed:@"chongbo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
}

//屏幕播放手动添加约束
- (void)setFrameOfControllerWithPalyer:(UIView *)view {
    
    if ([view isEqual:self.view]) {
        
        //添加按钮
        [self.view addSubview:self.lightProgress];
        [self.view addSubview:self.ExitBT];
        [self.view addSubview:self.playbackBT];
        [self.view addSubview:self.time];
        [self.view addSubview:self.allTime];
        [self.view addSubview:self.fullScreenBT];
        [self.view addSubview:self.rateSlider];
        [self.view addSubview:self.activityView];
        [self.view addSubview:self.rebroadcast];
        
        self.rateSlider.hidden = YES;
        self.playbackBT.hidden = YES;
        self.ExitBT.hidden     = YES;
        self.time.hidden       = YES;
        self.allTime.hidden    = YES;
        self.fullScreenBT.hidden = YES;
        
    }else if([view isEqual:self.fullPlayerView.view]){
        
        [self.fullPlayerView.view addSubview:self.lightProgress];
        [self.fullPlayerView.view addSubview:self.ExitBT];
        [self.fullPlayerView.view addSubview:self.playbackBT];
        [self.fullPlayerView.view addSubview:self.time];
        [self.fullPlayerView.view addSubview:self.allTime];
        [self.fullPlayerView.view addSubview:self.fullScreenBT];
        [self.fullPlayerView.view addSubview:self.rateSlider];
        [self.fullPlayerView.view addSubview:self.activityView];
        [self.fullPlayerView.view addSubview:self.rebroadcast];
        
    }else {
        
        [self.mview addSubview:self.lightProgress];
        [self.mview addSubview:self.ExitBT];
        [self.mview addSubview:self.playbackBT];
        [self.mview addSubview:self.time];
        [self.mview addSubview:self.allTime];
        [self.mview addSubview:self.fullScreenBT];
        [self.mview addSubview:self.rateSlider];
        [self.mview addSubview:self.activityView];
        [self.mview addSubview:self.rebroadcast];
        
    }
    [self.fullScreenBT mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(view.mas_right).offset(-10);
        make.bottom.equalTo(view.mas_bottom).offset(-10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    [self.lightProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(view.mas_top).offset(100);
        make.width.mas_equalTo(100);
    }];
    
    
    [self.ExitBT mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(view.mas_top).offset(10);
        make.right.equalTo(view.mas_right).offset(-10);
    }];
    
    if ([view isEqual:self.fullPlayerView.view]) {
        
        [self.playbackBT mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(view.mas_left).offset(kScreenH/2);
            make.top.equalTo(view.mas_top).offset(kScreenW/2);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];

    } else {
        
    [self.playbackBT mas_remakeConstraints:^(MASConstraintMaker *make) {

            make.centerY.equalTo(view.mas_centerY);
            make.centerX.equalTo(view.mas_centerX);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];

    }
    
    [self.activityView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
    }];
    [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(view.mas_bottom).offset(-30);
        make.left.equalTo(view.mas_left).offset(20);
    }];
    
    [self.allTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(view.mas_right).offset(-20);
        make.bottom.equalTo(view.mas_bottom).offset(-30);
    }];
    
    [self.rateSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(view.mas_right).offset(-100);
        make.left.equalTo(view.mas_left).offset(100);
        make.bottom.equalTo(view.mas_bottom).offset(-30);
    }];
    
    if ([view isEqual:self.fullPlayerView.view]) {
        
        [self.rebroadcast mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo (view.mas_left).offset(kScreenH/2);
            make.top.equalTo (view.mas_top).offset(kScreenW/2);
        }];
    }else{
    [self.rebroadcast mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo (view.mas_left).offset(kScreenW/2);
        make.top.equalTo (view.mas_top).offset(kScreenH/2);
    }];
    }

}


//滑竿控制视频进度
- (void)rateSliderAction:(UISlider *)sender {
    
    self.rebroadcast.hidden = YES;
    [self.playViewController sliderValueAndControlVideo:sender.value];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //为程序添加平移手势实现控制声音音量，屏幕亮度，视屏快进快退
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap:)];
    [self.view addGestureRecognizer:tap];
    
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


- (BOOL)shouldAutorotate {
    
    return NO;
}


- (void)panAction {
    
    //    //根据在view上Pan的位置，确定是调音量还是亮度
    //    CGPoint locationPoint = [pan locationInView:self];
    //
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [self.pan velocityInView:self.view];
    
    // 判断是垂直移动还是水平移动
    switch (self.pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
             NSLog(@"kaishi");
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
            NSLog(@"移动");
            switch (self.panDirection) { //水平移动
                case 1:{
                    
                    CGPoint point = [self.pan locationInView:self.view];
                    if (point.y > kScreenH/2 ) {
                        
                        [UIScreen mainScreen].brightness += veloctyPoint.x/10000;
                        self.lightProgress.progress       = [UIScreen mainScreen].brightness;
//                        NSLog(@"veloctyPoint.x/10000 %f",veloctyPoint.x/10000);
//                        NSLog(@"[UIScreen mainScreen].brightness %f",[UIScreen mainScreen].brightness);
                        
                    }else {
                        
                        [self setVolume:nil veloctyPoint:veloctyPoint];
                    }

                    break;
                }
                case 0:{ //垂直移动
                    
                    self.rateSlider.value += veloctyPoint.y / 1000;
                    [self.playViewController sliderValueAndControlVideo:self.rateSlider.value];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            
            [self performSelector:@selector(FullTimerAction) withObject:nil afterDelay:3];
            [self.timer fire];
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case 0:{
                    
                    break;
                }
                case 1:{
                    
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

//实现点击屏幕时出现所有的控件，三秒钟后消失
- (void)clickTap:(UITapGestureRecognizer *)tap {
    
//    //实现暂停或者播放
//    if (self.isPlayer) {
//        
//        [self.playViewController pauseVideo];
//        self.isPlayer =! self.isPlayer;
//    }else {
//        
//        [self.playViewController palyVideo];
//        self.isPlayer =! self.isPlayer;
//    }
//
    self.rateSlider.hidden = NO;
    self.allTime.hidden    = NO;
    self.time.hidden       = NO;
    self.fullScreenBT.hidden  = NO;
    self.playbackBT.hidden    = NO;
    self.ExitBT.hidden     = NO;
    
    [self performSelector:@selector(FullTimerAction) withObject:nil afterDelay:3];
}

//重播按钮方法
- (void)rebroadcastBTAction:(UIButton *)sender {
    
    self.rebroadcast.hidden = YES;
    PlayViewController *play = [PlayViewController shardPalyViewController];
    [play.player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        //开始播放
        if (finished) {
            [play.player play];
        }
    }];
}


//隐藏所有的按钮（延迟3秒执行使用）
- (void)FullTimerAction {
    
    self.rateSlider.hidden = YES;
    self.time.hidden       = YES;
    self.allTime.hidden    = YES;
    self.ExitBT.hidden     = YES;
    self.fullScreenBT.hidden  = YES;
    self.playbackBT.hidden    = YES;
    self.lightProgress.hidden = YES;
}




//声音设置调用方法
- (void)setVolume:(UIProgressView *)progress veloctyPoint:(CGPoint)point {
    
    if (point.x != 0) {
        
        self.volume.volume += (point.x / 10000);
    }
}



@end
