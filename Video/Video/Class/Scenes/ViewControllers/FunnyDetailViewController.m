//
//  FunnyDetailViewController.m
//  Video
//
//  Created by 朱鹏 on 16/5/9.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "FunnyDetailViewController.h"

@interface FunnyDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic,retain)UIScrollView *myScrollView;

@property (nonatomic,retain)RQShineLabel *textLabel;

@property (nonatomic,retain)UIButton *shardBtn; //分享按钮
@property (nonatomic,retain)UIButton *collectBtn; //收藏按钮

//@property (nonatomic,retain)UIButton *playBtn;  //播放按钮

@property (nonatomic,retain)UILabel *alertLabel; //保存弹框

@property (nonatomic,assign)CGFloat videoWidth;
@property (nonatomic,assign)CGFloat videoHeight;
@property (nonatomic,retain)UIImageView *videoImageView;


@end

@implementation FunnyDetailViewController


#pragma mark --懒加载
-(UIScrollView *)myScrollView{

    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _myScrollView.backgroundColor = [UIColor blackColor];
    }
    return _myScrollView;
}

-(RQShineLabel *)textLabel{

    if (!_textLabel) {
        _textLabel = [[RQShineLabel alloc]initWithFrame:CGRectMake(10, 100, kWidth-20, 100)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont fontWithName:@"STHeitiK-Light" size:18];

    }
    return  _textLabel;
}

-(UIButton *)shardBtn{

    if (!_shardBtn) {
        _shardBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_shardBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shardBtn addTarget:self action:@selector(shardAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shardBtn setFrame:CGRectMake(kWidth-60, kHeight-40, 50, 30)];
        _shardBtn.tintColor = [UIColor whiteColor];
    }
    return _shardBtn;
}

-(UIButton *)collectBtn{
    
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_collectBtn setFrame:CGRectMake(kWidth-130, kHeight-40, 50, 30)];
        _collectBtn.tintColor = [UIColor whiteColor];

    }
    return _collectBtn;
}

-(UIButton *)saveBtn{

    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        [_saveBtn setFrame:CGRectMake(10, kHeight-40, 50, 30)];
        _saveBtn.tintColor = [UIColor whiteColor];

    }

    return _saveBtn;
}

-(UILabel *)alertLabel{

    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kWidth, 20)];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.font = [UIFont fontWithName:@"STHeitiK-Light" size:10];
        _alertLabel.font = [UIFont systemFontOfSize:12];
        _alertLabel.textColor = [UIColor blackColor];
    }
    return _alertLabel;
}

-(UIImageView *)videoImageView{

    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, kWidth, 300)];
        _videoImageView.center = self.view.center;
    }
    return _videoImageView;
}

-(UIButton *)playBtn{

    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_playBtn setFrame:CGRectMake(0, 0, 50, 50)];
        [_playBtn setImage:[[UIImage imageNamed:@"play"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    return _playBtn;
}

#pragma mark --按钮回调
-(void)shardAction:(UIButton *)sender{

    NSLog(@"分享");

    MSQShare *share = [[MSQShare alloc]init];
    UIImageView *imageView = [[UIImageView alloc]init];
    if (self.model.image) { //如果是图片类

        NSArray *imageArray = self.model.image[@"big"];
        [imageView sd_setImageWithURL:imageArray.firstObject];
        

    }else if (self.model.gif){ //如果是gif类

        NSArray *imageArray = self.model.gif[@"gif_thumbnail"];
        [imageView sd_setImageWithURL:imageArray.firstObject];

    }

    //分享
    [share ShareToAll:self.model.text image:imageView.image url:self.model.share_url viewController:self];
}

//收藏按钮回调
-(void)collectAction:(UIButton *)sender{

    CollectionModel *colletModel = [[CollectionModel alloc]init];
    colletModel.title = self.textLabel.text;
    
    if (self.model.image) {  //判断如果是图片则直接传图片
       
        NSArray *imageArray = self.model.image[@"big"];
        colletModel.image = imageArray.firstObject;
        
        colletModel.file = nil;
    }else if (self.model.gif){//判断如果是gif直接传图片
        
        NSArray *gifArray = self.model.gif[@"images"];
        colletModel.image = gifArray.firstObject;
        colletModel.file = nil;
        
    }else {
        
        NSArray *videoArray = self.model.video[@"thumbnail"];
        colletModel.image = videoArray.firstObject;
        
        NSArray *videoUrl = self.model.video[@"video"];
        colletModel.file = videoUrl.firstObject;
    }
    
    [[CollectManager sharedManager]insertData:colletModel];

    //若用户登录，则上传至云端
    if ([AVUser currentUser].username.length != 0) {
        
        [ArtViewController creatLeanCludeWithString:colletModel.title image:colletModel.image video:colletModel.file userName:[AVUser currentUser].username time:[CollectManager dateToStringWhitDate]];
        NSLog(@"收藏成功");
        
    }else{
        
        NSLog(@"收藏失败");
    }
}

//保存按钮回调(保存到系统相册)---下载
-(void)saveAction:(UIButton *)sender{

    UIImageView *imageView = [[UIImageView alloc]init];
    if (self.model.image) {


        NSArray *imageArray = self.model.image[@"big"];
        [imageView sd_setImageWithURL:imageArray.firstObject];

    }else if (self.model.gif){

        NSArray *gifArray = self.model.gif[@"images"];
         [imageView sd_setImageWithURL:gifArray.firstObject];

    }else{

    }
    //保存到系统相册
    UIImageWriteToSavedPhotosAlbum(imageView.image,self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark --保存图片提示
-(void)savePhotoWithStr:(NSString *)str{

    self.alertLabel.text = str;

    self.alertLabel.alpha = 1.0;
    [UILabel animateWithDuration:4.0 animations:^{
            self.alertLabel.alpha = 0.01;
    }];
}

#pragma mark --保存图片的回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        [self savePhotoWithStr:@"保存失败"];

    }else{

        [self savePhotoWithStr:@"已保存到手机图库中"];
    }
}


#pragma mark --视图生命周期
-(void)viewWillAppear:(BOOL)animated{

    //标题的约束
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.view.mas_top).with.offset(70);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.centerX.equalTo(self.view.mas_centerX);

    }];

    //保存按钮
    [self.saveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);

    }];

    //分享按钮
    [self.shardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];

    //收藏按钮
    [self.collectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.right.equalTo(self.shardBtn.mas_right).with.offset(-60);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];

    //保存弹出框
    [self.alertLabel mas_remakeConstraints:^(MASConstraintMaker *make) {

//        make.left.equalTo(self.view.mas_left).with.offset(50);
        make.top.equalTo(self.view.mas_top).with.offset(20);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];


    //播放按钮
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
}

