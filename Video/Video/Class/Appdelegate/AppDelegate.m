//
//  AppDelegate.m
//  Video
//
//  Created by 朱鹏 on 16/4/29.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (MNavigationController *)mNavCC {
    
    if (!_mNavCC) {
        
        self.tab = [[TabBarViewController alloc] init];
        _mNavCC = [[MNavigationController alloc] initWithRootViewController:self.tab];
    }
    return _mNavCC;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    // 0.夜间模式
    [ThemeManage shareThemeManage].isNight = [[NSUserDefaults standardUserDefaults]boolForKey:@"night"];
    // 1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 2.设置根/Users/Mr.zhu/Desktop/我的工程/Video/Video控制器
    NSString *versionKey = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
    // 当前app的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    if ([lastVersion isEqualToString:currentVersion]) {
        
        [NSThread sleepForTimeInterval:1];
        LeftViewController *left = [[LeftViewController alloc]init];
//        RightViewController *right = [[RightViewController alloc]init];
        
        //给控制器添加夜间模式
        [ self.mNavCC.navigationBar NightWithType:(UIViewColorTypeNormal)];
        RESideMenu *res = [[RESideMenu alloc]initWithContentViewController: self.mNavCC leftMenuViewController:left rightMenuViewController:nil];
        self.window.rootViewController = res;
    } else {
        
        //给控制器添加夜间模式
        [ self.mNavCC.navigationBar NightWithType:(UIViewColorTypeNormal)];
        [NSThread sleepForTimeInterval:0.1];
        self.window.rootViewController = [[NewfeatureViewController alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    //友盟
    [self UMSocialSDK];

#pragma mark ---JPush推送
//    //带有回复框的通知
//    UIMutableUserNotificationAction *replyAction = [[UIMutableUserNotificationAction alloc]init];
//    replyAction.title = @"Reply";
//    replyAction.identifier = @"comment-reply";
//    replyAction.activationMode = UIUserNotificationActivationModeBackground;
//    replyAction.behavior = UIUserNotificationActionBehaviorTextInput;
//
//    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc]init];
//    category.identifier = @"reply";
//    [category setActions:@[replyAction] forContext:UIUserNotificationActionContextDefault];
//
//    //启动SDK
//    [JPUSHService setupWithOption:launchOptions appKey:@"3d3faf79c88ae3ab7d649ff9" channel:@"Publish channel" apsForProduction:NO];
//
//    //注册通知类型
//    [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:[NSSet setWithObject:category]];

    
#pragma mark---leanCloud
    [AVOSCloud setApplicationId:@"28A9dI7h4E4iK3cucee6sMiY-gzGzoHsz"
                      clientKey:@"4GVl34Q0H289nMFK1gKFXfnx"];
    //跟踪统计应用的打开情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    return YES;
}

#pragma mark--JPush------
////回复
//- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler NS_AVAILABLE_IOS(9_0) {
//    if ([identifier isEqualToString:@"comment-reply"]) {
//        NSString *response = responseInfo[UIUserNotificationActionResponseTypedTextKey];
//        NSLog(@"----输入的是---%@",response);
//        //对输入的文字作处理
//    }
//    completionHandler();
//}
//
////注册token值
//- (void)application:(UIApplication *)application
//didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//
//    /// Required - 注册 DeviceToken
//    [JPUSHService registerDeviceToken:deviceToken];
//}
//
////当你收到推送的点击事件
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//
//    // IOS 7 Support Required
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//}
//
////注册失败回调
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    //Optional
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
//}

- (void)UMSocialSDK {
    
    [UMSocialData setAppKey:@"572aed2be0f55a163f0027e5"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx0482be98ae4c5fcc" appSecret:@"d5ad727657e3d29cfa931c2337724c1" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"1105401652" appKey:@"Yv5gsX8rHBddDYPM" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"4030860979"
                                              secret:@"1cea0aa71b9722925cd4c8dec66b58a7"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

/*
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.maoshaoqian.Video" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Video" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Video.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
 
 
 
 
    }
}
 */

@end
