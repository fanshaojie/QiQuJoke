//
//  Favorite+CoreDataProperties.h
//  QiQuJoke
//
//  Created by 陈辉 on 15/9/18.
//  Copyright © 2015年 少杰范. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Favorite.h"

NS_ASSUME_NONNULL_BEGIN

@interface Favorite (CoreDataProperties)

@property (nullable, nonatomic) NSInteger *catetype;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *answer;

@end

NS_ASSUME_NONNULL_END
