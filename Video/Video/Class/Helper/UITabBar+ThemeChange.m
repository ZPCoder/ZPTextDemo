//
//  UITabBar+ThemeChange.m
//  夜间
//
//  Created by 朱鹏 on 15/10/26.
//  Copyright © 2015年 朱鹏 All rights reserved.
//

#import "UITabBar+ThemeChange.h"
#import "ThemeManage.h"
#import "UIView+ThemeChange.h"
#import "UILabel+ThemeChange.h"
#import "UIButton+ThemeChange.h"
#import "UINavigationBar+ThemeChange.h"
#import "UIView+RemoveNotifition.h"
@implementation UITabBar (ThemeChange)

-(void)changeColor
{
    [super changeColor];
    
    [self setBarTintColor:[ThemeManage shareThemeManage].bgColor];
}

@end
