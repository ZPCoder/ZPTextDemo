//
//  ThemeManage.m
//  夜间模式9-27
//
//  Created by 朱鹏 on 15/9/27.
//  Copyright (c) 2015年 朱鹏 All rights reserved.
//

#import "ThemeManage.h"
static ThemeManage *manage;
@implementation ThemeManage

#pragma mark - 单例的初始化
+(ThemeManage *)shareThemeManage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[ThemeManage alloc] init];
    });
    return manage;
}

#pragma mark 重写isNight的set方法
-(void)setIsNight:(BOOL)isNight
{
    _isNight = isNight;
    
    if (self.isNight) {
        self.bgColor = [UIColor colorWithRed:0.06 green:0.08 blue:0.1 alpha:1];
        self.textColor = [UIColor whiteColor];
        self.color1 = [UIColor colorWithRed:0.08 green:0.11 blue:0.13 alpha:1];
        self.navBarColor = [UIColor whiteColor];
        self.color2 = [UIColor colorWithRed:0.2 green:0.31 blue:0.43 alpha:1];
        self.textColorGray = [UIColor whiteColor];
        self.leftImageColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"xingkong"]];
        self.leftTextColor = [UIColor blackColor];
        self.tabBatColor = [UIColor whiteColor];
        self.nextColor = [UIColor clearColor];
        self.shoucangColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shoucang2"]];
        self.jiluColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"jilu2"]];
        self.qingchuColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"qingchu2"]];
        self.moshiColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"moshi2"]];
        self.saoColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sao2"]];
        self.fuwuColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shengming2"]];
        
    }
    else{
        self.bgColor = [UIColor whiteColor];
        self.textColor = [UIColor blackColor];
        self.color1 = [UIColor colorWithRed:0.06 green:0.25 blue:0.48 alpha:1];
        self.navBarColor = [UIColor colorWithRed:0.31 green:0.73 blue:0.58 alpha:1];
        self.color2 = [UIColor colorWithRed:0.57 green:0.66 blue:0.77 alpha:1];
        self.textColorGray = [UIColor grayColor];
        self.leftImageColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftWhite"]];
        self.leftTextColor = [UIColor whiteColor];
        self.tabBatColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nextView"]];
        self.nextColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nextView"]];
        self.shoucangColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shoucang1"]];
        self.jiluColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"jilu1"]];
        self.qingchuColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"qingchu1"]];
        self.moshiColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"moshi1"]];
        self.saoColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sao1"]];
        self.fuwuColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shengming1"]];
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.colorClear = [UIColor clearColor];
    });
}

@end
