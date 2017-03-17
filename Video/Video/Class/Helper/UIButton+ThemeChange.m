//
//  UIButton+ThemeChange.m
//  夜间模式9-27
//
//  Created by 朱鹏 on 15/9/27.
//  Copyright (c) 2015年 朱鹏 All rights reserved.
//

#import "UIButton+ThemeChange.h"
#import "ThemeManage.h"
#import "UIView+ThemeChange.h"
#import "UILabel+ThemeChange.h"
#import "UITabBar+ThemeChange.h"
#import "UINavigationBar+ThemeChange.h"
#import "UIView+RemoveNotifition.h"
@implementation UIButton (ThemeChange)

-(void)changeColor
{
    [super changeColor];
    
    self.titleLabel.textColor = [ThemeManage shareThemeManage].textColor;
}

@end
