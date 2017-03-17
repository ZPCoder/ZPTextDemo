//
//  MTabBar.m
//  SinaWeibo
//
//  Created by user on 15/10/16.
//  Copyright © 2015年 M. All rights reserved.
//

#import "MTabBar.h"

@interface MTabBar ()

@property (nonatomic, weak) UIButton *plusBtn;

@end

@implementation MTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self NightWithType:UIViewColorTypeClear];
        
/*        UIButton *plusBtn = [[UIButton alloc] init];
//        
////        plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [plusBtn setTitle:@"中间按钮" forState:UIControlStateNormal];
////        [plusBtn setBackgroundImage:[UIImage imageNamed:@"headImage"] forState:UIControlStateNormal];
////        [plusBtn setBackgroundImage:[UIImage imageNamed:@"headImage"] forState:UIControlStateHighlighted];
////        [plusBtn setImage:[UIImage imageNamed:@"headImage"] forState:UIControlStateNormal];
////        [plusBtn setImage:[UIImage imageNamed:@"headImage"] forState:UIControlStateHighlighted];
//        //tabBar添加夜间模式
//        [self NightWithType:UIViewColorTypeNormal];
//        plusBtn.frame = CGRectMake(kScreenW/2-20, 0, 40, 40);
////        plusBtn.size = plusBtn.currentBackgroundImage.size;
//        [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:plusBtn];
//        self.plusBtn = plusBtn;
 */
    }
    return self;
}

/**
 *  中间按钮点击
 */
- (void)plusBtnClick
{
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}

/**
 *  想要重新排布系统控件subview的布局，推荐重写layoutSubviews，在调用父类布局后重新排布。
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置加号按钮的位置
//    self.plusBtn.centerX = self.width*0.5;
//    self.plusBtn.centerY = self.height*0.5;
    
    // 2.设置其他tabbarButton的frame
    CGFloat tabBarButtonW = self.width / 4;
    CGFloat tabBarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置x
            child.x = tabBarButtonIndex * tabBarButtonW;
            // 设置宽度
            child.width = tabBarButtonW;
            // 增加索引
            tabBarButtonIndex++;
        }
    }
}

/*
 
 [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
 [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
 [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
 [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
 */

@end
