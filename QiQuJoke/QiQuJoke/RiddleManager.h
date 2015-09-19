//
//  RiddleManager.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/6.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CateModel.h"
#import "AFNetworking.h"
#import "DefineManager.h"
#import "NSString+MessageDigest.h"
#import "EnumManager.h"
#import "NetHelper.h"
@interface RiddleManager : NSObject

+(RiddleManager*)instance;

@property (nonatomic,strong) NSMutableArray *cateArr;

-(void)initRiddlesOfCateAllWithComplete:(void(^)(RequestState errState))complete ;

-(void)requestRiddleOfCate:(NSString*)cate reloadFromServer:(BOOL)needReload  pageIndex:(NSInteger)pIndex complete:(void(^)(RequestState errState)) _complete;

@end
