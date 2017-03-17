//
//  LoginViewController.m
//  OurTeamVideo
//
//  Created by 朱鹏 on 16/4/28.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *nameTeXField;
@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;
@property (strong, nonatomic) IBOutlet UIView *belowView;
@property (strong, nonatomic) IBOutlet UIView *CreativeView;
@property (strong, nonatomic) IBOutlet UIImageView *owlImage;
@property (strong, nonatomic) IBOutlet UIImageView *weiboImagView;
@property (strong, nonatomic) IBOutlet UIImageView *qqImageView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //界面加载
    [self viewLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backMainVC)];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    [self performSelector:@selector(hideMB) withObject:nil afterDelay:1];
}
- (void)hideMB {
    
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
//加载基本界面
-(void)viewLoad{
    
    [self.qqImageView layoutIfNeeded];
    [self.weiboImagView layoutIfNeeded];
    self.weiboImagView.image = [UIImage imageNamed:@"icon@2x"];
    self.qqImageView.image = [UIImage imageNamed:@"qq"];
    self.weiboImagView.layer.cornerRadius = 30;
    self.weiboImagView.layer.masksToBounds = YES;
    self.qqImageView.layer.cornerRadius = 30;
    self.qqImageView.layer.masksToBounds = YES;
    //    TextField的左视图
    self.nameTeXField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *nameImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-user"]];
    self.pwdTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *pwdImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-password"]];
    [self.nameTeXField setLeftViewMode:UITextFieldViewModeAlways];
    [self.pwdTextField setLeftViewMode:UITextFieldViewModeAlways];
    [pwdImage setFrame:CGRectMake(3, 3, 24, 24)];
    [nameImage setFrame:CGRectMake(5, 5, 20, 20)];
    [self.pwdTextField.leftView addSubview:pwdImage];
    [self.nameTeXField.leftView addSubview:nameImage];
    //设置阴影
    self.belowView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.belowView.layer.shadowOffset = CGSizeMake(0, 0);
    self.belowView.layer.shadowOpacity = 0.5;
    self.belowView.layer.shadowRadius = 8;
    //动画
    [self addAnimalImage];
}

- (void)addAnimalImage {
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        
        [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"a%d.tiff",i]]];
    }
    self.owlImage.animationImages = array;
    self.owlImage.animationDuration = 2;
    self.owlImage.animationRepeatCount = 3;
}

#pragma mark --------------点击方法----------------
//结束编辑手势；
- (IBAction)endingEditGesture:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
}
- (IBAction)nameTextField:(UITextField *)sender {
    
    [self creativeViewShadow];
    self.CreativeView.layer.shadowOpacity = 0.5;
    [self owlOut];
}
- (IBAction)pwdTextFieldAction:(UITextField *)sender {
    
    [self owlIn];
}
- (IBAction)loginButton:(UIButton *)sender {
    
    //登录
    [self judgeLogin];
}
//注册
- (IBAction)RegisterButtonAction:(UIButton *)sender {
    
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
    }];
    RegistViewController *registerVC = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
//返回主界面
- (void)backMainVC {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//忘记密码
- (IBAction)forgetButtonAction:(UIButton *)sender {

    FindPswViewController *findVC = [[FindPswViewController alloc]init];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:findVC];
    [self presentViewController:navC animated:YES completion:nil];
}


- (void) creativeViewShadow {
    
    self.CreativeView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.CreativeView.layer.shadowOffset = CGSizeMake(10, 0);
    
    self.CreativeView.layer.shadowRadius = 8;
}

- (void)judgeLogin {
    
    NSString *message = nil;
    if ([self.nameTeXField.text isEqualToString:@""]) {

        message = @"请输入账号";
    }else if (self.pwdTextField.text.length == 0) {

        message = @"密码不能为空";
    }else {
        //判断用户名密码是否正确
        [AVUser logInWithUsernameInBackground:self.nameTeXField.text password:self.pwdTextField.text block:^(AVUser *user, NSError *error) {
            if (user != nil) {
                
                NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.nameTeXField.text, @"userName", @"", @"userContent", self.pwdTextField.text, @"pwd", @"", @"imageURL",[self imageToStringWithImage:[UIImage imageNamed:@"headImage"]], @"image",@"",@"other", nil];
                NSArray *array = [[CollectManager sharedManager] selectedData];
                for (CollectionModel * model in array) {
                    
                    [ArtViewController creatLeanCludeWithString:model.title image:model.image video:model.file userName:user.username time:model.spare];
                }
                [MSQFileReadAndWriteTools writeDictionary:userInfoDic toFilePath: kUserInfoParth];
                [CleanCaches clearCachesWithFilePath:kThirdParty];
                //回到主界面
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {

                [self alertViewWithMessage:@"登录失败,用户名或密码不正确"];
            }
        }];
        if (message) {
            [self alertViewWithMessage:message];
        }
    }
}
//模态弹窗
- (void)alertViewWithMessage:(NSString *)message {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:sureAction];
    //模态推出
    [self presentViewController:alertC animated:YES completion:nil];
}
//动画效果
- (void)owlOut {
    
    [UIView animateWithDuration:0.7 animations:^{
        
        CGRect frame = self.owlImage.frame;
        frame.origin.x = 50+frame.size.width;
        self.owlImage.frame = frame;
    } completion:^(BOOL finished) {
        [self.owlImage startAnimating];
    }];
}
- (void)owlIn {
    
    [UIView animateWithDuration:0.7 animations:^{
        [self.owlImage stopAnimating];
        CGRect frame = self.owlImage.frame;
        frame.origin.x = 20;
        self.owlImage.frame = frame;
    } completion:^(BOOL finished) {
        
        [self creativeViewShadow];
        self.CreativeView.layer.shadowOpacity = 0;
    }];
}

