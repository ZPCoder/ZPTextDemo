//
//  PlayViewController.m
//  Video
//
//  Created by xalo on 16/5/3.
//  Copyright © 2016年 毛韶谦. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>

@interface PlayViewController ()

@property (nonatomic,strong) UITableView     *tableView;       //接收传进来的tableview
@property (nonatomic,strong) UIViewController *viewController; //接收传递过来的控制器
@property (nonatomic,strong) NewsModel      *model;            //接收传递过来的数据
@property (nonatomic,assign) CGFloat        contentsetY;
@property (nonatomic,assign) CGFloat        offsetY;           //用来记录tableview的偏移量
@property (nonatomic,strong) NSString       *url;
@property (nonatomic,strong) PlayViewVC     *playViewVC;       //播放窗口上的按钮显示界面
@property (nonatomic,strong) NSTimer        *timer;            //定时器，刷新视频的显示时间
@property (nonatomic,assign) CGFloat        totalTime;         //视屏的总长度
@property (nonatomic,assign) CGFloat        currenTime;        //当前播放时间
@property (nonatomic,assign) CGRect         smallFrame;        //记录屏幕旋转之前的大小
@property (nonatomic,assign) CGRect         bigFrame;          //记录屏幕要改变的大小
@property (nonatomic,assign) CGFloat        upDownOffsetY;     //用来存储下拉播放窗口回帖时的tableview的偏移量
@property (nonatomic,strong) NSIndexPath    *indexPath;        //用来存储下标，使用于回拉播放窗口重新贴回cell
@property (nonatomic,strong) UITableViewCell *cell;            //存储传递过来的cell
@end

@implementation PlayViewController

//将此类设置为单例
+ (PlayViewController *)shardPalyViewController {
    
    static PlayViewController *playView = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken,^{
        
        playView = [[PlayViewController alloc]init];
    });
    return playView;
}
#pragma mark --------------------所有懒加载
//懒加载
-(AVPlayer *)player {
    
    if (!_player) {
        
        _player = [[AVPlayer alloc]init];
    }
    return _player;
}

-(AVPlayerItem *)item {
    
    if (!_item) {
        
        _item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:self.url]];
    }
    return _item;
}

- (AVPlayerLayer *)plaryLayer {
    
    if (!_plaryLayer) {
        
        _plaryLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    }
    return _plaryLayer;
}

- (PlayViewVC *)playViewVC {
    
    if (!_playViewVC) {
        
        _playViewVC = [PlayViewVC shardPlayViewVC];
    }
    
    return _playViewVC;
}

-(NSTimer *)timer {
    
    if (_timer) {
        
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return _timer;
}


//播放网络视频
- (void)playVideoAtCell:(UITableViewCell *)cell url:(NSString *)url tableView:(UITableView *)tableView  contentsetY:(CGFloat)contentsetY  viewController:(UIViewController *)viewController indexPath:(NSIndexPath *)indexPath {
    
    self.contentsetY   = contentsetY;
    self.tableView     = tableView;
    self.viewController = viewController;
    self.url = url;
    self.indexPath    = indexPath;
    
    //暂停播放，并将播放窗口从原cell上移除
    [self.player pause];
    [self.plaryLayer removeFromSuperlayer];
    [self.view removeFromSuperview];
    
    //从网络加载视频，并添加到cell显示层
    self.item       = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:url]];
    [self.plaryLayer setPlayer:self.player];
    [self.player replaceCurrentItemWithPlayerItem:self.item];
    self.plaryLayer.frame = CGRectMake(5, 5, cell.frame.size.width-10, cell.frame.size.height-10);
    
    //保存屏幕放大前和放大后的大小
    self.bigFrame   = self.view.frame;
    self.smallFrame = self.plaryLayer.frame;
    
    //将播放窗口添加到tableview上
    self.view.frame = CGRectMake(0, cell.origin.y, cell.frame.size.width, cell.frame.size.height);
    [self.view.layer addSublayer:self.plaryLayer];
    [tableView addSubview:self.view];
    
    //将按钮显示层添加到tableview上
    self.playViewVC.view.frame = CGRectMake(0, cell.origin.y, cell.frame.size.width, cell.frame.size.height);
    NSLog(@"cell.frame.size.height %f",cell.frame.size.height);
    NSLog(@"elf.playViewVC.view.fram %@",NSStringFromCGRect( self.playViewVC.view.frame));
    [self.playViewVC disposeView];
    self.playViewVC.view.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
    [tableView addSubview:self.playViewVC.view];
    
    //添加观察者，实现观察contentOffset实现
    [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    self.plaryLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //直接播放（待优化）
    [self.player play];
    //开启定时器刷新视屏播放时间
    [self startTimer];
}

