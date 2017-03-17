//
//  VMovieViewController.m
//  Video
//
//  Created by 朱鹏 on 16/5/2.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "VMovieViewController.h"
#import "MovieTableViewCell.h"
#import "InfoMovieViewController.h"

@interface VMovieViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,TransSelectionAction>
@property (strong, nonatomic) IBOutlet UIImageView *MovieHeadImageView;
@property (strong, nonatomic) IBOutlet UIView *MovieHeadView;
@property (strong, nonatomic) IBOutlet UIImageView *ScienceHeadImageView;
@property (strong, nonatomic) IBOutlet UIView *ScienceHeadView;
@property (strong, nonatomic) IBOutlet UIImageView *CreativeHeadImageView;
@property (strong, nonatomic) IBOutlet UIView *CreativeHeadView;
@property (strong, nonatomic) IBOutlet UITableView *MovieTabelView;
@property (strong, nonatomic) IBOutlet UITableView *ScienceTableView;
@property (strong, nonatomic) IBOutlet UITableView *CreativeTableView;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) MSQSelectedNavigationViewTools *tool;
//数据临时储存
@property (strong, nonatomic) NSMutableArray *mMovieArray;
@property (strong, nonatomic) NSMutableArray *mScienceArray;
@property (strong, nonatomic) NSMutableArray *mCreativeArray;
//参数
@property (strong, nonatomic) NSMutableDictionary *mParameters;

@property (assign, nonatomic) NSInteger movieP;
@property (assign, nonatomic) NSInteger scienceP;
@property (assign, nonatomic) NSInteger creativeP;
@property (assign, nonatomic) BOOL isRefreshHeader;
@property (strong, nonatomic) TabBarViewController  *tabBarVC;

@property (strong, nonatomic) MICarouselTools *iCarouseMovie;
@property (strong, nonatomic) MICarouselTools *iCarouseScience;
@property (strong, nonatomic) MICarouselTools *iCarouseCreated;

@end

@implementation VMovieViewController

#pragma mark --------懒加载--------------

- (NSMutableArray *)mMovieArray {
    
    if (!_mMovieArray) {
        _mMovieArray = [NSMutableArray array];
    }
    return _mMovieArray;
}
- (NSMutableArray *)mScienceArray {
    
    if (!_mScienceArray) {
        _mScienceArray = [NSMutableArray array];
    }
    return _mScienceArray;
}
- (NSMutableArray *)mCreativeArray {
    
    if (!_mCreativeArray) {
        _mCreativeArray = [NSMutableArray array];
    }
    return _mCreativeArray;
}
- (NSMutableDictionary *)mParameters {
    
    if (!_mParameters) {
        //http://service.vmovier.com/api/post/getPostInCate?cateid=0&p=1  cateid=6&p=1
        _mParameters = [NSMutableDictionary dictionaryWithDictionary:@{@"p":@1,@"cateid":@0}];
    }
    return _mParameters;
}


