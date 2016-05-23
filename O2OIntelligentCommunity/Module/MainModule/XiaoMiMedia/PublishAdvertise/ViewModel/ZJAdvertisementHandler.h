//
//  ZJAdvertisementHandler.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/31.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "ZJAdvertisementModel.h"
#import "ZJSubmitOrdersModel.h"

@interface ZJAdvertisementHandler : BaseHandler

@property (nonatomic, copy) NSString *gGaocurrentPage;
@property (nonatomic, copy) NSString *gGaopageCount;
@property (nonatomic,strong)NSMutableArray *gGaoArray;



//规则
-(void)queryAdvertisementListInfo:(ZJAdvertisementModel *)advertisementM
                   success:(SuccessBlock)success
                    failed:(FailedBlock)failed
                  isHeader:(BOOL)isheader;

//客户端上传素材并下订单
-(void)subminMaterialOrders:(NSDictionary *)Dict
            success:(SuccessBlock)success
             failed:(FailedBlock)failed;

//下单
-(void)subminOrders:(NSDictionary *)Dict
            success:(SuccessBlock)success
             failed:(FailedBlock)failed;

//小蜜机器人的个数
-(void)requestXiaoMiNumber:(ZJAdvertisementModel *)model
                   success:(SuccessBlock)success
                    failed:(FailedBlock)failed;



@end
