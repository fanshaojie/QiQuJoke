//
//  TrickManager.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/8/31.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrickModel.h"
#import "AFNetworking.h"
#import "DefineManager.h"
#import "NSString+MessageDigest.h"
@interface TrickManager : NSObject

-(void)initTricksOfCateAllWithComplete:(void(^)(NSArray *trickCateArr))complete ;

-(void)initTrickOfCate:(NSString*)cate reloadFromServer:(BOOL)needReload complete:(void(^)(TrickCateModel*)) _complete;

-(void)requestTrickOfCate:(NSString*)cate pageIndex:(NSInteger)pIndex complete:(void(^)(TrickCateModel*)) _complete;

@end
