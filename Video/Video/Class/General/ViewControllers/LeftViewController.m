//
//  LeftViewController.m
//  Video
//
//  Created by 朱鹏 on 16/5/5.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "LeftViewController.h"
#import "UserInfoViewController.h"
#import "playRecordedVC.h"

@interface LeftViewController ()<CLLocationManagerDelegate, TransDataDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableDictionary *mWeatherDic;
@property (strong, nonatomic) IBOutlet UILabel *weatherL;
@property (strong, nonatomic) IBOutlet UILabel *temperatureL;
@property (strong, nonatomic) IBOutlet UILabel *locationL;
@property (strong, nonatomic) IBOutlet UIImageView *weatherImage;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIView *nextView;

@property (strong, nonatomic) IBOutlet UIImageView *userHeadImageView;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentInfo;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (strong, nonatomic) IBOutlet UIView *rightView;

@property (strong,nonatomic)NSMutableArray *allDateArray;
@property (assign, nonatomic) BOOL isLogin;

@property (assign, nonatomic) double doubleSize;

@property (strong, nonatomic) CLLocationManager *locationManager;   //地理管理对象，定位服务都需要借此对象完成；
@property (strong, nonatomic) CLGeocoder *geocoder;  //负责（反）地理编码的核心类；
@property (strong,nonatomic)UIButton *mybtn;


@end

@implementation LeftViewController

#pragma mark -----------懒加载-------------


- (NSMutableDictionary *)mWeatherDic {
    
    if (!_mWeatherDic) {
        _mWeatherDic = [NSMutableDictionary dictionaryWithDictionary:@{@"key":@"snemrbgx0sf5x59g",@"location":@"beijing",@"language":@"zh-Hans",@"unit":@"c"}];
    }
    return _mWeatherDic;
}

- (double)doubleSize {
    
    _doubleSize = [CleanCaches sizeWithFilePath:[SendBoxPath libraryPath]];
    return _doubleSize;
}

-(NSMutableArray *)allDateArray{
    
    if (!_allDateArray) {
        _allDateArray = [NSMutableArray arrayWithObjects:@"收藏",@"播放记录",@"清除缓存",@"模式切换",@"扫一扫",@"服务声明", nil];
    }
    return _allDateArray;
}

#pragma mark --------------视图生命周期--------------------
//目标接口：https://api.thinkpage.cn/v3/weather/now.json?key=snemrbgx0sf5x59g&location=beijing&language=zh-Hans&unit=c

