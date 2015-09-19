//
//  TrickManager.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/8/31.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CateModel.h"
#import "AFNetworking.h"
#import "DefineManager.h"
#import "NSString+MessageDigest.h"
#import "NetHelper.h"
#import "EnumManager.h"
@interface TrickManager : NSObject

+(TrickManager*)instance;

@property (nonatomic,strong) NSMutableArray *cateArr;

-(void)initTricksOfCateAllWithComplete:(void(^)(RequestState errState))complete;

-(void)requestTrickOfCate:(NSString*)cate reloadFormServer:(BOOL)needReload  pageIndex:(NSInteger)pIndex complete:(void(^)(RequestState errState)) _complete;

@end
