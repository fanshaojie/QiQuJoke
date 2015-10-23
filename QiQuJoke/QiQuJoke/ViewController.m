//
//  ViewController.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/8/28.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)initView{
    NSString *defaultBgName = [[NSUserDefaults standardUserDefaults]valueForKey:kUDSkinKey];
    if (!defaultBgName) {
        [[NSUserDefaults standardUserDefaults]setValue:@"zg4" forKey:kUDSkinKey];
    }
    
    NSString *detailDefaultBgName = [[NSUserDefaults standardUserDefaults]valueForKey:kUDDtailSkinKey];
    if (!detailDefaultBgName) {
        [[NSUserDefaults standardUserDefaults]setValue:@"dbg4" forKey:kUDDtailSkinKey];
    }
    
    //NetState netState = [NetHelper Instance].netState;
    RiddleViewController *rvCtrl = [[RiddleViewController alloc]init];
    rvCtrl.tabBarItem.title = NSLocalizedString(@"riddle", nil);
    rvCtrl.tabBarItem.image = [UIImage imageNamed:@"riddleIcon"];
    
    TrickViewController *trickCtrl = [[TrickViewController alloc]init];
    trickCtrl.tabBarItem.title = NSLocalizedString(@"trick", nil);
    trickCtrl.tabBarItem.image = [UIImage imageNamed:@"trickIcon"];
    
    SayingViewController *sayingCtrl =[[SayingViewController alloc]init];
    sayingCtrl.tabBarItem.title = NSLocalizedString(@"saying", nil);
    sayingCtrl.tabBarItem.image = [UIImage imageNamed:@"sayingIcon"];
    
    SettingViewController *settingCtrl = [[SettingViewController alloc]init];
    settingCtrl.tabBarItem.title = NSLocalizedString(@"setting", nil);
    settingCtrl.tabBarItem.image = [UIImage imageNamed:@"settingIcon"];
    
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:rvCtrl]];
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:trickCtrl]];
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:sayingCtrl]];
    
    [self addChildViewController:[[UINavigationController alloc]initWithRootViewController:settingCtrl ]];
    
    self.tabBar.barTintColor = [UIColor blackColor];
    self.tabBar.tintColor = [UIColor orangeColor];
    self.selectedIndex = 1;
    [self recordUserTimes];
}

-(void)recordUserTimes{
    BOOL isJudged = [[NSUserDefaults standardUserDefaults]boolForKey:kIsJudgedKey];
    if (isJudged) {
        return;
    }
    NSInteger times =  [[NSUserDefaults standardUserDefaults]integerForKey:kUserTimesKey];
    NSInteger setTimes = [[NSUserDefaults standardUserDefaults]integerForKey:kSetJudgeTimesKey];
    
    if (times) {
        times++;
        if (times == setTimes) {
            //弹出评价提示
            NSString *displayName = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"说说您对%@的印象",displayName]
                                                                message:@"您的评价对我们很重要"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"残忍的拒绝",@"赞一个",nil];
            [alertView show];
            
            setTimes = setTimes*3;
            [[NSUserDefaults standardUserDefaults]setInteger:setTimes forKey:kSetJudgeTimesKey];
        }
    }
    else{
        times =1;
        setTimes = 5;
        [[NSUserDefaults standardUserDefaults]setInteger:setTimes forKey:kSetJudgeTimesKey];
    }
    [[NSUserDefaults standardUserDefaults]setInteger:times forKey:kUserTimesKey];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==  1) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kIsJudgedKey];
        //去评价
        NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"1043441963"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
