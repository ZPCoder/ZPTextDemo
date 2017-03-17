//
//  UIView+ThemeChange.m
//  夜间模式9-27
//
//  Created by 朱鹏 on 15/9/27.
//  Copyright (c) 2015年 朱鹏 All rights reserved.
//

#import "UIView+ThemeChange.h"
//添加runtime头文件
#import <objc/runtime.h>
#import "ThemeManage.h"

@implementation UIView (ThemeChange)

#pragma mark 添加type的set,get方法
-(void)setType:(id)type
{
    objc_setAssociatedObject(self, @selector(type), type, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)type
{
    return objc_getAssociatedObject(self, @selector(type));
}

#pragma mark - 开始监听
-(void)startMonitor
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor) name:@"changeColor" object:nil];
}

#pragma mark 改变颜色
-(void)changeColor
{
    //type为NSNumber型, 变为NSInteger
    switch ([self.type integerValue]) {
        case UIViewColorTypeNormal:
            self.backgroundColor = [ThemeManage shareThemeManage].bgColor;
            break;
        case UIViewColorType1:
            self.backgroundColor = [ThemeManage shareThemeManage].color1;
            break;
        case UIViewColorType2:
            self.backgroundColor = [ThemeManage shareThemeManage].color2;
            break;
        case UIViewColorTypeClear:
            self.backgroundColor = [ThemeManage shareThemeManage].colorClear;
            break;
        case UIViewImageColor:
            self.backgroundColor = [ThemeManage shareThemeManage].leftImageColor;
            break;
        case UITextColorType1:
            self.backgroundColor = [ThemeManage shareThemeManage].leftTextColor;
            break;
        case UITabBarColor:
            self.backgroundColor = [ThemeManage shareThemeManage].tabBatColor;
            break;
        case UINextColor:
            self.backgroundColor = [ThemeManage shareThemeManage].nextColor;
            break;
        case UIShouCangColor:
            self.backgroundColor = [ThemeManage shareThemeManage].shoucangColor;
            break;
        case UIJiLuColor:
            self.backgroundColor = [ThemeManage shareThemeManage].jiluColor;
            break;
        case UIQingChuColor:
            self.backgroundColor = [ThemeManage shareThemeManage].qingchuColor;
            break;
        case UIMoShiColor:
            self.backgroundColor = [ThemeManage shareThemeManage].moshiColor;
            break;
        case UISaoColor:
            self.backgroundColor = [ThemeManage shareThemeManage].saoColor;
            break;
        case UIShengMingColor:
            self.backgroundColor = [ThemeManage shareThemeManage].fuwuColor;
            break;
        default:
            break;
    }
    
}

#pragma mark 设置颜色类型和对应颜色
-(void)NightWithType:(UIViewColorType)type
{
    self.type = [NSNumber numberWithInteger:type];
    [self changeColor];
    [self startMonitor];
    //调用设置字体颜色的方法
    [self initTextColor];
}

#pragma mark - 改变字体颜色的方法, 空方法, 可以在子类中重写这个方法来改变颜色(例如:Label)
-(void)initTextColor
{
    
}

@end