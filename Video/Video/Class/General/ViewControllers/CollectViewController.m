//
//  CollectViewController.m
//  Video
//
//  Created by 朱鹏 on 16/5/12.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "CollectViewController.h"

@interface CollectViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)UITableView *myTableView;  //存放收藏数据的tableView
@property (nonatomic,strong)NSMutableArray *dataSource;//存放收藏数据的数组
@property (nonatomic,strong)UIImageView *myImageView;  //背景图



@end

@implementation CollectViewController

#pragma mark ----- 懒加载

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    }
    return _myTableView;
}

-(NSMutableArray*)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(UIImageView *)myImageView{
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
        _myImageView.image =[UIImage imageNamed:@"beijing"];
        [self.view addSubview:_myImageView];
    }
    return _myImageView;
}


#pragma mark ------- 响应者链
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myTableView];
    
    [self.view NightWithType:(UIViewColorTypeNormal)];
    [self.myTableView NightWithType:(UIViewColorTypeNormal)];
    
    //设置代理
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    //注册Xib
    [self.myTableView registerNib:[UINib nibWithNibName:@"CollectTableViewCell" bundle:nil] forCellReuseIdentifier:@"CELLL"];
    
    self.navigationItem.title = @"我的收藏";
    
    //返回按钮
    self.navigationItem.leftBarButtonItem = ({
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"X" style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction:)];
        backItem;
    });

    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([[CollectManager sharedManager] selectedData].count == 0) {
        
        [self queryLeanCludWithUserName:[AVUser currentUser].username];
    }else {
    //获取表内数据并且添加到数组中
    [self.dataSource addObjectsFromArray:[[CollectManager sharedManager] selectedData]];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[PlayViewController shardPalyViewController]suspendPlayWhenChengeView];
}

//左按钮返回
-(void)backAction:(UIBarButtonItem *)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark ----- tableView代理方法

//返回cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableView showMessage:@"您还没有收藏的作品！" byDataSourceCount:self.dataSource.count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLL" forIndexPath:indexPath];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    CollectModel * model = self.dataSource[indexPath.row];
    
    //本地存储
    [cell NightWithType:UIViewColorTypeNormal];
    cell.title.text = model.title;
    [cell.title NightWithType:(UIViewColorTypeNormal)];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.image]];
    cell.time.text = [NSString stringWithFormat:@"收藏于%@", model.spare];
    [cell.time NightWithType:(UIViewColorTypeNormal)];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectModel * model = self.dataSource[indexPath.row];
    CollectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",model.file);
    PlayViewController *plauer = [PlayViewController shardPalyViewController];
    [plauer playVideoAtCell:cell url:model.file tableView:tableView contentsetY:cell.frame.origin.y viewController:self indexPath:indexPath title:model.title imageUrl:model.image];
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayViewController *plauer = [PlayViewController shardPalyViewController];
    [plauer pullDownCellAddPlay:cell indexPath:indexPath];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //进入删除模式
    return UITableViewCellEditingStyleDelete;
    
}

//当tableViewCell编辑的时候执行的事件
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
         CollectModel * model = self.dataSource[indexPath.row];
        NSLog(@"%@",model.spare_1);
        [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"delete from ArtFolde where objectId='%@'",model.spare_1] callback:^(AVCloudQueryResult *result, NSError *error) {
            
            //删除本地数据
            [[CollectManager sharedManager]deleteData:self.dataSource[indexPath.row]];
            
            //删除数据源
            [self.dataSource removeObjectAtIndex:indexPath.row];

            //删除UI
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
        }];
        
    }
}


-(void)queryLeanCludWithUserName:(NSString*)userName {

    
    AVQuery *query = [AVQuery queryWithClassName:@"ArtFolde"];
    
    //根据用户名查询
    [query whereKey:@"userName" hasPrefix:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for (AVObject *obj in objects) {
            
            if ([obj[@"userName"]isEqualToString:userName]) {
                
                //这里【】内部的是云端的key , 双引号内的数值为读取的key
//                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:obj[@"image"],@"image",obj[@"title"],@"title",obj[@"video"],@"file",nil];
                CollectionModel *model = [[CollectionModel alloc] init];
                model.title = obj[@"title"];
                model.image = obj[@"image"];
                model.file = obj[@"file"];
                model.spare_1 = obj[@"objectId"];
                model.spare = obj[@"time"];
                [self.dataSource addObject:model];
//                [[CollectManager sharedManager] insertData:model];
            }
        }
        //刷新收藏cell获取数据
        
                [self.myTableView reloadData];

    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
