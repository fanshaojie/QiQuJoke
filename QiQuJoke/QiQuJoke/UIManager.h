//
//  UIManager.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/1.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
@interface UIManager : NSObject
+(void)showNoNetToastIn:(UIView*)view;
+(void)showToastIn:(UIView*)view info:(NSString*)info;
+(UIColor*)selectedDefaultColor;
+(void)showToastIn:(UIView*)view title:(NSString*)title content:(NSString*)cnt;
+(UIColor*)btnDefaultColor;
@end
