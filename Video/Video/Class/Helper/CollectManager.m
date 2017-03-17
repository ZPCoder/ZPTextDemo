//
//  CollectManager.m
//  Video
//
//  Created by 朱鹏 on 16/5/12.
//  Copyright © 2016年 朱鹏 All rights reserved.
//

#import "CollectManager.h"

@implementation CollectManager

+(CollectManager*)sharedManager{
    
    static CollectManager *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[CollectManager alloc]init];
    });
    return handle;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
        //关联上下文
        self.context = [[NSManagedObjectContext alloc]initWithConcurrencyType:(NSPrivateQueueConcurrencyType)];
        
        //关联表模型
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc]initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"Video" withExtension:@"momd"]];
        
        //数据持久化处理的初始化
        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        
        //文件路径
        NSString *documentPath = [[SendBoxPath libraryPath] stringByAppendingPathComponent:@"Collect"];
        
        //存储的文件名
        NSString *fileName = [documentPath stringByAppendingPathExtension:@"model.sqlite"];
        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:fileName] options:nil error:nil];
        NSLog(@"%@",fileName);
        self.context.persistentStoreCoordinator = store;
    }
    return self;
}



//增
-(void)insertData:(CollectionModel *)data{
    
    //先判断有没有已经被收藏
    if(![self isContaintData:data]){
        
    //创建一个实体，并且插入到表中
        CollectModel *collectModel  = [NSEntityDescription insertNewObjectForEntityForName:@"CollectModel" inManagedObjectContext:self.context];
        collectModel.title = data.title;
        collectModel.image = data.image;
        collectModel.file = data.file;
        collectModel.spare = [CollectManager dateToStringWhitDate];
        NSLog(@"%@",collectModel.spare);
        [self.context save:nil];
        [self createAlerViewWithTitle:@"提示" message:@"收藏成功"];
        
    }else{
        [self createAlerViewWithTitle:@"提示" message:@"亲，你已经收藏了"];

    }
}

//删
-(void)deleteData:(CollectionModel *)model{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CollectModel" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", model.title];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"<#key#>"
//                                                                   ascending:YES];
//    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    for (CollectModel *model in fetchedObjects) {
        [self.context deleteObject:model];
        
        //保存
        [self.context save:nil];
    }
}

- (void)deledataAllData {

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CollectModel" ];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:request error:&error];
    if (fetchedObjects != nil) {
        
        for (CollectModel *model in fetchedObjects) {
            [self.context deleteObject:model];
            
            //保存
            [self.context save:nil];
        }
    }
}


//查询所有数据
-(NSArray *)selectedData{
    
    //创建请求体
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CollectModel" ];
    
    return [self.context executeFetchRequest:request error:nil];
    
}

//时间（date）转转字符串  *date = [NSDate dateWithTimeIntervalSince1970:<#(NSTimeInterval)#>]
+ (NSString *)dateToStringWhitDate   {
    //设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //当前时间[NSDate date];
    NSString *timeString = [formatter stringFromDate:[NSDate date]];
    return timeString;
}






//查询单个数据
-(BOOL)isContaintData:(CollectionModel*)data{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CollectModel"];
    
    //谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@",data.title];
    NSLog(@"%@",data.title);
    request.predicate = predicate;
    
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    NSLog(@"%@",array);
    
    if (array.count > 0) {
        return YES;
    }else{
        return NO;
    }
    
}

-(void)createAlerViewWithTitle:(NSString*)title message:(NSString*)message{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"亲，点我哦" otherButtonTitles:nil];
    
    [alert show];
    
}




@end
