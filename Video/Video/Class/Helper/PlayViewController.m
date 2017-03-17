//
//  PlayViewController.m
//  Video
//
//  Created by 朱鹏 on 16/5/3.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>

//播放器的几种状态
typedef NS_ENUM(NSInteger, ZFPlayerState) {
    ZFPlayerStateBuffering,  //缓冲中
    ZFPlayerStatePlaying,    //播放中
    ZFPlayerStateStopped,    //停止播放
    ZFPlayerStatePause       //暂停播放
};


@interface PlayViewController ()<PlayViewDelegate>


@property (nonatomic,strong) UIViewController *viewController; //接收传递过来的控制器
@property (nonatomic,strong) NewsModel      *model;            //接收传递过来的数据
@property (nonatomic,assign) CGFloat        contentsetY;
@property (nonatomic,assign) CGFloat        offsetY;           //用来记录tableview的偏移量
@property (nonatomic,strong) NSString       *url;

@property (nonatomic,strong) NSTimer        *timer;            //定时器，刷新视频的显示时间
@property (nonatomic,assign) CGFloat        totalTime;         //视屏的总长度
@property (nonatomic,assign) CGFloat        currenTime;        //当前播放时间
@property (nonatomic,assign) CGRect         smallFrame;        //记录屏幕旋转之前的大小
@property (nonatomic,assign) CGRect         bigFrame;          //记录屏幕要改变的大小
@property (nonatomic,assign) CGFloat        upDownOffsetY;     //用来存储下拉播放窗口回帖时的tableview的偏移量
@property (nonatomic,strong) NSIndexPath    *indexPath;        //用来存储下标，使用于回拉播放窗口重新贴回cell

@property(nonatomic,assign)  ZFPlayerState   playState;
@property (nonatomic,retain)NSMutableArray* array;
@property (nonatomic,retain)NSArray*kk;
/** 是否被用户暂停 */
@property (nonatomic,assign) BOOL    isPauseByUser;

@end

@implementation PlayViewController


- (NSMutableArray*)array{
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}
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
        [_plaryLayer setPlayer:self.player];
    }
    return _plaryLayer;
}

- (PlayViewVC *)playViewVC {
    
    if (!_playViewVC) {
        
        _playViewVC = [PlayViewVC shardPlayViewVC];
        _playViewVC.delegate = self;
    }
    
    return _playViewVC;
}

-(NSTimer *)timer {
    
    if (_timer) {
        
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return _timer;
}


//添加监听
- (void)addObserverWithPlayerItem {
    
    //监听播放状态
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew  context:nil];
    //监听加载情况，使用于缓存条的展示
//    [self.player addObserver:self forKeyPath:@"currentTime" options: NSKeyValueObservingOptionNew context:nil];
    [self.item addObserver:self forKeyPath:@"loadedTimeRanges" options: NSKeyValueObservingOptionNew context:nil];
    //监听是缓存是否为空
    [self.item addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew  context:nil];
    //监听是否缓存继续
    [self.item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options: NSKeyValueObservingOptionNew context:nil];
    
}

- (NSArray*)kk{
    if (!_kk) {
        _kk = [[NSArray alloc] initWithObjects:@"status",@"loadedTimeRanges",@"playbackBufferEmpty",@"playbackLikelyToKeepUp", nil];
    }
    return _kk;
}

- (void)removeObserveWithPlayerItem {
    
    [self.item removeObserver:self forKeyPath:@"status"];
    [self.item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.item removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.item removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
}

//普通播放
- (void)commonPlay:(UIViewController *)viewController playFrame:(CGRect)frame urlWithString:(NSString *)url title:(NSString *)titel imageUrl:(NSString *)imageUrl{
    
    self.view.hidden = NO;
    self.playViewVC.mview.hidden = NO;
    self.plaryLayer.hidden       = NO;
    self.playViewVC.view.hidden = NO;
    
//    play.playViewVC.mview.hidden = YES;
//    play.plaryLayer.hidden       = YES;
//    play.playViewVC.view.hidden  = YES;
//    play.view.hidden             = YES;
    self.playViewVC.rebroadcast.hidden = YES;
    self.playViewVC.progressView.progress = 0;
    //播放记录持久化；
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:[MSQFileReadAndWriteTools readArrayWithFilePath:kPlayRecord]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:titel ,@"title", imageUrl, @"imageUrl", url, @"url",[CollectManager dateToStringWhitDate],@"time", nil];
    [mArray addObject:dic];
    [MSQFileReadAndWriteTools writeArray:mArray toFilePath:kPlayRecord];
    [mArray removeAllObjects];
    mArray = nil;
    self.view.hidden = NO;
    for (NSString* k in self.kk) {
        if (_array && ![self.array containsObject:k]) {
            [self.item removeObserver:self forKeyPath:k];
        }
    }
    
    [self.array removeAllObjects];
    
//    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:@""]];
//    [self.player replaceCurrentItemWithPlayerItem:item];
    
    self.smallPlay = frame;
    self.item       = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:url]];
    [self.player replaceCurrentItemWithPlayerItem:self.item];
    self.plaryLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [viewController.view.layer addSublayer:self.plaryLayer];
    
    [self addObserverWithPlayerItem];
    
    self.view.frame = frame;
    [self.view.layer addSublayer:self.plaryLayer];
    
    //设置控件展示层不隐藏（在屏幕旋转的时候出现展示层frame更改无效，所以重新新建了view，并将此view隐藏，每次更换播放展示）
    self.playViewVC.view.hidden = NO;
    self.playViewVC.view.frame = self.view.bounds;
    
    //在更改了空间展示层的frame之后添加相关的控制按钮
    
