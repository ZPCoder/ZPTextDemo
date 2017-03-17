//
//  InfoMovieViewController.m
//  Video
//
//  Created by 朱鹏 on 16/5/3.
//  Copyright © 2016年 朱鹏 All rights reserved.
//接口地址：http://app.vmoiver.com/apiv3/post/view


#import "InfoMovieViewController.h"
#import "InfoMovieModel.h"
#import "ShareMovieModel.h"
#import "InfoMovieTableViewCell.h"

@interface InfoMovieViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (strong, nonatomic) InfoMovieModel *mInfoModel;

@property (strong, nonatomic) UIView *belowView;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UILabel *levelL;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIImageView *weixinImageView;
@property (strong, nonatomic) IBOutlet UIImageView *QQImageView;
@property (strong, nonatomic) IBOutlet UIImageView *PengYouQImageView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *pengyouquanGesture;


@end

@implementation InfoMovieViewController

- (NSMutableDictionary *)dicPostid {
    
    if (!_dicPostid) {
        _dicPostid = [NSMutableDictionary dictionaryWithDictionary:@{@"postid":@1234}];
    }
    return _dicPostid;
}
- (InfoMovieModel *)mInfoModel {
    
    if (!_mInfoModel) {
        _mInfoModel = [[InfoMovieModel alloc] init];
    }
    return _mInfoModel;
}

- (UIView *)belowView {
    
    if (!_belowView) {
        _belowView = [[UIView alloc] initWithFrame:self.headImage.frame];
    }
    return _belowView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.mainImageView layoutIfNeeded];
    [self imageViewChangeRadius];
    //毛玻璃效果
    [self blurEffectAddView];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"InfoMovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    self.mainTableView.estimatedRowHeight = 60;
    [self.mainTableView setRowHeight:UITableViewAutomaticDimension];
    [self fechDateSourceWithURL:kInfoMovie dictionary:self.dicPostid];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightShareButton)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(backMainView)];
    // Do any additional setup after loading the view from its nib.
}

- (void) imageViewChangeRadius {
    
    [self.QQImageView layoutIfNeeded];
    [self.weixinImageView layoutIfNeeded];
    [self.PengYouQImageView layoutIfNeeded];
    self.QQImageView.layer.cornerRadius = 25;
    self.QQImageView.layer.masksToBounds = YES;
    self.weixinImageView.layer.cornerRadius = 25;
    self.weixinImageView.layer.masksToBounds = YES;
    self.PengYouQImageView.layer.cornerRadius = 25;
    self.PengYouQImageView.layer.masksToBounds = YES;
}

- (void) blurEffectAddView{
    
    //    毛玻璃效果
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    visualEffectView.alpha = 1;
    [visualEffectView setFrame:[UIScreen mainScreen].bounds];
    [self.mainImageView addSubview:visualEffectView];
    self.mainTableView.backgroundColor = [UIColor clearColor];
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
            NSDictionary *d = dic[@"data"];
            [self.mInfoModel setValuesForKeysWithDictionary:d];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self headViewInterface];
                [self.mainTableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
        
    });
}

#pragma mark -----------代理方法------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (InfoMovieTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InfoMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    if (self.mInfoModel.content.length != 0) {
        
        cell.InfoL.text = self.mInfoModel.content;
        cell.InfoL.shineDuration = 3;
        cell.InfoL.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21.0];
        
        [cell.InfoL shine];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.mainTableView) {
        
        return;
    }
    if (scrollView.contentOffset.y < 0) {
        
        CGRect frame = self.belowView.frame;
        frame.origin.y = 64-scrollView.contentOffset.y;
        self.belowView.frame = frame;
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(InfoMovieTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)headViewInterface {
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.mInfoModel.image]];
    self.mainImageView.image = self.headImage.image;
    self.titleL.text = self.mInfoModel.title;
    NSMutableString *strLevel = [NSMutableString string];
    for (int i = 0 ; i < [self.mInfoModel.rating integerValue]/2; i++) {
        
        [strLevel appendString:@"🌟"];
    }
    
    self.levelL.text = [NSString stringWithFormat:@"%@ %@",strLevel,self.mInfoModel.rating];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect rect = [self.mInfoModel.content boundingRectWithSize:CGSizeMake(kScreenW-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21]} context:nil];
    return rect.size.height+50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)gestureAction:(UITapGestureRecognizer *)sender {
    
    NSDictionary *dic = self.mInfoModel.download_link;
    PlayViewController *player = [PlayViewController shardPalyViewController];
    
    [player commonPlay:self playFrame:CGRectMake(0, 64, kScreenW, self.headImage.frame.size.height) urlWithString:dic[@"mp4"][0] title:self.titleL.text imageUrl:self.mInfoModel.image];
}
- (IBAction)playButton:(UIButton *)sender {
    
    
    NSDictionary *dic = self.mInfoModel.download_link;
    PlayViewController *player = [PlayViewController shardPalyViewController];
    
    [player commonPlay:self playFrame:CGRectMake(0, 64, kScreenW, self.headImage.frame.size.height) urlWithString:dic[@"mp4"][0] title:self.titleL.text imageUrl:self.mInfoModel.image];
    
}

