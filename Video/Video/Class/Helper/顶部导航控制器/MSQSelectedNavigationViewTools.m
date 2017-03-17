//
//  LHSelectedNavigationViewTools.m
//  GraduationProject
//
//  Created by 朱鹏 on 16/4/2.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "MSQSelectedNavigationViewTools.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kMHeight 30
#define kBtnTitleColor [UIColor orangeColor]
#define kBtnSelectedTitleColor [UIColor orangeColor]

@interface MSQSelectedNavigationViewTools ()

@property (nonatomic, retain)UILabel *markLabel;
@property (nonatomic, assign)NSInteger btnCount;
@property (nonatomic, assign) CGRect kFrame;

@end


@implementation MSQSelectedNavigationViewTools

- (instancetype)initLHSelectedNavigationViewToolsWithFrame:(CGRect)frame ButtonTitle:(NSArray<NSString *> *)btnTitleArr {
    
    self.btnCount = btnTitleArr.count;
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, kMHeight);
    self.kFrame = frame;
    self = [super initWithFrame:frame];
    if (self) {
        
        if (btnTitleArr.count <= 5) {
            for (int i = 0; i < btnTitleArr.count; i++) {
                self.markLabel.frame = CGRectMake(0, kMHeight-2, frame.size.width/btnTitleArr.count-8, 2);
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC" size:15];
                btn.frame = CGRectMake(frame.size.width*i/btnTitleArr.count, 0, frame.size.width/btnTitleArr.count, kMHeight-2);
                btn.tag = 1000+i;
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            
                if (i == 0) {
                    [btn setTitleColor:kBtnSelectedTitleColor forState:UIControlStateNormal];
                } else {
                    [btn setTitleColor:kBtnTitleColor forState:UIControlStateNormal];
                }
                [self addSubview:btn];
            }
        } else {//按键数大于5
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
            for (int i = 0; i < btnTitleArr.count; i++) {
                self.markLabel.frame = CGRectMake(0, kMHeight-2, kWidth/5, 2);
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
                btn.frame = CGRectMake(kWidth*i/5, 0, kWidth/5, kMHeight-2);
                btn.tag = 1000+i;
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                
                if (i == 0) {
                    [btn setTitleColor:kBtnSelectedTitleColor forState:UIControlStateNormal];
                } else {
                    [btn setTitleColor:kBtnTitleColor forState:UIControlStateNormal];
                }
                [scrollView addSubview:btn];
            }
            [self addSubview:scrollView];
        }
    }
    return self;
}

- (void)btnAction:(UIButton *)sender {
    
    for (int i = 0; i < self.btnCount; i++) {
        UIButton *btn = [self viewWithTag:1000+i];
        [btn setTitleColor:kBtnTitleColor forState:UIControlStateNormal];
    }
    
    UIButton *btn = [self viewWithTag:sender.tag];
    [btn setTitleColor:kBtnSelectedTitleColor forState:UIControlStateNormal];
    CGRect frame = self.markLabel.frame;
    frame.origin.x = self.frame.size.width*(sender.tag-1000)/self.btnCount;
    
    if (self.selectedScrollViewPageBlock) {
        self.selectedScrollViewPageBlock(sender.tag-1000);
    }
    [UIView animateWithDuration:0.3 animations:^{
//        self.markLabel.frame = frame;
    }];
}


- (void)moveMarkLabelWithContentOffset:(CGPoint)contentOffset {
    
    self.markLabel.transform = CGAffineTransformMakeTranslation(contentOffset.x/kScreenW*self.kFrame.size.width/self.btnCount, 0);
    
    for (int i = 0; i < self.btnCount; i++) {
        UIButton *btn = [self viewWithTag:1000+i];
        [btn setTitleColor:kBtnTitleColor forState:UIControlStateNormal];
    }
    
    NSInteger BtnselectedIndex = contentOffset.x/kWidth;
    UIButton *btn = [self viewWithTag:1000+BtnselectedIndex];
    [btn setTitleColor:kBtnSelectedTitleColor forState:UIControlStateNormal];
}



#pragma mark - 属性懒加载

- (UILabel *)markLabel {
    
    if (!_markLabel) {
        _markLabel = [[UILabel alloc] init];
        _markLabel.backgroundColor = [UIColor orangeColor];
        [self addSubview:_markLabel];
    }
    return _markLabel;
}




@end
