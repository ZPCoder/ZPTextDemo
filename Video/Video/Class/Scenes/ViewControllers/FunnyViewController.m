//
//  FunnyViewController.m
//  FunnyDemo
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "FunnyViewController.h"


typedef enum {

    newType,   //最新
    jingType,   //精品
    gameType   //游戏视频

}DataType;



@interface FunnyViewController ()<UITableViewDelegate,UITableViewDataSource,lsTransSelectionAction>


//最新
@property (weak, nonatomic) IBOutlet UITableView *zuixinTableView;

//精品
@property (weak, nonatomic) IBOutlet UITableView *jingTableView;

//游戏
@property (weak, nonatomic) IBOutlet UITableView *gameTableView;

//滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *contantView;

//存放最新数据的数组
@property (nonatomic,retain)NSMutableArray *dataMarray;

//存放精品数据的数组
@property (nonatomic,retain)NSMutableArray *jingArray;

//存放视频数据的数组
@property (nonatomic,retain)NSMutableArray *gameArray;

//参数
@property (nonatomic,retain)NSNumber *parameter;
//接收拼接后的url
@property (nonatomic,retain)NSString *funnyUpdate;

//数据类型
@property (nonatomic,assign)DataType dataType;


//判断是否为刷新
@property (nonatomic,assign)BOOL isRefresh;

//导航标签工具
@property (strong, nonatomic) MSQSelectedNavigationViewTools *tool;
@property (strong, nonatomic) TabBarViewController  *tabBarVC;


//播放界面
@property (nonatomic,retain)UIScrollView *playerScrollView;

@end

@implementation FunnyViewController

#pragma mark ----懒加载
-(NSMutableArray *)dataMarray{

    if (!_dataMarray) {
        _dataMarray = [NSMutableArray array];
    }
    return _dataMarray;
}

-(NSMutableArray *)jingArray{

    if (!_jingArray) {
        _jingArray = [NSMutableArray array];
    }
    return _jingArray;
}

-(NSMutableArray *)gameArray{

    if (!_gameArray) {
        _gameArray = [NSMutableArray array];
    }
    return _gameArray;
}


-(UIScrollView *)playerScrollView{

    if (!_playerScrollView) {
        _playerScrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _playerScrollView.backgroundColor = [UIColor clearColor];

        UIImageView *imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        imageView.image = [UIImage imageNamed:@"mb.png"];
        imageView.alpha = 0.6;
        [_playerScrollView insertSubview:imageView atIndex:0];
    }
    return _playerScrollView;
}


#pragma mark --- 解析
-(void)fetchSourceWithUrl:(NSString *)url{

    //加载动画
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

            NSArray *array = dic[@"list"];

            self.parameter = dic[@"info"][@"np"];

            for (NSDictionary *object in array) {

                FunnyModel *model = [[FunnyModel alloc]init];
                [model setValuesForKeysWithDictionary:object];

                //判断分类
                if (self.dataType == newType ) {

                    [self.dataMarray addObject:model];

                }else if (self.dataType == jingType){

                    [self.jingArray addObject:model];

                }else if (self.dataType == gameType){

                    [self.gameArray addObject:model];
                }
            }

            //下拉刷新
            NSRange range = NSMakeRange(0, 20);
            if (self.dataType == newType) {

                if (self.isRefresh) {

                    [self.dataMarray removeObjectsInRange:range];
                }
            }
            if (self.dataType == jingType){

                if (self.isRefresh) {

                    [self.jingArray removeObjectsInRange:range];
                }
            }
            if (self.dataType == gameType){

                if (self.isRefresh) {

                    [self.gameArray removeObjectsInRange:range];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{



                //结束下拉刷新、上拉加载
                [self.zuixinTableView.mj_footer endRefreshing];
                [self.zuixinTableView.mj_header endRefreshing];

                [self.jingTableView.mj_footer endRefreshing];
                [self.jingTableView.mj_header endRefreshing];

                [self.gameTableView.mj_footer endRefreshing];
                [self.gameTableView.mj_header endRefreshing];

                //刷新数据
                [self.zuixinTableView reloadData];
                [self.jingTableView reloadData];
                [self.gameTableView reloadData];

                //结束加载
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"------%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
            //结束加载
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
    });

}

#pragma mark ---tableView协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == self.zuixinTableView) {

        return [tableView showMessage:@"💦没有网络数据，😱快下拉刷新" byDataSourceCount:self.dataMarray.count];

    }else if (tableView == self.jingTableView){

        return [tableView showMessage:@"💦没有网络数据，😱快下拉刷新" byDataSourceCount:self.jingArray.count];

    }else if (tableView == self.gameTableView){

        return [tableView showMessage:@"💦没有网络数据，😱快下拉刷新" byDataSourceCount:self.gameArray.count];
    }

    return 0;
}

