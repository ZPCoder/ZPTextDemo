//
//  ArtViewController.m
//  ArtVideo
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 王勇. All rights reserved.
//

#import "ArtViewController.h"
#import "ArtTableViewCell.h"
#import "ArtModel.h"

@interface ArtViewController ()<UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView; //滚动视图
@property (weak, nonatomic) IBOutlet UITableView *hotTableView;  //热门页面
@property (weak, nonatomic) IBOutlet UITableView *MV;            //MV页面
@property (weak, nonatomic) IBOutlet UITableView *enditTableView;//编舞页面

@property (nonatomic,strong)NSMutableArray *allDateArray;        //热门页面数据收集数组
@property (nonatomic,strong)NSMutableArray *allMVArray;          //MV页面数据收集数组
@property (nonatomic,strong)NSMutableArray *allEnArray;          //编舞页面数据收集数组


@property (nonatomic,strong)NSMutableArray *collectArray;        //存放收藏数据的数组

@property (nonatomic,assign)BOOL isRefreshe;                     //是否刷新的bool值
@property (nonatomic,strong)NSMutableDictionary *allDatedic;     //网站的参数字典
@property (nonatomic,assign)NSInteger hotNum;
@property (nonatomic,assign)NSInteger MVNum;
@property (nonatomic,assign)NSInteger entNum;

@property (nonatomic, assign) BOOL isMBProgress;                //是否再刷新；

@property (nonatomic, strong)MSQSelectedNavigationViewTools *selectrd;  //选择工具栏
@property (strong, nonatomic) TabBarViewController  *tabBarVC;
@end

@implementation ArtViewController

#pragma mark ---------------懒加载------------------
-(NSMutableArray *)allDateArray{
    if (!_allDateArray) {
        _allDateArray = [NSMutableArray array];
    }
    return _allDateArray;
}
-(NSMutableArray *)allMVArray{
    if (!_allMVArray) {
        _allMVArray = [NSMutableArray array];
    }
    return  _allMVArray;
}
-(NSMutableArray *)allEnArray{
    if (!_allEnArray) {
        _allEnArray = [NSMutableArray array];
    }
    return _allEnArray;
}

-(NSMutableDictionary *)allDatedic{
    if (!_allDatedic) {
        _allDatedic = [NSMutableDictionary dictionaryWithDictionary:@{@"page":@1}];
    }
    return _allDatedic;
}




-(NSMutableArray *)collectArray{
    if (!_collectArray) {
        _collectArray = [NSMutableArray array];
    }
    return _collectArray;
}


