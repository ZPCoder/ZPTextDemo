//
//  MSQShare.m
//  Video
//
//  Created by 朱鹏 on 16/5/9.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "MSQShare.h"

@implementation MSQShare



#pragma mark -------------分享--------------------

- (void)ShareToSina:(NSString *)title image:(UIImage *)image url:(NSString *)urlStr viewController:(UIViewController *) viewController{
    
    UMSocialUrlResource *urlR = [[UMSocialUrlResource alloc] init];
    urlR.url = urlStr;
    urlR.resourceType = UMSocialUrlResourceTypeVideo;
    //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:title image:image location:nil urlResource:urlR presentedController:viewController completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    
}

- (void)ShareToWechatSession:(NSString *)title image:(UIImage *)image url:(NSString *)urlStr viewController:(UIViewController *) viewController {
    
    UMSocialUrlResource *urlR = [[UMSocialUrlResource alloc] init];
    urlR.url = urlStr;
    urlR.resourceType = UMSocialUrlResourceTypeVideo;
    //使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:title image:image location:nil urlResource:urlR presentedController:viewController completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

- (void)ShareToWechatTimeline:(NSString *)title image:(UIImage *)image url:(NSString *)urlStr viewController:(UIViewController *) viewController {
    
    UMSocialUrlResource *urlR = [[UMSocialUrlResource alloc] init];
    urlR.url = urlStr;
    urlR.resourceType = UMSocialUrlResourceTypeVideo;
    //使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:title image:image location:nil urlResource:urlR presentedController:viewController completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

- (void)ShareToQQ:(NSString *)title image:(UIImage *)image url:(NSString *)urlStr viewController:(UIViewController *) viewController{
    
    UMSocialUrlResource *urlR = [[UMSocialUrlResource alloc] init];
    urlR.url = urlStr;
    urlR.resourceType = UMSocialUrlResourceTypeVideo;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:title image:image location:nil urlResource:urlR presentedController:viewController completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

- (void)ShareToQzone:(NSString *)title image:(UIImage *)image url:(NSString *)urlStr viewController:(UIViewController *) viewController {
    
    UMSocialUrlResource *urlR = [[UMSocialUrlResource alloc] init];
    urlR.url = urlStr;
    urlR.resourceType = UMSocialUrlResourceTypeVideo;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:title image:image location:nil urlResource:urlR presentedController:viewController completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}
- (void)ShareToAll:(NSString *)title image:(UIImage *)image url:(NSString *)urlStr viewController:(UIViewController *) viewController{
    
    [UMSocialData defaultData].extConfig.emailData.urlResource.url = urlStr;
    [UMSocialSnsService presentSnsIconSheetView:viewController
                                         appKey:@"572aed2be0f55a163f0027e5"
                                      shareText:title
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToEmail,UMShareToSms,UMShareToQzone,nil]
                                       delegate:nil];
    [UMSocialData defaultData].extConfig.qqData.url = urlStr;
    [UMSocialData defaultData].extConfig.qzoneData.url = urlStr;
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeVideo url:urlStr];
    
    
}

@end
