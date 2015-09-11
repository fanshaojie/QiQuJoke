//
//  CommonTableViewController.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/1.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "CommonTableViewController.h"

@interface CommonTableViewController (){
    ContentType cntType;
    id cnt;
    NSInteger pageIndex;
    BOOL didFirstReload ;
    XHRefreshControl *refreshCtrl;
}

@end

@implementation CommonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    
}

-(void)initView{
    refreshCtrl = [[XHRefreshControl alloc]initWithScrollView:self.tableView delegate:self];
    refreshCtrl.circleColor = [UIColor orangeColor];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (BOOL)keepiOS7NewApiCharacter;{
    return YES;
}

-(void)beginPullDownRefreshing{
    if (!didFirstReload) {
        [self loadDataByOperMode:RMInit];
        didFirstReload = YES;
    }else{
        [self loadDataByOperMode:RMReload];
    }
}

-(void)beginLoadMoreRefreshing{
    pageIndex++;
    [self loadDataByOperMode:RMLoadMore];
}

-(NSString *)lastUpdateTimeString{
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"HH:mm:ss"];
    return [formater stringFromDate:[NSDate date]];
}

-(void)loadDataByOperMode:(RequestMode)mode{
    BOOL needReloadFormServer = false;
    if (mode == RMInit) {
        needReloadFormServer = NO;
    }
    else{
        needReloadFormServer = YES;
    }
    
    switch (cntType) {
        case CTTrick:{
            TrickCateModel *cateModel = cnt;
            if(mode == RMInit && cateModel.trickArray){
                [refreshCtrl endPullDownRefreshing];
                return;
            }
            TrickManager *manager =   [[TrickManager alloc]init];
            [manager requestTrickOfCate:[self checkOutCateKey:cateModel.cateName] reloadFormServer:needReloadFormServer pageIndex:pageIndex complete:^(TrickCateModel *cm, RequestState errState) {
                if(errState == NENoNet)
                {
                    if(mode == RMLoadMore)
                    {
                        pageIndex-- ;
                    }
                    [UIManager showNoNetToastIn:self.view];
                }
                else if(cm)
                {
                    if(mode == RMLoadMore){
                        TrickCateModel *cateModel = cnt;
                        [cateModel.trickArray addObjectsFromArray:cm.trickArray];
                    }
                    else{
                        cnt = cm;
                    }
                    [self.tableView reloadData];
                }
                else {
                    if(mode == RMLoadMore)
                    {
                        pageIndex-- ;
                    }
                }
                if (mode == RMLoadMore) {
                    [refreshCtrl endLoadMoreRefresing];
                }
                else{
                    [refreshCtrl endPullDownRefreshing];
                }
                
            }];
            break;
        }
        case CTRiddle:{
            RiddleCateModel *cateModel = cnt;
            if(mode == RMInit && cateModel.riddleArray){
                [refreshCtrl endPullDownRefreshing];
                return;
            }
            RiddleManager *manager =   [[RiddleManager alloc]init];
            
            [manager requestRiddleOfCate:[self checkOutCateKey:cateModel.cateName] reloadFromServer:needReloadFormServer pageIndex:pageIndex complete:^(RiddleCateModel *rcm, RequestState errState) {
                if(errState == NENoNet)
                {
                    if(mode == RMLoadMore)
                    {
                        pageIndex-- ;
                    }
                    [UIManager showNoNetToastIn:self.view];
                }
                else if(rcm)
                {
                    if(mode == RMLoadMore){
                        RiddleCateModel *cateModel = cnt;
                        [cateModel.riddleArray addObjectsFromArray:rcm.riddleArray];
                    }
                    else{
                        cnt = rcm;
                    }
                    [self.tableView reloadData];
                }
                else {
                    if(mode == RMLoadMore)
                    {
                        pageIndex-- ;
                    }
                }
                if (mode == RMLoadMore) {
                    [refreshCtrl endLoadMoreRefresing];
                }
                else{
                    [refreshCtrl endPullDownRefreshing];
                }
                
            }];
            break;
        }
        case CTSaying:
        {
            SayingCateModel *cateModel = cnt;
            if(mode == RMInit && cateModel.sayingArray){
                [refreshCtrl endPullDownRefreshing];
                return;
            }
            SayingManager *manager =   [[SayingManager alloc]init];
            [manager requestSayingOfCate:[self checkOutCateKey:cateModel.cateName] reloadFromServer:needReloadFormServer pageIndex:pageIndex complete:^(SayingCateModel *scm, RequestState errState) {
                if(errState == NENoNet)
                {
                    if(mode == RMLoadMore)
                    {
                        pageIndex-- ;
                    }
                    [UIManager showNoNetToastIn:self.view];
                }
                else if(scm)
                {
                    if(mode == RMLoadMore){
                        SayingCateModel *cateModel = cnt;
                        [cateModel.sayingArray addObjectsFromArray:scm.sayingArray];
                    }
                    else{
                        cnt = scm;
                    }
                    [self.tableView reloadData];
                }
                else {
                    if(mode == RMLoadMore)
                    {
                        pageIndex-- ;
                    }
                }
                if (mode == RMLoadMore) {
                    [refreshCtrl endLoadMoreRefresing];
                }
                else{
                    [refreshCtrl endPullDownRefreshing];
                }
                
            }];
            break;
        }
        default:
            break;
    }
}


