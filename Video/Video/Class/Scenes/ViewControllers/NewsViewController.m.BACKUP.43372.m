//
//  NewsViewController.m
//  Video
//
//  Created by xalo on 16/4/29.
//  Copyright © 2016年 毛韶谦. All rights reserved.
//

#import "NewsViewController.h"



@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation NewsViewController

#pragma mark ----------懒加载
-(NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

#pragma mark ----------视图声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsTableViewCell"];
    [self fecthDataFromNet:KNewsURL parameters:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.dataSource.count == 0) {
        
        [self fecthDataFromNet:kNewsURL parameters:nil];
    }
}

#pragma mark ------------封装方法
//请求数据
- (void)fecthDataFromNet:(NSString *)url parameters:(NSDictionary *)parameter {
    
    //初始化请求工具
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
<<<<<<< HEAD

        NSLog(@"%@",dic);
//        NSMutableArray *itemArray = dic[@"items"];
////        遍历存储数据
//        for (NSDictionary *item in itemArray) {
//            
//            NewsModel *model = [[NewsModel alloc]init];
//            [model setValuesForKeysWithDictionary:item];
//            [self.dataSource addObject:model];
//        }
//        [self.tableView reloadData];
        
        NSMutableArray *itemArray = dic[@"items"];
=======
        NSLog(@"%@",dic);
        NSMutableArray *itemArray = dic[@"视频"];
>>>>>>> 22e315da7c4d74afe844b557314d39668f026c72
//        遍历存储数据
        for (NSDictionary *item in itemArray) {
//
            NewsModel *model = [[NewsModel alloc]init];
            [model setValuesForKeysWithDictionary:item];
            [self.dataSource addObject:model];
        }
        NSLog(@"dataSource%ld",self.dataSource);
        [self.tableView reloadData];
<<<<<<< HEAD
//        NSLog(@"%ld",self.dataSource.count);

=======
>>>>>>> 22e315da7c4d74afe844b557314d39668f026c72
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"数据请求失败");
    }];
}

//cell3d动画效果
- (void)cell3DAnimations:(UITableViewCell *)cell {
    
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (45*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
    //    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"position"];
    //    basic.fromValue = [NSValue valueWithCGPoint:cell.layer.position];
    //    CGPoint toPoint = cell.layer.position;
    //    toPoint.x += 40;
    //    basic.toValue = [NSValue valueWithCGPoint:toPoint];
    //    [cell.layer addAnimation:basic forKey:@"basic"];
}



#pragma mark ----------tableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell" forIndexPath:indexPath];
    [cell cellDataWithModel:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200;
}

//cell即将出现时的代理方法，此中实现出现动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    

    [self cell3DAnimations:cell];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}





@end