#pragma mark --------视图生命周期-------------
- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieP = 1;
    self.scienceP = 1;
    self.creativeP = 1;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.tabBarVC = delegate.tab;
    self.tabBarVC.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction)];
    [self.mainScrollView NightWithType:UIViewColorTypeNormal];
    self.MovieTabelView.backgroundColor = [UIColor clearColor];
    self.ScienceTableView.backgroundColor = [UIColor clearColor];
    self.CreativeTableView.backgroundColor = [UIColor clearColor];
    //刷新
    [self addThirdTools];
    [self.MovieTabelView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    [self.ScienceTableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    [self.CreativeTableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    
    [self selectedNavigationViewTools];
    [self blurEffectAddView:self.MovieHeadImageView];
    [self blurEffectAddView:self.ScienceHeadImageView];
    [self blurEffectAddView:self.CreativeHeadImageView];
    
    self.MovieTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ScienceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.CreativeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [self.mMovieArray addObjectsFromArray:[MSQFileReadAndWriteTools readArrayWithFilePath:kMoviePath]];
//    [self.mScienceArray addObjectsFromArray:[MSQFileReadAndWriteTools readArrayWithFilePath:kSciencePath]];
//    [self.mCreativeArray addObjectsFromArray:[MSQFileReadAndWriteTools readArrayWithFilePath:kCreationPath]];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.mMovieArray.count == 0) {
        
        [self fechDateSourceWithURL:kMovieURL dictionary:self.mParameters];
    }
    self.tabBarVC.navigationItem.titleView = self.tool;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[PlayViewController shardPalyViewController]suspendPlayWhenChengeView];
}
- (void)leftBarButtonAction {
    
    
}
//添加头部视图
- (void)addHeaderView:(NSMutableArray *)array {
    
    if (self.iCarouseMovie != nil) {
        return;
    }
    NSMutableArray *mArray = [self selectedImageUrl:array];
    self.iCarouseMovie = [[MICarouselTools alloc] initWithFrame:self.MovieHeadView.frame photosArray:mArray titleArray:[self titleICarouse:array]];
    
    [self.MovieHeadView addSubview:self.iCarouseMovie];
    self.iCarouseMovie.backgroundColor = [UIColor clearColor];
    
    __weak VMovieViewController *kSelf = self;
    self.iCarouseMovie.seletedImageViewTag = ^(NSInteger tag){
        
        [kSelf skipViewControllerFromiCarouse:tag array:array];
    };
    self.iCarouseMovie.currentImageViewTag = ^(NSInteger tag){
        
        UIImageView *imageView = mArray[tag];
        kSelf.MovieHeadImageView.image = imageView.image;
    };
    
}
- (void)addHeaderViewS:(NSMutableArray *)array {
    
    if (self.iCarouseScience != nil) {
        return;
    }
    NSMutableArray *mArray = [self selectedImageUrl:array];
    self.iCarouseScience = [[MICarouselTools alloc] initWithFrame:self.ScienceHeadView.frame photosArray:mArray titleArray:[self titleICarouse:array]];
    [self.ScienceHeadView addSubview:self.iCarouseScience];
    self.iCarouseScience.backgroundColor = [UIColor clearColor];
    __weak VMovieViewController *kSelf = self;
    self.iCarouseScience.seletedImageViewTag = ^(NSInteger tag){
        
        [kSelf skipViewControllerFromiCarouse:tag array:array];
    };
    self.iCarouseScience.currentImageViewTag = ^(NSInteger tag){
        
        UIImageView *imageView = mArray[tag];
        kSelf.ScienceHeadImageView.image = imageView.image;
    };
}
- (void)addHeaderViewC:(NSMutableArray *)array {
    
    if (self.iCarouseCreated != nil) {
        return;
    }
    NSMutableArray *mArray = [self selectedImageUrl:array];
    self.iCarouseCreated = [[MICarouselTools alloc] initWithFrame:self.CreativeHeadView.frame  photosArray:mArray titleArray:[self titleICarouse:array]];
    [self.CreativeHeadView addSubview:self.iCarouseCreated];
    self.iCarouseCreated.backgroundColor = [UIColor clearColor];
    __weak VMovieViewController *kSelf = self;
    self.iCarouseCreated.seletedImageViewTag = ^(NSInteger tag){
        
        [kSelf skipViewControllerFromiCarouse:tag array:array];
    };
    self.iCarouseCreated.currentImageViewTag = ^(NSInteger tag){
        
        UIImageView *imageView = mArray[tag];
        kSelf.CreativeHeadImageView.image = imageView.image;
    };
}
//取出照片链接
- (NSMutableArray *)selectedImageUrl:(NSMutableArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];

    for (int i = 0; i < 3; i++) {
        
        MovieModel *model = array[i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"register"] options:SDWebImageRefreshCached];
        [mArray addObject:imageView];
    }
    return mArray;
}
//取出标题
- (NSMutableArray *)titleICarouse:(NSMutableArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        
        MovieModel *model = array[i];
        NSString *str = [@"🔥  " stringByAppendingString:model.title];
        [mArray addObject:str];
    }
    return mArray;
}
- (void) blurEffectAddView:(UIImageView *)imageView{
    
    //    毛玻璃效果
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    visualEffectView.alpha = 1;
    [visualEffectView setFrame:imageView.frame];
    [imageView addSubview:visualEffectView];
}
//添加顶部视图
- (void)selectedNavigationViewTools {
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"速看", @"科幻", @"创意", nil];
    self.tool = [[MSQSelectedNavigationViewTools alloc] initLHSelectedNavigationViewToolsWithFrame:CGRectMake(kScreenW/4, 0, kScreenW/2, 30) ButtonTitle: array];
    __weak VMovieViewController *kSelf = self;
    self.tool.selectedScrollViewPageBlock = ^(NSInteger tag){
        
        if (tag == 0) {
            
            [kSelf.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if (tag == 1) {
            
            [kSelf.mainScrollView setContentOffset:CGPointMake(kScreenW, 0) animated:YES];
        }else if (tag == 2) {
            
            [kSelf.mainScrollView setContentOffset:CGPointMake(kScreenW*2, 0) animated:YES];
        }
    };
    self.tabBarVC.navigationItem.titleView = self.tool;
}
//刷新
- (void)addThirdTools {
    
    self.MovieTabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        PlayViewController *play = [PlayViewController shardPalyViewController];
        [play pauseVideo];
        play.playViewVC.mview.hidden = YES;
        play.plaryLayer.hidden       = YES;
        play.playViewVC.view.hidden  = YES;
        play.view.hidden             = YES;
        
        self.isRefreshHeader = YES;
        [self.mParameters setValue:@1 forKey:@"p"];
        [self.mParameters setValue:@0 forKey:@"cateid"];
        [self fechDateSourceWithURL:kMovieURL dictionary:self.mParameters];
    }];
    self.ScienceTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        PlayViewController *play = [PlayViewController shardPalyViewController];
        [play pauseVideo];
        play.playViewVC.mview.hidden = YES;
        play.plaryLayer.hidden       = YES;
        play.playViewVC.view.hidden  = YES;
        play.view.hidden             = YES;
        
        self.isRefreshHeader = YES;
        [self.mParameters setValue:@1 forKey:@"p"];
        [self.mParameters setValue:@23 forKey:@"cateid"];
        [self fechDateSourceWithURL:kMovieURL dictionary:self.mParameters];
    }];
    self.CreativeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        PlayViewController *play = [PlayViewController shardPalyViewController];
        [play pauseVideo];
        play.playViewVC.mview.hidden = YES;
        play.plaryLayer.hidden       = YES;
        play.playViewVC.view.hidden  = YES;
        play.view.hidden             = YES;
        
        self.isRefreshHeader = YES;
        [self.mParameters setValue:@1 forKey:@"p"];
        [self.mParameters setValue:@6 forKey:@"cateid"];
        [self fechDateSourceWithURL:kMovieURL dictionary:self.mParameters];
    }];
    self.MovieTabelView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.isRefreshHeader = NO;
        self.movieP += 1;
        [self.mParameters setValue:[NSNumber numberWithInteger:self.movieP] forKey:@"p"];
        [self.mParameters setValue:@0 forKey:@"cateid"];
        [self fechDateSourceWithURL:kMovieURL dictionary:self.mParameters];
    }];
    self.ScienceTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.isRefreshHeader = NO;
        self.scienceP += 1;
        [self.mParameters setValue:[NSNumber numberWithInteger:self.scienceP] forKey:@"p"];
        [self.mParameters setValue:@23 forKey:@"cateid"];
        [self fechDateSourceWithURL:kMovieURL dictionary:self.mParameters];
    }];
    self.CreativeTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.isRefreshHeader = NO;
        self.creativeP += 1;
        [self.mParameters setValue:[NSNumber numberWithInteger:self.creativeP] forKey:@"p"];
        [self.mParameters setValue:@6 forKey:@"cateid"];
        [self fechDateSourceWithURL:kMovieURL dictionary:self.mParameters];
    }];
}

