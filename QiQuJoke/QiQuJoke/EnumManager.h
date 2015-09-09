//
//  EnumManager.h
//  QiQuJoke
//
//  Created by 少杰范 on 15/9/1.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#ifndef QiQuJoke_EnumManager_h
#define QiQuJoke_EnumManager_h

typedef enum{
    CTTrick,
    CTRiddle,
    CTSaying
}ContentType;


typedef enum{
    QQReachabilityStatusUnknown          = -1,
    QQReachabilityStatusNotReachable     = 0,
    QQReachabilityStatusReachableViaWWAN = 1,
    QQReachabilityStatusReachableViaWiFi = 2,
    
}NetState;

typedef enum{
    NENoNet,
    NENetDataErr,
    NELocalDateErr,
    NEOK
    
}RequestState;

typedef enum{
    RMInit,
    RMReload,
    RMLoadMore
    
}RequestMode;

#endif
