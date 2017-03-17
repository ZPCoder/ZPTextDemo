//
//  TabBarViewController.m
//  Video
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()<MTabBarDelegate>

@property (nonatomic, assign) BOOL menuIsVisible;
@property (nonatomic, strong) HMSideMenu *sideMenu;

@property (nonatomic,retain)UILabel *stateLabel;

@end

@implementation TabBarViewController

#pragma mark ---------懒加载-----------
-(UILabel *)stateLabel{

    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, kWidth, 30)];

        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.font = [UIFont fontWithName:@"STHeitiK-Light" size:15];
        _stateLabel.font = [UIFont systemFontOfSize:15];
        _stateLabel.textColor = [UIColor orangeColor];
        _stateLabel.backgroundColor = [UIColor colorWithRed:70 green:72 blue:79 alpha:0.8];
        [self.view addSubview:_stateLabel];
    }
    return _stateLabel;
}

#pragma mark --------视图声明周期------------

-(void)viewWillAppear:(BOOL)animated{

//    self.stateLabel.hidden = YES;
    //网络监听
    [self networkingState];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加子视图控制器
    [self addChildVc:[[VMovieViewController alloc] init] title:@"V电影" image:@"movie" selectedImage:@"number1"];
    UIStoryboard *artStoryboard = [UIStoryboard storyboardWithName:@"ArtStoryBoard" bundle:nil];
    [self addChildVc:[artStoryboard instantiateViewControllerWithIdentifier:@"ArtViewController"] title:@"酷炫舞" image:@"dance" selectedImage:@"number2"];
    [self addChildVc:[[NewsViewController alloc] init] title:@"趣乐闻" image:@"TV" selectedImage:@"number3"];
    [self addChildVc:[[FunnyViewController alloc]init] title:@"涨姿势" image:@"gaoxiao" selectedImage:@"number4"];
    MTabBar *mTabBar = [[MTabBar alloc] init];
    
    mTabBar.delegate = self;
    // KVC：如果要修系统的某些属性，但被设为readOnly，就是用KVC，即setValue：forKey：。
    [self setValue:mTabBar forKey:@"tabBar"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    // Do any additional setup after loading the view.

    //点击主页弹出按钮
//    [self centerBtn];
}

//打开左侧控制器
- (void)leftBarButtonAction {
    
    [self.sideMenuViewController presentLeftMenuViewController];
}
//打开右侧控制器
- (void)rightBarButtonAction {
    
//    [self.sideMenuViewController presentRightMenuViewController];
}
/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];

    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBColor(123, 123, 123)} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} forState:UIControlStateSelected];
    
    // 为子控制器包装导航控制器
//    MNavigationController *navigationVc = [[MNavigationController alloc] initWithRootViewController:childVc];
//    // 添加子控制器
    [self addChildViewController:childVc];
}


#pragma mark --监听网络状态
-(void)networkingState{
    //设置网络监听

    //监听网络状态
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];

    //显然是枚举值


    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");{
                    self.stateLabel.hidden = NO;
                    self.stateLabel.text = @"未识别的网络状态";
                    self.stateLabel.alpha = 0.5;
                    [UILabel animateWithDuration:4.0 animations:^{
                        self.stateLabel.alpha = 0.01;
                    }];
                    break;
                }
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");{
                    self.stateLabel.hidden = NO;
                    self.stateLabel.text = @"不可达的网络状态(未连接)";
                    self.stateLabel.alpha = 0.5;
                    [UILabel animateWithDuration:4.0 animations:^{
                        self.stateLabel.alpha = 0.01;
                    }];
                }
                break;

            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"2G,3G,4G...的网络");{
                    self.stateLabel.hidden = NO;
                    self.stateLabel.text = @"目前为蜂窝状态";
                    self.stateLabel.alpha = 0.5;
                    [UILabel animateWithDuration:4.0 animations:^{
                        self.stateLabel.alpha = 0.01;
                    }];
                }
                break;

            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi的网络");{
                    self.stateLabel.hidden = NO;
                    self.stateLabel.text = @"目前为WIFI状态";
                    self.stateLabel.alpha = 0.5;
                    [UILabel animateWithDuration:4.0 animations:^{
                        self.stateLabel.alpha = 0.01;
                    }];
                }
                    break;
                default:
                    break;
            }
        }];
        
        //3.开始监听
        [manager startMonitoring];
}

#pragma MTabBarDelegate


/**
 *  中间按钮点击
 */
- (void)tabBarDidClickPlusButton:(MTabBar *)tabBar
{

//    if (self.sideMenu.isOpen) {
//        [self.sideMenu close];
//
//    }else{
//        [self.sideMenu open];
//    }
}


//中间按钮

/*
-(void)centerBtn{
    //扫一扫
    UIView *saoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [saoView setMenuActionWithBlock:^{

        NSLog(@"扫一扫");
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"扫一扫" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    [saoView addSubview:button];

    //收藏
    UIView *collectView = [[UIView alloc]initWithFrame:CGRectMake(20, kHeight-60, 50, 40)];
    [collectView setMenuActionWithBlock:^{

        NSLog(@"收藏");
    }];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:@"收藏" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(collectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setFrame:CGRectMake(5, 5, 35, 35)];
    [collectView addSubview:button1];

    //播放记录
    UIView *recordView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [recordView setMenuActionWithBlock:^{

        NSLog(@"播放记录");
    }];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"播放记录" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(recordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setFrame:CGRectMake(2, 2, 35, 35)];
    [recordView addSubview:button2];

    //切换模式
    UIView *modelView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [modelView setMenuActionWithBlock:^{

        NSLog(@"切换模式");
    }];
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button3 setTitle:@"切换模式" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(modelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [button3 setFrame:CGRectMake(0, 0, 40, 40)];
    [modelView addSubview:button3];

    self.sideMenu = [[HMSideMenu alloc] initWithItems:@[saoView, collectView, recordView, modelView]];
    [self.sideMenu setItemSpacing:5.0f];
    [self.view addSubview:self.sideMenu];
}

#pragma mark ---点击主页面按钮回调
//扫一扫
-(void)saoBtnAction:(UIButton *)sender{

}

//收藏
-(void)collectBtnAction:(UIButton *)sender{

    NSLog(@"收藏");
}

//播放记录
-(void)recordBtnAction:(UIButton *)sender{

}

//切换模式
-(void)modelBtnAction:(UIButton *)sender{

}
*/

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
