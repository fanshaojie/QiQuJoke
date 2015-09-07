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
    SDRefreshHeaderView *refreshHeader;
    SDRefreshFooterView *refreshFooter;
}

@end

@implementation CommonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

-(void)initView{
    refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addTarget:self refreshAction:@selector(refreshByHeader)];
    [refreshHeader addToScrollView:self.tableView];
    
    refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addTarget:self  refreshAction:@selector(refreshByFooter)];
    [refreshFooter addToScrollView:self.tableView];
    
    
}

-(void)refreshByHeader{
    [self reloadData];
}

-(void)refreshByFooter{
    pageIndex++;
    if (cntType == CTTrick) {
        TrickCateModel *cateModel = cnt;
        TrickManager *manager =   [[TrickManager alloc]init];
        [manager requestTrickOfCate:[self checkOutCateKey:cateModel.cateName] pageIndex:pageIndex complete:^(TrickCateModel *cm) {
            if (!cm) {
                pageIndex--;
                return;
            }
            TrickCateModel *cateModel = cnt;
            [cateModel.trickArray addObjectsFromArray:cm.trickArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [refreshFooter endRefreshing];
            });
            
        }];
    }
    else if(cntType == CTRiddle) {
        RiddleCateModel *cateModel = cnt;
        RiddleManager *manager = [[RiddleManager alloc]init];
        [manager requestRiddleOfCate:[self checkOutCateKey:cateModel.cateName] pageIndex:pageIndex complete:^(RiddleCateModel *rcm) {
            if (!rcm) {
                pageIndex--;
                return;
            }
            RiddleCateModel *riddleCM = cnt;
            [riddleCM.riddleArray addObjectsFromArray:rcm.riddleArray];
            [self.tableView reloadData];
            [refreshFooter endRefreshing];
        }];
    }
    else if(cntType == CTSaying) {
        SayingCateModel *cateModel = cnt;
        SayingManager *manager = [[SayingManager alloc]init];
        [manager requestSayingOfCate:[self checkOutCateKey:cateModel.cateName] pageIndex:pageIndex complete:^(SayingCateModel *scm) {
            if (!scm) {
                pageIndex--;
                return;
            }
            SayingCateModel *sayingCM = cnt;
            [sayingCM.sayingArray addObjectsFromArray:scm.sayingArray];
            [self.tableView reloadData];
            [refreshFooter endRefreshing];
        }];
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
    if (cntType == CTTrick) {
        TrickCateModel *cateModel = cnt;
        if (cateModel.trickArray == nil) {
            //todo  进行首次加载数据操作
            TrickManager *manager =   [[TrickManager alloc]init];
            [manager   initTrickOfCate:[self checkOutCateKey:cateModel.cateName] reloadFromServer:NO complete:^(TrickCateModel *cm) {
                cnt = cm;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [refreshHeader endRefreshing];
                });
                
            }];
        }
        else{
            //数据已存在，则直接等待初始化视图,这里不用做处理
        }
        
    }
    else if(cntType == CTRiddle) {
        RiddleCateModel *cateModel = cnt;
        if (cateModel.riddleArray == nil) {
            RiddleManager *manager = [[RiddleManager alloc]init];
            [manager initRiddleOfCate:[self checkOutCateKey:cateModel.cateName] reloadFromServer:NO complete:^(RiddleCateModel *rcm) {
                cnt = rcm;
                [self.tableView reloadData];
                [refreshHeader endRefreshing];
            }];
        }
    }
    else if(cntType == CTSaying) {
        SayingCateModel *cateModel = cnt;
        if (cateModel.sayingArray == nil) {
            SayingManager *manager = [[SayingManager alloc]init];
            [manager initSayingOfCate:[self checkOutCateKey:cateModel.cateName] reloadFromServer:NO complete:^(SayingCateModel *scm) {
                cnt = scm;
                [self.tableView reloadData];
                [refreshHeader endRefreshing];
            }];
        }
    }
    [refreshHeader beginRefreshing];
}




-(void)reloadData{
    pageIndex = 0;
    if (cntType == CTTrick) {
        TrickCateModel *cateModel = cnt;
        //todo  进行首次加载数据操作
        TrickManager *manager =   [[TrickManager alloc]init];
        [manager   initTrickOfCate:[self checkOutCateKey:cateModel.cateName] reloadFromServer:YES complete:^(TrickCateModel *cm) {
            if (!cm) {
                [refreshHeader endRefreshing];
                return;
            }
            cnt = cm;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [refreshHeader endRefreshing];
            });
            
        }];
    }
    else if(cntType == CTRiddle) {
        RiddleCateModel *cateModel = cnt;
        RiddleManager *manager = [[RiddleManager alloc]init];
        [manager initRiddleOfCate:[self checkOutCateKey:cateModel.cateName] reloadFromServer:YES complete:^(RiddleCateModel *rcm) {
            if (!rcm) {
                [refreshHeader endRefreshing];
                return;
            }
            cnt =  rcm;
            [self.tableView reloadData];
            [refreshHeader endRefreshing];
        }];
    }
    else if(cntType == CTSaying) {
        SayingCateModel *cateModel = cnt;
        SayingManager *manager = [[SayingManager alloc]init];
        [manager initSayingOfCate:[self checkOutCateKey:cateModel.cateName] reloadFromServer:YES complete:^(SayingCateModel *scm) {
            if (!scm) {
                [refreshHeader endRefreshing];
                return;
            }
            cnt =  scm;
            [self.tableView reloadData];
            [refreshHeader endRefreshing];
        }];
    }
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
