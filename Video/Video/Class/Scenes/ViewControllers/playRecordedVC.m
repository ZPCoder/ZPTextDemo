//
//  playRecordedVC.m
//  Video
//
//  Created by 朱鹏 on 16/5/15.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "playRecordedVC.h"
#import "PlayRecordedTableViewCell.h"

@interface playRecordedVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray *array;

@end

@implementation playRecordedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"PlayRecordedTableViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    self.array = [NSMutableArray arrayWithArray:[MSQFileReadAndWriteTools readArrayWithFilePath:kPlayRecord]];
    self.navigationItem.title = @"播放记录";
//    self.mainTableView.backgroundColor = [UIColor clearColor];
    [self.mainTableView NightWithType:UIViewColorTypeNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[PlayViewController shardPalyViewController]suspendPlayWhenChengeView];
}

//返回
- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---------mainTableView代理方法-------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [tableView showMessage:@"么有播放记录，😝快去看视频吧" byDataSourceCount:self.array.count];
}

- (PlayRecordedTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayRecordedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *dic = self.array[indexPath.row];
    [cell getValueFormPlayPath:dic];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 140;
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
        
        //删除本地数据
        [[CollectManager sharedManager]deleteData:self.array[indexPath.row]];
        
        //删除数据源
        [self.array removeObjectAtIndex:indexPath.row];
        [MSQFileReadAndWriteTools writeArray:self.array toFilePath:kPlayRecord];
        //删除UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
        
//        [AVQuery doCloudQueryInBackgroundWithCQL:@"delete from Todo where objectId='558e20cbe4b060308e3eb36c'" callback:^(AVCloudQueryResult *result, NSError *error) {
//            // 如果 error 为空，说明保存成功
//            
//        }];
//        [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"delete from Memory where objectId='%@'",[self.dataSource objectAtIndex:indexPath.row][@"objectId"]] callback:^(AVCloudQueryResult *result, NSError *error) {
//            
//            [self.dataSource removeObjectAtIndex:indexPath.row];
//            //            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
//        }];
//        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.array[indexPath.row];
    CollectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PlayViewController *plauer = [PlayViewController shardPalyViewController];
    [plauer playVideoAtCell:cell url:dic[@"url"] tableView:tableView contentsetY:cell.frame.origin.y viewController:self indexPath:indexPath title:dic[@"title"] imageUrl:dic[@"imageUrl"]];
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayViewController *plauer = [PlayViewController shardPalyViewController];
    [plauer pullDownCellAddPlay:cell indexPath:indexPath];
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
