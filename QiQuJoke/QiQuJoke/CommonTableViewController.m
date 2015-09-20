//
//  CommonTableViewController.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/1.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "CommonTableViewController.h"

@interface CommonTableViewController (){
    BOOL didFirstReload ;
    CateModel *_cm;
    XHRefreshControl *refreshCtrl;
    CateModel *cateModel;
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
        [self loadDataByOperMode:RMInit pIndex:0];
        didFirstReload = YES;
    }else{
        [self loadDataByOperMode:RMReload pIndex:0];
    }
}

-(void)beginLoadMoreRefreshing{
    if (_cm.itemsArr.count >[self.tableView numberOfRowsInSection:0]) {
        //使用场景为:详情页面上一条下一条引起的数据已被缓存
        [self.tableView reloadData];
    }
    else{
        //上拉加载更多数据（从服务器端请求更多数据）
        NSInteger indexOfNeedLoad = _cm.itemsArr.count/kPageDefaultCount;
        [self loadDataByOperMode:RMLoadMore pIndex:indexOfNeedLoad];
    }
    
}

-(instancetype)initWithCateModel:(CateModel *)cm{
    self = [super init];
    if (self) {
        _cm = cm;
    }
    return self;
}

-(NSString *)lastUpdateTimeString{
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"HH:mm:ss"];
    return [formater stringFromDate:[NSDate date]];
}

-(void)loadDataByOperMode:(RequestMode)mode pIndex:(NSInteger)pi{
    BOOL needReloadFormServer = false;
    if (mode == RMInit) {
        needReloadFormServer = NO;
    }
    else{
        needReloadFormServer = YES;
    }
    
    if(mode == RMInit && _cm.itemsArr){
        [refreshCtrl endPullDownRefreshing];
        return;
    }
    switch (_cm.type) {
        case CTTrick:{
            [[TrickManager instance]requestTrickOfCate:_cm.cateName reloadFormServer:needReloadFormServer pageIndex:pi complete:^(RequestState errState) {
                if(errState == NENoNet)
                {
                    [UIManager showNoNetToastIn:self.view];
                }
                else if(_cm.itemsArr)
                {
                    [self.tableView reloadData];
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
            [[RiddleManager instance]requestRiddleOfCate:_cm.cateName reloadFromServer:needReloadFormServer pageIndex:pi complete:^(RequestState errState) {
                if(errState == NENoNet)
                {
                    [UIManager showNoNetToastIn:self.view];
                }
                else if(_cm.itemsArr)
                {
                    [self.tableView reloadData];
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
            [[SayingManager instance]requestSayingOfCate:_cm.cateName reloadFromServer:needReloadFormServer pageIndex:pi complete:^(RequestState errState) {
                if(errState == NENoNet)
                {
                    [UIManager showNoNetToastIn:self.view];
                }
                else if(_cm.itemsArr)
                {
                    [self.tableView reloadData];
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

-(void)initData{
    [refreshCtrl startPullDownRefreshing];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (_cm.itemsArr) {
        return _cm.itemsArr.count;
    }
    return 0;
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
    
    ItemModel *im = [_cm.itemsArr objectAtIndex:indexPath.row];
    cell.textLabel.text = im.content;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedCellIndex:cm:)]) {
        [self.delegate selectedCellIndex:indexPath.row cm:_cm];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

@end
