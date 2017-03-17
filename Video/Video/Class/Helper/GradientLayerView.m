//
//  GradientLayerView.m
//  Video
//
//  Created by xalo on 16/5/10.
//  Copyright © 2016年 毛韶谦. All rights reserved.
//

#import "GradientLayerView.h"

@interface GradientLayerView ()

@property (nonatomic,strong) CAGradientLayer   *topGradient;     //顶部渐变色条
@property (nonatomic,strong) CAGradientLayer   *bottomGradient;  //底部渐变色条
@property (nonatomic,strong) UIImageView       *topImageView;    //用于盛放顶部渐变色条
@property (nonatomic,strong) UIImageView       *bottomImageView; //用于盛放底部渐变色条

@end

@implementation GradientLayerView

- (CAGradientLayer *)topGradient {
    
    if (!_topGradient) {
        
        _topGradient       = [CAGradientLayer layer];
        _topGradient.frame = self.topImageView.bounds;
        _topGradient.startPoint = CGPointMake(0, 0);
        _topGradient.endPoint   = CGPointMake(0, 1);
        _topGradient.colors     = @[(__bridge id) [UIColor blackColor].CGColor,
                                    (__bridge id) [UIColor whiteColor].CGColor];
        _topGradient.locations  = @[@(0.5)];
    }
    return _topGradient;
}

- (CAGradientLayer *)bottomGradient {
    
    if (!_bottomGradient) {
        
        _bottomGradient       = [CAGradientLayer layer];
        _bottomGradient.frame = self.bottomImageView.bounds;
        _bottomGradient.startPoint = CGPointMake(0, 1);
        _bottomGradient.endPoint   = CGPointMake(0, 1);
        _bottomGradient.colors     = @[(__bridge id) [UIColor blackColor].CGColor,
                                       (__bridge id) [UIColor whiteColor].CGColor];
        _bottomGradient.locations  = @[@(0.5)];
    }
    return _bottomGradient;
}




- (void)addGradientLayerForView:(UIView *)view frame:(CGRect)frame topColor:(UIColor *)topColor downColor:(UIColor *)downColor {
    
    self.topImageView = [[UIImageView alloc]initWithFrame:frame];
    self.topGradient  = [CAGradientLayer layer];
    self.topGradient.frame = self.topImageView.bounds;
    self.topGradient.startPoint = CGPointMake(0, 0);
    self.topGradient.endPoint   = CGPointMake(0, 1);
    self.topGradient.colors     = @[(__bridge id) topColor.CGColor,
                                   (__bridge id) downColor.CGColor];
    [self.topImageView.layer addSublayer:self.topGradient];
    [view addSubview:self.topImageView];
}


@end
