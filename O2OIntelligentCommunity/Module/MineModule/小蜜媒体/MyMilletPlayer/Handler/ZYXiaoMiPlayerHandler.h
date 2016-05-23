//
//  ZYMilletPlayerHandler.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/22.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "ZYXiaoMiPlayerModel.h"

@interface ZYXiaoMiPlayerHandler : BaseHandler

@property (nonatomic,strong)NSString *milletPage;
@property (nonatomic,strong)NSString *millerCount;
@property (nonatomic,strong)NSMutableArray *millerArray;
@property (nonatomic, strong) NSMutableArray *recvArr;


//查询的媒体
-(void)queryMillerList:(ZYXiaoMiPlayerModel *)milletM
               success:(SuccessBlock)success
                failed:(FailedBlock)failed
              isHeader:(BOOL)isheader;

//查询我的媒体详情
-(void)queryMeiTiDetailed:(NSDictionary *)detailedM
                  success:(SuccessBlock)success
                   failed:(FailedBlock)failed;

-(void)milletResetData;
@end
