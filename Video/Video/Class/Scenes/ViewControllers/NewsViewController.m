//
//  NewsViewController.m
//  Video
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "NewsViewController.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource; //存放数据源
//@property (nonatomic,strong) PlayViewController *play;   //播放窗口
@property (nonatomic,assign) CGFloat   contentOffsetY;
@property (nonatomic,strong) NSString *modelTitle;
@property (nonatomic,assign) CGRect    cellFrame;       //保存cell的frame，在实现cell下拉重新找回播放窗口时使用

//upRow;downRow;用于判断tableview的滑动方向
@property (nonatomic,assign) int       upRow;
@property (nonatomic,assign) int       downRow;
@property (nonatomic,assign) BOOL      tableviewDirection; //用于保存tableview的方向信息，向上为yes，向下为no
@property (nonatomic,strong) TabBarViewController *tabBarVC;
@property (nonatomic,strong) MSQMediaPlayer *player;

@end

@implementation NewsViewController

#pragma mark ----------所有懒加载
-(NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (MSQMediaPlayer *)player {
    
    if (!_player) {
        
        _player = [[MSQMediaPlayer alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
    }
    return  _player;
}


//-(PlayViewController *)play {
//    
//    if (!_play) {
//        
//        _play = [[PlayViewController alloc]init];
//    }
//    return _play;
//}

#pragma mark ----------视图声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsTableViewCell"];

    //获取到框架控制器，关闭自适应（对tableview自动下移64）
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.tabBarVC  = delegate.tab;
    self.tabBarVC.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加下拉刷新，上拉加载
    [self tableViewMJHesderRefirsh:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;


}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[PlayViewController shardPalyViewController] suspendPlayWhenChengeView];
    if (self.dataSource.count == 0) {
        
        [self fecthDataFromNet:KNewsURL parameters:nil];
    }
    self.tabBarVC.navigationItem.titleView = nil;
    self.tabBarVC.navigationItem.title = @"新闻连连看";
    self.tabBarVC.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor orangeColor]};
}

//为tableview添加刷洗和加载功能
- (void)tableViewMJHesderRefirsh:(UITableView *)tableView {
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        PlayViewController *play = [PlayViewController shardPalyViewController];
        [play pauseVideo];
//        [play.plaryLayer removeFromSuperlayer];
//        [play.view removeFromSuperview];
//        [play.playViewVC.mview removeFromSuperview];
//        [play.playViewVC.view removeFromSuperview];
//        [play.view removeFromSuperview];
        play.playViewVC.mview.hidden = YES;
        play.plaryLayer.hidden       = YES;
        play.playViewVC.view.hidden  = YES;
        play.view.hidden             = YES;
        
        [self fecthDataFromNet:KNewsURL parameters:nil];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark ------------封装方法
//请求数据
- (void)fecthDataFromNet:(NSString *)url parameters:(NSDictionary *)parameter {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //初始化请求工具
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSMutableArray *itemArray = dic[@"视频"];
            //        遍历存储数据
            for (NSDictionary *item in itemArray) {
                
                NewsModel *model = [[NewsModel alloc]init];
                [model setValuesForKeysWithDictionary:item];
                [self.dataSource insertObject:model atIndex:0];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
            });

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"shibai你好");
        }];
            });
    
}

//cell3d动画效果
- (void)cell3DAnimations:(UITableViewCell *)cell {
    
    
    
//    CATransform3D rotation;
//    rotation = CATransform3DMakeRotation( (45*M_PI)/180, 0.0, 0.7, 0.4);
//    rotation.m34 = 1.0/ -600;
//    
//    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//    cell.layer.transform = rotation;
//    cell.layer.anchorPoint = CGPointMake(0, 0.5);
//    
//    [UIView beginAnimations:@"rotation" context:NULL];
//    [UIView setAnimationDuration:0.8];
//    cell.layer.transform = CATransform3DIdentity;
//    cell.alpha = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
    
    //    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"position"];
    //    basic.fromValue = [NSValue valueWithCGPoint:cell.layer.position];
    //    CGPoint toPoint = cell.layer.position;
    //    toPoint.x += 40;
    //    basic.toValue = [NSValue valueWithCGPoint:toPoint];
    //    [cell.layer addAnimation:basic forKey:@"basic"];
}