//        [self.playViewVC disposeView];

    
    
    self.playViewVC.view.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
    
    self.plaryLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view addSubview:self.playViewVC.view];
    [viewController.view addSubview:self.view];
    [self palyVideo];
    
    self.playState = ZFPlayerStatePlaying;
    [self.playViewVC.activityView startAnimating];
    
    //开启定时器刷新视屏播放时间
    [self startTimer];

}


//tableview上播放网络视频
- (void)playVideoAtCell:(UITableViewCell *)cell url:(NSString *)url tableView:(UITableView *)tableView  contentsetY:(CGFloat)contentsetY  viewController:(UIViewController *)viewController indexPath:(NSIndexPath *)indexPath  title:(NSString *)titel imageUrl:(NSString *)imageUrl {
    

    self.view.hidden = NO;
    self.playViewVC.mview.hidden = NO;
    self.plaryLayer.hidden       = NO;
    self.playViewVC.view.hidden = NO;

    self.playViewVC.rebroadcast.hidden = YES;
    self.view.frame = cell.frame;
    self.playViewVC.progressView.progress = 0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //播放记录持久化；
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:[MSQFileReadAndWriteTools readArrayWithFilePath:kPlayRecord]];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:titel ,@"title", imageUrl, @"imageUrl", url, @"url",[CollectManager dateToStringWhitDate],@"time", nil];
        [mArray addObject:dic];
        [MSQFileReadAndWriteTools writeArray:mArray toFilePath:kPlayRecord];
        [mArray removeAllObjects];
        mArray = nil;
    });
    
    self.view.hidden = NO;

    self.contentsetY   = contentsetY;
    self.tableView     = tableView;
    self.viewController = viewController;
    self.url = url;
    self.indexPath    = indexPath;
    self.smallPlay    = cell.frame;
    

    
        //暂停播放，并将播放窗口从原cell上移除
        [self pauseVideo];
        [self.plaryLayer removeFromSuperlayer];
        [self.view removeFromSuperview];
        for (NSString* k in self.kk) {
            if (_array && ![self.array containsObject:k]) {
                [self.item removeObserver:self forKeyPath:k];
            }
        }
        
        [self.array removeAllObjects];
        
        self.item = nil;

        //从网络加载视频，添加到tableview,并添加监听
        self.item       = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:url]];
        [self.player replaceCurrentItemWithPlayerItem:self.item];
        
        //添加监听
        [self addObserverWithPlayerItem];
    

    
    
//    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:@""]];
//    [self.player replaceCurrentItemWithPlayerItem:item];
    
    //将播放窗口添加到tableview上
    self.plaryLayer.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);

    [self.view.layer addSublayer:self.plaryLayer];
    
    //设置控件展示层不隐藏（在屏幕旋转的时候出现展示层frame更改无效，所以重新新建了view，并将此view隐藏，每次更换播放展示）
    self.playViewVC.view.hidden = NO;
    self.playViewVC.view.frame = self.view.bounds;
    

    //添加观察者，实现观察contentOffset
    [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    self.plaryLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //将控件展示层添加到播放层上之后，将播放层添加到tableview上
    [self.view addSubview:self.playViewVC.view];
    [tableView addSubview:self.view];
    
    //直接播放（待优化）
    [self palyVideo];
    
    self.playState = ZFPlayerStatePlaying;
    [self.playViewVC.activityView startAnimating];
    
    NSLog(@"activityView %@",NSStringFromCGRect( self.playViewVC.activityView.frame));
    NSLog(@"%@",NSStringFromCGRect(self.playViewVC.playbackBT.frame));

    //开启定时器刷新视屏播放时间
    [self startTimer];
}

