//
//  Life_First.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "Life_First.h"
#import "NetworkRequest.h"
#import "APIConfig.h"
#import "BaseHandler.h"
#import "QiangGouModel.h"
#import "QiangGouLife.h"

@implementation Life_First


//首页获取相关图片信息--接口已通 GET请求
- (void)getHomeData:(lifefirst *)life success:(SuccessBlock)success failed:(FailedBlock)failed{

    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:life.companyId,@"companyId", life.communityhouseId,@"communityhouseId",life.code,@"code",nil];
    
    NSLog(@"生活首页广告上传>>>%@",dict);
    
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:LifeHomeData] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"生活首页广告返回>>>%@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}

//获取首页惠团购广告

- (void)getAdverHuituangou:(lifefirst *)huituan success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:huituan.companyId,@"companyId", huituan.communityhouseId,@"communityhouseId",huituan.code,@"code",nil];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:LifeHomeData] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}

//获取开抢广告页面
- (void)getAdverkaiqiang:(lifefirst *)kaiqiang success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:kaiqiang.companyId,@"companyId", kaiqiang.communityhouseId,@"communityhouseId",kaiqiang.code,@"code",nil];
    [AppUtils showProgressMessage:@"正在加载"];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:LifeHomeData] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}

//首页倒计时接口
-(void)getTime:(DaoJIShi *)shijian success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict  = [NSDictionary dictionaryWithObjectsAndKeys:shijian.bundleGroupId,@"bundleGroupId", nil];
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:DAOJISHI] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}


//抢购列表---接口已通
- (void)getKaiQiang:(QiangGouModel *)qiang success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:qiang.nameUp,@"name",qiang.bundleGroupId,@"bundleGroupId", nil];
    NSDictionary * uploaDict = [NSDictionary dictionaryWithObjectsAndKeys:qiang.pageNumber,@"pageNumber",qiang.pageSize,@"pageSize",dict,@"queryMap", nil];
    
    
    NSLog(@"Upload >> %@",uploaDict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:QIANGGOU] requestType:ZJHttpRequestPost parameters:uploaDict prepareExecute:^{
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
//        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}

//获取所有惠团购......查询惠团购
- (void)HuiTuanGouAll:(HuiTuanGouAllModel *)tuangou success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:tuangou.storeName forKey:@"storeName"];
    [dict setObject:tuangou.catalogId forKey:@"categoryId"];
    [dict setObject:tuangou.areaId forKey:@"areaId"];
    [dict setObject:tuangou.sort forKey:@"sort"];
    [dict setObject:tuangou.latitude forKey:@"latitude"];
    [dict setObject:tuangou.longitude forKey:@"longitude"];
    [dict setObject:tuangou.areaName forKey:@"areaName"];
    NSDictionary * uploaDict = [NSDictionary dictionaryWithObjectsAndKeys:tuangou.pageNumber,@"pageNumber",tuangou.pageSize,@"pageSize",dict,@"queryMap", nil];
    
    
    NSLog(@"Upload >> %@",uploaDict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:TUANGOU] requestType:ZJHttpRequestPost parameters:uploaDict prepareExecute:^{
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        
        NSLog(@"惠团购返回>>>>>%@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
    
}

//惠团购目录列表
- (void)MuLuLieBiao:(HuiTuanGouMuLuModel *)mulu success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:mulu.catalogId,@"catalogId", mulu.parentCategoryId,@"parentCategoryId",mulu.languageId,@"languageId",nil];
    
    NSLog(@"%@",dict);
    
//    [AppUtils showProgressMessage:@"正在加载"];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:TUANLIEBIAO] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic);

        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}

//惠团购获取城市列表接口---公用倒计时Model
- (void)getCityList:(DaoJIShi *)list success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:list.areaId,@"areaId",nil];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:CITYLIST] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                
                NSLog(@"response dic = %@",dic);

                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}


//获取惠团购详情接口
- (void)getTuanGouDetail:(TuanGouDetailModel *)detail success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:detail.productId,@"productId",detail.memberId,@"memberId",nil];
    
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:TUANDETAIL] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"团购详情response dic = %@",dic);

        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
    
}

