//
//  NetHelper.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/8.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "NetHelper.h"


@implementation NetHelper

+(NetHelper *)Instance{
    static NetHelper *mNetHelper = nil;
   static dispatch_once_t  onceT;
    dispatch_once(&onceT, ^{
        mNetHelper = [[NetHelper alloc]init];
    });
    return mNetHelper;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        //网络初始化
        _netState = QQReachabilityStatusReachableViaWWAN;
        [self checkNetworkState];
    }
    return  self;
}

-(void)checkNetworkState{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case  AFNetworkReachabilityStatusUnknown :
                    NSLog(@"无网络");
                    self.netState = QQReachabilityStatusUnknown;
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"无网络2");
                    self.netState = QQReachabilityStatusNotReachable;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"-----wifi");
                    self.netState = QQReachabilityStatusReachableViaWiFi;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"------手机网络");
                    self.netState = QQReachabilityStatusReachableViaWWAN;
                    break;
                default:
                    break;
            }
        }];
        [manager startMonitoring];
    });
}

@end
