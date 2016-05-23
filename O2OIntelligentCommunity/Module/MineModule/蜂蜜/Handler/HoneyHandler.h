//
//  HoneyHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/11/30.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "HoneyTradeInfoModel.h"

@interface HoneyHandler : BaseHandler

@property (nonatomic,strong)NSString *honeyPage;
@property (nonatomic,strong)NSString *honeyCount;
@property (nonatomic,strong)NSMutableArray *honeyArr;
@property (nonatomic, strong) NSMutableArray *recvArr;



//查询会员相关的积分交易信息
-(void)queryHoneyTradeInfo:(HoneyTradeInfoModel *)honey
                   success:(SuccessBlock)success
                    failed:(FailedBlock)failed
                  isHeader:(BOOL)isheader;

//查询会员积分
-(void)queryVIPHoneyInfo:(HoneyTradeInfoModel *)honey
                 success:(SuccessBlock)success
                  failed:(FailedBlock)failed;

//积分兑换
-(void)exchangeHoney:(HoneyTradeInfoModel *)honey
             success:(SuccessBlock)success
              failed:(FailedBlock)failed;



-(void)honeyResetData;

//多少蜂蜜对应1元
- (void)beeToOneYuan:(HoneyTradeInfoModel *)honey success:(SuccessBlock)success failed:(FailedBlock)failed;



@end