//视图即将消失
-(void)viewWillDisappear:(BOOL)animated{

    //暂停播放器
    [[PlayViewController shardPalyViewController]suspendPlayWhenChengeView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; //设置屏幕不下移64
    [self.view addSubview:self.myScrollView];

    //为scrollView添加背景图
    UIImageView *imageVIew = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageVIew.image = [UIImage imageNamed:@"mb.png"];
    imageVIew.alpha = 0.8;
    [self.myScrollView insertSubview:imageVIew atIndex:0];
    self.myScrollView.userInteractionEnabled = YES;
    self.view.frame = [UIScreen mainScreen].bounds;
    [self playerWithModel:self.model];

    //设置textLabel
    [self.view addSubview:self.textLabel];
    self.textLabel.text = self.model.text;
    [self.textLabel shine];  //开启酷炫动画

    //设置分享按钮
    [self.view addSubview:self.shardBtn];
    //设置收藏按钮
    [self.view addSubview:self.collectBtn];
    //设置保存按钮
    [self.view addSubview:self.saveBtn];
    //添加保存弹框
    [self.view addSubview:self.alertLabel];
    //添加播放按钮
    [self.view addSubview:self.playBtn];

}


#pragma mark --播放
-(void)playerWithModel:(FunnyModel *)model{


    if (model.gif) {
        CGFloat width = [model.gif[@"width"] floatValue];
        CGFloat height = [model.gif[@"height"]floatValue];
        NSArray *gifArray = model.gif[@"images"];
        NSLog(@"-----%@",gifArray.lastObject);

        UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        [photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",gifArray.firstObject]]];
        photoImageView.center = self.myScrollView.center;
        [self.myScrollView addSubview:photoImageView];

    }else if (model.image){

        CGFloat width = [model.image[@"width"]floatValue];
        CGFloat height = [model.image[@"height"]floatValue];
        NSArray *gifArray = model.image[@"big"];

        if (width > kWidth || height>kHeight) {  //宽度超出屏幕,高度超出屏幕

            //重新按照比例计算图片的frame
            UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, height*kWidth/width)];
            [photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",gifArray.firstObject]]];
            //按照图片的frame设置滚动范围
            self.myScrollView.contentSize = CGSizeMake(photoImageView.frame.size.width, photoImageView.frame.size.height);

            photoImageView.center = self.myScrollView.center;
            [self.myScrollView addSubview:photoImageView];


            if (photoImageView.frame.size.height>kHeight) {

                photoImageView.frame = CGRectMake(0, 0, kWidth, height*kWidth/width);
            }
        }else { //正常尺寸图片

            UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
            [photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",gifArray.firstObject]]];
            photoImageView.center = self.myScrollView.center;
            [self.myScrollView addSubview:photoImageView];

        }
    }else if (model.video){

        NSArray *array =model.video[@"thumbnail"];
        NSString *videoStr = [NSString stringWithFormat:@"%@",array.firstObject];
        [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:videoStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {


            self.videoImageView.center = self.view.center;
            [self.myScrollView addSubview:self.videoImageView];
        }];
    }
    //为imgaeView添加轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction:)];
    [self.myScrollView addGestureRecognizer:tap];
}

#pragma mark ---播放按钮
-(void)playerBtnAction:(UIButton *)sender{
    NSLog(@"播放视频");

    NSArray *videoArray = self.model.video[@"video"];
    NSArray *iArr = self.model.video[@"thumbnail"];
    PlayViewController *player = [PlayViewController shardPalyViewController];
    [player commonPlay:self playFrame:CGRectMake(self.videoImageView.frame.origin.x, self.videoImageView.frame.origin.y, self.videoImageView.frame.size.width, self.videoImageView.frame.size.width) urlWithString:videoArray.lastObject title:self.model.text imageUrl:iArr[0]];
    player.plaryLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.videoImageView.hidden = YES;
    self.playBtn.hidden = YES;

}

#pragma mark --轻拍按钮的回调
-(void)backAction:(UITapGestureRecognizer *)sender{

    [self dismissViewControllerAnimated:NO completion:nil];
    [self.myScrollView removeFromSuperview];
    self.myScrollView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