#pragma mark ------------视图生命周期-----------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置三个页面参数的初始值为1
    self.hotNum = 1;
    self.MVNum = 1;
    self.entNum = 1;
    
    //设置刚开始不刷新
    self.isMBProgress = NO;
    
    //滚动视图夜间模式
    [self.myScrollView NightWithType:UIViewColorTypeNormal];
    
    self.hotTableView.tag = 100;
    self.MV.tag = 101;
    self.enditTableView.tag = 102;
    
    self.hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.MV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.enditTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //三个页面的tableView为透明色
    self.hotTableView.backgroundColor = [UIColor clearColor];
    self.enditTableView.backgroundColor = [UIColor clearColor];
    self.MV.backgroundColor = [UIColor clearColor];
    
    //连接tabBar与本页面的代码
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.tabBarVC = delegate.tab;
    self.tabBarVC.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self.myScrollView layoutIfNeeded];
    self.myScrollView.alwaysBounceHorizontal = YES;
    
    //创建选择工具栏
    NSArray *array = @[@"热门",@"MV",@"编舞"];
    self.selectrd = [[MSQSelectedNavigationViewTools alloc]initLHSelectedNavigationViewToolsWithFrame:CGRectMake(kScreenW/4, 0, kScreenW/2, 30) ButtonTitle:array];
    __weak ArtViewController *kSelf = self;
    
    //通过block传值来判断view的滑动坐标
    self.selectrd.selectedScrollViewPageBlock = ^(NSInteger tag){
        
        switch (tag) {
            case 0:
                [kSelf.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                break;
            case 1:
                [kSelf.myScrollView setContentOffset:CGPointMake(kScreenW, 0) animated:YES];
                break;
            case 2:
                [kSelf.myScrollView setContentOffset:CGPointMake(kScreenW*2, 0) animated:YES];
                break;
            default:
                break;
        }
    };
    
    self.tabBarVC.navigationItem.titleView = self.selectrd;
    
    //注册xib
    [self.hotTableView registerNib:[UINib nibWithNibName:@"ArtTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.MV registerNib:[UINib nibWithNibName:@"ArtTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.enditTableView registerNib:[UINib nibWithNibName:@"ArtTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //三个页面下拉刷新
    self.hotTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //        [self.allDateArray removeAllObjects];
        self.isMBProgress = YES;
        [self fechDateSourceWithURL:kURL parameter:self.allDatedic];
    }];
    self.MV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.isMBProgress = YES;
        [self fechDateSourceWithURL:kMVURL parameter:self.allDatedic];
    }];
    self.enditTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.isMBProgress = YES;
        [self fechDateSourceWithURL:kEnURL parameter:self.allDatedic];
    }];
    
    //三个页面上拉加载，通过改变参数page的值来获取历史数据
    self.hotTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.isRefreshe = NO;
        self.hotNum += 1;
        [self.allDatedic setValue:[NSNumber numberWithInteger:self.hotNum] forKey:@"page"];
        [self fechDateSourceWithURL:kURL parameter:self.allDatedic];
        
    }];
    self.MV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.isRefreshe = NO;
        self.MVNum += 1;
        [self.allDatedic setValue:[NSNumber numberWithInteger:self.MVNum] forKey:@"page"];
        [self fechDateSourceWithURL:kMVURL parameter:self.allDatedic];
    }];
    self.enditTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.isRefreshe = NO;
        self.entNum += 1;
        [self.allDatedic setValue:[NSNumber numberWithInteger:self.entNum] forKey:@"page"];
        [self fechDateSourceWithURL:kEnURL parameter:self.allDatedic];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.allDateArray.count == 0) {
        
        [self fechDateSourceWithURL:kURL parameter:self.allDatedic];
    }
    self.tabBarVC.navigationItem.titleView = self.selectrd;
}

//返回cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.hotTableView) {
        
        return [tableView showMessage:@"💦没有网络数据，😱快下拉刷新" byDataSourceCount:self.allDateArray.count];
        
    }else if(tableView == self.MV){
        
        
        return [tableView showMessage:@"💦没有网络数据，😱快下拉刷新" byDataSourceCount:self.allMVArray.count];
        
    }else{
        
        return [tableView showMessage:@"💦没有网络数据，😱快下拉刷新" byDataSourceCount:self.allEnArray.count];
        
    }
    
}


