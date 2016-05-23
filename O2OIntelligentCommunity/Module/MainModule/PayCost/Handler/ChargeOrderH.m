//
//  PhoneChargeH.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/6.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//



#import "ChargeOrderH.h"
#import "WeChatPayClass.h"
#import "AppDelegate.h"
#import "ZSDPaymentView.h"
#import "MoneyBagPayHandler.h"
#import "UserManager.h"

@implementation ChargeOrderH
- (void)executePhoneChargeTaskWithOrder:(ChargeOrderE *)orderE
                                payType:(PayType)payType
                                success:(SuccessBlock)success
                                 failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             orderE.saleAmount,@"saleAmount",
                             orderE.usernumber,@"usernumber",
                             orderE.spbillCreateIp,@"spbill_create_ip", //@"192.168.188.104",@"spbill_create_ip"
                             orderE.tradeType,@"trade_type",// @"APP",@"trade_type",
                             orderE.body,@"body",//@"商品",@"body",
                             orderE.totalFee,@"total_fee",//@"1",@"total_fee",
                             orderE.pay_method,@"payType",
                             orderE.memberInfoPid,@"memberInfoPid",
                             orderE.wyNo,@"wyNo",
                             orderE.orderSource,@"orderSource",
                             orderE.attach,@"attach",
                             nil];
    
    NSLog(@"paraDic = %@",[NSString jsonStringWithDictionary:paraDic]);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP  WithPath:API_PHONE_CHONGZHI] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] &&
            [dic_json[@"code"] isEqualToString:@"success"] &&
            ![NSString isEmptyOrNull:dic_json[@"thirdBizIncrOrderId"]]) {
            [AppUtils dismissHUD];
            NSString *order = dic_json[@"thirdBizIncrOrderId"];
            if (payType == PayTypeQianBao) {
                __block ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
                payment.title      = @"请输入支付密码";
                payment.goodsName  = @"应付金额";
                payment.amount     = orderE.totalFee.floatValue;
                payment.finishBlock = ^(NSString *inputStr) {
                    [AppUtils showProgressMessage:W_ALL_PROGRESS];
                    MoneyBagPayModel *payM =[MoneyBagPayModel new];
                    MoneyBagPayHandler *payH = [MoneyBagPayHandler new];
                    payM.memberId      = [UserManager shareManager].userModel.memberId;
                    payM.payPassWord   = [NSString md5_32Bit_String:inputStr];
                    payM.amount        = orderE.totalFee;
                    payM.payOrderNo    = order;
                    [payH moneybagpay:payM success:^(id moneyPayObj) {
                        success(moneyPayObj);
                    } failed:^(id moneyPayObj) {
                        failed(moneyPayObj);
                    }];
                };
                [payment show];
            }
            else {
                [WeChatPayClass wxPayWithOrderName:@"name1" price:@"1" order:order];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];;
                appDelegate.wxPayBlock = ^(NSUInteger payStatus, NSString *prompt) {
                    switch (payStatus) {
                        case WXPaySuccess:
                            success(prompt);
                            break;
                        case WXPayFail:
                        case WXPayCancel:
                        case WXPayFailOther:
                            failed(prompt);
                            break;
                        default:
                            break;
                    }
                };
            }
            return;
        }
        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

//缴物业费
- (void)executePropertyChargeTaskWithArr:(NSArray *)orderArr
                                 payType:(PayType)payType
                                  success:(SuccessBlock)success
                                   failed:(FailedBlock)failed {
    NSLog(@"PropertyCharge orderArr = %@",orderArr);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_PRO_SUBMMINT_ORDER] requestType:ZJHttpRequestPost parameters:orderArr prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] &&
            [dic_json[@"code"] isEqualToString:@"success"] &&
            ![NSString isEmptyOrNull:dic_json[@"thirdBizIncrOrderId"]]) {
            [AppUtils dismissHUD];
            NSString *order = dic_json[@"thirdBizIncrOrderId"];
            if (payType == PayTypeQianBao) {
                __block CGFloat totalFee = 0;
                [orderArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSDictionary *paraDic = obj;
                    totalFee += [paraDic[@"saleAmount"] floatValue];
                }];
                
                __block ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
                payment.title      = @"请输入支付密码";
                payment.goodsName  = @"应付金额";
                payment.amount     = totalFee;
                payment.finishBlock = ^(NSString *inputStr) {
                    [AppUtils showProgressMessage:W_ALL_PROGRESS];
                    MoneyBagPayModel *payM =[MoneyBagPayModel new];
                    MoneyBagPayHandler *payH = [MoneyBagPayHandler new];
                    payM.memberId      = [UserManager shareManager].userModel.memberId;
                    payM.payPassWord   = [NSString md5_32Bit_String:inputStr];
                    payM.amount        = [NSString stringWithFormat:@"%.2f",totalFee];
                    payM.payOrderNo    = order;
                    [payH moneybagpay:payM success:^(id moneyPayObj) {
                        success(moneyPayObj);
                    } failed:^(id moneyPayObj) {
                        failed(moneyPayObj);
                    }];
                };
                [payment show];
            }
            else {
                [WeChatPayClass wxPayWithOrderName:@"name1" price:@"1" order:order];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];;
                appDelegate.wxPayBlock = ^(NSUInteger payStatus, NSString *prompt) {
                    switch (payStatus) {
                        case WXPaySuccess:
                            success(prompt);
                            break;
                        case WXPayFail:
                        case WXPayCancel:
                        case WXPayFailOther:
                            failed(prompt);
                            break;
                        default:
                            break;
                    }
                };
            }
            return;
        }
        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

