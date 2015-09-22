//
//  FaviorteViewController.m
//  QiQuJoke
//
//  Created by 陈辉 on 15/9/21.
//  Copyright © 2015年 少杰范. All rights reserved.
//

#import "FaviorteViewController.h"

@interface FaviorteViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_favoriteTable;
    NSMutableArray *_cateNameArray;
    NSMutableDictionary *_newDataDic;
}

@end

@implementation FaviorteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}

/**
 *  初始化控件
 */
- (void)initView{
    _favoriteTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _favoriteTable.dataSource = self;
    _favoriteTable.delegate = self;

    [self.view addSubview:_favoriteTable];
    
    self.navigationItem.title = NSLocalizedString(@"myFavorite", nil);
}

/**
 *  初始化数据
 */
-(void)initData{
    _newDataDic = [[NSMutableDictionary alloc] init];
    _cateNameArray =[[NSMutableArray alloc]init];
    NSArray *sqlArr = [[CoreDataManager instance] selectDataFromClassName:@"Favorite" predicate:nil sortkeys:nil];
    for (NSManagedObject *item in sqlArr) {
        NSString *typeStr = [item valueForKey:@"catetype"];
        if (![_newDataDic.allKeys containsObject:typeStr]) {
            [ _newDataDic setObject:[[NSMutableArray alloc]init] forKey:typeStr];
            [_cateNameArray addObject:typeStr];
        }
        
        ItemModel *itemModel = [[ItemModel alloc] init];
        [itemModel setContent:[item valueForKey:@"content"]];
        [itemModel setAnswer:[item valueForKey:@"answer"]];
        [_newDataDic[typeStr] addObject:itemModel];
    }
    [_favoriteTable reloadData];

}

/**
 *  显示组数
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _newDataDic.count;
}

/**
 *  列表组名
 */
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *indexStr =[_cateNameArray objectAtIndex:section];
    switch (indexStr.intValue) {
        case CTTrick:
            return NSLocalizedString(@"trick", nil);
            break;
        case CTRiddle:
            return NSLocalizedString(@"riddle", nil);
            break;
         
        case CTSaying:
            return NSLocalizedString(@"saying", nil);
            break;
            
        default:
            break;
    }
    return nil;
}

/**
 *  每组显示行数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     NSNumber *indexStr =[_cateNameArray objectAtIndex:section];
    NSArray *imArr = [_newDataDic objectForKey:indexStr];
    return imArr.count;
}

/**
 *  每行显示内容
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIDStr = @"queue";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDStr];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIDStr];
        cell.backgroundColor =[UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc]init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView.backgroundColor =[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.1];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    NSNumber *indexStr =[_cateNameArray objectAtIndex:indexPath.section];
    NSArray *imArr = [_newDataDic objectForKey:indexStr];
    ItemModel *itemModel = imArr[indexPath.row];
    cell.textLabel.text = itemModel.content;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *indexStr =[_cateNameArray objectAtIndex:indexPath.section];
    NSMutableArray *imArr = [_newDataDic objectForKey:indexStr];
    ItemModel *itemModel = imArr[indexPath.row];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:itemModel.content message:itemModel.answer delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alertView show];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"cancelFavorite", nil);
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *indexStr =[_cateNameArray objectAtIndex:indexPath.section];
    NSMutableArray *imArr = [_newDataDic objectForKey:indexStr];
    ItemModel *itemModel = imArr[indexPath.row];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"content == %@ AND catetype == %@",itemModel.content,[NSString stringWithFormat:@"%@",indexStr]];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[CoreDataManager instance] deleteDataWithClassName:kFavNameKey predicate:predicate];
        [imArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