- (void)viewDidLoad {
    [super viewDidLoad];

    self.geocoder = [[CLGeocoder alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    
    [self.leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.nextView.backgroundColor = [UIColor clearColor];
    
    [self.userLabel NightWithType:UIViewColorTypeClear];
    [self.contentInfo NightWithType:UIViewColorTypeClear];
    [self.locationL NightWithType:UIViewColorTypeClear];
    [self.weatherL NightWithType:UIViewColorTypeClear];
    [self.temperatureL NightWithType:UIViewColorTypeClear];
    //让所有控件处于透明状态，使得View的背景图片显示出来，从而使得夜间模式和日间模式的leftViewController更加好看
    [self.view NightWithType:UIViewImageColor];

    self.leftTableView.backgroundColor = [UIColor clearColor];

    UIImage *btnImage = [ThemeManage shareThemeManage].isNight ? [UIImage imageNamed:@"yejian"] : [UIImage imageNamed:@"rijian"];
    self.mybtn = [self creatBtnWithImage:btnImage frame:CGRectMake(0, 0, 50, 30) action:@selector(btnAction:)];
    
    
    //本地登录信息
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.isLogin = NO;
    NSMutableDictionary *userInfoDic = [MSQFileReadAndWriteTools readDictionaryWithFilePath:kThirdParty];
    if (userInfoDic != nil) {
        
        self.isLogin = YES;
        self.userHeadImageView.image = [self base64StringToImage:userInfoDic[@"image"]];
        self.userLabel.text = userInfoDic[@"userName"];
        
    }
    NSMutableDictionary *userInfoD = [MSQFileReadAndWriteTools readDictionaryWithFilePath:kUserInfoParth];
    if (userInfoD != nil) {
        
        self.isLogin = YES;
        self.userHeadImageView.image = [self base64StringToImage:userInfoD[@"image"]];
        self.userLabel.text = userInfoD[@"userName"];
        self.contentInfo.text = userInfoD[@"userContent"];
    }
    if (!self.isLogin) {
        
        self.userHeadImageView.image = [UIImage imageNamed:@"headImage"];
        self.userLabel.text = @"点击登录";
        self.contentInfo.text = @"他很懒，啥都不写😝";
    }
    self.userHeadImageView.layer.cornerRadius = 35;
    self.userHeadImageView.layer.masksToBounds = YES;
    //是否定位
    if ([self isLocation]) {
        
        [self startLocation];
        
    }else {
        
        [self fechDateSourceWithURL:kWeatherUrl dictionary:self.mWeatherDic];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
#pragma mark ------------定位--------------------
- (BOOL)isLocation {
    
    return [CLLocationManager locationServicesEnabled];
}

- (void)startLocation {
    
    //用户已经开启了定位服务
    //取得用户授权   不管应用是否在前台运行，都可以获取用户授权；
    [self.locationManager requestWhenInUseAuthorization];
    //定位服务，每隔多少米定位一次；
    self.locationManager.distanceFilter = 1000;
    //定位的精确度，越高越耗电
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    //指定代理
    self.locationManager.delegate = self;
    //开始定位
    [self.locationManager startUpdatingLocation];
}

//实时获取的定位信息    代理方法会被多次执行
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (locations.count) {
        //获取最新位置
        CLLocation *location = locations.lastObject;
        NSString *str = [NSString stringWithFormat:@"%.2f:%.2f",location.coordinate.latitude,location.coordinate.longitude];
        NSLog(@"%@",str);
        [self.mWeatherDic setValue:str forKey:@"location"];
        [self fechDateSourceWithURL:kWeatherUrl dictionary:self.mWeatherDic];
        [self.locationManager stopUpdatingLocation];
    }
}
//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    [self fechDateSourceWithURL:kWeatherUrl dictionary:self.mWeatherDic];
    if ([error code] == kCLErrorDenied) {
        
        NSLog(@"定位被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        
         NSLog(@"定位失败 = %@", error);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//数据请求；
-(void)fechDateSourceWithURL:(NSString*)url dictionary:(NSMutableDictionary *)dictionary{
//    [MBProgressHUD showHUDAddedTo:self.rightView animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [manager GET:kWeatherUrl parameters:dictionary progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *jsoStr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *dic = jsoStr[@"results"][0];
            self.locationL.text = dic[@"location"][@"name"];
            self.temperatureL.text = [NSString stringWithFormat:@"%@℃",dic[@"now"][@"temperature"]];
            self.weatherL.text = dic[@"now"][@"text"];
            self.weatherImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"now"][@"code"]]];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideAllHUDsForView:self.rightView animated:YES];
            });
//            [self headImageColour:dic[@"now"][@"code"]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideAllHUDsForView:self.rightView animated:YES];
            });
        }];
        
    });
}
/*
- (void)headImageColour:(NSString *)code {
    
    NSInteger number = [code integerValue];
    
    if ((number > 8 && number < 38) || number == 1 || number == 3 || number == 6 || number == 8) {
        
        self.headImage.backgroundColor = [UIColor lightGrayColor];
        self.nextView.backgroundColor = [UIColor lightGrayColor];
    }else {
        
        self.headImage.backgroundColor =[UIColor colorWithRed:122/255.0 green:214/255.0 blue:253/255.0 alpha:1];
        self.nextView.backgroundColor = self.headImage.backgroundColor;
    }
    
}
 */
#pragma mark ------------点击手势--------------

- (IBAction)LoginGesture:(UITapGestureRecognizer *)sender {
    
    if (self.isLogin) {
        
        UserInfoViewController *userINfoVC = [[UserInfoViewController alloc] init];
        userINfoVC.delegate = self;
        userINfoVC.headImageView.image = self.userHeadImageView.image;
        userINfoVC.userLabel.text = self.userLabel.text;
        userINfoVC.contentText.text = self.contentInfo.text;
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:userINfoVC];
        [self presentViewController:navC animated:YES completion:nil];
    }else {
        
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navC animated:YES completion:nil];
    }
}


- (void)transDataWithDelegate:(NSString *)userName userTalk:(NSString *)userTalk userHeadImage:(UIImage *)userHeadImage {
    
    self.userHeadImageView.image = userHeadImage;
    self.userHeadImageView.layer.cornerRadius = 35;
    self.userHeadImageView.layer.masksToBounds = YES;
    self.userLabel.text = userName;
    self.contentInfo.text = userTalk;
}


#pragma mark ---------tableView代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allDateArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.allDateArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    [cell.textLabel NightWithType:UIViewColorTypeClear];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        //收藏
        [self collectAction];
    }else if(indexPath.row == 1){
        
        [self playRecordedVC];
    }else if(indexPath.row == 2){
        
        //弹框
        [self createAlerView];
        
    }else if(indexPath.row == 3){
        
        //夜间模式
        [self btnAction:self.mybtn];
        
    }else if(indexPath.row == 4){

        //扫一扫
        [self saoyisao];

    }else if (indexPath.row == 5){
        
        //免责声明
        [self disclaimerText];
    }
}