#pragma mark -----------播放窗口的悬浮和回贴复原
//在方法中实现cell.frame.origin.y上下滑动的到顶部时，播放框悬浮在顶部,下拉往回后实现重新贴在cell上
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
//    悬浮和回贴
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
    //如果是下拉执行此方法
    CGPoint newPoint = [change [NSKeyValueChangeNewKey]CGPointValue];
    
    //通过偏移量区分tableview的滑动方向，因为下拉重新贴在对应位置的cell上时，在cell即将出现的方法中执行重新贴时，悬浮和贴重复执行造成贴不上，通过滑动方向防止误操作，让悬浮方法只在向上滑动时开启
    if (newPoint.y < 0 || newPoint.y - self.offsetY > 0) {
        
//        PlayViewController *play = [PlayViewController shardPalyViewController];
        //    通过判断总体偏移量和当前位置，实现到达顶部悬浮
        if (newPoint.y + 65 >= self.contentsetY) {
            
            CGRect rect   = self.view.frame;
            rect.origin.x = 0;
            rect.origin.y = 65;
            self.view.frame = rect;
            [self.viewController.view addSubview:self.view];
        }
        
    }else if (self.upDownOffsetY - newPoint.y >= 200){//此处用于播放视图的回帖，当视图完全出现的时候，在将播放窗口贴在cell上
        //将播放窗口和按钮界面全部回帖到cell上
//        PlayViewController *play   = [PlayViewController shardPalyViewController];
        self.view.frame            = CGRectMake(0, self.contentsetY, self.cell.frame.size.width, self.cell.frame.size.height);
        [self.tableView addSubview:self.view];
        
    }
    self.offsetY = newPoint.y;
}
    
    
    
    
    //此部分为加载菊花，缓存进度条的控制
//    if (object == self.item) {
//    缓存和控件的隐藏
        if ([keyPath isEqualToString:@"status"]) {
            
            if (self.player.status == AVPlayerStatusReadyToPlay) {
                
                //开始播放，停止转动
                self.playState = ZFPlayerStatePlaying;
                [self.playViewVC disposeView];
                
                //隐藏所有按钮
                self.playViewVC.lightProgress.hidden = YES;
                self.playViewVC.rateSlider.hidden    = YES;
                self.playViewVC.allTime.hidden       = YES;
                self.playViewVC.time.hidden          = YES;
                
            } else if (self.player.status == AVPlayerStatusFailed){
                
                //播放失败，转动
                [self.playViewVC.activityView startAnimating];
//                self.playViewVC.view.hidden = YES;
            }
            
            [self.item removeObserver:self forKeyPath:@"status"];
            [self.array addObject:@"status"];
        }
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            
            //计算并设置缓存进度条
//            NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
//            
//            CMTime duration             = self.item.duration;
//            CGFloat totalDuration       = CMTimeGetSeconds(duration);
//            [self.playViewVC.progressView setProgress:timeInterval / totalDuration animated:NO];

            [self.item removeObserver:self forKeyPath:@"loadedTimeRanges"];
            [self.array addObject:@"loadedTimeRanges"];

            
        }
    if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            
            // 当缓冲是空的时候，开启转动，可能会多次进入，其可能会配合暂停播放按钮（播放暂停按钮功能没有完善）
            if (self.item.playbackBufferEmpty) {
                
                self.playState = ZFPlayerStateBuffering;
                [self bufferingSomeSecond];
            }
            [self.item removeObserver:self forKeyPath:@"playbackBufferEmpty"];
            [self.array addObject:@"playbackBufferEmpty"];
            
        }
    if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            // 当缓冲好的时候
            NSLog(@"playbackLikelyToKeepUp:%d",self.item.playbackLikelyToKeepUp);
            
            if (self.item.playbackLikelyToKeepUp){
                NSLog(@"playbackLikelyToKeepUp");
                self.playState = ZFPlayerStatePlaying;
            }
            [self.item removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
            [self.array addObject:@"playbackLikelyToKeepUp"];
        }
    }
//}

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

#pragma mark  ----------视图声明周期
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    [self.playViewVC disposeView];
    self.playViewVC.view.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
    

}

//播放视屏
- (void)palyVideo {
    
    [self.player play];
    self.playViewVC.playbackBT.hidden = YES;
}