//获取网上商城目录
- (void)getStoreOnLineMuLu:(ShangChengMuLu *)mulu success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:mulu.catalogId,@"catalogId", mulu.parentCategoryId,@"parentCategoryId",mulu.languageId,@"languageId",nil];
    
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:TUANLIEBIAO] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        
        NSLog(@"商城目录response dic = %@",dic);

        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}


//根据名称查找商城商品
- (void)searchStoreGoodsList:(ShangChengGoodsModel *)shangcheng success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys: shangcheng.type, @"type",shangcheng.catalogId,@"catalogId",nil];
    NSDictionary * uploaDict = [NSDictionary dictionaryWithObjectsAndKeys:shangcheng.pageNumber,@"pageNumber",shangcheng.pageSize,@"pageSize",dict,@"queryMap",nil];
//    NSLog(@"Upload >> %@",uploaDict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:SHANGCHNEG] requestType:ZJHttpRequestPost parameters:uploaDict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
                
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}

//获取商城屏论列表
- (void)getPinLunInStore:(PinLunModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed{

//    [AppUtils showProgressMessage:@"正在加载"];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:model.productId,@"productId", nil];
    NSDictionary * uploaDict = [NSDictionary dictionaryWithObjectsAndKeys:model.pageNumber,@"pageNumber",model.pageSize,@"pageSize",dict,@"queryMap",nil];
    
        NSLog(@"评论Upload >> %@",uploaDict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:SHANGCHENGPINGLUN] requestType:ZJHttpRequestPost parameters:uploaDict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"评论response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success) {
            success(dic);
            return;
        }
        
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"评论列表报错>>>>>%@",error);
    }];
}

//获取商城商品详情
-(void)getStoreGoodsDetail:(StoreGoodsDetailModel *)detail success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * uploaDict = [NSDictionary dictionaryWithObjectsAndKeys:detail.productId,@"productId",detail.memberId,@"memberId",nil];
    
    NSLog(@"Upload 商城商品详情 >> %@",uploaDict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:STOREGOODSDETAIL] requestType:ZJHttpRequestGet parameters:uploaDict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}

//获取家政服务类型EasyShopInfo    用  Model
- (void)getJiaZhengLeiXing:(EasyShopInfo *)info success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:info.storeId,@"storeId", nil];
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:KINDJIAZHENG] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}


//提交家政预约
-(void)uploadYuYue:(YuYueModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:model.storeid,@"storeid",model.serviceTime,@"serviceTime",model.address,@"address",model.name,@"name",model.phone,@"phone",model.remarks,@"remarks",model.serverId,@"serverId",model.userId,@"userId", nil];
    
    NSLog(@"Upload >> %@",dict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:TIJIAOYUYUE] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {

                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}
//获取便利店所有商家信息，公用评论model，实现分页效果
- (void)getAllEasyShop:(PinLunModel *)mode success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict1 = [NSDictionary dictionaryWithObjectsAndKeys:mode.optionId, @"optionId",mode.storeName,@"storeName",mode.screening,@"screening",mode.commId,@"commId",nil];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:mode.pageNumber,@"pageNumber",mode.pageSize,@"pageSize",dict1,@"queryMap",nil];
    NSLog(@"便利店上处啊字典 >> %@",dict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:ALLEASYSHOP] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}

//获取便利店所有的分类
- (void)getEasyAllKinds:(SuccessBlock)success failed:(FailedBlock)failed{
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:ALLKINDSEASY] requestType:ZJHttpRequestGet parameters:nil prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        NSLog(@"response 便利店所有分类 dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                [SVProgressHUD dismiss];
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}
//便利店智能排序
- (void)SortEasyShop:(EasyShopSortModel *)sort success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:sort.Screening,@"Screening", nil];
    NSDictionary * dictupload = [NSDictionary dictionaryWithObjectsAndKeys:sort.pageNumber,@"pageNumber",sort.pageSize,@"pageSize",dict,@"queryMap", nil];
    
    NSLog(@"Upload >> %@",dictupload);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:GOOSSORT] requestType:ZJHttpRequestPost parameters:dictupload prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        NSLog(@"response 智能排序便利店便利店 dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}

//便利店根据商家ID获取商家信息
- (void)getShopInfor:(EasyShopInfo *)shop success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:shop.storeId,@"storeId",shop.memberId,@"memberId",nil];
    
    NSLog(@"Upload >> %@",dict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:EASYSHOPDETAIL] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
    }];
}