-(ArtTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    //tableview添加夜间模式
    [tableView NightWithType:UIViewColorTypeNormal];
    
    ArtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ArtModel *model = [[ArtModel alloc]init];
    
    //通过判断tableView来决定每个页面获取的数据不同
    if (tableView == self.hotTableView) {
        model = self.allDateArray[indexPath.row];
        
        [cell setCellWithArtModel:model tableViewTag:0 datasource:self.allDateArray];
        
    }else if(tableView == self.MV){
        model = self.allMVArray[indexPath.row];
        [cell setCellWithArtModel:model tableViewTag:1 datasource:self.allMVArray];
        
    }else{
        model = self.allEnArray[indexPath.row];
        [cell setCellWithArtModel:model tableViewTag:2 datasource:self.allEnArray];
        
    }
    
    //分享按钮
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [btn setImage:[[UIImage imageNamed:@"share-1"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(action:) forControlEvents:(UIControlEventTouchUpInside)];
            btn.frame = CGRectMake(kScreenW-40, 150, 25, 25);
    [cell addSubview:btn];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    //得到当前cell的indexPath.row，方便自定义cell里的收藏按钮传值给收藏页面
    cell.number = indexPath.row;
    
    //model传值
    cell.title.text = model.content;
    [cell.title NightWithType:UIViewColorTypeNormal];
    [cell.myImage sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
//  cell.title.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    [cell.title shine];
    
    //cell添加夜间模式
    [cell NightWithType:UIViewColorTypeNormal];
   
    
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    PlayViewController *play = [PlayViewController shardPalyViewController];
    [play pullDownCellAddPlay:cell indexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ArtTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    PlayViewController *play = [PlayViewController shardPalyViewController];
    
    if (tableView == self.hotTableView) {
         ArtModel *model = self.allDateArray[indexPath.row];
        
        [play playVideoAtCell:cell url:model.file tableView:tableView contentsetY:cell.frame.origin.y viewController:self indexPath:indexPath title:model.content imageUrl:model.thumb];
    }else if(tableView == self.MV){
        ArtModel *model = self.allMVArray[indexPath.row];
        
        [play playVideoAtCell:cell url:model.file tableView:tableView contentsetY:cell.frame.origin.y viewController:self indexPath:indexPath title:model.content imageUrl:model.thumb];
    }else{
        ArtModel *model = self.allEnArray[indexPath.row];
            
        [play playVideoAtCell:cell url:model.file tableView:tableView contentsetY:cell.frame.origin.y viewController:self indexPath:indexPath title:model.content imageUrl:model.thumb];
    }
   
    
}
//获取数据
-(void)fechDateSourceWithURL:(NSString*)url parameter:(NSMutableDictionary*)parameter{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [manager GET:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:nil];
            
            NSArray *list = dic[@"data"];
            for (NSDictionary *obj in list) {
                
                ArtModel *model = [[ArtModel alloc]init];
                [model setValuesForKeysWithDictionary:obj];
                
                if ([url  isEqual: kURL]) {
                    
                    [self.allDateArray addObject:model];
                    
                }else if([url isEqual:kMVURL]){
                    [self.allMVArray addObject:model];
                }else{
                    [self.allEnArray addObject:model];
                }
            }
            if (self.isMBProgress) {
                
                if ([url  isEqual: kURL]) {
                    
                    NSRange range = NSMakeRange(0, 15);
                    [self.allDateArray removeObjectsInRange:range];
                    
                }else if([url isEqual:kMVURL]){
                    NSRange range = NSMakeRange(0, 15);
                    [self.allMVArray removeObjectsInRange:range];
            
                }else{
                    NSRange range = NSMakeRange(0, 15);
                    [self.allEnArray removeObjectsInRange:range];
                }
            }
            self.isMBProgress = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.hotTableView.mj_header endRefreshing];
                [self.MV.mj_header endRefreshing];
                [self.enditTableView.mj_header endRefreshing];
                [self.hotTableView.mj_footer endRefreshing];
                [self.MV.mj_footer endRefreshing];
                [self.enditTableView.mj_footer endRefreshing];
                [self.hotTableView reloadData];
                [self.MV reloadData];
                [self.enditTableView reloadData];
            });
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.hotTableView.mj_header endRefreshing];
                [self.MV.mj_header endRefreshing];
                [self.enditTableView.mj_header endRefreshing];
                [self.hotTableView.mj_footer endRefreshing];
                [self.MV.mj_footer endRefreshing];
                [self.enditTableView.mj_footer endRefreshing];
            });
        }];
    });
}

//根据滚动视图的偏移量来决定当前tableView接收哪部分数据
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.myScrollView) {
        
        if (scrollView.contentOffset.x == 0) {
            if (self.allDateArray.count == 0) {
//                [self fechDateSourceWithURL:kURL parameter:self.allDatedic];
            }
            
        }else if(scrollView.contentOffset.x == kScreenW){
            if(self.allMVArray.count == 0){
                [self fechDateSourceWithURL:kMVURL parameter:self.allDatedic];
            }
        }else if(scrollView.contentOffset.x == kScreenW*2){
            if (self.allEnArray.count == 0) {
                [self fechDateSourceWithURL:kEnURL parameter:self.allDatedic];
            }
        }
        [self.selectrd moveMarkLabelWithContentOffset:scrollView.contentOffset];
    }
    
}



