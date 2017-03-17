//
//  SaoViewController.m
//  Video
//
//  Created by 朱鹏 on 16/5/15.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "SaoViewController.h"

@interface SaoViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *saoView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)saoBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *saoBtn;

// 捕捉会话 捕捉外界信息，并将信息呈现在手机上
@property(nonatomic, retain) AVCaptureSession *captureSession;

// 用来展示捕捉到的外界信息
@property(nonatomic, retain) AVCaptureVideoPreviewLayer *videoPreviewLayer;
// 存放当前状态（是否在进行扫描）

@property(nonatomic, assign) BOOL isReading;
@property (nonatomic, retain) CALayer *scanLayer;
@property (nonatomic, retain) UIView *boxView;

@end

@implementation SaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //添加左侧返回按钮
    UIBarButtonItem *leftBen = [[UIBarButtonItem alloc]initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction:)];
    self.navigationItem.leftBarButtonItem = leftBen;

    [_captureSession stopRunning];
    _captureSession  = nil;
    self.titleLabel.hidden = YES;
    self.saoView.hidden = YES;
    
}

//左侧返回按钮回调方法
-(void)backBtnAction:(UIBarButtonItem *)sender{

    [self dismissViewControllerAnimated:YES completion:nil];
}

//模态弹窗
- (void)alertViewWithMessage:(NSString *)message {

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"友情提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([message isEqualToString:@"请打开摄像头"]) {

            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [alertC addAction:sureAction];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (BOOL)startReading{
    //初始化捕捉设备
    AVCaptureDevice *Device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //用Device创建输入流  捕捉完结内容 例如到设备不给中 也就是手机
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:Device error:&error];
    if (error) {

        [self alertViewWithMessage:@"请打开摄像头"];
        _isReading = NO;
        return NO;
    }

    //创建媒体数据输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理来处理输出流中的信息

    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];


    output.rectOfInterest = CGRectMake(0.2, 0.2, 0.8, 0.8);

    // 4.   实例化捕捉绘画
    _captureSession = [[AVCaptureSession alloc] init];

    // 4.1  设置绘画的采集率 属性 决定了
    [_captureSession setSessionPreset:AVCaptureSessionPreset1920x1080];
    //将输入流添加到绘画
    [_captureSession addInput:input];


    //将输出流添加到绘画
    [_captureSession addOutput:output];

    //设置媒体数据类型 二维码和条形码
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code]];

    //实例化
    _videoPreviewLayer  = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //设置预览图层的frame
    _videoPreviewLayer.frame = self.saoView.layer.bounds;

    [self.saoView.layer insertSublayer:_videoPreviewLayer atIndex:0];


    //  6.1.扫描框
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(self.saoView.bounds.size.width * 0.2f, self.saoView.bounds.size.height * 0.2f, self.saoView.bounds.size.width - self.saoView.bounds.size.width * 0.4f, self.saoView.bounds.size.height - self.saoView.bounds.size.height * 0.4f)];
    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
    _boxView.layer.borderWidth = 3.0f;
    [self.saoView addSubview:_boxView];
    //  6.2.扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 1);
    _scanLayer.backgroundColor = [UIColor greenColor].CGColor;
    [_boxView.layer addSublayer:_scanLayer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer) userInfo:nil repeats:YES];


    //设置图层内容的填充防腐蚀
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    //开始扫描
    [_captureSession startRunning];
    _isReading = YES;
    return YES;

}

- (void)moveScanLayer {
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        frame.origin.y += 5;
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

/**
 *  @param captureOutput                输出流
 *  @param didOutputMetadataObjects     信息在哪存储
 *  @param connection
 */

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //处理捕捉到的内容
    if ([metadataObjects count]>0&&metadataObjects !=nil) {
        AVMetadataMachineReadableCodeObject *object = [metadataObjects objectAtIndex:0];
        if ([[object type] isEqualToString:AVMetadataObjectTypeQRCode] |  [[object type] isEqualToString:AVMetadataObjectTypeEAN13Code]) {

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:object.stringValue]];
            
            [self dismissViewControllerAnimated:YES completion:nil];

            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
        }
    }
}


- (void)stopReading{
    _isReading = NO;
    //结束扫描
    [_captureSession stopRunning];
    //将预览图层滞空
    _captureSession = nil;
    //移除预览图层
    [_scanLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
}

//打开扫描二维码模式
- (IBAction)saoBtn:(UIButton *)sender {
    if (!_isReading) {
        if ([self startReading]) {

            self.titleLabel.hidden = NO;
            self.saoView.hidden = NO;
            [self.saoBtn setTitle:@"关闭扫描模式" forState:UIControlStateNormal];
//            [self.statusLabel setText:@"Scanning for QR Code"];
        }
    }

    else{
        [self stopReading];
        [self.saoBtn setTitle:@"开启扫描模式" forState:UIControlStateNormal];
        self.titleLabel.hidden = YES;
        self.saoView.hidden = YES;
    }


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