#pragma mark --------数据请求----------------

-(void)fechDateSourceWithURL:(NSString*)url dictionary:(NSMutableDictionary *)dictionary{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [manager POST:url parameters:dictionary progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:nil];
            NSArray *array = dic[@"data"];
            
            NSNumber *tempNum = [dictionary objectForKey:@"cateid"];
            if ([tempNum isEqual:@0]) {
                
                for (NSDictionary *dic in array) {
                    
                    MovieModel *model = [[MovieModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.mMovieArray addObject:model];
                }
                if (self.isRefreshHeader && self.mMovieArray.count > 10) {
                    NSRange range = NSMakeRange(0, 10);
                    [self.mMovieArray removeObjectsInRange:range];
                    self.isRefreshHeader = NO;
                }
                [self addHeaderView:[self levelMaxToMin:self.mMovieArray]];
            }else if ([tempNum isEqual:@23]) {
                
                for (NSDictionary *dic in array) {
                    
                    MovieModel *model = [[MovieModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.mScienceArray addObject:model];
                }
                if (self.isRefreshHeader && self.mScienceArray.count > 10) {
                    NSRange range = NSMakeRange(0, 10);
                    [self.mScienceArray removeObjectsInRange:range];
                    self.isRefreshHeader = NO;
                }
                [self addHeaderViewS:[self levelMaxToMin:self.mScienceArray]];
            }else {
                
                for (NSDictionary *dic in array) {
                    
                    MovieModel *model = [[MovieModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.mCreativeArray addObject:model];
                }
                if (self.isRefreshHeader && self.mCreativeArray.count > 10) {
                    NSRange range = NSMakeRange(0, 10);
                    [self.mCreativeArray removeObjectsInRange:range];
                    self.isRefreshHeader = NO;
                }
                [self addHeaderViewC:[self levelMaxToMin:self.mCreativeArray]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.MovieTabelView.mj_header endRefreshing];
                [self.ScienceTableView.mj_header endRefreshing];
                [self.CreativeTableView.mj_header endRefreshing];
                [self.MovieTabelView.mj_footer endRefreshing];
                [self.ScienceTableView.mj_footer endRefreshing];
                [self.CreativeTableView.mj_footer endRefreshing];
                [self.MovieTabelView reloadData];
                [self.ScienceTableView reloadData];
                [self.CreativeTableView reloadData];
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.MovieTabelView.mj_header endRefreshing];
                [self.ScienceTableView.mj_header endRefreshing];
                [self.CreativeTableView.mj_header endRefreshing];
                [self.MovieTabelView.mj_footer endRefreshing];
                [self.ScienceTableView.mj_footer endRefreshing];
                [self.CreativeTableView.mj_footer endRefreshing];
            });
        }];
        
    });
}