#pragma mark -----------播放窗口的悬浮和回贴复原
//在方法中实现cell.frame.origin.y上下滑动的到顶部时，播放框悬浮在顶部,下拉往回后实现重新贴在cell上
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
        //如果是下拉执行此方法
        CGPoint newPoint = [change [NSKeyValueChangeNewKey]CGPointValue];
        
        //通过偏移量区分tableview的滑动方向，因为下拉重新贴在对应位置的cell上时，在cell即将出现的方法中执行重新贴时，悬浮和贴重复执行造成贴不上，通过滑动方向防止误操作，让悬浮方法只在向上滑动时开启
        if (newPoint.y < 0 || newPoint.y - self.offsetY > 0) {
            
            PlayViewController *play = [PlayViewController shardPalyViewController];
            //    通过判断总体偏移量和当前位置，实现到达顶部悬浮
            if (newPoint.y + 65 >= self.contentsetY) {
                
                play.view.frame  = CGRectMake(0, 65, 100, 500);
                [self.viewController.view addSubview:play.view];
                
                CGRect frame = self.playViewVC.view.frame;
                frame.origin.x = 0;
                frame.origin.y = 65;
                self.playViewVC.view.frame = frame;
                [self.viewController.view addSubview:self.playViewVC.view];
                }
            
        }else if (self.upDownOffsetY - newPoint.y >= 200){//此处用于播放视图的回帖，当视图完全出现的时候，在将播放窗口贴在cell上
            //将播放窗口和按钮界面全部回帖到cell上
            PlayViewController *play   = [PlayViewController shardPalyViewController];
            play.view.frame            = CGRectMake(0, self.contentsetY, self.cell.frame.size.width, self.cell.frame.size.height);
            self.playViewVC.view.frame = CGRectMake(0, self.contentsetY, self.cell.frame.size.width, self.cell.frame.size.height);
            [self.tableView addSubview:play.view];
            [self.tableView addSubview:self.playViewVC.view];

        }
    self.offsetY = newPoint.y;
    
}

//回拉实现对应的播放窗口重新贴在对应的cell上
- (void)pullDownCellAddPlay:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    self.cell = cell;
    //    使用记录的原cell的indexPath和现在的indexPath做比较，如果相同重新改变播放窗口的父视图（加载在tableview上，实现移动）
    if (self.indexPath == indexPath) {
        
        //记录tableview的偏移量，并调用监听，为实现当cell底部刚出现的时候不将播放窗口与原cell对其贴加，以免造成播放窗口消失。调用监听实现cell完全出现的时候再将播放窗口添加
        self.upDownOffsetY = self.tableView.contentOffset.y;
        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

//播放视屏
- (void)palyVideo {
    
    [self.player play];
}

//暂停视屏播放
- (void)pauseVideo {
    
    [self.player pause];
}

#pragma mark ------------配置播放窗口上的相关功能，声音控制，亮度控制，快进快退，全屏，退出全屏等功能
#pragma mark -----滑竿进度时间控制相关方法

//滑竿时间显示，并更新滑竿进度
- (void)sliderRate:(UISlider *)slider {
    
    //计算视频总时长，并赋值给显示时长的label
    if (self.totalTime == 0) {
    
        [self allTimeOfTextLabel:slider];
    }
    
    //当前时间
    CMTime time   = self.player.currentTime;
    CGFloat total = time.value / time.timescale;
    
    //计算秒数 分钟 并添加到label上显示
    NSInteger proSec = (NSInteger) total%60;
    NSInteger proMin = (NSInteger) total/60;
    self.playViewVC.allTime.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    
    //设置滑竿的位置，让其随着时间更新
    slider.value =  total;
}

//计算当前时间
- (CGFloat)nowTimeofVolme {
    
    //    当前时间
    CMTime time   = self.player.currentTime;
    CGFloat total = time.value / time.timescale;
    
    //计算秒数 分钟 并添加到label上显示
    NSInteger proSec = (NSInteger) total%60;
    NSInteger proMin = (NSInteger) total/60;
    self.playViewVC.allTime.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];

    return total;
}

