//
//  NetHelper.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/8.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "EnumManager.h"
@interface NetHelper : NSObject

+(NetHelper*)Instance;

@property (nonatomic) NetState netState;
@end
