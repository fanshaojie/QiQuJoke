//
//  AppDelegate.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/8/28.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "DefineManager.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "NetHelper.h"
#import <UMFeedback.h>
#import "DefineManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UINavigationBar appearance].tintColor = [UIColor orangeColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds ]];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *controller= [[ViewController alloc]init];
    self.window.rootViewController=controller;
    [[self window]makeKeyAndVisible];
    
    //友盟反馈
    [UMFeedback setAppkey:kUmengAppKey];
    
    //初始化分享组件
    [ShareSDK registerApp:kShareSDKApiKey activePlatforms:@[@(SSDKPlatformTypeQQ),@(SSDKPlatformSubTypeQZone ), @(SSDKPlatformTypeWechat),@(SSDKPlatformSubTypeWechatTimeline)] onImport:^(SSDKPlatformType platformType){
        switch(platformType){
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformSubTypeWechatTimeline:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            default:
                break;
        }
        
    }onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:kQQAppID appKey:kQQAppKey authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:kWechatAppID appSecret:kWechatAppSecret];
                break;
            case SSDKPlatformSubTypeWechatTimeline:
                [appInfo SSDKSetupWeChatByAppId:kWechatAppID appSecret:kWechatAppSecret];
                break;
            default:
                break;
        }
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}



@end