//交通罚款费
- (void)executeTrafficFinesChargeTaskWithUser:(NSArray *)trafficArr
                                      payType:(PayType)payType
                                      success:(SuccessBlock)success
                                       failed:(FailedBlock)failed {
    NSLog(@"TrafficFines paraDic = %@",trafficArr);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP
                                                                            WithPort:A_PORT_SUP
                                                                            WithPath:API_TRAFFIC_SUBMMIT_ORDER]
                                         requestType:ZJHttpRequestPost
                                          parameters:trafficArr
                                      prepareExecute:^{
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] &&
            [dic_json[@"code"] isEqualToString:@"success"] &&
            ![NSString isEmptyOrNull:dic_json[@"thirdBizIncrOrderId"]]) {
            [AppUtils dismissHUD];
            NSString *order = dic_json[@"thirdBizIncrOrderId"];
            if (payType == PayTypeQianBao) {
                __block CGFloat totalFee = 0;
                [trafficArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSDictionary *paraDic = obj;
                    totalFee += [paraDic[@"total_fee"] floatValue];
                }];
                
                __block ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
                payment.title      = @"请输入支付密码";
                payment.goodsName  = @"应付金额";
                payment.amount     = totalFee;
                payment.finishBlock = ^(NSString *inputStr) {
                    [AppUtils showProgressMessage:W_ALL_PROGRESS];
                    MoneyBagPayModel *payM =[MoneyBagPayModel new];
                    MoneyBagPayHandler *payH = [MoneyBagPayHandler new];
                    payM.memberId      = [UserManager shareManager].userModel.memberId;
                    payM.payPassWord   = [NSString md5_32Bit_String:inputStr];
                    payM.amount        = [NSString stringWithFormat:@"%f",totalFee];
                    payM.payOrderNo    = order;
                    [payH moneybagpay:payM success:^(id moneyPayObj) {
                        success(moneyPayObj);
                    } failed:^(id moneyPayObj) {
                        failed(moneyPayObj);
                    }];
                };
                [payment show];
            }
            else {
                [WeChatPayClass wxPayWithOrderName:@"name1" price:@"1" order:order];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];;
                appDelegate.wxPayBlock = ^(NSUInteger payStatus, NSString *prompt) {
                    switch (payStatus) {
                        case WXPaySuccess:
                            success(prompt);
                            break;
                        case WXPayFail:
                        case WXPayCancel:
                        case WXPayFailOther:
                            failed(prompt);
                            break;
                        default:
                            break;
                    }
                };
            }
            return;
        }
        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

