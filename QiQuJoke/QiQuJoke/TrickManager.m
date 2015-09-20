//
//  TrickManager.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/8/31.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "TrickManager.h"


@implementation TrickManager

+(TrickManager *)instance{
    static dispatch_once_t onceT;
    static TrickManager *_trickManager;
    dispatch_once(&onceT, ^{
        _trickManager = [[TrickManager alloc]init];
    });
    return _trickManager;
}


/**
 *  脑筋急转弯默认加载项－全部  以及获取了分类
 *
 *  @param complete 获取数据完成回调函数
 */
-(void)initTricksOfCateAllWithComplete:(void (^)(RequestState errState))complete{
    NetState netState = [NetHelper Instance].netState;
    NSString *urlStr = [NSString stringWithFormat:kCommonUrl,kTrickQuery,kTrickAppId,kTrickAppId,kPageDefaultCount,@"",(long)0];
    
    //对数据进行本地化处理
    //**************************************
    NSString *filePath = [self filePathFromUrl:urlStr];
    
    BOOL isExists = [self isFileExists:filePath];
    if (isExists) {
        NSData *backData = [NSData  dataWithContentsOfFile:filePath];
        BOOL isOK = [self afterGetAllSuccessWithData:backData];
        if (isOK && complete) {
            complete(NEOK);
        }
        else if (complete)
        {
            complete(NELocalDateErr);
        }
    }
    else  if (netState == QQReachabilityStatusUnknown || netState == QQReachabilityStatusNotReachable) {
        if (complete) {
            complete(NENoNet);
        }
    }
    else{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^void(AFHTTPRequestOperation * optation, id responseObject) {
            NSData *backData = optation.responseData;
            BOOL isOK = [self afterGetAllSuccessWithData:backData];
            if (isOK && complete) {
                [backData writeToFile:filePath atomically:YES];
                complete(NEOK);
            }
            else if (complete) {
                complete(NENetDataErr);
            }
            
        } failure:^void(AFHTTPRequestOperation *requestOperation, NSError *error) {
            if (complete) {
                complete(NENetDataErr);
            }
        }];
    }
    
    //*************************************
}

/**
 *  获取脑筋急转弯指定分类指定页面下的数据(此方法不做缓存处理)
 *
 *  @param cate      分类
 *  @param needReload 只针对第一页,其他无效
 *  @param pIndex    页码
 *  @param _complete 获取数据回调函数
 */
-(void)requestTrickOfCate:(NSString *)cate reloadFormServer:(BOOL)needReload pageIndex:(NSInteger)pIndex complete:(void (^)( RequestState))_complete{
    NSString *urlStr = [NSString stringWithFormat:kCommonUrl,kTrickQuery,kTrickAppId,kTrickAppId,kPageDefaultCount,[self checkOutCateKey:cate] ,pIndex*kPageDefaultCount];
     NSString *filePath = [self filePathFromUrl:urlStr];
    NetState netState = [NetHelper Instance].netState;
    if(pIndex == 0 && (!needReload))
    {
        //此种情况，先去检查本地缓存
        BOOL isExists = [self  isFileExists:filePath];
        if (isExists) {
            NSData *backData = [NSData  dataWithContentsOfFile:filePath];
            BOOL isOK = [self afterGetTricksAtCateWithData:backData cateName:cate pIndex:pIndex ];
            if (isOK && _complete) {
                _complete(NEOK);
            }
            else if (_complete)
            {
                _complete(NELocalDateErr);
            }
        }
        else{
            //本地文件不存在则进行网络请求
            goto netrequeststep;
        }
        
    }
    else{
    netrequeststep:
        if (netState == QQReachabilityStatusUnknown || netState == QQReachabilityStatusNotReachable) {
            if (_complete) {
                _complete(NENoNet);
            }
        }else{
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^void(AFHTTPRequestOperation * optation, id responseObject) {
                NSData *backData = optation.responseData;
                BOOL isOK = [self afterGetTricksAtCateWithData:backData cateName:cate pIndex:pIndex];
                if (isOK && _complete) {
                    if (pIndex == 0) {
                        //首页需要缓存
                        [backData writeToFile:filePath atomically:YES];
                    }
                    _complete(NEOK);
                }
                else if (_complete) {
                    _complete(NENetDataErr);
                }
                
            } failure:^void(AFHTTPRequestOperation *requestOperation, NSError *error) {
                if (_complete) {
                    _complete(NENetDataErr);
                }
            }];
        }
    }
}

/**
 *  解析脑筋急转弯指定分类下数据
 *
 *  @param data      缓存或者服务器数据
 *  @param _cateName 分类名称
 *
 *  @return 数据所对应对象实体
 */
