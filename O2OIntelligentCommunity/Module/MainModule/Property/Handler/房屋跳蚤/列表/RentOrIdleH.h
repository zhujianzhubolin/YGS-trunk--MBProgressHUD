//
//  LieBiaoHandel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "RentOrIdleM.h"

@interface RentOrIdleH : BaseHandler
@property (nonatomic, copy) NSString *idleSellPNumber;
@property (nonatomic, copy) NSString *idleSellPCount;
@property (nonatomic, strong) NSMutableArray *idleSellArr;
@property (nonatomic, assign) BOOL isIdleSellNeedUpdate;

@property (nonatomic, copy) NSString *idleBuyPNumber;
@property (nonatomic, copy) NSString *idleBuyPCount;
@property (nonatomic, strong) NSMutableArray *idleBuyArr;
@property (nonatomic, assign) BOOL isIdleBuyNeedUpdate;

@property (nonatomic, copy) NSString *rentBuyHousePNumber;
@property (nonatomic, copy) NSString *rentBuyHousePCount;
@property (nonatomic, strong) NSMutableArray *rentBuyHouseArr;
@property (nonatomic, assign) BOOL isRentBuyHouseNeedUpdate;

@property (nonatomic, copy) NSString *rentRentHousePNumber;
@property (nonatomic, copy) NSString *rentRentHousePCount;
@property (nonatomic, strong) NSMutableArray *rentRentHouseArr;
@property (nonatomic, assign) BOOL isRentRentHouseNeedUpdate;

@property (nonatomic, copy) NSString *rentWantedRentPNumber;
@property (nonatomic, copy) NSString *rentWantedRentPCount;
@property (nonatomic, strong) NSMutableArray *rentWantedRentArr;
@property (nonatomic, assign) BOOL isRentWantedRentNeedUpdate;

//跳蚤市场出售
- (void)excuteRequestIdelForSell:(RentOrIdleM *)model
                         success:(SuccessBlock)success
                          failed:(FailedBlock)failed
                        isHeader:(BOOL)isheader;

//跳蚤市场求购
- (void)excuteRequestIdelForWantedBuy:(RentOrIdleM *)model
                              success:(SuccessBlock)success
                               failed:(FailedBlock)failed
                             isHeader:(BOOL)isheader;

//房屋租售－买房
- (void)excuteRequestRentBuyHouseForModel:(RentOrIdleM *)model
                                  success:(SuccessBlock)success
                                   failed:(FailedBlock)failed
                                 isHeader:(BOOL)isheader;

//房屋租售－租房
- (void)excuteRequestRentRentHouseForModel:(RentOrIdleM *)model
                                   success:(SuccessBlock)success
                                    failed:(FailedBlock)failed
                                  isHeader:(BOOL)isheader;

//房屋租售－求租
- (void)excuteRequestRentWantedRentForModel:(RentOrIdleM *)model
                                    success:(SuccessBlock)success
                                     failed:(FailedBlock)failed
                                   isHeader:(BOOL)isheader;
@end
