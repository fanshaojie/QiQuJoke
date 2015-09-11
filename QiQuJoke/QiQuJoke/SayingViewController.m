//
//  SayingViewController.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/8/28.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "SayingViewController.h"

@interface SayingViewController (){
    NSArray *cateArr;
    CAPSPageMenu *cateMenu;
    MONActivityIndicatorView *loadingView;
}

@end

@implementation SayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    NetState netState = [NetHelper Instance].netState;
    if ((!cateArr)&&(netState == QQReachabilityStatusReachableViaWiFi || netState == QQReachabilityStatusReachableViaWWAN)) {
        [self initData];
    }
}

-(void)initData{
    [loadingView startAnimating];
    SayingManager *manager = [[SayingManager alloc]init];
    [manager initSayingsOfCateAllWithComplete:^(NSArray *sayingCateArr,RequestState errState)  {
        [loadingView stopAnimating];
        if (errState == NENoNet) {
            [UIManager showNoNetToastIn:self.view];
            return;
        }
        
        cateArr = sayingCateArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (sayingCateArr == nil) {
                [UIManager showAlert:NSLocalizedString(@"netErr", nil)];
                return;
            }
            
            NSMutableArray *ctrlArr = [[NSMutableArray alloc]init];
            for (SayingCateModel *cate in cateArr) {
                CommonTableViewController *ctvCtrl = [[CommonTableViewController alloc]initWithContentType:CTSaying Content:cate];
                ctvCtrl.title = cate.cateName;
                ctvCtrl.delegate =self;
                [ctrlArr addObject:ctvCtrl];
            }
            
            NSDictionary *parameters = @{
                                         CAPSPageMenuOptionScrollMenuBackgroundColor:[UIColor clearColor],
                                         CAPSPageMenuOptionViewBackgroundColor: [UIColor clearColor],
                                         CAPSPageMenuOptionSelectedMenuItemLabelColor:[UIColor orangeColor],
                                         CAPSPageMenuOptionSelectionIndicatorColor: [UIColor orangeColor],
                                         CAPSPageMenuOptionUnselectedMenuItemLabelColor:[UIColor blackColor],
                                         CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0],
                                         CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:13.0],
                                         CAPSPageMenuOptionMenuHeight: @(40.0),
                                         CAPSPageMenuOptionMenuItemWidth: @(80.0),
                                         CAPSPageMenuOptionCenterMenuItems: @(YES)
                                         };
            
            cateMenu = [[CAPSPageMenu alloc]initWithViewControllers:ctrlArr frame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-kScreenTop - kTabBarDefaultHeight) options:parameters];
            [self.view addSubview:cateMenu.view];
        });
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)cellSelectedAtModel:(id)model{
    SayingModel *tm = model;
    CommonSingleQuestViewController *singleCtrl = [[CommonSingleQuestViewController alloc]init];
    singleCtrl.cntType = CTSaying;
    singleCtrl.cnt = tm;
    [self.navigationController pushViewController:singleCtrl animated:true];
}

-(void)initView{
    self.navigationItem.title = NSLocalizedString(@"saying", nil);
    
    UIImageView *bgIv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"listBg"]];
    bgIv.frame = self.view.frame;
    bgIv.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:bgIv];
    
    loadingView = [[MONActivityIndicatorView alloc]init];
    loadingView.delegate = self;
    loadingView.numberOfCircles =5;
    loadingView.radius = 10;
    loadingView.internalSpacing = 3;
    loadingView.center = self.view.center;
    [self.view addSubview:loadingView];
    [loadingView startAnimating];
    [self placeAtTheCenterWithView:loadingView];
    
    
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)placeAtTheCenterWithView:(UIView *)view {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0f]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
