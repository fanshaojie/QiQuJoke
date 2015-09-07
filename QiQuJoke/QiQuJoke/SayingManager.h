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

@interface SayingManager : NSObject

-(void)initSayingsOfCateAllWithComplete:(void(^)(NSArray *SayingCateArr))complete ;

-(void)initSayingOfCate:(NSString*)cate reloadFromServer:(BOOL)needReload complete:(void(^)(SayingCateModel* scm)) _complete;

-(void)requestSayingOfCate:(NSString*)cate pageIndex:(NSInteger)pIndex complete:(void(^)(SayingCateModel* scm)) _complete;

@end
