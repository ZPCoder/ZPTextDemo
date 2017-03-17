//
//  ThemeManage.h
//  夜间模式9-27
//
//  Created by 朱鹏 on 15/9/27.
//  Copyright (c) 2015年 朱鹏 All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeManage : NSObject

#pragma mark - 颜色属性
@property(nonatomic, retain)UIColor *bgColor;
@property(nonatomic, retain)UIColor *color1;
@property(nonatomic, retain)UIColor *color2;
@property(nonatomic, retain)UIColor *textColor;
@property(nonatomic, retain)UIColor *textColorGray;
@property(nonatomic, retain)UIColor *navBarColor;
@property(nonatomic, retain)UIColor *colorClear;
@property(nonatomic, retain)UIColor *leftImageColor;
@property(nonatomic, retain)UIColor *leftTextColor;
@property(nonatomic, retain)UIColor *tabBatColor;
@property(nonatomic, retain)UIColor *nextColor;

@property(nonatomic, retain)UIColor *shoucangColor;
@property(nonatomic, retain)UIColor *jiluColor;
@property(nonatomic, retain)UIColor *qingchuColor;
@property(nonatomic, retain)UIColor *moshiColor;
@property(nonatomic, retain)UIColor *saoColor;
@property(nonatomic, retain)UIColor *fuwuColor;

#pragma mark -
/**是否是夜间*/
//YES表示夜间, NO为正常
@property(nonatomic, assign)BOOL isNight;
//@property(nonatomic, assign)
/**模式管理单例*/
+(ThemeManage *)shareThemeManage;

@end