//免责声明
- (void)disclaimerText {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"本视" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:sureAction];
    //模态推出
    [self presentViewController:alertC animated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//播放记录
- (void)playRecordedVC {
    
    // 实例化
    LAContext *lac = [[LAContext alloc]init];
    NSError *error;
    // 判断设备是否支持指纹识别
    BOOL isSupport = [lac canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if(!isSupport || !([AVUser currentUser].username.length != 0))
    {
        playRecordedVC *playRecorded = [[playRecordedVC alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:playRecorded];
        [self presentViewController:navC animated:YES completion:nil];
        
        return;
    }
    [lac evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请进行指纹验证" reply:^(BOOL success, NSError *error) {
        if(success)
        {
            // 指纹验证成功后，跳转收藏页面
            dispatch_async(dispatch_get_main_queue(), ^{
                
                playRecordedVC *playRecorded = [[playRecordedVC alloc] init];
                UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:playRecorded];
                [self presentViewController:navC animated:YES completion:nil];
                
            });
        }else{
            NSLog(@"%@", error);
        }
    }];
}
//夜间模式执行方法
-(UIButton*)creatBtnWithImage:(UIImage*)image frame:(CGRect)frame action:(SEL)action{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame = frame;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.nextView addSubview:btn];
    return btn;
}
-(void)btnAction:(UIButton*)sender{
    
    [ThemeManage shareThemeManage].isNight = ![ThemeManage shareThemeManage].isNight;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeColor" object:nil];
    [[NSUserDefaults standardUserDefaults] setBool:[ThemeManage shareThemeManage].isNight forKey:@"night"];
    UIImage *barButtonImage = [ThemeManage shareThemeManage].isNight ? [UIImage imageNamed:@"yejian"] : [UIImage imageNamed:@"rijian"];
    [sender setImage:barButtonImage forState:UIControlStateNormal];
    
    
}

//收藏
-(void)collectAction{
    
    if ([AVUser currentUser].username.length != 0) {
        
    }else{
        NSLog(@"收藏成功");
    }

    // 实例化
    LAContext *lac = [[LAContext alloc]init];
    NSError *error;
    // 判断设备是否支持指纹识别
    BOOL isSupport = [lac canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if(!isSupport || !([AVUser currentUser].username.length != 0))
    {
        CollectViewController *collectVC = [[CollectViewController alloc]init];
        UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:collectVC];
        [self presentViewController:naVC animated:YES completion:nil];

        return;
    }
    [lac evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请进行指纹验证" reply:^(BOOL success, NSError *error) {
        if(success)
        {
            // 指纹验证成功后，跳转收藏页面
            dispatch_async(dispatch_get_main_queue(), ^{

                CollectViewController *collectVC = [[CollectViewController alloc]init];
                UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:collectVC];

                [self presentViewController:naVC animated:YES completion:^{
                    
                }];

            });
        }else{
            NSLog(@"%@", error);
        }
    }];

}

//扫一扫
-(void)saoyisao{

    SaoViewController *saoVC = [[SaoViewController alloc]init];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:saoVC];
    [self presentViewController:navC animated:YES completion:nil];
}

//清楚缓存弹框
-(void)createAlerView{
   
    if (self.doubleSize != 0) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"清楚缓存后所有收藏即将删除！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 300;
        [alert show];
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"😝亲，已经没有缓存了！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        alert.tag = 301;
        [alert show];
    }
    
}



//清楚缓存
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (alertView.tag == 301) {
        
        return;
    }
    if (buttonIndex == 1 && self.doubleSize != 0.0) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] init];
        [self.view addSubview:hud];
        //加载条上显示文本
        hud.labelText = [NSString stringWithFormat:@"急速清理中(共 %.2f M)",self.doubleSize];
        //设置对话框样式
        hud.mode = MBProgressHUDModeDeterminate;
        [hud showAnimated:YES whileExecutingBlock:^{
            while (hud.progress < 1.0) {
                hud.progress += 0.01;
                [NSThread sleepForTimeInterval:0.02];
            }
            hud.labelText = @"清理完成";
        } completionBlock:^{
            //清除本地
            //清理coreData
            [[CollectManager sharedManager] deledataAllData];
            //清除caches文件下所有文件
            [CleanCaches clearSubfilesWithFilePath:[SendBoxPath libraryPath]];
            //清除内存
            [[SDImageCache sharedImageCache] clearMemory];
            [hud removeFromSuperview];
        }];
    }
}

-(UIImage *)base64StringToImage:(NSString *)bade64String{
    //    字符串转换成Data；
    if (bade64String == nil) {
        
        return [UIImage imageNamed:@"headImage"];
    }
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:bade64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //    data转换成图片
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image;
}

@end
