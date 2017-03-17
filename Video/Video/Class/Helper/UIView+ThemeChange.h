//
//  UIView+ThemeChange.h
//  夜间模式9-27
//
//  Created by 朱鹏 on 15/9/27.
//  Copyright (c) 2015年 朱鹏 All rights reserved.
//

#import <UIKit/UIKit.h>

//颜色的定义(一个代表一套)
typedef NS_ENUM(NSInteger, UIViewColorType) {
    /**白天白色, 夜间灰色*/
    UIViewColorTypeNormal,
    /**白天蓝色, 夜间黑色*/
    UIViewColorType1,
    /**白天红色, 夜间深灰*/
    UIViewColorType2,
    /**透明状态*/
    UIViewColorTypeClear,
    /**白天钢琴图,夜间星空图*/
    UIViewImageColor,
    /**白天黑色字体，夜间白色字体**/
    UITextColorType1,
    /**白天白色，夜间星空**/
    UITabBarColor,
    UINextColor,
    
    UIShouCangColor,
    UIJiLuColor,
    UIQingChuColor,
    UIMoShiColor,
    UISaoColor,
    UIShengMingColor
    
};

@interface UIView (ThemeChange)

/**定义颜色类型的属性, NSNumber类型*/
@property(nonatomic, assign)id type;
/**消息中心开始监听*/
-(void)startMonitor;
/**改变颜色的方法*/
-(void)changeColor;
/**设置颜色类型和对应颜色*/
-(void)NightWithType:(UIViewColorType)type;

/**设置字体颜色的方法*/
-(void)initTextColor;

@property(nonatomic, retain)UIImageView *myimageView;
@end
