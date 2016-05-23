//
//  TGHandel.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/18.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "TGHandel.h"
#import "TGShopModel.h"
#import "TGGoodsModel.h"

@implementation TGHandel

//团购列表
- (void)getHuiTuanList:(TGListModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSMutableDictionary * queryMapDict = [NSMutableDictionary dictionary];
    
    [queryMapDict setObject:model.storeName forKey:@"storeName"];
    [queryMapDict setObject:model.code forKey:@"code"];
    [queryMapDict setObject:model.areaName forKey:@"areaName"];
    [queryMapDict setObject:model.catalogId forKey:@"catalogId"];
    [queryMapDict setObject:model.companyId forKey:@"companyId"];
    [queryMapDict setObject:model.xqId forKey:@"xqId"];
    [queryMapDict setObject:model.areaId forKey:@"areaId"];
    [queryMapDict setObject:model.longitude forKey:@"longitude"];
    [queryMapDict setObject:model.latitude forKey:@"latitude"];
    [queryMapDict setObject:model.sort forKey:@"sort"];
    
    NSMutableDictionary * upLoadDict = [NSMutableDictionary dictionary];
    
    [upLoadDict setObject:model.pageNumber forKey:@"pageNumber"];
    [upLoadDict setObject:model.pageSize forKey:@"pageSize"];
    [upLoadDict setObject:queryMapDict forKey:@"queryMap"];
    
    NSLog(@"团购列表上传报文>>>>%@",upLoadDict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:TGList] requestType:ZJHttpRequestPost parameters:upLoadDict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        success([self shopGoodsToModel:dic]);
        
        if (![dic[@"pageCount"] isEqual:[NSNull null]]) {
            self.totalPage = dic[@"pageCount"];
        }else{
            self.totalPage = @"1";
        }
        
        NSLog(@"团购列表返回的数据>>>>>>%@",dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}

//查询团购分类接口
- (void)searChTGFenlei:(TGFenLei *)model success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:model.catalogId forKey:@"catalogId"];
    [dict setObject:model.parentCategoryId forKey:@"parentCategoryId"];
    [dict setObject:model.languageId forKey:@"languageId"];

    
    NSLog(@"团购分类列表上传报文>>>>%@",dict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:HTFenlei] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"团购列表目录返回的数据>>>>>>%@",dic);
        
        success([self dictToModel:dic]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}

- (void)ShopGoodsLiss:(TGListModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSMutableDictionary * queryMapDict = [NSMutableDictionary dictionary];
    
    [queryMapDict setObject:model.storeId forKey:@"storeId"];
    [queryMapDict setObject:model.memberId forKey:@"memberId"];
    [queryMapDict setObject:model.catalogId forKey:@"catalogId"];

    
    NSMutableDictionary * upLoadDict = [NSMutableDictionary dictionary];
    [upLoadDict setObject:model.pageNumber forKey:@"pageNumber"];
    [upLoadDict setObject:model.pageSize forKey:@"pageSize"];
    [upLoadDict setObject:queryMapDict forKey:@"queryMap"];
    
    NSLog(@"团购列表上传报文>>>>%@",upLoadDict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:TGShopGoods] requestType:ZJHttpRequestPost parameters:upLoadDict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"团购商家商品列表返回的数据>>>>>>%@",dic);
        
        if (![dic[@"pageCount"] isEqual:[NSNull null]]) {
            self.totalPage = dic[@"pageCount"];
        }else{
            self.totalPage = @"1";
        }
        
        success([self shopGoodsToModel:dic]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}


//删除评论接口
- (void)deletePingLun:(DeletePingLunModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSMutableDictionary * upLoadDict = [NSMutableDictionary dictionary];
    [upLoadDict setObject:model.commentId forKey:@"commentId"];

    NSLog(@"团购列表上传报文>>>>%@",upLoadDict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_MDM WithPath:DELETEPINGLUN] requestType:ZJHttpRequestGet parameters:upLoadDict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"团购商家商品列表返回的数据>>>>>>%@",dic);
        success(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];
    
}

//目录的转换
- (NSMutableArray *)dictToModel:(NSDictionary *)dict{

    NSMutableArray * modelArray = [NSMutableArray array];
    if (![dict[@"list"] isEqual:[NSNull null]]) {
        for (NSDictionary * dict1 in dict[@"list"]) {
            TGFenLei * model = [TGFenLei new];
            model.tgid = dict1[@"id"];
            model.name = dict1[@"name"];
            model.code = dict1[@"code"];
            [modelArray addObject:model];
        }
        
    }
    return modelArray;
}