//暂停视屏播放
- (void)pauseVideo {
    
    [self.player pause];
    self.playViewVC.playbackBT.hidden = NO;
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
    
    CMTime currenttime   = self.item.duration;
    
    if (currenttime.timescale != 0) {
        CGFloat currenttimef = currenttime.value / currenttime.timescale;
        
        if (total == currenttimef && currenttimef != 0) {
            
            self.playViewVC.rebroadcast.hidden = NO;

        }

    }
    
    
   }

//计算当前时间
- (CGFloat)nowTimeofVolme {
    
    //    当前时间
    CMTime time   = self.player.currentTime;
    CGFloat total = time.value / time.timescale;
    
    
    return total;
}

//计算总时间,并实时更新当前时间
- (void)allTimeOfTextLabel:(UISlider *)slider {
    
    //    当前时间
    CMTime time   = self.player.currentTime;
    CGFloat total = time.value / time.timescale;
    
    //计算秒数 分钟 并添加到label上显示
    NSInteger proSec = (NSInteger) total%60;
    NSInteger proMin = (NSInteger) total/60;
    self.playViewVC.time.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];

    slider.value = total;
    //总时间
    CMTime allTime    = self.item.duration;
    //判断如果allTime.value为0不让执行，否则崩溃，安全措施，
    if (allTime.value == 0) {
        return;
    }
//
//    if (self.playViewVC.allTime.text) {
//        
//        return;
//    }
    CGFloat totalAll = allTime.value / allTime.timescale;
    //计算秒数 分钟数 并显示在label上
    NSInteger proSecAll = (NSInteger)totalAll % 60;
    NSInteger proMinAll = (NSInteger)totalAll / 60;
    self.playViewVC.allTime.text   =  [NSString stringWithFormat:@"%02zd:%02zd", proMinAll,proSecAll];
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
    
//    CMTime time   = self.player.currentTime;
//    CGFloat total = time.value / time.timescale;

 
    
    if (self.playViewVC.progressView.progress != 1) {
        
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        
        CMTime duration             = self.item.duration;
        CGFloat totalDuration       = CMTimeGetSeconds(duration);
        [self.playViewVC.progressView setProgress:timeInterval / totalDuration animated:NO];
        
        NSLog(@"ra progress%f",self.playViewVC.progressView.progress);
        NSLog(@"timeInterval / totalDuration %f",timeInterval / totalDuration);
    }
    

}

//设置滑竿的最大值最小值
- (void)setSlider:(UISlider *)slider {
    
    slider.value        = 0;
    slider.minimumValue = 0;
}

//滑动滑块控制视频进度
- (void)sliderValueAndControlVideo:(CGFloat)valueFloat {
    
    //滑动暂停播放
    [self.player pause];
    //从指定时间开始播放
    [self.player seekToTime:CMTimeMake(valueFloat, 1) completionHandler:^(BOOL finished) {
        //开始播放
        if (finished) {
            [self.player play];
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

//计算缓存，用于更新缓存进度条
- (NSTimeInterval)availableDuration {
    
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}


-(void)setPlayState:(ZFPlayerState)playState
{
    
    if (playState != ZFPlayerStateBuffering) {
        [self.playViewVC.activityView stopAnimating];
    }
    
    _playState = playState;
}

- (void)bufferingSomeSecond
{
    
    [self.playViewVC.activityView startAnimating];
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    static BOOL isBuffering = NO;
    if (isBuffering) {
        return;
    }
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self pauseVideo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        
        //播放缓冲区已满的时候 在播放否则继续缓冲
        //         [self.player play];
        
        
        /** 是否缓冲好的标准 （系统默认是1分钟。不建议用 ）*/
        //self.playerItme.isPlaybackLikelyToKeepUp
        
        if ((self.playViewVC.progressView.progress - self.playViewVC.rateSlider.value) > 0.01) {
            
            self.playState = ZFPlayerStatePlaying;
            [self.player play];
        }
        else
        {
            [self bufferingSomeSecond];
        }
    });
}

- (void)playOrSuspend:(BOOL)sender {
    
    
}

- (BOOL)shouldAutorotate {
    
    return NO;
}


- (void)suspendPlayWhenChengeView {
    
    PlayViewController *play = [PlayViewController shardPalyViewController];
//    AVPlayerItem *item       = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:@""]];
//    [play.player replaceCurrentItemWithPlayerItem:item];
    [play pauseVideo];
    self.view.hidden = YES;
}


- (void)dealloc {
    
    [self.timer invalidate];
    self.timer = nil;
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end

