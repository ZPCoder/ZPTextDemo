//
//  FindPswViewController.m
//  Video
//
//  Created by 朱鹏 on 16/5/12.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "FindPswViewController.h"

@interface FindPswViewController ()
@property (weak, nonatomic) IBOutlet UITextField *findPswTF;
- (IBAction)backBtn:(UIButton *)sender;
- (IBAction)findPswBtn:(UIButton *)sender;
- (IBAction)findPhoneBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;

//手机找回密码界面
@property (weak, nonatomic) IBOutlet UITextField *findPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNewTF;
- (IBAction)returnBtn:(UIButton *)sender;
- (IBAction)defineBtn:(UIButton *)sender;
- (IBAction)getCodeBtn:(UIButton *)sender;
@property (nonatomic,retain)NSTimer *timer;
@property (nonatomic,assign)NSInteger timerCount;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@end

@implementation FindPswViewController

#pragma mark ---懒加载
-(NSTimer *)timer{
    
    if (!_timer) {
        _timer = [[NSTimer alloc]init];
    }
    return _timer;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.emailView.hidden = NO;
    self.phoneView.hidden = YES;
    self.timerCount = 60;
}

#pragma mark --按钮的回调
- (IBAction)backBtn:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)findPswBtn:(UIButton *)sender {

    if (self.findPswTF.text.length == 0) {
        [self alertViewWithMessage:@"请输入邮箱或者手机号码"];
    }else{

        if ([self.findPswTF.text containsString:@"@"]) { //邮箱

            [AVUser requestPasswordResetForEmailInBackground:self.findPswTF.text block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {

                    [self alertViewWithMessage:@"以发送至邮箱,请在邮箱中设置密码"];
                } else {
                    [self alertViewWithMessage:@"输入错误"];
                }
            }];
        }else{
            [AVUser requestPasswordResetWithPhoneNumber:self.findPswTF.text block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {

//                    [self alertViewWithMessage:@"重置密码成功😊"];
//                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    NSLog(@"手机重置密码出错%@",error);
                    if (error.code == 601) {
                        [self alertViewWithMessage:@"找回密码限制,请在30分钟后重试"];
                    }
                }
            }];
        }
    }
}


// **********用手机找回密码按钮************

- (IBAction)findPhoneBtn:(UIButton *)sender {

    self.emailView.hidden = YES;   //隐藏邮件找回密码View
    self.phoneView.hidden = NO;   //显示手机找回密码View
}

- (IBAction)returnBtn:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)defineBtn:(UIButton *)sender {

    [AVUser resetPasswordWithSmsCode:self.phoneCodeTF.text newPassword:self.phoneNewTF.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {

            [self alertViewWithMessage:@"修改密码成功"];
        } else {
            NSLog(@"--------修改密码失败%@",error);
            [self alertViewWithMessage:@"重置密码失败,请填写正确的手机验证码"];
        }
    }];
}

- (IBAction)getCodeBtn:(UIButton *)sender {

    //获取短信验证码
    [AVUser requestPasswordResetWithPhoneNumber:self.findPhoneTF.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {

            NSLog(@"------获取短信验证码成功");
            [self changeTimeAction];
            self.getCodeBtn.userInteractionEnabled = NO;
            self.getCodeBtn.selected = YES;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTimeAction) userInfo:nil repeats:YES];
        } else {
            NSLog(@"获取短信验证码失败*******%@",error);
            if (error.code == 601) {

                [self alertViewWithMessage:@"该用户已限制,请在30分钟后再次尝试"];
            }else{
            [self alertViewWithMessage:@"填写正确的手机号"];

            }
        }
    }];
}

//定时器的方法实现
-(void)changeTimeAction
{
    NSString *str = [NSString stringWithFormat:@"%lds后重新发送",self.timerCount];
    [self.getCodeBtn setTitle:str forState:UIControlStateNormal];
    self.timerCount--;

    if (self.timerCount == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.getCodeBtn.selected = NO;
        [self.getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.getCodeBtn.alpha = 0.8;
        self.getCodeBtn.userInteractionEnabled = YES;
        self.timerCount = 60;

    }
}


//模态弹窗
- (void)alertViewWithMessage:(NSString *)message {

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"友情提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([message isEqualToString:@"修改密码成功"]) {

            [self dismissViewControllerAnimated:YES completion:nil];
        }

    }];
    [alertC addAction:sureAction];

    //模态推出
    [self presentViewController:alertC animated:YES completion:nil];
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
