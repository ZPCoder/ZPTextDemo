//
//  complaintViewController.m
//  Video
//
//  Created by 朱鹏 on 16/5/16.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "complaintViewController.h"

@interface complaintViewController ()

@property (strong, nonatomic) NSString *videoUrl;

@end

@implementation complaintViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)seqingdis:(UIButton *)sender {
    
    [ArtViewController creatLeanCludeWithReason:@"色情低俗" video:self.videoUrl];
    [self message:@"已经上传您的投诉，谢谢您参与净化网络视频"];
}
- (IBAction)zhengzhi:(UIButton *)sender {
    
    [ArtViewController creatLeanCludeWithReason:@"政治敏感" video:self.videoUrl];
    [self message:@"已经上传您的投诉，谢谢您参与净化网络视频"];
}
- (IBAction)baolixuex:(UIButton *)sender {
    
    [ArtViewController creatLeanCludeWithReason:@"暴力血腥" video:self.videoUrl];
    [self message:@"已经上传您的投诉，谢谢您参与净化网络视频"];
}
- (IBAction)qiuquan:(UIButton *)sender {
    
    [ArtViewController creatLeanCludeWithReason:@"侵权" video:self.videoUrl];
    [self message:@"已经上传您的投诉，谢谢您参与净化网络视频"];
}
- (IBAction)qita:(UIButton *)sender {
    
    [ArtViewController creatLeanCludeWithReason:@"其他" video:self.videoUrl];
    [self message:@"已经上传您的投诉，谢谢您参与净化网络视频"];
}
- (IBAction)toushuxuzhi:(UIButton *)sender {
    
    [self message:@"投诉须知：你应保证你的投诉行为基于善意，并代表你本人真实意思。本公司作为中立的平台服务者，收到你投诉后，会尽快按照相关法律法规的规定独立判断并进行处理。本公司将会采取合理的措施保护你的个人信息；除法律法规规定的情形外，未经用户许可本公司不会向第三方公开、透露你的个人信息。"];
}

- (void)transDataVideo:(NSString *)videoUrl {
    
    self.videoUrl = videoUrl;
}

- (void)message:(NSString *)message {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"通知" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([message isEqualToString:@"投诉须知：你应保证你的投诉行为基于善意，并代表你本人真实意思。本公司作为中立的平台服务者，收到你投诉后，会尽快按照相关法律法规的规定独立判断并进行处理。本公司将会采取合理的措施保护你的个人信息；除法律法规规定的情形外，未经用户许可本公司不会向第三方公开、透露你的个人信息。"]) {
            return;
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:sureAction];
    //模态推出
    [self presentViewController:alertC animated:YES completion:nil];
}
- (IBAction)back:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