//根据商家ID查找商家所有的商品
- (void)getShopAllGoods:(ShopGoodsList *)goodslist success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:goodslist.storeId,@"storeId",goodslist.catalogId,@"catalogId",goodslist.categoryId,@"categoryId",goodslist.Sort,@"Sort",goodslist.productName,@"productName",goodslist.companyId,@"companyId",nil];
    
    NSDictionary * uploaddict = [NSDictionary dictionaryWithObjectsAndKeys:goodslist.pageNumber,@"pageNumber",goodslist.pageSize,@"pageSize",dict,@"queryMap", nil];
    
    NSLog(@"Upload >> %@",uploaddict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:SHOPGOODSLIST] requestType:ZJHttpRequestPost parameters:uploaddict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            NSLog(@"yes");
        }
//        NSLog(@"response 便利店商品列表 dic = %@",dic);
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}


//根据商家ID查询商家所有的快送商品
- (void)getKuaiSongList:(ShopGoodsList *)goodslist success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:goodslist.storeId,@"storeId",goodslist.catalogId,@"catalogId",goodslist.memberId,@"memberId",nil];
    
    NSDictionary * uploaddict = [NSDictionary dictionaryWithObjectsAndKeys:goodslist.pageNumber,@"pageNumber",goodslist.pageSize,@"pageSize",dict,@"queryMap", nil];
    
    NSLog(@"Upload >> %@",uploaddict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:KUAISONGLIST] requestType:ZJHttpRequestPost parameters:uploaddict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            NSLog(@"yes");
        }
        //        NSLog(@"response 便利店商品列表 dic = %@",dic);
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}

//根据商家ID查询商家所有的商品列表
- (void)getAllGoodsInShop:(ShopGoodsList *)goodsList success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:goodsList.storeId,@"storeId",goodsList.catalogId,@"catalogId",goodsList.memberId,@"memberId",nil];
    
    NSDictionary * uploaddict = [NSDictionary dictionaryWithObjectsAndKeys:goodsList.pageNumber,@"pageNumber",goodsList.pageSize,@"pageSize",dict,@"queryMap", nil];
    
    NSLog(@"Upload >> %@",uploaddict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:ALLGOODSINSHOP] requestType:ZJHttpRequestPost parameters:uploaddict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            NSLog(@"yes");
        }
        //        NSLog(@"response 便利店商品列表 dic = %@",dic);
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];
    
}


- (void)SearchEasyShopGoodsByCondition:(EasyShopGoodsConditionSearch *)condition success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:condition.catalogId,@"catalogId", condition.storeId,@"storeId",condition.categoryId,@"categoryId",nil];
    
    NSDictionary * uploaddict = [NSDictionary dictionaryWithObjectsAndKeys:condition.pageNumber,@"pageNumber",condition.pageSize,@"pageSize",dict,@"queryMap", nil];
    NSLog(@"Upload >> %@",uploaddict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:ARRANGEGOODSINEASYSHOP] requestType:ZJHttpRequestPost parameters:uploaddict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}

//便利店商品智能排序
- (void)arrangeGoodEasyshop:(EasyGoodArrange *)range success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:range.Screening,@"Screening", range.storeId,@"storeId",range.categoryId,@"categoryId",nil];
    
    NSDictionary * uploaddict = [NSDictionary dictionaryWithObjectsAndKeys:range.pageNumber,@"pageNumber",range.pageSize,@"pageSize",dict,@"queryMap", nil];
    
    NSLog(@"Upload >> %@",uploaddict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:EASYGOOSSORT] requestType:ZJHttpRequestPost parameters:uploaddict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"便利店智能排序%@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}

