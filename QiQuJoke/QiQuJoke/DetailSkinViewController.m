//
//  DetailSkinViewController.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/15.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "DetailSkinViewController.h"

@interface DetailSkinViewController (){
    NSArray *_skinArr ;
    int  _defautSelectIndex;
}

@end
static NSString *dsvcId = @"dsvcid";
@implementation DetailSkinViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    self.title = NSLocalizedString(@"detailSkin", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[SkinViewCell class] forCellWithReuseIdentifier:dsvcId];
    _skinArr = @[@"dbg7",@"dbg1",@"dbg2",@"dbg3",@"dbg4",@"dbg5",@"dbg6"];
    NSString *imgName = [[NSUserDefaults standardUserDefaults]valueForKey:kUDDtailSkinKey];
    for (int i = 0; i<_skinArr.count; i++) {
        if ([imgName isEqualToString:_skinArr[i]]) {
            _defautSelectIndex = i;
            break;
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SkinViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:dsvcId forIndexPath:indexPath];
    cell.imgName = [_skinArr objectAtIndex:indexPath.row];
    if (indexPath.row == _defautSelectIndex) {
        cell.isSelected = YES;
    }
    else{
        cell.isSelected = NO;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _defautSelectIndex) {
        return;
    }
    _defautSelectIndex = (int)indexPath.row;
    NSString *selectedImgName = [_skinArr objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setValue:selectedImgName forKey:kUDDtailSkinKey];
    
    [self.collectionView reloadData];
    
    NSNotification *notice = [NSNotification notificationWithName:kDetailSkinChangedNotice object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notice];

    
     
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _skinArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(UICollectionViewLayout *)collectionViewLayout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return flowLayout;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (CGRectGetWidth(self.collectionView.frame) - 20)/2;
    return CGSizeMake(width,width*3/2);
}
@end
