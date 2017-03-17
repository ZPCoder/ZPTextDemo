//
//  MTabBar.h
//  SinaWeibo
//
//  Created by user on 15/10/16.
//  Copyright © 2015年 M. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTabBar;

//#warning MTabBar继承自UITabBar，所以MTabBar的代理必须遵循UITabBar的代理协议！

@protocol MTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton:(MTabBar *)tabBar;

@end

@interface MTabBar : UITabBar

@property (nonatomic, weak) id<MTabBarDelegate> delegate;

@end
