//
//  PlayViewController.h
//  Video
//
//  Created by xalo on 16/5/3.
//  Copyright © 2016年 毛韶谦. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsModel;
@class NewsTableViewCell;
@class AVPlayer;
@class AVPlayerItem;
@class AVPlayerLayer;

@protocol PlayViewControllerDelegate <NSObject>


@end

@interface PlayViewController : UIViewController

@property (nonatomic,assign) BOOL    isDragSlider;  //是否开启滑竿的移动,用于手势控制视屏播放时使用
@property (nonatomic,strong) AVPlayer      *player;       //播放管理
@property (nonatomic,strong) AVPlayerItem  *item;         //播放对象
@property (nonatomic,strong) AVPlayerLayer *plaryLayer;   //播放显示层

//单例，在其他类调用本类中方法时首先通过此单例创建一个对象，由对象调用
+ (PlayViewController *)shardPalyViewController;

//在需要播放的视频类中的tableview的代理方法中调用两个方法

//在tableview的点击事件中调用，- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//playVideoAtCell参数为点击方法中的cell，即为点击tableview点击方法中的cell，在点击事件的方法使用*cell  = [tableView dequeueReusableCellWithIdentifier:@"   " forIndexPath:indexPath];
//[cell cellDataWithModel:self.dataSource[indexPath.row]];方法获取到cell。model为当前cell上的存储数据对象，（从数据源中通过[indexPath.row]取出）。tableview为调用类中的使用的tableview。contentsetY为cell的y轴方向位置（cell.frame.origin.y获取）。viewController为调用类本身UIViewController，（如果是调用类本身为UIViewController，此处填写self）。
- (void)playVideoAtCell:(UITableViewCell *)cell url:(NSString *)url tableView:(UITableView *)tableView contentsetY:(CGFloat)contentsetY viewController:(UIViewController *)viewController indexPath:(NSIndexPath *)insexPath;

//在视频播放类中实现tableview的
//- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//此代理方法，在此代理方法中调用，传入cell
- (void)pullDownCellAddPlay:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;


- (void)palyVideo;                                       //视屏开始播放
- (void)pauseVideo;                                      //暂停视频播放
- (void)sliderValueAndControlVideo:(UISlider *)slider;   //拖动滑块实现指定位置播放，在滑块的触发时间中调用
- (void)setScreenRotation;                               //设置屏幕旋转
- (void)panControllerVolum:(CGFloat)value;

- (void)recoverPalyWindowAndView;                        ////播放窗口复原

@end