//首页精选商家数据
- (void)JingXuanShangJia:(JingXuanModel *)model succes:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:model.commId,@"commId", nil];
    
    NSLog(@"精选商家上传%@",dict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:JINGXUANSJ] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}

//查询所有的代金券列表
- (void)getAllDaiJinQuan:(DaiJinQuanModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed{


    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:model.memberId,@"memberId",nil];
    NSLog(@"Upload >> %@",dict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:ALLDAIJINQUAN] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
                
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}


- (void)GetOrderNo:(NSMutableDictionary *)dict success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_OMS WithPort:A_PORT_OMS WithPath:ORDERPATH] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];

    
}

//商家收藏
- (void)ShopShouCang:(ShouCangGoods *)shou success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:shou.storeId,@"storeId",shou.memberId,@"memberId",shou.isDeleted,@"isDeleted",nil];
    NSLog(@"Upload >> %@",dict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:SHOUCANGSHANGJIA] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
            NSLog(@"response dic = %@",dic);

            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}

//添加商品收藏
- (void)StoreGoods:(ShouCangGoods *)goods success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:goods.productId,@"productId",goods.memberId,@"memberId",nil];
    NSLog(@"Upload >> %@",dict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:GOODSSHOUCANG] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            NSLog(@"response dic = %@",dic);
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}

//删除商品收藏
- (void)DeleGoodsShou:(ShouCangGoods *)goods success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:goods.productId,@"productId",goods.memberId,@"memberId",nil];
    NSLog(@"Upload >> %@",dict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:DELEGOODSSHOUCANG] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            NSLog(@"response dic = %@",dic);

            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
    }];
}

//获取商家评论列表接口
- (void)getShopPingLun:(ShopPingLunModel *)ping success:(SuccessBlock)success failed:(FailedBlock)failed{


    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:ping.storeId,@"storeId",ping.storeType,@"storeType",nil];
    NSDictionary * upload = [NSDictionary dictionaryWithObjectsAndKeys:ping.pageNumber,@"pageNumber",ping.pageSize,@"pageSize",dict,@"queryMap", nil];
    
    NSLog(@"商家评论Upload >> %@",upload);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:SHOPPINGLUN] requestType:ZJHttpRequestPost parameters:upload prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}

//获取最新收货地址
- (void)GetMoRenAddress:(MoRenAddress *)address success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:address.memberId,@"memberId",nil];
    NSLog(@"Upload >> %@",dict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:MORENADDRESS] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];

    
}

//添加一个收货地址
- (void)addNewAdress:(AddNewDressModel *)adress success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:adress.memberId,@"memberId",adress.consignee,@"consignee",adress.mobile,@"mobile",adress.province,@"province",adress.city,@"city",adress.district,@"district",adress.addressName,@"addressName",adress.default_Address,@"default_Address",nil];
    NSLog(@"新增收货地址 >> %@",dict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:ADDNEWADRESS] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}

//修改收货地址
- (void)resertAdress:(AddNewDressModel *)adress success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:adress.memberId,@"memberId",adress.consignee,@"consignee",adress.mobile,@"mobile",adress.province,@"province",adress.city,@"city",adress.district,@"district",adress.addressName,@"addressName",adress.default_Address,@"default_Address",adress.adressid,@"id",nil];
    NSLog(@"修改货地址 >> %@",dict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:RESTADRESS] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        

        NSLog(@"response dic = %@",dic);
 
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];
    
}

//获取所有的收货地址
- (void)getAllAdress:(AllAdressList *)list success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:list.memberId,@"memberId",nil];
    NSLog(@"获取所有的收货地址 >> %@",dict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:GETALLADRESSLIST] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}

//删除一个收货地址
- (void)deleteAdress:(AllAdressList *)list success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:list.addressId,@"addressId",nil];
    NSLog(@"获取所有的收货地址 >> %@",dict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:DELETEADRESS] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
    
}

//添加默认收货地址
- (void)setDefaultAdress:(SetDefaultAdress *)defaultAdress success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:defaultAdress.addressId,@"addressId",nil];
    
    NSLog(@"默认收货地址上传>>>>%@",dict);

    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:DEFAULTADRESS] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}

@end
