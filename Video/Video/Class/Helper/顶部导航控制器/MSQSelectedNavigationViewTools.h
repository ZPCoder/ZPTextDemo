//
//  LHSelectedNavigationViewTools.h
//  GraduationProject
//
//  Created by 朱鹏 on 16/4/2.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedScrollViewPageBlock)(NSInteger);

@interface MSQSelectedNavigationViewTools : UIView

@property (nonatomic, copy)SelectedScrollViewPageBlock selectedScrollViewPageBlock;

//根据标签的标题和标签导航的位置初始化一个标签导航控制器。
//如果标签数量小于等于5的时候，标签直接添加在UIView上， 标签的宽度为  屏幕宽度/标签数量
//如果标签数量大于5的时候，标签将添加在一个滚动视图上，滚动视图的可视宽度为屏幕宽度，标签的宽度为  屏幕宽度/5
- (instancetype)initLHSelectedNavigationViewToolsWithFrame:(CGRect)frame ButtonTitle:(NSArray<NSString *> *)btnTitleArr;

//根据scrollView的偏移量移动markLabel的位置，并更改对应标签的颜色
- (void)moveMarkLabelWithContentOffset:(CGPoint)contentOffset;

@end
