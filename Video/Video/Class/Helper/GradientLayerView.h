//
//  GradientLayerView.h
//  Video
//
//  Created by xalo on 16/5/10.
//  Copyright © 2016年 毛韶谦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientLayerView : UIView

//渐变色方法
- (void)addGradientLayerForView:(UIView *)view frame:(CGRect)frame topColor:(UIColor *)topColor downColor:(UIColor *)downColor;
@end
