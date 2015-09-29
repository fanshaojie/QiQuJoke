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
    BaiduMobAdView *_adView;
}

@end

@implementation SettingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

-(void)initView{
    self.title = NSLocalizedString(@"setting", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    _settingTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - kTabBarDefaultHeight)];
    _settingTable.dataSource = self;
    _settingTable.delegate = self;
    //_settingTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_settingTable];
    
    _adView = [[BaiduMobAdView alloc]init];
    _adView.AdUnitTag = @"2014898";
    _adView.AdType = BaiduMobAdViewTypeBanner;
    _adView.frame = CGRectMake(0,0 , kBaiduAdViewSizeDefaultWidth, kBaiduAdViewSizeDefaultHeight);
    _adView.delegate = self;
    _settingTable.tableFooterView = _adView;
     [_adView start];
}

-(NSString *)publisherId{
    return @"b6059d44";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row  == 0) {
        //皮肤
        SkinViewController *skinCtrl = [[SkinViewController alloc]init];
        [self.navigationController pushViewController:skinCtrl animated:YES];
        
    }
    else if(indexPath.row == 1){
        //详情皮肤
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        DetailSkinViewController *dsvCtrl = [[DetailSkinViewController alloc]initWithCollectionViewLayout:flowLayout];
        [self.navigationController pushViewController:dsvCtrl animated:YES];
    }
    else if(indexPath.row == 2)
    {
        //我的收藏
        FaviorteViewController *favorite = [[FaviorteViewController alloc] init];
        [self.navigationController pushViewController:favorite animated:YES];
    }
    else if(indexPath.row == 3){
        //清理缓存
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        BOOL isOK = [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
        if (isOK) {
            [UIManager showToastIn:self.view info:NSLocalizedString(@"clearCacheOK", nil)];
        }
        else{
            [UIManager showToastIn:self.view info:NSLocalizedString(@"noCache", nil)];
        }
    }
    else if(indexPath.row == 4)
    {
        //意见建议
        [self.navigationController pushViewController:[UMFeedback feedbackViewController] animated:YES];
        [self.tabBarController.tabBar setHidden:YES];
    }
    else if(indexPath.row == 5)
    {
        //精彩推荐
        [UIManager showToastIn:self.view info:NSLocalizedString(@"waitRecommend", nil)];
    }
    else if(indexPath.row == 6){
        [UIManager showToastIn:self.view title:NSLocalizedString(@"sponserUs", <#comment#>) content:NSLocalizedString(@"toClickMe", nil)];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"setCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectedBackgroundView = [[UIView alloc]init];
        cell.selectedBackgroundView.backgroundColor =[UIManager selectedDefaultColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    
    if (indexPath.row  == 0) {
        //皮肤
        cell.textLabel.text  =NSLocalizedString(@"listSkin", nil);
        
    }
    else if(indexPath.row == 1){
        cell.textLabel.text = NSLocalizedString(@"detailSkin", nil);
    }
    else if (indexPath.row == 2)
    {
        //我的收藏
        cell.textLabel.text = NSLocalizedString(@"myFavorite", nil);
    }
    else if(indexPath.row == 3){
        //清理缓存
        cell.textLabel.text = NSLocalizedString(@"clearCache", nil);
    }
    else if(indexPath.row == 4)
    {
        //意见建议
        cell.textLabel.text = NSLocalizedString(@"advice", nil);
    }
    else if(indexPath.row == 5)
    {
        //精彩推荐
        cell.textLabel.text = NSLocalizedString(@"recommend", nil);
    }
    else if (indexPath.row == 6){
        cell.textLabel.text = NSLocalizedString(@"sponserUs", nil);
    }
    return cell;
}

@end
