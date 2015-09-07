//
//  CommonSingleQuestViewController.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/1.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "CommonSingleQuestViewController.h"

@interface CommonSingleQuestViewController(){
    UILabel *cntLbl;
    UIButton *answerBtn;
}

@end

@implementation CommonSingleQuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    // Do any additional setup after loading the view.
}

-(void)initView{
    [self.navigationController setNavigationBarHidden:false];
    self.title = NSLocalizedString(@"canYouGuess", nil);
    self.view.backgroundColor =[UIColor whiteColor];
    cntLbl = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetHeight(self.view.frame)/3, CGRectGetWidth(self.view.frame) - 50, 100)];
    cntLbl.textAlignment = NSTextAlignmentCenter;
    cntLbl.numberOfLines = 0;
    [self.view addSubview:cntLbl];
    
    answerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    answerBtn.frame = CGRectMake((CGRectGetWidth(self.view.frame)-kBtnNormalWidth)/2, CGRectGetMaxY(cntLbl.frame)+30, kBtnNormalWidth, kBtnDefaultHeight);
    answerBtn.layer.cornerRadius = 2;
    [answerBtn addTarget:self action:@selector(btnAnswerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [answerBtn setBackgroundColor:[UIColor redColor]];
    [answerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [answerBtn setTitle:NSLocalizedString(@"openResult", nil) forState:UIControlStateNormal];
    [self.view addSubview:answerBtn];
    
    if (_cntType == CTTrick) {
        TrickModel *trickModel = _cnt;
        cntLbl.text =trickModel.content;
    }
    else if (_cntType == CTRiddle) {
        RiddleModel *riddleModel = _cnt;
        cntLbl.text = riddleModel.content;
    }
    else if (_cntType == CTSaying) {
        SayingModel *sayingModel = _cnt;
        cntLbl.text = sayingModel.content;
        answerBtn.hidden = YES;
    }
    
}

-(void)btnAnswerClicked:(id)sender{
    if (_cntType == CTTrick) {
        TrickModel *trickModel = _cnt;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"rightAnswer", nil)message:trickModel.answer delegate:nil cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (_cntType == CTRiddle) {
        RiddleModel *riddleModel =_cnt;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"rightAnswer", nil)message:riddleModel.answer delegate:nil cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (_cntType == CTSaying) {
        
    }
    
    
}

-(void)initData{
    
}

@end
