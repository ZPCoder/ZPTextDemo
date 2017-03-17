//
//  UserInfoViewController.m
//  Video
//
//  Created by 朱鹏 on 16/5/11.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UIActionSheetDelegate>

- (IBAction)backLogin:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *countdownLabel;
@property (assign, nonatomic) NSInteger strCount;
@property (assign, nonatomic) BOOL isExceedChar;

@end

@implementation UserInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.strCount = 30;
    self.contentText.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfo)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    NSMutableDictionary *userInfoDic = [MSQFileReadAndWriteTools readDictionaryWithFilePath:kThirdParty];
    if (userInfoDic != nil) {
        
        //        self.isLogin = YES;
        self.headImageView.image = [self base64StringToImage:userInfoDic[@"image"]];
        self.userLabel.text = userInfoDic[@"userName"];
        
    }
    NSMutableDictionary *userInfoD = [MSQFileReadAndWriteTools readDictionaryWithFilePath:kUserInfoParth];
    if (userInfoD != nil) {
        
        //        self.isLogin = YES;
        self.headImageView.image = [self base64StringToImage:userInfoD[@"image"]];
        self.userLabel.text = userInfoD[@"userName"];
        self.contentText.text = userInfoD[@"userContent"];
    }
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)saveInfo {
    
    if (self.isExceedChar) {
        
        [self alertViewMessage:@"字符超出😝"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(transDataWithDelegate:userTalk:userHeadImage:)]) {
        [self.delegate transDataWithDelegate:self.userLabel.text userTalk:self.contentText.text userHeadImage:self.headImageView.image];
        NSMutableDictionary *userInfoDic;
        if (self.headImageView.image == nil) {
            
                 userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.userLabel.text,@"userName",self.contentText.text,@"userContent",[self imageToStringWithImage:[UIImage imageNamed:@"headImage"]],@"image",@"",@"other",@"", @"imageURL",@"",@"pwd", nil];
        }else {
            
       userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.userLabel.text,@"userName",self.contentText.text,@"userContent",[self imageToStringWithImage:self.headImageView.image],@"image",@"",@"other",@"", @"imageURL",@"",@"pwd", nil];
        }
        if ([MSQFileReadAndWriteTools writeDictionary:userInfoDic toFilePath:kUserInfoParth]) {
            
            [CleanCaches clearCachesWithFilePath:kThirdParty];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)loginButtonAction:(UIButton *)sender {
    
    
}
- (IBAction)headImageGesture:(UITapGestureRecognizer *)sender {
    
    [self UesrImageClicked];
}
- (IBAction)mainViewGesture:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
}

- (void)UesrImageClicked
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"从相册选择" otherButtonTitles:@"拍照", @"取消", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"从相册选择" otherButtonTitles:@"取消", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}
#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 2:
                    return;
                case 1: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 0: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 1) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - image picker delegte
//轻拍，回调
-(void)changeImage{
    
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    //照片样式
    pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;                             
    //设置照片可编辑
    pick.allowsEditing = YES;
    //设置代理
    pick.delegate = self;
    [self presentViewController:pick animated:YES completion:nil];
}
//选择照片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    //从相册中选取
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.headImageView.image = resultImage;
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)backLogin:(UIButton *)sender {  //退出登录

    //退出登录界面
    [CleanCaches clearCachesWithFilePath:kUserInfoParth];
    [CleanCaches clearCachesWithFilePath:kThirdParty];

    //leanCloud登出
    [AVUser logOut];  //清除缓存用户对象
    AVUser *currentUser = [AVUser currentUser]; // 现在的currentUser是nil了

    if (currentUser == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];



    }else{
        [self alertViewMessage:@"退出失败"];
    }
}
//testView代理方法

- (void)textViewDidChange:(UITextView *)textView {
    
    NSInteger tempInt = self.strCount-textView.text.length;
    self.countdownLabel.text = [NSString stringWithFormat:@"%ld",tempInt];
    if (tempInt > 0) {
        
        self.isExceedChar = NO;
    }else {
        
        self.isExceedChar = YES;
    }
    
}

- (void)alertViewMessage:(NSString *)message {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"友情提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:sureAction];
    //模态推出
    [self presentViewController:alertC animated:YES completion:nil];
}

-(NSString *)imageToStringWithImage:(UIImage *)image{
    
    //    先将image转换成Data类型
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //    将nsdata 转换成字符串
    NSString *string = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return string;
}
-(UIImage *)base64StringToImage:(NSString *)bade64String{
    
    if (bade64String == nil) {
        
        return [UIImage imageNamed:@"headImage"];
    }
    //    字符串转换成Data；
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:bade64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //    data转换成图片
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image;
}

@end