#pragma mark -------代理方法------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.MovieTabelView) {
    
        
        return [tableView showMessage:@"💦没有网络数据，😱快下拉刷新" byDataSourceCount:self.mMovieArray.count];
    }else if (tableView == self.ScienceTableView) {
        
        return [tableView showMessage:@"💦没有网络数据，😱快下拉刷新" byDataSourceCount:self.mScienceArray.count];
    }else {
        return [tableView showMessage:@"💦没有网络数据，😱快下拉刷新" byDataSourceCount:self.mCreativeArray.count];
    }
}

- (MovieTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.delegate = self;
    if (tableView == self.MovieTabelView) {
        
        MovieModel *model = self.mMovieArray[indexPath.row];
        [cell setValuesWithCell:model];
    }else if (tableView == self.ScienceTableView) {
        
        MovieModel *model = self.mScienceArray[indexPath.row];
        [cell setValuesWithCell:model];
    }else {
        
        MovieModel *model = self.mCreativeArray[indexPath.row];
        [cell setValuesWithCell:model];
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 220;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[PlayViewController shardPalyViewController]pullDownCellAddPlay:cell indexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self skipViewController:indexPath.row];
}

//跳转方法；
- (void)skipViewController:(NSInteger)row {
    
    InfoMovieViewController *infoMovieVC = [[InfoMovieViewController alloc]init];
    [[PlayViewController shardPalyViewController]suspendPlayWhenChengeView];
    if (self.mainScrollView.contentOffset.x == 0) {
        
        MovieModel *model = self.mMovieArray[row];
        
        [infoMovieVC.dicPostid setValue:model.postid forKey:@"postid"];
    }else if (self.mainScrollView.contentOffset.x == kScreenW) {
        
        MovieModel *model = self.mScienceArray[row];
        [infoMovieVC.dicPostid setValue:model.postid forKey:@"postid"];
    }else if (self.mainScrollView.contentOffset.x == kScreenW*2) {
        
        MovieModel *model = self.mCreativeArray[row];
        [infoMovieVC.dicPostid setValue:model.postid forKey:@"postid"];
    }
    
    [self.navigationController pushViewController:infoMovieVC animated:YES];
}

