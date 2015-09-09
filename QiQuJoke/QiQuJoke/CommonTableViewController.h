//
//  CommonTableViewController.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/1.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumManager.h"
#import "DefineManager.h"
#import "TrickModel.h"
#import "TrickManager.h"
#import <XHRefreshControl.h>
#import "UIManager.h"
#import "RiddleManager.h"
#import "RiddleModel.h"
#import "SayingModel.h"
#import "SayingManager.h"
#import "NetHelper.h"
@protocol tableViewProcotol <NSObject>

-(void)cellSelectedAtModel:(id)model;

@end

@interface CommonTableViewController : UITableViewController<XHRefreshControlDelegate>

-(instancetype)initWithContentType:(ContentType)type Content:(id)ct;

@property (nonatomic)  id<tableViewProcotol> delegate;

@end