-(BOOL)afterGetTricksAtCateWithData:(NSData*)data cateName:(NSString*)_cateName pIndex:(NSInteger)pi{
    NSError *error = nil;
    NSDictionary *backDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        return NO;
    }
    NSArray *rootResultNodeArr =[backDic objectForKey:@"data"];
    NSDictionary *resultNodeDic = rootResultNodeArr.firstObject;
    NSString *listNumStr = [resultNodeDic objectForKey:@"listNum"];
    NSArray *dispDataNodeArr = [resultNodeDic objectForKey:@"disp_data"];
    
    CateModel *tcm = nil;
    for (CateModel *tmp in _cateArr) {
        if (tmp.cateName == _cateName) {
            tcm = tmp;
            tcm.nums = listNumStr.integerValue;
            break;
        }
    }
    
    if (pi == 0 && tcm.itemsArr) {
        //此种情况为下拉刷新时，需要删除所有缓存数据
        [tcm.itemsArr removeAllObjects];
    }

    for (NSDictionary *tmpDic in dispDataNodeArr) {
        NSString *content = [tmpDic objectForKey:@"content"];
        NSString *answer = [tmpDic objectForKey:@"answer"];
        ItemModel *tm = [[ItemModel alloc]init];
        tm.content = content;
        tm.answer = answer;
        if (!tcm.itemsArr) {
            tcm.itemsArr = [[NSMutableArray alloc]init];
        }
        [tcm.itemsArr addObject:tm];
    }
    return YES;
}

/**
 *  解析脑筋急转弯－全部分类下数据以及所有分类
 *
 *  @param data 缓存数据或服务器数据
 *
 *  @return trickcatemodel集合
 */
-(BOOL)afterGetAllSuccessWithData:(NSData*)data{
    NSError *error = nil;
    NSDictionary *backDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        return NO;
    }
    NSArray *rootResultNodeArr =[backDic objectForKey:@"data"];
    if (!rootResultNodeArr) {
        return NO;
    }
    NSDictionary *resultNodeDic = rootResultNodeArr.firstObject;
    NSString *listNumStr = [resultNodeDic objectForKey:@"listNum"];
    NSArray *dispDataNodeArr = [resultNodeDic objectForKey:@"disp_data"];
    
    NSArray *displayTagsNodeArr = [resultNodeDic objectForKey:@"display_tags"];
    NSDictionary *displayTagsNodeDic = displayTagsNodeArr.firstObject;
    NSArray *cateNodeArr = [displayTagsNodeDic objectForKey:@"tag_values"];
    
    CateModel *cateOfAll = [[CateModel alloc]init];
    cateOfAll.cateName = NSLocalizedString(@"all", nil);
    cateOfAll.nums = listNumStr.integerValue;
    cateOfAll.type = CTTrick;
    if (!_cateArr) {
        _cateArr = [[NSMutableArray alloc]init];
    }
    [_cateArr addObject:cateOfAll];
    
    for (NSString *tmpStr in cateNodeArr) {
        CateModel *tcm = [[CateModel alloc]init];
        tcm.cateName  = tmpStr;
        tcm.type = CTTrick;
        [_cateArr addObject:tcm];
    }
    
    for (NSDictionary *tmpDic in dispDataNodeArr) {
        NSString *content = [tmpDic objectForKey:@"content"];
        NSString *answer = [tmpDic objectForKey:@"answer"];
        ItemModel *tm = [[ItemModel alloc]init];
        tm.content = content;
        tm.answer = answer;
        if (!cateOfAll.itemsArr) {
            cateOfAll.itemsArr = [[NSMutableArray alloc]init];
        }
        [cateOfAll.itemsArr addObject:tm];
    }
    return YES;
}


/**
 *  获取url所对应的本地缓存路径
 *
 *  @param url 请求url
 *
 *  @return 本地路径
 */
-(NSString*)filePathFromUrl:(NSString*)url{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return  [path stringByAppendingPathComponent:url.md5];
}

/**
 *  获取搜索关键字
 *
 *  @param cateName 分类名称
 *
 *  @return 搜索关键字
 */
-(NSString*)checkOutCateKey:(NSString*)cateName{
    if ([cateName isEqualToString:NSLocalizedString(@"all", nil)]) {
        return @"";
    }
    return cateName;
}

/**
 *  判断文件文件是否存在
 *
 *  @param filePath 本地文件路径
 *
 *  @return 返回文件是否存在
 */
-(BOOL)isFileExists:(NSString*)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists  =   [fileManager fileExistsAtPath:filePath];
    if (isExists) {
        return YES;
    }
    return NO;
}



@end
