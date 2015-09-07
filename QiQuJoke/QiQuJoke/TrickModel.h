//
//  TrickModel.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/8/31.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrickCateModel : NSObject
@property (nonatomic,strong) NSString  *cateName;
@property (nonatomic,retain) NSMutableArray *trickArray;
@end

@interface TrickModel : NSObject
@property (nonatomic,strong)  NSString *content;
@property (nonatomic,strong) NSString *answer;

@end
