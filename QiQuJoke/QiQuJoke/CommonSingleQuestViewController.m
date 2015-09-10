//
//  CommonSingleQuestViewController.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/1.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "CommonSingleQuestViewController.h"

@interface CommonSingleQuestViewController()

@property (nonatomic,strong) UILabel *cntLbl;
@property (nonatomic,strong) UIButton *btnPrevious;
@property (nonatomic,strong) UIButton *btnNext;
@property (nonatomic,strong) UIBarButtonItem *shareItem;
@property (nonatomic,strong) STScratchView *scratchView;
@property (nonatomic,strong) UIImageView *ball;
@property (nonatomic,strong) UILabel *lblAnswer;
@property (nonatomic,strong) UILabel *lblTip;

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
    //内容
    self.cntLbl = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetHeight(self.view.frame)/3, CGRectGetWidth(self.view.frame) - 50, 100)];
    self.cntLbl.textAlignment = NSTextAlignmentCenter;
    self.cntLbl.numberOfLines = 0;
    [self.view addSubview:self.cntLbl];
    
    //分享
    self.shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(btnShareClicked)];
    self.navigationItem.rightBarButtonItem = self.shareItem;
    
    if (_cntType == CTTrick) {
        TrickModel *trickModel = _cnt;
        self.cntLbl.text =trickModel.content;
    }
    else if (_cntType == CTRiddle) {
        RiddleModel *riddleModel = _cnt;
        self.cntLbl.text = riddleModel.content;
    }
    else if (_cntType == CTSaying) {
        SayingModel *sayingModel = _cnt;
        self.cntLbl.text = sayingModel.content;
    }
    
    CGFloat scratchX = 30;
    CGFloat scratchY = self.cntLbl.frame.origin.y+self.cntLbl.frame.size.height+20;
    CGFloat scratchWidth = self.view.frame.size.width-scratchX * 2;
    CGFloat scratchHeight = 80;
    
    self.scratchView = [[STScratchView alloc] initWithFrame:CGRectMake(scratchX, scratchY, scratchWidth, scratchHeight)];
    [self.scratchView setSizeBrush:20.0];
    
    self.ball = [[UIImageView alloc] init];
    [self.ball setFrame:CGRectMake(0, 0, scratchWidth, scratchHeight)];
    [self.ball setImage:[UIImage imageNamed:@"scratch"]];
    [self.scratchView setHideView:self.ball];
    
    self.lblAnswer = [[UILabel alloc] initWithFrame:CGRectMake(scratchX, scratchY, scratchWidth, scratchHeight)];
    self.lblAnswer.textAlignment = NSTextAlignmentCenter;
    TrickModel *trickModel = _cnt;
    [self.lblAnswer setText:trickModel.answer];
    
    self.lblTip = [[UILabel alloc] initWithFrame:CGRectMake(scratchX, scratchY, scratchWidth, scratchHeight)];
    self.lblTip.textAlignment = NSTextAlignmentCenter;
    self.lblTip.textColor = [UIColor whiteColor];
    self.lblTip.text = @"刮开我,揭晓答案";
    
    [self.view addSubview:self.lblAnswer];
    [self.view addSubview:self.scratchView];
    [self.view addSubview:self.lblTip];
    
    
    [UIView animateWithDuration:5.0 animations:^{
        [self.lblTip setAlpha:0];
    }];
    
}

-(void)btnShareClicked{
    LXActivity  *sheetView = [[LXActivity alloc]initWithTitle:NSLocalizedString(@"shareToWhere", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) ShareButtonTitles:@[NSLocalizedString(@"wechat", nil),NSLocalizedString(@"wechatFriends", nil),NSLocalizedString(@"QQ", nil),NSLocalizedString(@"QQZone", nil)] withShareButtonImagesName:@[@"sns_icon_wechat",@"sns_icon_friends",@"sns_icon_qq",@"sns_icon_zone" ]];
    [sheetView showInView:self.view];
}

-(void)btnAnswerClicked:(id)sender{
    if (_cntType == CTTrick) {
        TrickModel *trickModel = _cnt;
        [UIManager showAlert:trickModel.answer  title:NSLocalizedString(@"rightAnswer", nil)];
    }
    else if (_cntType == CTRiddle) {
        RiddleModel *riddleModel =_cnt;
        [UIManager showAlert:riddleModel.answer title:NSLocalizedString(@"rightAnswer", nil) ];
    }
    else if (_cntType == CTSaying) {
        
    }
}

-(void)shareToWechat{
    [self shareCommon:SSDKPlatformTypeWechat];
}

-(void)shareToWechatFriends{
    [self shareCommon:SSDKPlatformSubTypeWechatTimeline];
}

-(void)shareCommon:(SSDKPlatformType)platformType{
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.cntLbl.text
                                     images:@[[UIImage imageNamed:@"shareImg"]]
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:self.tabBarItem.title
                                       type:SSDKContentTypeImage];
    
    //进行分享
    [ShareSDK share:platformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [UIManager showAlert:nil title:NSLocalizedString(@"shareSuccess", nil)];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [UIManager showAlert:[NSString stringWithFormat:@"%@", [error.userInfo valueForKey:@"error_message"]]  title:NSLocalizedString(@"shareFailed", nil)];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 [UIManager showAlert:nil title:NSLocalizedString(@"shareCancel", nil)];
                 break;
             }
             default:
                 break;
         }
         
     }];
}

-(void)shareToQQ{
    [self shareCommon:SSDKPlatformTypeQQ];
}

-(void)shareToZone{
    [self shareCommon:SSDKPlatformSubTypeQZone];
}

-(void)didClickOnImageIndex:(NSInteger *)imageIndex{
    if ((NSInteger)imageIndex == 0) { //微信
        [self shareToWechat];
    }
    else if((NSInteger)imageIndex == 1){//微信朋友圈
        [self shareToWechatFriends];
        
    }
    else if((NSInteger)imageIndex == 2){//qq
        [self shareToQQ];
        
    }else if((NSInteger)imageIndex ==3){//qq空间
        [self shareToZone];
        
    }
}

-(void)initData{
    
}

@end
