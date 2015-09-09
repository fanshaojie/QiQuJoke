//
//  SayingManager.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/6.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SayingModel.h"
#import "AFNetworking.h"
#import "DefineManager.h"
#import "NSString+MessageDigest.h"
#import "EnumManager.h"
#import "NetHelper.h"
@interface SayingManager : NSObject

-(void)initSayingsOfCateAllWithComplete:(void(^)(NSArray *SayingCateArr,RequestState errState))complete ;

-(void)requestSayingOfCate:(NSString*)cate reloadFromServer:(BOOL)needReload pageIndex:(NSInteger)pIndex complete:(void(^)(SayingCateModel* scm,RequestState errState)) _complete;

@end
