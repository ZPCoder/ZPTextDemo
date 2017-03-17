//
//  UITableView+UItableView_EmptyData.h
//  Leisure
//
//  Created by 朱鹏 on 16/4/22.
//  Copyright © 2016年 王勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (UItableView_EmptyData)

//根据数据源的个数来判断tableView的显示内容
-(NSInteger)showMessage:(NSString *)title byDataSourceCount:(NSInteger)count;

@end
