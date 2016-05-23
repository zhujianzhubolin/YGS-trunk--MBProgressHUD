//
//  CityList.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "CityListModel.h"

@interface CityList : BaseHandler

//获取城市列表
-(void)postCity:(CityListModel *)cityM success:(SuccessBlock)success failed:(FailedBlock)failed;
+ (NSMutableDictionary *)decodeGetAllCity:(NSArray *)list;
+ (NSMutableArray *)hotgetAllCity:(NSArray *)list;
@end
