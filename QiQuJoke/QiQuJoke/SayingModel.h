//
//  SayingModel.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/6.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SayingCateModel : NSObject
@property (nonatomic,strong) NSString  *cateName;
@property (nonatomic,retain) NSMutableArray *sayingArray;
@end

@interface SayingModel : NSObject
@property (nonatomic,strong)  NSString *content;
@property (nonatomic,strong) NSString *answer;

@end