#pragma mark ----视频播放器 各别属性

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.view.backgroundColor = [UIColor blackColor];
    }
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return  UIInterfaceOrientationMaskAllButUpsideDown;
}

//云端存储，注意读取视频文件的时候需要将获取的data转化为string模式，再转换为url用播放器播放出来
//userName 为每个用户的固定ID，也就是注册ID
+(void)creatLeanCludeWithString:(NSString*)string image:(NSString*)image video:(NSString*)video userName:(NSString*)userName time:(NSString *)time{
    
    AVObject *artFolder = [[AVObject alloc]initWithClassName:@"ArtFolde"];
    //创建完成，保存对象
    [artFolder setObject:userName forKey:@"userName"];
    [artFolder setObject:string forKey:@"title"];
    [artFolder setObject:video forKey:@"video"];
    [artFolder setObject:image forKey:@"image"];
    [artFolder setObject:time forKey:@"time"];
    [artFolder saveEventually:^(BOOL succeeded, NSError *error) {
         if (succeeded) {
                    
                    NSLog(@"数据存储成功");
                }else{
                    NSLog(@"数据存储失败");
                }
            }];
 
}
//投诉云存储；
+ (void)creatLeanCludeWithReason:(NSString *)reason video:(NSString *)video {
    
    
    AVObject *artFolder = [[AVObject alloc]initWithClassName:@"complainReason"];
    //创建完成，保存对象
    if ([AVUser currentUser].username.length != 0) {
    [artFolder setObject:[AVUser currentUser].username forKey:@"userName"];
    }
    [artFolder setObject:reason forKey:@"reason"];
    [artFolder setObject:video forKey:@"video"];
    [artFolder setObject:[CollectManager dateToStringWhitDate] forKey:@"time"];
    [artFolder saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            NSLog(@"数据存储成功");
        }else{
            NSLog(@"数据存储失败");
        }
    }];
}
/*
//存储用户信息到云端
+ (void)creatLeanCludeSaveInfoUer:(NSDictionary *)dictionary {
    
     AVObject *artFolder = [[AVObject alloc]initWithClassName:@"SaveInfoUer"];
    [artFolder setObject:dictionary[@"userName"] forKey:@"userName"];
    [artFolder setObject:dictionary[@"userContent"] forKey:@"userContent"];
    [artFolder setObject:dictionary[@"image"] forKey:@"image"];
    
    [artFolder saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            NSLog(@"数据存储成功");
        }else{
            NSLog(@"数据存储失败");
        }
    }];
    
    [AVQuery doCloudQueryInBackgroundWithCQL:@"update TodoFolder set name='家庭' where objectId='558e20cbe4b060308e3eb36c'" callback:^(AVCloudQueryResult *result, NSError *error) {
        // 如果 error 为空，说明保存成功
        
    }];
}
 */

//分享按钮回调方法
-(void)action:(UIButton *)sender {
    
    MSQShare *share = [[MSQShare alloc]init];
    
    //计算当前button所在的cell的index
    UITableView *tableView = (UITableView *)sender.superview.superview.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:(ArtTableViewCell*)sender.superview];

    ArtModel *model = [[ArtModel alloc]init];
    //判断tableView
    if (tableView == self.hotTableView) {
        model = self.allDateArray[indexPath.row];
    }else if(tableView == self.MV){
        model = self.allMVArray[indexPath.row];
    }else{
        model = self.allEnArray[indexPath.row];
    }
    //接收到的图片网址转换成UIImageView类型的
    UIImageView *myImage = [[UIImageView alloc]init];
    [myImage sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    
    //分享
    [share ShareToAll:model.content image:myImage.image url:model.file viewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
