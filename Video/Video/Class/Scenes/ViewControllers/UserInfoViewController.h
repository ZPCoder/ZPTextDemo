//
//  UserInfoViewController.h
//  Video
//
//  Created by 朱鹏 on 16/5/11.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransDataDelegate <NSObject>
//属性c
-(void)transDataWithDelegate:(NSString *)userName userTalk:(NSString *)userTalk userHeadImage:(UIImage *)userHeadImage;

@end

@interface UserInfoViewController : UIViewController

@property (assign, nonatomic) id<TransDataDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UITextView *contentText;

@end
