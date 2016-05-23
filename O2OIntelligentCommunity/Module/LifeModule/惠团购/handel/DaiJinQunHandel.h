//
//  DaiJinQunHandel.h
//  O2OIntelligentCommunity
//
//  Created by app on 16/3/1.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "DaiJinQuanModel.h"
@interface DaiJinQunHandel : BaseHandler
@property (nonatomic, copy) NSString *voucherPNumber;
@property (nonatomic, copy) NSString *voucherPCount;
@property (nonatomic, strong) NSMutableArray *voucherArr;

//根据商家ID及用户ID查询商家可使用券情况
- (void)getStoreQuan:(DaiJinQuanModel*)model success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader;

//下单时候查询商家券的情况
- (void)getStoreAvailbleQuan:(DaiJinQuanModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