/**
 *  获取搜索关键字
 *
 *  @param cateName 分类名称
 *
 *  @return 搜索关键字
 */
-(NSString*)checkOutCateKey:(NSString*)cateName{
    if ([cateName isEqualToString:NSLocalizedString(@"all", nil)]) {
        return @"";
    }
    return cateName;
}

-(void)initData{
    pageIndex = 0;
    [refreshCtrl startPullDownRefreshing];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(instancetype)initWithContentType:(ContentType)type Content:(id)ct{
    if (self = [super init]) {
        cntType = type;
        cnt = ct;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (cntType == CTTrick) {
        TrickCateModel *cateModel = cnt;
        return cateModel.trickArray.count;
    }
    else if(cntType == CTRiddle) {
        RiddleCateModel *cateModel = cnt;
        return cateModel.riddleArray.count;
    }
    else if(cntType == CTSaying) {
        SayingCateModel *cateModel = cnt;
        return cateModel.sayingArray.count;
    }
    return 3 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIDStr = @"queue";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDStr];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDStr];
        cell.backgroundColor =[UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc]init];
        cell.selectedBackgroundView.backgroundColor =[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.1];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    if (cntType == CTTrick) {
        TrickCateModel *cateModel = cnt;
        TrickModel *trickModel =  [cateModel.trickArray objectAtIndex:indexPath.row];
        cell.textLabel.text = trickModel.content;
        
    }
    else if(cntType == CTRiddle) {
        RiddleCateModel *cateModle = cnt;
        RiddleModel *riddleModel = [cateModle.riddleArray objectAtIndex:indexPath.row];
        cell.textLabel.text = riddleModel.content;
    }
    else if(cntType == CTSaying) {
        SayingCateModel *cateModel = cnt;
        SayingModel  *sayingModel = [cateModel.sayingArray objectAtIndex:indexPath.row];
        cell.textLabel.text = sayingModel.content;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (cntType == CTTrick) {
        TrickCateModel *cateModel = cnt;
        TrickModel *trickModel =  [cateModel.trickArray objectAtIndex:indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cellSelectedAtModel:)]) {
            [self.delegate cellSelectedAtModel:trickModel];
        }
    }
    else if(cntType == CTRiddle) {
        RiddleCateModel *cateModel = cnt;
        RiddleModel *riddleModel = [cateModel.riddleArray objectAtIndex:indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cellSelectedAtModel:)]) {
            [self.delegate cellSelectedAtModel:riddleModel];
        }
    }
    else if(cntType == CTSaying) {
        SayingCateModel *cateModel = cnt;
        SayingModel *sayingModel = [cateModel.sayingArray objectAtIndex:indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cellSelectedAtModel:)]) {
            [self.delegate cellSelectedAtModel:sayingModel];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

@end