//分享
- (void)shareMovie {
    
    MSQShare *share = [[MSQShare alloc] init];
    NSDictionary *dic = self.mInfoModel.download_link;
    [share ShareToAll:self.mInfoModel.title image:self.headImage.image url:dic[@"mp4"][0] viewController:self];
}
//收藏
- (void)colletMovie {
    
    NSDictionary *dic = self.mInfoModel.download_link;
    CollectionModel *colletModel = [[CollectionModel alloc]init];
    colletModel.title = self.mInfoModel.title;
    colletModel.image = self.mInfoModel.image;
    colletModel.file = dic[@"mp4"][0];
    colletModel.spare = [CollectManager dateToStringWhitDate];
    //    NSLog(@"=====%ld",self.number);
    [[CollectManager sharedManager]insertData:colletModel];
    
    //若用户登录，则上传至云端
    if ([AVUser currentUser].username.length != 0) {
        
        [ArtViewController creatLeanCludeWithString:colletModel.title image:colletModel.image video:colletModel.file userName:[AVUser currentUser].username time:colletModel.spare];
    }else{
        NSLog(@"收藏成功");
    }
}
//更多方法；
- (void)rightShareButton {
    
    
     UIActionSheet *sheet  = [[UIActionSheet alloc] initWithTitle:@"分享或收藏或投诉" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"收藏" otherButtonTitles:@"分享", @"投诉", @"取消", nil];
     [sheet showInView:self.view];
}
- (void)backMainView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------------actionSheet代理方法----------

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            
            [self colletMovie];
            break;
            
        case 1:
            
            [self shareMovie];
            break;
            
        case 2:
            
            [self complaint];
            break;
            
        case 3:
            
            return;
            break;
            
        default:
            break;
    }
}

- (void)complaint{
    
     complaintViewController *complainVC = [[complaintViewController alloc]init];
     NSDictionary *dic = self.mInfoModel.download_link;
    [complainVC transDataVideo:dic[@"mp4"][0]];
    [self presentViewController:complainVC animated:YES completion:nil];
}
- (IBAction)weixinShare:(UITapGestureRecognizer *)sender {
     NSDictionary *dic = self.mInfoModel.download_link;
    MSQShare *share = [[MSQShare alloc] init];
    [share ShareToWechatSession:self.mInfoModel.title image:self.headImage.image url:dic[@"mp4"][0] viewController:self];
}
- (IBAction)weiboShare:(UITapGestureRecognizer *)sender {
     NSDictionary *dic = self.mInfoModel.download_link;
    MSQShare *share = [[MSQShare alloc] init];
    [share ShareToSina:self.mInfoModel.title image:self.headImage.image url:dic[@"mp4"][0] viewController:self];
}
- (IBAction)PengyouquanShare:(UITapGestureRecognizer *)sender {
     NSDictionary *dic = self.mInfoModel.download_link;
    MSQShare *share = [[MSQShare alloc] init];
    [share ShareToWechatTimeline:self.mInfoModel.title image:self.headImage.image url:dic[@"mp4"][0] viewController:self];
}



/*
 
 - (void)shineLabel1 {
 
 if (self.mInfoModel.content.length != 0) {
 
 self.shineLabel = ({
 WWXShineLabel *label = [[WWXShineLabel alloc] initWithFrame:CGRectMake(16, 8, kScreenW-32, 30)];
 label.numberOfLines = 0;
 label.text = self.mInfoModel.content;
 label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21.0f];
 label.backgroundColor = [UIColor clearColor];
 [label sizeToFit];
 label;
 });
 
 [self.shineLabel shine];
 }
 }
 
 - (void)changeText
 {
 self.shineLabel = ({
 WWXShineLabel *label = [[WWXShineLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW-40, 60)];
 label.numberOfLines = 0;
 //        label.text = [self.textArray objectAtIndex:self.textIndex];
 label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
 label.backgroundColor = [UIColor clearColor];
 [label sizeToFit];
 label.center = self.view.center;
 label;
 });
 [self.view addSubview:self.shineLabel];
 
 }
 
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
