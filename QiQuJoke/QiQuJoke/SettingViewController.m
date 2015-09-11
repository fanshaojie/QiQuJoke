//
//  SettingViewController.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/11.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController (){
    UITableView *_settingTable;
}

@end

@implementation SettingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
}

-(void)initView{
    _settingTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenNavTop, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- kScreenNavTop - kTabBarDefaultHeight)];
    _settingTable.dataSource = self;
    _settingTable.delegate = self;
    [self.view addSubview:_settingTable];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row  == 0) {
        //皮肤
    }
    else if(indexPath.row == 1)
    {
        //意见建议
    }
    else if(indexPath.row == 2)
    {
        //精彩推荐
    }
    
    return nil;
}

@end