-(FunnyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //设置夜间、白天模式
    [tableView NightWithType:UIViewColorTypeNormal];

    FunnyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"funnyCell" forIndexPath:indexPath];

    if (tableView == _zuixinTableView) {

        [cell setCellWithModel:self.dataMarray[indexPath.row]];

    }else if (tableView == _jingTableView){

        [cell setCellWithModel:self.jingArray[indexPath.row]];

    }else if (tableView == _gameTableView){

        [cell setCellWithModel:self.gameArray[indexPath.row]];
    }

    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //白天模式--夜间模式
    [cell.text NightWithType:UIViewColorTypeNormal];
    [cell NightWithType:UIViewColorTypeNormal];


    cell.delegate = self;
    cell.videoImageVIew.layer.cornerRadius = 15;
    cell.videoImageVIew.layer.masksToBounds = YES;

    //图片添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [cell.videoImageVIew addGestureRecognizer:tap];
    cell.videoImageVIew.userInteractionEnabled = YES;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 240;
}

//cell即将出现
//cell即将出现时的代理方法，实现回拉时，播放窗口重新贴会对应的cell以及动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    PlayViewController *play = [PlayViewController shardPalyViewController];
    [play pullDownCellAddPlay:cell indexPath:indexPath];
}

#pragma mark ---播放按钮的回调
-(void)lsbuttonSelectAction:(UIButton *)sender{

    NSIndexPath *indexPath = [(UITableView *)sender.superview.superview.superview.superview indexPathForCell:(UITableViewCell *)sender.superview.superview];
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    UITableView *tableView = (UITableView *)sender.superview.superview.superview.superview;

    FunnyModel *model;
    if (tableView == self.zuixinTableView) {

        model = self.dataMarray[indexPath.row];
    }else if (tableView == self.jingTableView) {

        model = self.jingArray[indexPath.row];
    }else {

        model = self.gameArray[indexPath.row];
    }
    if (model.video) {  //如果是视频类

        NSArray *array = model.video[@"video"];
        NSArray *iArr = model.video[@"thumbnail"];
        PlayViewController *plauer = [PlayViewController shardPalyViewController];
        [plauer playVideoAtCell:cell url:array.lastObject tableView:tableView contentsetY:cell.frame.origin.y viewController:self indexPath:indexPath title:model.text imageUrl:iArr[0]];
    }
}

#pragma mark -- 轻拍手势回调
-(void)tapAction:(UITapGestureRecognizer *)sender{

    //获得cell的indexPath,用来确定model
    UIImageView *view =  (UIImageView *)sender.view;
    FunnyTableViewCell* superView = (FunnyTableViewCell *)view.superview.superview;
    FunnyModel *model = [[FunnyModel alloc]init];


    if (self.myScrollView.contentOffset.x == 0) {

        NSIndexPath *indexPath = [self.zuixinTableView indexPathForCell:superView];
        //最新板块
        model = self.dataMarray[indexPath.row];

    }else if(self.myScrollView.contentOffset.x == kWidth){

        NSIndexPath *indexPath = [self.jingTableView indexPathForCell:superView];
        //精品板块
        model = self.jingArray[indexPath.row];

    }else{

        NSIndexPath *indexPath = [self.gameTableView indexPathForCell:superView];
        //游戏板块
        model = self.gameArray[indexPath.row];
    }
    if (model.gif || model.image) {

        NSLog(@"播放gif动图,图片");

        //跳转下级页面
        FunnyDetailViewController *funnyDetailVC = [[FunnyDetailViewController alloc]init];
        //传值
        funnyDetailVC.model = model;

        //显示下载按钮
        funnyDetailVC.saveBtn.hidden = NO;
        funnyDetailVC.playBtn.hidden = YES;
        [self presentViewController:funnyDetailVC animated:YES completion:nil];

    }else if(model.video){

        NSLog(@"播放视频");
        FunnyDetailViewController *funnyDetailVC = [[FunnyDetailViewController alloc]init];
        funnyDetailVC.model = model;
        //隐藏下载按钮
        funnyDetailVC.saveBtn.hidden = YES;
        funnyDetailVC.playBtn.hidden = NO; //播放按钮

        [self presentViewController:funnyDetailVC animated:YES completion:nil];
    }
}


#pragma mark --scrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView == self.myScrollView) {
        if (scrollView.contentOffset.x == 0) {

            self.dataType = newType;

        }else if (scrollView.contentOffset.x == kWidth){

            self.dataType = jingType;

            if (self.jingArray.count == 0) {

                [self fetchSourceWithUrl:kFunny_1Url];
            }

            [[PlayViewController shardPalyViewController]suspendPlayWhenChengeView];
        }else if (scrollView.contentOffset.x == 2*kWidth){
            [[PlayViewController shardPalyViewController]suspendPlayWhenChengeView];
            self.dataType = gameType;

            if (self.gameArray.count == 0) {

                [self fetchSourceWithUrl:kFunny_gameUrl];
            }
        }
        [[PlayViewController shardPalyViewController]suspendPlayWhenChengeView];
        [self.tool moveMarkLabelWithContentOffset:scrollView.contentOffset];
    }
}

//点击单元格
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    NSLog(@"点击");
//}


