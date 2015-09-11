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
    NetState netState = [NetHelper Instance].netState;
    RiddleViewController *rvCtrl = [[RiddleViewController alloc]init];
    rvCtrl.tabBarItem.title = NSLocalizedString(@"riddle", nil);
    rvCtrl.tabBarItem.image = [UIImage imageNamed:@"riddleIcon"];
    
    TrickViewController *trickCtrl = [[TrickViewController alloc]init];
    trickCtrl.tabBarItem.title = NSLocalizedString(@"trick", nil);
    trickCtrl.tabBarItem.image = [UIImage imageNamed:@"trickIcon"];
    
    SayingViewController *sayingCtrl =[[SayingViewController alloc]init];
    sayingCtrl.tabBarItem.title = NSLocalizedString(@"saying", nil);
    sayingCtrl.tabBarItem.image = [UIImage imageNamed:@"sayingIcon"];
    
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:rvCtrl]];
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:trickCtrl]];
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:sayingCtrl]];
    self.tabBar.barTintColor = [UIColor blackColor];
    self.tabBar.tintColor = [UIColor orangeColor];
    self.selectedIndex = 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
