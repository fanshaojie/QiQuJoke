//
//  CommonSingleQuestViewController.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/1.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumManager.h"
#import "DefineManager.h"
#import "CateModel.h"
#import <ShareSDK/ShareSDK.h>
#import "LXActivity.h"
#import "UIManager.h"
#import "STScratchView.h"
#import "TrickManager.h"
#import "CoreDataManager.h"
#import "RiddleManager.h"
#import "SayingManager.h"
@interface CommonSingleQuestViewController : UIViewController<LXActivityDelegate>

@property (nonatomic,strong) CateModel *cm;
@property (nonatomic,assign) NSInteger iindex;


@end
