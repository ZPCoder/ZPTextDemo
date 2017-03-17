//
//  PlayViewController.h
//  Video
//
//  Created by 朱鹏 on 16/5/3.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsModel;
@class NewsTableViewCell;
@class AVPlayer;
@class AVPlayerItem;
@class AVPlayerLayer;
@class PlayViewVC;
@class UIProgressView;

@protocol PlayViewControllerDelegate <NSObject>


@end

@interface PlayViewController : UIViewController

@property (nonatomic,assign) BOOL             isDragSlider;      //是否开启滑竿的移动,用于手势控制视屏播放时使用
@property (nonatomic,strong) AVPlayer         *player;           //播放管理
@property (nonatomic,strong) AVPlayerItem     *item;             //播放对象
@property (nonatomic,strong) AVPlayerLayer    *plaryLayer;       //播放显示层
@property (nonatomic,strong) UITableView      *tableView;        //接收传进来的tableview
@property (nonatomic,strong) UITableViewCell  *cell;
//@property (nonatomic,strong) UITableViewCell  *clickCell;
@property (nonatomic,assign) CGRect           smallPlay;         //小的播放窗口的frame
@property (nonatomic,strong) PlayViewVC       *playViewVC;       //播放窗口上的按钮显示界面


//存储传递过来的cell

//单例，在其他类调用本类中方法时首先通过此单例创建一个对象，由对象调用
+ (PlayViewController *)shardPalyViewController;


//在需要播放的视频类中的tableview的代理方法中调用两个方法



//在tableview的点击事件中调用，- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//playVideoAtCell参数为点击方法中的cell，即为点击tableview点击方法中的cell，在点击事件的方法使用*cell  = [tableView dequeueReusableCellWithIdentifier:@"   " forIndexPath:indexPath];
//[cell cellDataWithModel:self.dataSource[indexPath.row]];方法获取到cell。model为当前cell上的存储数据对象，（从数据源中通过[indexPath.row]取出）。tableview为调用类中的使用的tableview。contentsetY为cell的y轴方向位置（cell.frame.origin.y获取）。viewController为调用类本身UIViewController，（如果是调用类本身为UIViewController，此处填写self）。
- (void)playVideoAtCell:(UITableViewCell *)cell url:(NSString *)url tableView:(UITableView *)tableView contentsetY:(CGFloat)contentsetY viewController:(UIViewController *)viewController indexPath:(NSIndexPath *)insexPath title:(NSString *)titel imageUrl:(NSString *)imageUrl;

//在视频播放类中实现tableview的
//- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//此代理方法，在此代理方法中调用，传入cell
- (void)pullDownCellAddPlay:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)commonPlay:(UIViewController *)viewController playFrame:(CGRect)frame urlWithString:(NSString *)url title:(NSString *)titel imageUrl:(NSString *)imageUrl;

//如果需要模态返回或者pop返回时，在代码块中调用此方法，实现正在播放的视屏暂停，以免造成退出界面仍然有声音存在（视频依然在播放）
- (void)pauseVideo;                                      //暂停视频播放

- (void)suspendPlayWhenChengeView;                       //切换view时调用方法，实现暂停，置空播放


//不需要调用的方法
- (void)palyVideo;                                       //视屏开始播放
- (void)sliderValueAndControlVideo:(CGFloat)valueFloat;   //拖动滑块实现指定位置播放，在滑块的触发时间中调用

@end
