//
//  SkinViewController.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/11.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "SkinViewController.h"

@interface SkinViewController (){
    NSArray  *_skinNamesArr;
    int  _defaultSelectedIndex;
    UICollectionView *_myCollectionView;
}

@end

@implementation SkinViewController
static NSString *cellID = @"skinCell";
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    self.title = NSLocalizedString(@"listSkin", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    _skinNamesArr = @[@"zg1",@"zg2",@"zg3",@"zg4",@"zg6",@"zg7"];
    NSString *imgName = [[NSUserDefaults standardUserDefaults]objectForKey:kUDSkinKey];
    for (int i = 0; i<_skinNamesArr.count; i++) {
        if ([imgName isEqualToString:_skinNamesArr[i]]) {
            _defaultSelectedIndex = i ;
            break;
            
        }
        
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    _myCollectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGRectGetHeight(self.view.frame) - kTabBarDefaultHeight) collectionViewLayout:flowLayout];
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    [self.view addSubview:_myCollectionView];
    
    [_myCollectionView registerClass:[SkinViewCell class] forCellWithReuseIdentifier:cellID];
    _myCollectionView.scrollEnabled = YES;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SkinViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.imgName = [_skinNamesArr objectAtIndex:indexPath.row];
    if (_defaultSelectedIndex == indexPath.row  ) {
        cell.isSelected = YES;
    }
    else{
        cell.isSelected = NO;
    }
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _defaultSelectedIndex) {
        return;
    }
    _defaultSelectedIndex = (int)indexPath.row;
    [[NSUserDefaults standardUserDefaults]setValue:[_skinNamesArr objectAtIndex:indexPath.row] forKey:kUDSkinKey];
    [collectionView reloadData];
    
    NSNotification *notice = [NSNotification notificationWithName:kSkinChangedNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (CGRectGetWidth(_myCollectionView.frame) - 20)/2;
    return CGSizeMake(width,width*3/2);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5,5,5,5);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _skinNamesArr.count;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

@end
