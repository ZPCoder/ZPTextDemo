//
//  CollectModel+CoreDataProperties.h
//  Video
//
//  Created by 朱鹏 on 16/5/12.
//  Copyright © 2016年 朱鹏 All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CollectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *file;
@property (nullable, nonatomic, retain) NSString *spare;
@property (nullable, nonatomic, retain) NSString *spare_1;

@end

NS_ASSUME_NONNULL_END
