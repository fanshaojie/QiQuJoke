//
//  UIManager.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/1.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "UIManager.h"
#import <UIKit/UIKit.h>
@implementation UIManager

+(void)showAlert:(NSString *)content{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"tip", nil) message:content delegate:nil cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil, nil];
    [alert show];
}

@end