//计算总时间
- (void)allTimeOfTextLabel:(UISlider *)slider {
    
    //总时间
    CMTime allTime    = self.item.duration;
    //判断如果allTime.value为0不让执行，否则崩溃，安全措施，
    if (allTime.value == 0) {
        return;
    }
    
    CGFloat totalAll = allTime.value / allTime.timescale;
    //计算秒数 分钟数 并显示在label上
    NSInteger proSecAll = (NSInteger)totalAll % 60;
    NSInteger proMinAll = (NSInteger)totalAll / 60;
    self.playViewVC.time.text   =  [NSString stringWithFormat:@"%02zd:%02zd", proMinAll,proSecAll];
    slider.maximumValue = totalAll;
}

//开启定时器
- (void)startTimer {
    
    //    如果当前定时器被初始化就不在初始化
    //如果当前timer已经被初始化后不再去初始化
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}


//定时器触发事件
- (void)timerAction {
    
    [self sliderRate:self.playViewVC.rateSlider];
}

//设置滑竿的最大值最小值
- (void)setSlider:(UISlider *)slider {
    
    slider.value        = 0;
    slider.minimumValue = 0;
}

//滑动滑块控制视频进度
- (void)sliderValueAndControlVideo:(UISlider *)slider {
    
    //滑动暂停播放
    [self pauseVideo];
    //从指定时间开始播放
    [self.player seekToTime:CMTimeMake(slider.value, 1) completionHandler:^(BOOL finished) {
        //开始播放
        if (finished) {
            [self palyVideo];
        }
    }];
}

#pragma mark -------------手势控制视频进度
//手势控制视频进度
- (void)panControllerVolum:(CGFloat)value {
    
    [self.timer setFireDate:[NSDate distantFuture]];
    [self pauseVideo];
    
    CGFloat timer = [self nowTimeofVolme];
    [self.player seekToTime:CMTimeMake(timer + value/1000, 1) completionHandler:^(BOOL finished) {
        
        if (finished) {
            
            [self player];
            [self.timer fire];
        }
    }];
}


#pragma mark -------------屏幕放大缩小方法
//设置屏幕放大旋转
- (void)setScreenRotation {
    
    //    设置所有目前显示的view旋转
    //将播放显示播放画面的view和layer旋转并改变大小
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    self.smallFrame = self.view.frame;
    self.view.transform   = CGAffineTransformMakeRotation(M_PI/2);
    self.view.frame       = CGRectMake(0, 0, kScreenW, kScreenH);
    self.plaryLayer.frame = CGRectMake(0, 0, kScreenH, kScreenW);
    self.plaryLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //将盛放播放控制键的view旋转并改变大小
    self.playViewVC.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    self.playViewVC.view.frame     = CGRectMake(0, 0, kScreenH, kScreenW);
    
    //将对应的导航控制器导航条，tabbar旋转并隐藏
}

//播放窗口复原
- (void)recoverPalyWindowAndView {
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationUnknown];
    self.view.transform = CGAffineTransformMakeRotation(M_PI*2);
    self.view.frame     = self.smallFrame;
    CGRect rect         = self.smallFrame;
    rect.origin.x       = 0;
    rect.origin.y       = 0;
    self.plaryLayer.frame = rect;
    
    self.playViewVC.view.transform = CGAffineTransformMakeRotation(M_PI*2);
    self.playViewVC.view.frame     = self.smallFrame;
}


- (BOOL)shouldAutorotate {
    
    return NO;
}





- (void)dealloc {
    
    [self.timer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




//定时器为注销（在获得缓存后开启定时器） 定时器移除, 声音音量， 全屏  缓存 安全措施





@end
