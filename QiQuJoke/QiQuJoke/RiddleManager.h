//
//  RiddleManager.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/6.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RiddleModel.h"
#import "AFNetworking.h"
#import "DefineManager.h"
#import "NSString+MessageDigest.h"

@interface RiddleManager : NSObject

-(void)initRiddlesOfCateAllWithComplete:(void(^)(NSArray *riddleCateArr))complete ;

-(void)initRiddleOfCate:(NSString*)cate reloadFromServer:(BOOL)needReload complete:(void(^)(RiddleCateModel* rcm)) _complete;

-(void)requestRiddleOfCate:(NSString*)cate pageIndex:(NSInteger)pIndex complete:(void(^)(RiddleCateModel* rcm)) _complete;

@end
