//
//  ShengShiJiaH.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "ShengSJDataE.h"
#import "ShengSJNewBuiltE.h"

@interface ShengShiJiaH : BaseHandler

//物业的数据列表，包含 1：话题  2：房屋租售  3：咨询服务  4：管理报告 5:社区政务
-(void)requestForGetShengShiJiaData:(ShengSJDataE *)shengSJE success:(SuccessBlock)success failed:(FailedBlock)failed;

-(ShengSJDataE *)decodeShengSJDataJson:(NSDictionary *)dic;


//新建建议和意见
-(void)requestForSubmmitShengShiJiaData:(ShengSJNewBuiltE *)newBuiltE
                                success:(SuccessBlock)success
                                 failed:(FailedBlock)failed;
@end
