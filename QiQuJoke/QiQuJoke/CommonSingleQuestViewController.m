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
    UIImageView *_favIv;
    BOOL _isFav;
    UIButton *_preBtn;
    UIButton *_nextBtn;
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
    self.cntLbl = [[UILabel alloc]initWithFrame:CGRectMake(30, (CGRectGetHeight(self.view.frame)-kScreenNavTop - kTabBarDefaultHeight)/3, CGRectGetWidth(self.view.frame) - 60, 100)];
    self.cntLbl.textAlignment = NSTextAlignmentCenter;
    self.cntLbl.numberOfLines = 0;
    [self.view addSubview:self.cntLbl];
    ItemModel *im = self.cm.itemsArr[self.iindex];
    self.cntLbl.text = im.content;
    
    //分享
    self.shareItemBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(btnShareClicked)];
    self.navigationItem.rightBarButtonItem = self.shareItemBtn;
    
    _favIv = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)*2/3, 0, CGRectGetWidth(self.view.frame)/6, CGRectGetWidth(self.view.frame)/6*3/2)];
    _favIv.contentMode = UIViewContentModeScaleToFill;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favIvClicked)];
    _favIv.userInteractionEnabled = YES;
    [_favIv addGestureRecognizer:tapGes];
    [self.view addSubview:_favIv];
    
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
    
    _preBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _preBtn.frame = CGRectMake(0,(self.view.frame.size.height - kScreenNavTop - kTabBarDefaultHeight) /2, 26, 26*2);
    [_preBtn addTarget:self action:@selector(preBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_preBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [self.view addSubview:_preBtn];
    
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _nextBtn.frame = CGRectMake(self.view.frame.size.width - 26,(self.view.frame.size.height - kScreenNavTop - kTabBarDefaultHeight) /2, 26, 26*2);
    [_nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [self.view addSubview:_nextBtn];
}

-(void)preBtnClicked{
    _iindex--;
    [self resetContent];
    [self autoBtnState];
}

-(void)resetContent{
    ItemModel *im =  _cm.itemsArr[_iindex];
    self.cntLbl.text = im.content;
    if (self.lblAnswer) {
        self.lblAnswer.text = im.answer;
       [self.scratchView reset:self.ballIv];
    }
    [self toJudgeFav];
    
}


-(void)autoBtnState{
    if (self.iindex == 0) {
        _preBtn.alpha = 0;
    }
    else if(_cm && _cm.itemsArr && self.iindex == _cm.itemsArr.count -1)
    {
        _nextBtn.alpha = 0;
        NSInteger needLoadIndex = _cm.itemsArr.count/kPageDefaultCount;
        //显示等待动画以及请求更多数据
        if (_cm.type == CTTrick) {
            [[TrickManager instance]requestTrickOfCate:_cm.cateName reloadFormServer:YES pageIndex:needLoadIndex complete:^(RequestState errState) {
                if (errState == NENoNet) {
                    [UIManager showToastIn:self.view info:NSLocalizedString(@"noNet", nil)];
                    return ;
                }
                else if(errState == NELocalDateErr || errState == NENetDataErr){
                   //此种情况暂不处理
                }
                else if (errState == NEOK){
                    _nextBtn.alpha = 1;
                }
            }];
        }
        else if (_cm.type == CTRiddle){
            [[RiddleManager instance]requestRiddleOfCate:_cm.cateName reloadFromServer:YES pageIndex:needLoadIndex complete:^(RequestState errState) {
                if (errState == NENoNet) {
                    [UIManager showToastIn:self.view info:NSLocalizedString(@"noNet", nil)];
                    return ;
                }
                else if(errState == NELocalDateErr || errState == NENetDataErr){
                    //此种情况暂不处理
                }
                else if (errState == NEOK){
                    _nextBtn.alpha = 1;
                }
           
            }];
        }
        else{
            [[SayingManager instance]requestSayingOfCate:_cm.cateName reloadFromServer:YES pageIndex:needLoadIndex complete:^(RequestState errState) {
                if (errState == NENoNet) {
                    [UIManager showToastIn:self.view info:NSLocalizedString(@"noNet", nil)];
                    return ;
                }
                else if(errState == NELocalDateErr || errState == NENetDataErr){
                    //此种情况暂不处理
                }
                else if (errState == NEOK){
                    _nextBtn.alpha = 1;
                }
            }];
        }
    }
    else
    {
        _nextBtn.alpha = 1;
        _preBtn.alpha = 1;
    }
}

-(void)nextBtnClicked{
    _iindex++;
    [self resetContent];
    [self autoBtnState];
}

-(void)initData{
    [self toJudgeFav];
    [self autoBtnState];
}

-(void)favIvClicked{
    ItemModel *im = _cm.itemsArr[self.iindex];
    if (_isFav) {
        //取消收藏操作
        [[CoreDataManager instance]deleteDataWithClassName:kFavNameKey predicate:[NSPredicate predicateWithFormat:@"catetype == %d and content==%@",_cm.type,im.content]];
        _isFav = NO;
        _favIv.image = [UIImage imageNamed:@"unfav"];
        [UIManager showToastIn:self.view info:NSLocalizedString(@"isNotFaved", nil)];
    }else{
        //增加收藏操作
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:im.content forKey:kContentKey];
        [dic setValue:im.answer forKey:kAnswerKey];
        [dic setValue:[NSNumber numberWithInteger:_cm.type] forKey:kCateTypeKey];
        [[CoreDataManager instance]insertDataWithClassName:kFavNameKey attriDic:dic];
        _isFav = YES;
        _favIv.image = [UIImage imageNamed:@"fav"];
        [UIManager showToastIn:self.view info:NSLocalizedString(@"isFaved", nil)];
    }
}

-(void)toJudgeFav{
    ItemModel *im = _cm.itemsArr[self.iindex];
    NSArray *imArr = [[CoreDataManager instance]selectDataFromClassName:kFavNameKey predicate:[NSPredicate predicateWithFormat:@"catetype == %d AND content == %@" ,_cm.type, im.content] sortkeys:nil];
    
    if (imArr && imArr.count > 0) {
        //已被收藏
        _isFav = YES;
        _favIv.image = [UIImage imageNamed:@"fav"];
    }
    else{
        _isFav = NO;
        _favIv.image = [UIImage imageNamed:@"unfav"];
    }
    
}

#pragma mark 分享代码

-(void)btnShareClicked{
    LXActivity  *sheetView = [[LXActivity alloc]initWithTitle:NSLocalizedString(@"shareToWhere", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) ShareButtonTitles:@[NSLocalizedString(@"wechat", nil),NSLocalizedString(@"wechatFriends", nil),NSLocalizedString(@"QQ", nil)] withShareButtonImagesName:@[@"sns_icon_wechat",@"sns_icon_friends",@"sns_icon_qq" ]];
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
                 [UIManager showToastIn:self.view info:NSLocalizedString(@"shareSuccess", nil)];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [UIManager showToastIn:self.view title:NSLocalizedString(@"shareFailed", nil) content:[NSString stringWithFormat:@"%@", [error.userInfo valueForKey:@"error_message"]]];
                 //[UIManager showAlert:[NSString stringWithFormat:@"%@", [error.userInfo valueForKey:@"error_message"]]  title:NSLocalizedString(@"shareFailed", nil)];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                // [UIManager showAlert:nil title:NSLocalizedString(@"shareCancel", nil)];
                 [UIManager showToastIn:self.view info:NSLocalizedString(@"shareCancel", nil)];
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




@end
