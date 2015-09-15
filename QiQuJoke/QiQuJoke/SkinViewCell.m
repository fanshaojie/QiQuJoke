//
//  SkinViewCell.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/14.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "SkinViewCell.h"


@interface SkinViewCell (){
    UIImageView *_skinIv;
    UIImageView *_selectIv;
}

@end

@implementation SkinViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self ) {
        [self initView];
    }
    return self;
}

-(void)initView{
    _skinIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _skinIv.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_skinIv];
    
    _selectIv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightIcon"]];
    _selectIv.frame = CGRectMake(self.frame.size.width - 48, self.frame.size.height - 48, 48, 48);
    _skinIv.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_selectIv];
}

-(void)setImgName:(NSString *)imgName{
    _imgName = imgName;
    _skinIv.image = [UIImage imageNamed:imgName];
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        _selectIv.alpha = 1.0;
    }
    else{
        _selectIv.alpha = 0.0;
    }
}


@end
