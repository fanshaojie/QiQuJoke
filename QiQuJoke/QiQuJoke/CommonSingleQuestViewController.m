//
//  CommonSingleQuestViewController.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/1.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "CommonSingleQuestViewController.h"

@interface CommonSingleQuestViewController(){
    UIImageView *_bgIv;
}

@property (nonatomic,strong) UILabel *cntLbl;
@property (nonatomic,strong) UIButton *btnPrevious;
@property (nonatomic,strong) UIButton *btnNext;
@property (nonatomic,strong) UIBarButtonItem *shareItemBtn;
@property (nonatomic,strong) STScratchView *scratchView;
@property (nonatomic,strong) UIImageView *ballIv;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false];
    [self changBgImage];
}

-(void)changBgImage{
    NSString *imgName = [[NSUserDefaults standardUserDefaults]valueForKey:kUDDtailSkinKey];
    if (imgName) {
        _bgIv.image = [UIImage imageNamed:imgName];
    }
}

-(void)initView{
    self.title = NSLocalizedString(@"canYouGuess", nil);
    self.view.backgroundColor = [UIColor  whiteColor];
    
    _bgIv = [[UIImageView alloc]init];
    _bgIv.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - kScreenNavTop - kTabBarDefaultHeight);
    [self changBgImage];
    _bgIv.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:_bgIv];
    //内容
    self.cntLbl = [[UILabel alloc]initWithFrame:CGRectMake(25, (CGRectGetHeight(self.view.frame)-kScreenNavTop - kTabBarDefaultHeight)/3, CGRectGetWidth(self.view.frame) - 50, 100)];
    self.cntLbl.textAlignment = NSTextAlignmentCenter;
    self.cntLbl.numberOfLines = 0;
    [self.view addSubview:self.cntLbl];
    ItemModel *im = self.cm.itemsArr[self.iindex];
    self.cntLbl.text = im.content;
    
    //分享
    self.shareItemBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(btnShareClicked)];
    self.navigationItem.rightBarButtonItem = self.shareItemBtn;
    
    
    if ( self.cm.type != CTSaying) {
        CGFloat scratchX = 30;
        CGFloat scratchY = CGRectGetMaxY(self.cntLbl.frame)+ 20;
        CGFloat scratchWidth = self.view.frame.size.width-scratchX * 2;
        CGFloat scratchHeight = 80;
        
        self.scratchView = [[STScratchView alloc] initWithFrame:CGRectMake(scratchX, scratchY, scratchWidth, scratchHeight)];
        [self.scratchView setSizeBrush:30.0];
        
        self.ballIv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scratch"]];
        [self.ballIv setFrame:CGRectMake(0, 0, scratchWidth, scratchHeight)];
        [self.scratchView setHideView:self.ballIv];
        
        self.lblAnswer = [[UILabel alloc] initWithFrame:CGRectMake(scratchX, scratchY, scratchWidth, scratchHeight)];
        self.lblAnswer.textAlignment = NSTextAlignmentCenter;
        self.lblAnswer.numberOfLines = 0;
        self.lblAnswer.text = im.answer;
        
        self.lblTip = [[UILabel alloc] initWithFrame:CGRectMake(scratchX, scratchY, scratchWidth, scratchHeight)];
        self.lblTip.textAlignment = NSTextAlignmentCenter;
        self.lblTip.textColor = [UIColor whiteColor];
        self.lblTip.text = NSLocalizedString(@"toSeeAnswer", nil);
        
        [self.view addSubview:self.lblAnswer];
        [self.view addSubview:self.scratchView];
        [self.view addSubview:self.lblTip];
        
        [UIView animateWithDuration:5.0 animations:^{
            [self.lblTip setAlpha:0];
        }];
    }
}

#pragma mark 分享代码

-(void)btnShareClicked{
    LXActivity  *sheetView = [[LXActivity alloc]initWithTitle:NSLocalizedString(@"shareToWhere", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) ShareButtonTitles:@[NSLocalizedString(@"wechat", nil),NSLocalizedString(@"wechatFriends", nil),NSLocalizedString(@"QQ", nil),NSLocalizedString(@"QQZone", nil)] withShareButtonImagesName:@[@"sns_icon_wechat",@"sns_icon_friends",@"sns_icon_qq",@"sns_icon_zone" ]];
    [sheetView showInView:self.view];
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
    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@\r\n%@",self.cntLbl.text,NSLocalizedString(@"shareTitle", nil)]
                                     images:nil
                                        url:nil
                                      title:self.tabBarItem.title
                                       type:SSDKContentTypeAuto];
    
    
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
        
    }
}

-(void)initData{
    
}


@end
