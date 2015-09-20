//
//  CoreDataManager.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/20.
//  Copyright © 2015年 少杰范. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface CoreDataManager : NSObject

+(CoreDataManager*)instance;

-(void)insertDataWithClassName:(NSString*)name attriDic:(NSDictionary*)dic;

-(void)deleteDataWithClassName:(NSString*)name predicate:(NSPredicate*)predicate ;

-(NSArray*)selectDataFromClassName:(NSString*)name predicate:(NSPredicate*)predicate sortkeys:(NSArray*)sortkeys;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