//商家商品
- (NSMutableArray *)shopGoodsToModel:(NSDictionary *)dict{
    
    NSMutableArray * shopArray = [NSMutableArray array];
    
    if (![dict[@"list"] isEqual:[NSNull null]]) {
        
          for (NSDictionary * shopDict in dict[@"list"]) {
              
              TGShopModel * shopModel = [TGShopModel new];
              shopModel.address = shopDict[@"address"];
              shopModel.areaCode = shopDict[@"areaCode"];
              shopModel.status = shopDict[@"status"];
              
              if (![shopDict[@"count"] isEqual:[NSNull null]]) {
                  shopModel.count = shopDict[@"count"];
              }else{
                  shopModel.count = @"0";
              }

              if (![shopDict[@"distance"] isEqual:[NSNull null]]) {
                    shopModel.distance = shopDict[@"distance"];
              }else{
                  shopModel.distance = @"未知";
              }
              
              
              
              shopModel.latitude = shopDict[@"filed1"];
              shopModel.longitude = shopDict[@"filed2"];
              shopModel.path = shopDict[@"path"];
              shopModel.range = shopDict[@"range"];
              shopModel.score = shopDict[@"score"];
              shopModel.status = shopDict[@"status"];
              shopModel.storeEndDate = shopDict[@"storeEndDate"];
              shopModel.storeId = shopDict[@"storeId"];
              shopModel.storeName = shopDict[@"storeName"];
              shopModel.storeStartDate = shopDict[@"storeStartDate"];

              
              NSMutableArray * goodsArray = [NSMutableArray array];
              
              if (![shopDict[@"group"] isEqual:[NSNull null]]) {
                  
                  for (NSDictionary * goodsDict in shopDict[@"group"]) {
                      
                      TGGoodsModel * goodsModel = [TGGoodsModel new];
                      
                      goodsModel.address = goodsDict[@"address"];
                      goodsModel.atStatus = goodsDict[@"atStatus"];
                      goodsModel.details = goodsDict[@"details"];
                      goodsModel.effectiveTime = goodsDict[@"effectiveTime"];
                      goodsModel.fullMoney = goodsDict[@"fullMoney"];
                      goodsModel.goodsid = goodsDict[@"id"];
                      goodsModel.img = goodsDict[@"img"];
                      goodsModel.listImg = goodsDict[@"listImg"];
                      goodsModel.madein = goodsDict[@"madein"];
                      goodsModel.marketStatus = goodsDict[@"marketStatus"];
                      goodsModel.market_price = goodsDict[@"market_price"];
                      goodsModel.name = goodsDict[@"name"];
                      goodsModel.notFullMoney = goodsDict[@"notFullMoney"];
                      goodsModel.num = goodsDict[@"num"];
                      goodsModel.price = goodsDict[@"price"];
                      goodsModel.shortDescription = goodsDict[@"shortDescription"];
                      
                      //规格判断
                      if (![goodsDict[@"standard"] isEqual:[NSNull null]]) {
                          goodsModel.standard = [NSString stringWithFormat:@"/%@",goodsDict[@"standard"]];
                      }else{
                          goodsModel.standard = @"";
                      }
                      
                      //判断时间不能为Null
                      if (![goodsDict[@"groupEndDate"] isEqual:[NSNull null]]) {
                          goodsModel.groupEndDate = goodsDict[@"groupEndDate"];
                      }else{
                          goodsModel.groupEndDate = @"0";
                      }
                      
                      if (![goodsDict[@"groupStartDate"] isEqual:[NSNull null]]) {
                          goodsModel.groupStartDate = goodsDict[@"groupStartDate"];
                      }else{
                          goodsModel.groupStartDate = @"0";
                      }
                      
                      if (![goodsDict[@"serverTime"] isEqual:[NSNull null]]) {
                          goodsModel.serverTime = goodsDict[@"serverTime"];
                      }else{
                          goodsModel.serverTime = @"0";
                      }
                      
                      goodsModel.status = goodsDict[@"status"];
                      goodsModel.stock = goodsDict[@"stock"];
                      goodsModel.storeEndDate = goodsDict[@"storeEndDate"];
                      goodsModel.storeId = shopDict[@"storeId"];
                      goodsModel.storeName = shopDict[@"storeName"];
                      goodsModel.storeStartDate = goodsDict[@"storeStartDate"];
                      goodsModel.goodsNum = @"1";
                      
                      [goodsArray addObject:goodsModel];
                  }
            }
              
              
              NSLog(@"goodsArray>>>%@",goodsArray);
              
              shopModel.goodsArray = goodsArray;
              
              [shopArray addObject:shopModel];
        }
    }
    
  
    
    return shopArray;
}

@end