#pragma mark --------第三方登录-----------
- (IBAction)leftImageWithWeibo:(UITapGestureRecognizer *)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId);
            self.nameTeXField.text = snsAccount.userName;
            self.pwdTextField.text = snsAccount.usid;
            //数据持久化
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:snsAccount.iconURL]];
            NSString *string = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSMutableDictionary *thirdDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:snsAccount.userName, @"userName", snsAccount.accessToken, @"accessToken", snsAccount.usid, @"usid", snsAccount.iconURL, @"imageURL",string, @"image", nil];
            [MSQFileReadAndWriteTools writeDictionary:thirdDic toFilePath:kThirdParty];
            [UIView animateWithDuration:0.7 animations:^{
                
                CGRect frame = self.owlImage.frame;
                frame.origin.x = 50+frame.size.width;
                self.owlImage.frame = frame;
            } completion:^(BOOL finished) {
                
                [self creativeViewShadow];
                self.CreativeView.layer.shadowOpacity = 0;
                 [self thirdRegistInfoUserName:snsAccount.usid pwd:snsAccount.usid];
            }];
            [self.owlImage sd_setImageWithURL:[NSURL URLWithString:snsAccount.iconURL]];
        }});
}

- (IBAction)rightImageWithQQ:(UITapGestureRecognizer *)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId,  response.message);
            //数据持久化
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:snsAccount.iconURL]];
             NSString *string = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSMutableDictionary *thirdDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:snsAccount.userName, @"userName", snsAccount.accessToken, @"accessToken", snsAccount.usid, @"usid", snsAccount.iconURL, @"imageURL",string, @"image", nil];
            [MSQFileReadAndWriteTools writeDictionary:thirdDic toFilePath:kThirdParty];
            self.nameTeXField.text = snsAccount.userName;
            self.pwdTextField.text = snsAccount.usid;
            
            [UIView animateWithDuration:0.7 animations:^{
                
                CGRect frame = self.owlImage.frame;
                frame.origin.x = 50+frame.size.width;
                self.owlImage.frame = frame;
            } completion:^(BOOL finished) {
                
                [self creativeViewShadow];
                self.CreativeView.layer.shadowOpacity = 0;
                
                [self thirdRegistInfoUserName:snsAccount.usid pwd:snsAccount.usid];
            }];
            [self.owlImage sd_setImageWithURL:[NSURL URLWithString:snsAccount.iconURL]];
            
        }});
}

- (void)thirdRegistInfoUserName:(NSString *)userName pwd:(NSString *)pwd {
    
    //注册
    AVUser *user = [AVUser user];// 新建 AVUser 对象实例
    user.username = userName;// 设置用户名
    user.password =  pwd;// 设置密
        
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            NSArray *array = [[CollectManager sharedManager] selectedData];
            for (CollectionModel * model in array) {
                
                [ArtViewController creatLeanCludeWithString:model.title image:model.image video:model.file userName:userName time:model.spare];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            
            switch (error.code) {
            
                case 139:
                    [self alertViewWithMessage:@"用户名不合格"];
                    break;
                case 202:
                    [self thirdLoginInfoUserName:userName pwd:pwd];
                    break;
                case 200:
                    [self alertViewWithMessage:@"用户名为空"];
                    break;
                case 201:
                    [self alertViewWithMessage:@"密码为空"];
                    break;
                case 205:
                    [self alertViewWithMessage:@"找不到电子邮箱所对应的用户"];
                    break;
                case 204:
                    [self alertViewWithMessage:@"请填写正确的邮箱"];
                    break;
                default:
                    [self alertViewWithMessage:@"注册失败,请填写正确的格式"];
                    break;
            }
        }
    }];
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

- (void)thirdLoginInfoUserName:(NSString *)userName pwd:(NSString *)pwd {
    
    //判断用户名密码是否正确
    [AVUser logInWithUsernameInBackground:userName password:pwd block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            
            //回到主界面
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            
            [self alertViewWithMessage:@"登录失败"];
        }
    }];
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
