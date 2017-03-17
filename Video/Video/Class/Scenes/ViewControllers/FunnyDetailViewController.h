//
//  FunnyDetailViewController.h
//  Video
//
//  Created by 朱鹏 on 16/5/9.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunnyDetailViewController : UIViewController

//用来接收传值
@property (nonatomic,retain)FunnyModel *model;

@property (nonatomic,retain)UIButton *saveBtn;   //保存按钮
@property (nonatomic,retain)UIButton *playBtn;  //播放按钮

@end
