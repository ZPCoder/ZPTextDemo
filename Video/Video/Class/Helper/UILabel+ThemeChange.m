//
//  UILabel+ThemeChange.m
//  夜间模式9-27
//
//  Created by 朱鹏 on 15/9/27.
//  Copyright (c) 2015年 朱鹏 All rights reserved.
//

#import "UILabel+ThemeChange.h"
#import <objc/runtime.h>
#import "ThemeManage.h"
#import "UIView+ThemeChange.h"
#import "UIButton+ThemeChange.h"
#import "UITabBar+ThemeChange.h"
#import "UINavigationBar+ThemeChange.h"
#import "UIView+RemoveNotifition.h"
@implementation UILabel (ThemeChange)

#pragma mark - 添加字体颜色枚举的属性
-(void)setTextType:(id)textType
{
    objc_setAssociatedObject(self, @selector(textType), textType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)textType
{
    return objc_getAssociatedObject(self, @selector(textType));
}

#pragma mark - 重写changeColor方法
-(void)changeColor
{
    [super changeColor];
    
    switch ([self.textType integerValue]) {
        case LabelColorBlack:
            self.textColor = [ThemeManage shareThemeManage].textColor;
            break;
        case LabelColorGray:
            self.textColor = [ThemeManage shareThemeManage].textColorGray;
            break;
            
        default:
            break;
    }
}

-(void)NightTextType:(LabelColor)type
{
    self.textType = [NSNumber numberWithInteger:type];
    [self changeColor];
}


#pragma mark - 初始化字体的颜色
-(void)initTextColor
{
    switch ([self.textType integerValue]) {
        case LabelColorBlack:
            self.textColor = [ThemeManage shareThemeManage].textColor;
            break;
        case LabelColorGray:
            self.textColor = [ThemeManage shareThemeManage].textColorGray;
            break;
            
        default:
            break;
    }
}

@end
