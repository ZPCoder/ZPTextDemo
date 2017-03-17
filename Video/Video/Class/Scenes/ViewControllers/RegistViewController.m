//
//  RegistViewController.m
//  OurTeamVideo
//
//  Created by 朱鹏 on 16/4/28.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *leftEmailImage;
@property (strong, nonatomic) IBOutlet UIImageView *RightPhoneImage;
@property (strong, nonatomic) IBOutlet UIView *leftEmailView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *registerToolsTestField;
@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;
@property (strong, nonatomic) IBOutlet UITextField *correctPwdTextField;
- (IBAction)registBtn:(UIButton *)sender;//注册按钮

//--------------手机注册------------
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginAndRegistBtn;


@property (weak, nonatomic) IBOutlet UITextField *userTF;
@property (weak, nonatomic) IBOutlet UITextField *phonePswTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *veriCodeTF;


- (IBAction)sendVeriCodeBtn:(UIButton *)sender;
- (IBAction)loginAndRegisterBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *rightView;

//定时器
@property (nonatomic,retain)NSTimer *timer;
@property (nonatomic,assign)NSInteger timeCount;

@property (strong, nonatomic) MSQSelectedNavigationViewTools *selected;
@end

@implementation RegistViewController

#pragma  mark ----懒加载------
-(NSTimer *)timer
{
    if (!_timer) {
        _timer = [[NSTimer alloc]init];
    }
    return _timer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.scrollView layoutIfNeeded];
    
    self.scrollView.delegate = self;
    [self blurView];
    [self blurViewRight];
    [self createRegisterView];
    [self settingLeftRighestFrame];
    [self settingRigesteFrame];
    self.timeCount = 60;

}

- (void)settingLeftRighestFrame {
    
    self.userTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *nameImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-user"]];
    self.phonePswTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *pwdImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-password"]];
    self.veriCodeTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *correctPwdImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"code"]];
    
    UIImageView *messageImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone"]];
    self.phoneNumberTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.veriCodeTF setLeftViewMode:UITextFieldViewModeAlways];
    [self.userTF setLeftViewMode:UITextFieldViewModeAlways];
    [self.phonePswTF setLeftViewMode:UITextFieldViewModeAlways];
    [self.phoneNumberTF setLeftViewMode:UITextFieldViewModeAlways];
    [pwdImage setFrame:CGRectMake(3, 3, 24, 24)];
    [nameImage setFrame:CGRectMake(5, 5, 20, 20)];
    [correctPwdImage setFrame:CGRectMake(3, 3, 24, 24)];
    [messageImage setFrame:CGRectMake(3, 3, 24, 24)];
    [self.phonePswTF.leftView addSubview:pwdImage];
    [self.veriCodeTF.leftView addSubview:correctPwdImage];
    [self.userTF.leftView addSubview:nameImage];
    [self.phoneNumberTF.leftView addSubview:messageImage];
}

- (void)settingRigesteFrame {
    
    [self.leftEmailView layoutIfNeeded];
    self.leftEmailView.frame = CGRectMake(30, 120, kScreenW-60, 280);
    self.nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *nameImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-user"]];
    self.pwdTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *pwdImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-password"]];
    self.correctPwdTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *correctPwdImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-password"]];
    
    UIImageView *messageImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message"]];
    self.registerToolsTestField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.registerToolsTestField setLeftViewMode:UITextFieldViewModeAlways];
    [self.nameTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.pwdTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.correctPwdTextField setLeftViewMode:UITextFieldViewModeAlways];
    [pwdImage setFrame:CGRectMake(3, 3, 24, 24)];
    [nameImage setFrame:CGRectMake(5, 5, 20, 20)];
    [correctPwdImage setFrame:CGRectMake(3, 3, 24, 24)];
    [messageImage setFrame:CGRectMake(3, 3, 24, 24)];
    [self.pwdTextField.leftView addSubview:correctPwdImage];
    [self.correctPwdTextField.leftView addSubview:pwdImage];
    [self.nameTextField.leftView addSubview:nameImage];
    [self.registerToolsTestField.leftView addSubview:messageImage];
}

- (void)createRegisterView {
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"邮箱", @"手机", nil];
    self.selected = [[MSQSelectedNavigationViewTools alloc] initLHSelectedNavigationViewToolsWithFrame:CGRectMake(80, 34, kScreenW-160, 30) ButtonTitle:array];
    
    __weak RegistViewController *kSelf = self;
    self.selected.selectedScrollViewPageBlock = ^(NSInteger tag){
      
        kSelf.selected.alpha = 0.6;
        [UIView animateWithDuration:0.3 animations:^{
            
            kSelf.scrollView.contentOffset = CGPointMake(kScreenW*tag, 0);
        } completion:^(BOOL finished) {
            
        }];
        
    };
    self.navigationItem.titleView = self.selected;
    self.scrollView.frame = CGRectMake(0, 64, kScreenW*2, kScreenH-64);
}

//毛玻璃效果
- (void)blurView {
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    visualEffectView.alpha = 1;
    [visualEffectView setFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.leftEmailImage addSubview:visualEffectView];
    self.leftEmailView.backgroundColor = [[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]colorWithAlphaComponent:0.2];

}
- (void)blurViewRight {

    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    visualEffectView.alpha = 1;
    [visualEffectView setFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.RightPhoneImage addSubview:visualEffectView];
    self.rightView.backgroundColor = [[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]colorWithAlphaComponent:0.2];
    [self.rightView layoutIfNeeded];
    self.rightView.frame = CGRectMake(30, 120, kScreenW-60, 265);
    [visualEffectView addSubview:self.rightView];

}

