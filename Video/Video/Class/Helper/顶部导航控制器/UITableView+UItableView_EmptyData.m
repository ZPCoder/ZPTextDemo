//
//  UITableView+UItableView_EmptyData.m
//  Leisure
//
//  Created by 朱鹏 on 16/4/22.
//  Copyright © 2016年 王勇. All rights reserved.
//

#import "UITableView+UItableView_EmptyData.h"

@implementation UITableView (UItableView_EmptyData)

//根据数据源的个数来判断tableView的显示内容
-(NSInteger)showMessage:(NSString *)title byDataSourceCount:(NSInteger)count{
    
    if (count == 0) {
        
        self.backgroundView = ({
            
            UILabel *label = [[UILabel alloc]init];
            label.text = title;
            [label NightWithType:UIViewColorTypeClear];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return count;
    }else{
        
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        return count;
    }
    
}



@end
