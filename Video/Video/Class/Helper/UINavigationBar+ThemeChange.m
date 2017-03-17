//
//  UINavigationBar+ThemeChange.m
//  夜间
//
//  Created by 朱鹏 on 15/10/26.
//  Copyright © 2015年 朱鹏 All rights reserved.
//

#import "UINavigationBar+ThemeChange.h"
#import "ThemeManage.h"
#import "UIView+ThemeChange.h"
#import "UILabel+ThemeChange.h"
#import "UIButton+ThemeChange.h"
#import "UITabBar+ThemeChange.h"
#import "UIView+RemoveNotifition.h"
@implementation UINavigationBar (ThemeChange)

-(void)changeColor
{
    [super changeColor];
    
    [self setBarTintColor:[ThemeManage shareThemeManage].bgColor];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [ThemeManage shareThemeManage].navBarColor}];
    
    //改变电池栏Style
    if ([ThemeManage shareThemeManage].isNight) {
        [self setBarStyle:UIBarStyleBlackTranslucent];
    }
    else{
        [self setBarStyle:UIBarStyleDefault];
    }
}

@end
