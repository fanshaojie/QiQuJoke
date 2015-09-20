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
#import "CateModel.h"
#import <XHRefreshControl.h>
#import "UIManager.h"
#import "RiddleManager.h"
#import "SayingManager.h"
#import "NetHelper.h"
#import "TrickManager.h"
@protocol tableViewProcotol <NSObject>

-(void)selectedCellIndex:(NSInteger)index cm:(CateModel*)cm;

@end

@interface CommonTableViewController : UITableViewController<XHRefreshControlDelegate>

-(instancetype)initWithCateModel:(CateModel*)cm;
@property (nonatomic)  id<tableViewProcotol> delegate;

@end