#pragma mark--leanCloud登录注册
//邮箱注册
-(void)registerWithEmail{

    //判断密码是否相同
    if ([self.pwdTextField.text isEqualToString:self.correctPwdTextField.text]) {
        //注册
        AVUser *user = [AVUser user];// 新建 AVUser 对象实例
        user.username = self.nameTextField.text;// 设置用户名
        user.password =  self.pwdTextField.text;// 设置密码
        user.email = self.registerToolsTestField.text;// 设置邮箱

        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                
                NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:user.username, @"userName", @"他很懒，啥都不写😝", @"userContent", self.pwdTextField.text, @"pwd", @"", @"imageURL",[self imageToStringWithImage:[UIImage imageNamed:@"headImage"]], @"image",@"",@"other", nil];
                [MSQFileReadAndWriteTools writeDictionary:userInfoDic toFilePath: kUserInfoParth];
                [self alertViewWithMessage:@"注册成功😊"];

            } else {

                switch (error.code) {
                    case 203:
                        [self alertViewWithMessage:@"此邮箱已被注册"];
                        break;
                    case 139:
                        [self alertViewWithMessage:@"用户名不合格"];
                        break;
                    case 202:
                        [self alertViewWithMessage:@"用户名被占用"];
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
        else{
                [self alertViewWithMessage:@"注册失败,再次输入密码错误"];
        }
    }

//手机注册
-(void)registerWithPhoto{

    AVUser *user = [AVUser user];
    user.username = self.userTF.text;
    user.password =  self.phonePswTF.text;
    user.mobilePhoneNumber = self.phoneNumberTF.text;
    NSError *error = nil;
    [user signUp:&error];
    if (!error) {
        //发送验证码给手机
        [AVOSCloud requestSmsCodeWithPhoneNumber:self.phoneNumberTF.text callback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self alertViewWithMessage:@"验证码发送成功,请注意查看手机"];
                self.sendBtn.userInteractionEnabled = NO;
                self.sendBtn.selected = YES;
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTimeAction) userInfo:nil repeats:YES];
            }else{
                NSLog(@"*-*******%ld",error.code);
                if (error.code == 601) {

                    [self alertViewWithMessage:@"验证码发送失败,该号码操作过于频繁"];

                }else if(error.code == 127){

                    [self alertViewWithMessage:@"验证码发送失败,手机号码无效"];
                }else if (error.code == 214){

                    [self alertViewWithMessage:@"该手机已注册"];
                }else if (error.code == 202){

                    [self alertViewWithMessage:@"该用户名已被占用"];
                }
                [self alertViewWithMessage:@"验证码发送失败,请输入正确的手机号码"];
            }
        }];
    }else{
        NSLog(@"---******-----%ld",error.code);
        [self alertViewWithMessage:@"请填写正确的注册信息"];
    }
}

//模态弹窗
- (void)alertViewWithMessage:(NSString *)message {

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"友情提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([message isEqualToString:@"注册成功😊"]) {

            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];

    [alertC addAction:sureAction];
    //模态推出
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark --------手机注册-----------

//发送验证码---手机
- (IBAction)sendVeriCodeBtn:(UIButton *)sender {

    [self registerWithPhoto];

}

//注册并登陆-----手机
- (IBAction)loginAndRegisterBtn:(UIButton *)sender {


    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:self.phoneNumberTF.text smsCode:self.veriCodeTF.text block:^(AVUser *user, NSError *error) {
        if (error) {
            NSLog(@"---error---%ld",error.code);

            [self alertViewWithMessage:@"注册失败,请输入正确的手机验证码"];
        }else{
            
            NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:user.username, @"userName", @"他很懒，啥都不写😝", @"userContent", self.pwdTextField.text, @"pwd", @"", @"imageURL",[self imageToStringWithImage:[UIImage imageNamed:@"headImage"]], @"image",@"",@"other", nil];
            [MSQFileReadAndWriteTools writeDictionary:userInfoDic toFilePath: kUserInfoParth];
            //登陆成功返回主页面
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

//定时器的方法实现
-(void)changeTimeAction
{
    NSString *str = [NSString stringWithFormat:@"%lds后重新发送",self.timeCount];
    [self.sendBtn setTitle:str forState:UIControlStateNormal];
    self.timeCount--;

    if (self.timeCount == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.sendBtn.selected = NO;
        [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.sendBtn.alpha = 0.8;
        self.sendBtn.userInteractionEnabled = YES;
        self.timeCount = 60;

    }
}


#pragma mark -------------按钮方法--------------
- (IBAction)cancelFirstRespond:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
}

//注册按钮的回调方法----邮箱
- (IBAction)registBtn:(UIButton *)sender {

    [self registerWithEmail];

}

#pragma mark --------------代理方法---------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {


    [self.selected moveMarkLabelWithContentOffset:scrollView.contentOffset];
//    CGRect frame1 = self.leftEmailView.frame;
//    frame1.origin.x = scrollView.contentOffset.x+30;
//    self.leftEmailView.frame = frame1;

}

#pragma mark ------------工具方法------------
- (void)addShadowWithView:(UIView *)view {
    
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 1;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowRadius = 10.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)imageToStringWithImage:(UIImage *)image{
    
    //    先将image转换成Data类型
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //    将nsdata 转换成字符串
    NSString *string = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return string;
}
-(UIImage *)base64StringToImage:(NSString *)bade64String{
    //    字符串转换成Data；
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:bade64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //    data转换成图片
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image;
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