- (void)skipViewControllerFromiCarouse:(NSInteger)tag array:(NSMutableArray *)array{
    
    InfoMovieViewController *infoMovieVC = [[InfoMovieViewController alloc]init];
    
        MovieModel *model = array[tag];
        [infoMovieVC.dicPostid setValue:model.postid forKey:@"postid"];
    
    [self.navigationController pushViewController:infoMovieVC animated:YES];
}



//滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.mainScrollView) {
        
         [self.tool moveMarkLabelWithContentOffset:scrollView.contentOffset];
        if (scrollView.contentOffset.x == 0) {
            
            [[PlayViewController shardPalyViewController]suspendPlayWhenChengeView];
        }else if (scrollView.contentOffset.x == kScreenW) {
            
            [[PlayViewController shardPalyViewController]suspendPlayWhenChengeView];
            if (self.mScienceArray.count == 0) {
                
                [self.mParameters setValue:@1 forKey:@"p"];
                [self.mParameters setValue:@23 forKey:@"cateid"];
                [self fechDateSourceWithURL:kMovieURL dictionary:self.mParameters];
            }
        }else if (scrollView.contentOffset.x == kScreenW*2) {
            
            [[PlayViewController shardPalyViewController]suspendPlayWhenChengeView];
            if ( self.mCreativeArray.count == 0) {
                
                [self.mParameters setValue:@1 forKey:@"p"];
                [self.mParameters setValue:@6 forKey:@"cateid"];
                [self fechDateSourceWithURL:kMovieURL dictionary:self.mParameters];
            }
        }
    }
}

//排序方法
- (NSMutableArray *)levelMaxToMin:(NSMutableArray *)arr {
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:arr];
    
    if (array.count<5) {
        return array;
    }
    for (int i = 2; i < 5; i++) {
        for (int j = i; j < array.count-1; j++) {
            
            MovieModel *jModel = array[j];
            MovieModel *iModel = array[j+1];
            NSInteger jInt = [jModel.share_num integerValue];
            NSInteger iInt = [iModel.share_num integerValue];
            if (iInt < jInt) {
                
                [array exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
            }
        }
    }
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSInteger i = array.count-3; i < array.count; i++) {
        
        MovieModel *model = array[i];
        [mArray addObject:model];
    }
    return mArray;
}

//播放按钮的方法

- (void)buttonSelectAction:(UIButton *)sender {
    
    NSIndexPath *indexPath = [(UITableView *)sender.superview.superview.superview.superview indexPathForCell:(UITableViewCell *)sender.superview.superview];
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    UITableView *tableView = (UITableView *)sender.superview.superview.superview.superview;
    
    MovieModel *model;
    if (tableView == self.MovieTabelView) {
        
        model = self.mMovieArray[indexPath.row];
    }else if (tableView == self.ScienceTableView) {
        
        model = self.mScienceArray[indexPath.row];
    }else {
        
        model = self.mCreativeArray[indexPath.row];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [manager POST:kInfoMovie parameters:[NSDictionary dictionaryWithObjectsAndKeys:model.postid,@"postid", nil] progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:nil];
            NSDictionary *di = dic[@"data"];
            NSDictionary *d = [di objectForKey:@"download_link"];
            PlayViewController *plauer = [PlayViewController shardPalyViewController];
            [plauer playVideoAtCell:cell url:d[@"mp4"][0] tableView:tableView contentsetY:cell.frame.origin.y viewController:self indexPath:indexPath title:model.title imageUrl:model.image];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    });
}

//播放按钮的数据请求

-(void)fechDateSourceWithURLForButtonAction:(NSString*)url dictionary:(NSMutableDictionary *)dictionary{
    
    
}

-(UIImage *)base64StringToImage:(NSString *)bade64String{
    //    字符串转换成Data；
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:bade64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //    data转换成图片
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image;
}

-(NSString *)imageToStringWithImage:(UIImage *)image{
    
    //    先将image转换成Data类型
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //    将nsdata 转换成字符串
    NSString *string = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return string;
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