#pragma mark --视图生命周期
-(void)viewWillAppear:(BOOL)animated{

    //隐藏分隔线
    self.zuixinTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.jingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.gameTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.zuixinTableView layoutIfNeeded];
    [self.jingTableView layoutIfNeeded];
    [self.gameTableView layoutIfNeeded];
    self.tabBarVC.navigationItem.titleView = self.tool;
    //请求数据
    if (self.dataMarray.count == 0) {
        //请求数据
        [self fetchSourceWithUrl:kFunnyUrl];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
     AppDelegate *delegate = [UIApplication sharedApplication].delegate;
     self.tabBarVC = delegate.tab;

    //为tableView下边添加朦图 并手动约束
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.contantView insertSubview:imageView atIndex:0];

    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.leading.offset(0);
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
    }];

    //设置导航栏
    NSArray *array = @[@"推荐",@"精品",@"游戏"];
    self.tool = [[MSQSelectedNavigationViewTools alloc]initLHSelectedNavigationViewToolsWithFrame:CGRectMake(kWidth/4, 0, kWidth/2, 30) ButtonTitle:array];
    __weak FunnyViewController *kSelf = self;//
//    __weak typeof(self) kSelf = self;
    self.tool.selectedScrollViewPageBlock = ^(NSInteger tag){

        if (tag == 0) {

            [kSelf.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if (tag == 1) {

            [kSelf.myScrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];

        }else if (tag == 2) {

            [kSelf.myScrollView setContentOffset:CGPointMake(kWidth*2, 0) animated:YES];
        }
    };
    self.tabBarVC.navigationItem.titleView = self.tool;

    self.tabBarVC.automaticallyAdjustsScrollViewInsets = NO;

    //注册单元格
    [self.zuixinTableView registerNib:[UINib nibWithNibName:@"FunnyTableViewCell" bundle:nil] forCellReuseIdentifier:@"funnyCell"];

    [self.jingTableView registerNib:[UINib nibWithNibName:@"FunnyTableViewCell" bundle:nil] forCellReuseIdentifier:@"funnyCell"];

    [self.gameTableView registerNib:[UINib nibWithNibName:@"FunnyTableViewCell" bundle:nil] forCellReuseIdentifier:@"funnyCell"];
    //刷新数据
    [self update];

    self.zuixinTableView.backgroundColor = [UIColor clearColor];
    self.jingTableView.backgroundColor = [UIColor clearColor];
    self.gameTableView.backgroundColor = [UIColor clearColor];
    [self.zuixinTableView NightWithType:UIViewColorTypeNormal];
    [self.jingTableView NightWithType:UIViewColorTypeNormal];
    [self.gameTableView NightWithType:UIViewColorTypeNormal];
}

//视图即将消失 
-(void)viewWillDisappear:(BOOL)animated{

    //暂停播放器
    [[PlayViewController shardPalyViewController]suspendPlayWhenChengeView];
    
}

#pragma mark --上拉加载和下拉刷新
-(void)update{

    //最新
    //上拉加载
    self.zuixinTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"最新上拉加载");

        self.isRefresh = NO;
        self.funnyUpdate = [NSString stringWithFormat:@"http://s.budejie.com/topic/list/zuixin/41/baisi_xiaohao-iphone-4.1/%@-20.json",self.parameter];
        [self fetchSourceWithUrl:self.funnyUpdate];
    }];
    //下拉刷新
    self.zuixinTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"最新下拉刷新");

        self.isRefresh = YES;
        //请求数据
        [self fetchSourceWithUrl:kFunnyUrl];
    }];

    //精品
    //上拉加载
    self.jingTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"精品上拉加载");

        self.isRefresh = NO;
        self.funnyUpdate = [NSString stringWithFormat:@"http://s.budejie.com/topic/list/jingxuan/41/baisi_xiaohao-iphone-4.1/%@-20.json",self.parameter];
        [self fetchSourceWithUrl:self.funnyUpdate];
    }];
    //下拉刷新
    self.jingTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"精品下拉刷新");

        self.isRefresh = YES;
        //请求数据
        [self fetchSourceWithUrl:kFunny_1Url];
    }];

    //上拉加载
    self.gameTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"游戏视频上拉加载");

        self.isRefresh = NO;
        self.funnyUpdate = [NSString stringWithFormat:@"http://s.budejie.com/topic/tag-topic/164/new/baisi_xiaohao-iphone-4.1/%@-20.json",self.parameter];
        NSLog(@"-----%@",self.funnyUpdate);
        [self fetchSourceWithUrl:self.funnyUpdate];
    }];
    //下拉刷新
    self.gameTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"游戏视频下拉刷新");

        self.isRefresh = YES;
        //请求数据
        [self fetchSourceWithUrl:kFunny_gameUrl];
    }];

    PlayViewController *play = [PlayViewController shardPalyViewController];
    [play pauseVideo];
    play.playViewVC.mview.hidden = YES;
    play.plaryLayer.hidden       = YES;
    play.playViewVC.view.hidden  = YES;
    play.view.hidden             = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