#pragma mark ----------tableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [tableView showMessage:@"💦没有网络数据，😱快下拉刷新" byDataSourceCount:self.dataSource.count];;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell" forIndexPath:indexPath];
    
    //    因为重用机制，当cell即将出现，在出现之前加载cell上内容之前，将原cell上的内容清空，再赋值
    cell.titleLabel.text = nil;
    cell.myImage.image   = nil;

    [cell cellDataWithModel:self.dataSource[indexPath.row]];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [btn setImage:[[UIImage imageNamed:@"personal_share_friend-1"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    
    [btn addTarget:self action:@selector(action:) forControlEvents:(UIControlEventTouchUpInside)];

    [cell addSubview:btn];
    [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(cell.mas_right).offset(-10);
        make.bottom.equalTo(cell.mas_bottom).offset(-5);
    }];

    UIButton *savebtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [savebtn setImage:[[UIImage imageNamed:@"1L3NYZPXXO[6CD%@AE_1P[9"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    
    [savebtn addTarget:self action:@selector(saveaction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [cell addSubview:savebtn];
    [savebtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(cell.mas_right).offset(-50);
        make.bottom.equalTo(cell.mas_bottom).offset(-5);
    }];

    //cell添加夜间模式
    [cell NightWithType:UIViewColorTypeNormal];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kNewsCellH;
}

//cell的点击方法实现点击播放
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell" forIndexPath:indexPath];

    [cell cellDataWithModel:self.dataSource[indexPath.row]];

//    NewsModel *model = self.dataSource[indexPath.row];
    //去除tableview的选中颜色
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    
//    调用视频播放方法
    NewsModel *model = self.dataSource[indexPath.row];
    PlayViewController *play = [PlayViewController shardPalyViewController];

    [play playVideoAtCell:cell url:[self.dataSource[indexPath.row] valueForKeyPath:@"mp4_url"] tableView:tableView contentsetY:cell.frame.origin.y viewController:self indexPath:indexPath title:model.title imageUrl:model.topicImg];


}

//cell即将出现时的代理方法，实现回拉时，播放窗口重新贴会对应的cell以及动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PlayViewController *play = [PlayViewController shardPalyViewController];
    [play pullDownCellAddPlay:cell indexPath:indexPath];
    NSLog(@"yi");
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
//    PlayViewController *play = [PlayViewController shardPalyViewController];
//    [play palyVideo];
}



//分享按钮回调方法,点击分享
-(void)action:(UIButton *)sender {
    
    MSQShare *share = [[MSQShare alloc]init];
    
    //计算当前button所在的cell的index
    UITableView *tableView = (UITableView *)sender.superview.superview.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:sender.superview];
    
    NewsModel *model = [[NewsModel alloc]init];
       //接收到的图片网址转换成UIImageView类型的
    UIImageView *myImage = [[UIImageView alloc]init];
    [myImage sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    
    //分享
    [share ShareToAll:model.title image:myImage.image url:model.mp4_url viewController:self];
}


//收藏，点击收藏
- (void)saveaction:(UIButton *)sender {
    
    //计算当前button所在的cell的index
    UITableView *tableView = (UITableView *)sender.superview.superview.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:sender.superview];
    
    NewsModel *model = self.dataSource[indexPath.row];
    
    CollectionModel *colletModel = [[CollectionModel alloc]init];
    colletModel.title = model.title;
    colletModel.image = model.cover;
    colletModel.file  = model.mp4_url;
    [[CollectManager sharedManager]insertData:colletModel];
    
    //若用户登录，则上传至云端
    if ([AVUser currentUser].username.length != 0) {
        
        [ArtViewController creatLeanCludeWithString:colletModel.title image:colletModel.image video:colletModel.file userName:[AVUser currentUser].username time:colletModel.spare];
        NSLog(@"收藏成功");
        
    }else{
        
        NSLog(@"收藏失败");
    }

}


- (void)viewWillDisappear:(BOOL)animated {
    
    [[PlayViewController shardPalyViewController] suspendPlayWhenChengeView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}





@end
