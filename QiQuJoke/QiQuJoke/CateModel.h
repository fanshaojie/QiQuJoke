//
//  TrickModel.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/8/31.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumManager.h"
@interface CateModel : NSObject
@property (nonatomic,strong) NSString  *cateName;
@property (nonatomic,retain) NSMutableArray *itemsArr;
@property (nonatomic) NSInteger nums;
@property (nonatomic) ContentType type;
@end

@interface ItemModel : NSObject
@property (nonatomic,strong)  NSString *content;
@property (nonatomic,strong) NSString *answer;

@end
