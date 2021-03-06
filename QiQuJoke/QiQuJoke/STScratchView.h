//
//  STScratchView.h
//  STScratchView
//
//  Created by Sebastien Thiebaud on 12/17/12.
//  Copyright (c) 2012 Sebastien Thiebaud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STScratchView : UIView

@property (nonatomic, assign) float sizeBrush;
@property (nonatomic, strong) UIView *hideView;

- (void)setHideView:(UIView *)hideView;
- (void)setAutomaticScratchCurve:(UIBezierPath *)curvePath duration:(float)duration;
-(void)reset:(UIView*)hideView;

@end
