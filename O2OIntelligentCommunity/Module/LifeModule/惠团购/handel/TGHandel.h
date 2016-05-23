//
//  TGHandel.h
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/18.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "TGListModel.h"
#import "TGFenLei.h"
#import "DeletePingLunModel.h"

@interface TGHandel : BaseHandler

@property(nonatomic,copy)NSString * totalPage;

//团购列表
- (void)getHuiTuanList:(TGListModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed;

//查询团购分类接口
- (void)searChTGFenlei:(TGFenLei *)model success:(SuccessBlock)success failed:(FailedBlock)failed;

//商家商品列表
- (void)ShopGoodsLiss:(TGListModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed;


//删除评论接口
- (void)deletePingLun:(DeletePingLunModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