- (void)executeParkChargeTaskWithOder:(ChargeOrderE *)orderE
                              payType:(PayType)payType
                              success:(SuccessBlock)success
                               failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             orderE.body,@"body",
                             orderE.orderSource,@"orderSource",
                             orderE.spbillCreateIp,@"spbill_create_ip",
                             orderE.memberInfoPid,@"memberInfoPid",
                             orderE.mouths,@"mouths",
                             orderE.tradeType,@"trade_type",
                             orderE.xqNo,@"xqNo",
                             orderE.monthlyFee,@"monthlyFee",
                             orderE.totalFee,@"total_fee",
                             orderE.parkingType,@"parkingType",
                             orderE.licenseNumber,@"licenseNumber",
                             orderE.payType,@"payType",
                             orderE.infoNo,@"infoNo",
                             orderE.wyNo,@"wyNo",
                             orderE.cityNo,@"cityNo",
                             orderE.attach,@"attach",
                             nil];

    NSLog(@"ParkCharge paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_PARK_SUBMMINT_ORDER] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
    
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] &&
            [dic_json[@"code"] isEqualToString:@"success"] &&
            ![NSString isEmptyOrNull:dic_json[@"thirdBizIncrOrderId"]]) {
            [AppUtils dismissHUD];
            NSString *order = dic_json[@"thirdBizIncrOrderId"];
            if (payType == PayTypeQianBao) {
                __block ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
                payment.title      = @"请输入支付密码";
                payment.goodsName  = @"应付金额";
                payment.amount     = orderE.totalFee.floatValue;
                payment.finishBlock = ^(NSString *inputStr) {
                    [AppUtils showProgressMessage:W_ALL_PROGRESS];
                    MoneyBagPayModel *payM =[MoneyBagPayModel new];
                    MoneyBagPayHandler *payH = [MoneyBagPayHandler new];
                    payM.memberId      = [UserManager shareManager].userModel.memberId;
                    payM.payPassWord   = [NSString md5_32Bit_String:inputStr];
                    payM.amount        = orderE.totalFee;
                    payM.payOrderNo    = order;
                    [payH moneybagpay:payM success:^(id moneyPayObj) {
                        success(moneyPayObj);
                    } failed:^(id moneyPayObj) {
                        failed(moneyPayObj);
                    }];
                };
                [payment show];
            }
            else {
                [WeChatPayClass wxPayWithOrderName:@"name1" price:@"1" order:order];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];;
                appDelegate.wxPayBlock = ^(NSUInteger payStatus, NSString *prompt) {
                    switch (payStatus) {
                        case WXPaySuccess:
                            success(prompt);
                            break;
                        case WXPayFail:
                        case WXPayCancel:
                        case WXPayFailOther:
                            failed(prompt);
                            break;
                        default:
                            break;
                    }
                };
            }
            return;
        }
        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}


//水电燃缴费
- (void)executeWECTaskWithOder:(ChargeOrderE *)orderE
                       payType:(PayType)payType
                       success:(SuccessBlock)success
                        failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             orderE.sdmType,@"sdmType",
                             orderE.memberInfoPid,@"memberInfoPid",
                             orderE.userNumber,@"userNumber",
                             orderE.payAmount,@"payAmount",
                             orderE.attach,@"attach",
                             orderE.spbillCreateIp,@"spbill_create_ip", //@"192.168.188.104",@"spbill_create_ip"
                             orderE.tradeType ,@"trade_type",// @"APP",@"trade_type",
                             orderE.body,@"body",//@"商品",@"body",
                             orderE.pay_method,@"payType",
                             orderE.totalFee,@"total_fee",
                             orderE.usernumber,@"userToken",
                             orderE.wyNo,@"wyNo",
                             orderE.orderSource,@"orderSource",
                             orderE.buildNo,@"buildingNo",
                             orderE.houseNo,@"houseNo",
                             orderE.cityNo,@"areaNo",
                             orderE.xqNo,@"xqNo",
                             orderE.prepaIdFlag,@"preapidFlag",
                             orderE.contentNo,@"contentNo",
                             orderE.contNo,@"contNo",
                             orderE.chargeUnit,@"chargeUnit",
                             orderE.userName,@"userName",
                             orderE.address,@"address",
                             nil];
    NSLog(@"WECTask paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_WATER_ELEC_COAR_SUBMIT_ORDER] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] &&
            [dic_json[@"code"] isEqualToString:@"success"] &&
            ![NSString isEmptyOrNull:dic_json[@"thirdBizIncrOrderId"]]) {
            [AppUtils dismissHUD];
            NSString *order = dic_json[@"thirdBizIncrOrderId"];
            if (payType == PayTypeQianBao) {
                __block ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
                payment.title      = @"请输入支付密码";
                payment.goodsName  = @"应付金额";
                payment.amount     = orderE.totalFee.floatValue;
                payment.finishBlock = ^(NSString *inputStr) {
                    [AppUtils showProgressMessage:W_ALL_PROGRESS];
                    MoneyBagPayModel *payM =[MoneyBagPayModel new];
                    MoneyBagPayHandler *payH = [MoneyBagPayHandler new];
                    payM.memberId      = [UserManager shareManager].userModel.memberId;
                    payM.payPassWord   = [NSString md5_32Bit_String:inputStr];
                    payM.amount        = orderE.totalFee;
                    payM.payOrderNo    = order;
                    [payH moneybagpay:payM success:^(id moneyPayObj) {
                        success(moneyPayObj);
                    } failed:^(id moneyPayObj) {
                        failed(moneyPayObj);
                    }];
                };
                [payment show];
            }
            else {
                [WeChatPayClass wxPayWithOrderName:@"name1" price:@"1" order:order];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];;
                appDelegate.wxPayBlock = ^(NSUInteger payStatus, NSString *prompt) {
                    switch (payStatus) {
                        case WXPaySuccess:
                            success(prompt);
                            break;
                        case WXPayFail:
                        case WXPayCancel:
                        case WXPayFailOther:
                            failed(prompt);
                            break;
                        default:
                            break;
                    }
                };
            }
            return;
        }

        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}


@end
