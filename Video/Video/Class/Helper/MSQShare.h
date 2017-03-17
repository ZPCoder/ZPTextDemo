//
//  MSQShare.h
//  Video
//
//  Created by 朱鹏 on 16/5/9.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSQShare : NSObject



#pragma mark -----------分享---------------

//分享调用，全部；
- (void)ShareToAll:(NSString *)title image:(UIImage *)image url:(NSString *)urlStr viewController:(UIViewController *) viewController;

//分享调用，微博；
- (void)ShareToSina:(NSString *)title image:(UIImage *)image url:(NSString *)urlStr viewController:(UIViewController *) viewController;

//分享调用，微信；
- (void)ShareToWechatSession:(NSString *)title image:(UIImage *)image url:(NSString *)urlStr viewController:(UIViewController *) viewController;
//分享调用，朋友圈；
- (void)ShareToWechatTimeline:(NSString *)title image:(UIImage *)image url:(NSString *)urlStr viewController:(UIViewController *) viewController;
//分享调用，QQ空间
- (void)ShareToQzone:(NSString *)title image:(UIImage *)image url:(NSString *)urlStr viewController:(UIViewController *) viewController;
//分享调用，QQ
- (void)ShareToQQ:(NSString *)title image:(UIImage *)image url:(NSString *)urlStr viewController:(UIViewController *) viewController;

@end
