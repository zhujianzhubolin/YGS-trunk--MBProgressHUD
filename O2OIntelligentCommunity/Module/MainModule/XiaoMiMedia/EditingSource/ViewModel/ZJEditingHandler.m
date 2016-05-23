//
//  ZJEditingHandler.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/29.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ZJEditingHandler.h"

@implementation ZJEditingHandler
- (id)init {
    self = [super init];
    if (self) {
        self.currentPage = @"1";
        self.pageCount =  @"1";
        self.templateArr = [NSMutableArray array];
    }
    return self;
}

- (void)ZJ_requestForGetTemplateList:(ZJXiaoMiTemplateM *)model
                             success:(SuccessBlock)success
                              failed:(FailedBlock)failed
                            isHeader:(BOOL)isHeader {
    if (isHeader) {
        self.currentPage = @"1";
        self.pageCount =  @"1";
    }
    else {
        if (self.currentPage.integerValue > self.pageCount.integerValue) {
            success(self.templateArr);
            return;
        }
        self.currentPage = [NSString stringWithFormat:@"%ld",self.currentPage.integerValue + 1];
    }
    
    model.pageNumber = self.currentPage;
    
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:model.pageNumber,@"pageNumber",
                             model.pageSize,@"pageSize",
//                             model.xqNo,@"xqNo",
//                             model.wyNo,@"wyNo",
                             nil];
    NSLog(@"ZJ_requestForGetTemplateList,paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_XiaoMI_TemplateList] requestType:ZJHttpRequestGet parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success) {
            NSLog(@"dic_json = %@",dic_json);
            
            ZJXiaoMiTemplateM *templateE = [self decodeTemplateListJson:dic_json];
            if ([NSArray isArrEmptyOrNull:templateE.list]) {
                self.currentPage = templateE.pageNumber;
            }
            
            self.pageCount = templateE.pageCount;
            if (isHeader) {
                [self.templateArr removeAllObjects];
                [templateE.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.templateArr addObject:obj];
                }];
            }
            else {
                [templateE.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.templateArr addObject:obj];
                }];
            }
            
            success(self.templateArr);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

- (ZJXiaoMiTemplateM *)decodeTemplateListJson:(NSDictionary *)json_dic {
    ZJXiaoMiTemplateM *model = [ZJXiaoMiTemplateM new];
    model.pageNumber = json_dic[@"pageNumber"];
    model.pageSize = json_dic[@"pageCount"];
    
    NSArray *listArr = json_dic[@"list"];
    NSMutableArray *temArr = [NSMutableArray array];
    if (![NSArray isArrEmptyOrNull:listArr]) {
        [listArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *temDic = obj;
            ZJXiaoMiTemplateM *templateM = [ZJXiaoMiTemplateM new];
            templateM.ID                        = [NSString stringFromat:temDic[@"id"]];
            
            ZJXiaoMiTemTextM *textM1 = [ZJXiaoMiTemTextM new];
            ZJXiaoMiTemTextM *textM2 = [ZJXiaoMiTemTextM new];
            ZJXiaoMiTemTextM *textM3 = [ZJXiaoMiTemTextM new];
            
            textM1.templateText             = [NSString stringFromat:temDic[@"templateText1"]];
            textM1.templateTextXy           = [NSString stringFromat:temDic[@"templateText1Xy"]];
            textM1.templateTextZt           = [NSString stringFromat:temDic[@"templateText1Zt"]];
            if (![NSString isEmptyOrNull:temDic[@"templateText1Fontsize"]]) {
                textM1.templateTextFontsize     = [temDic[@"templateText1Fontsize"] floatValue];
            }
            if (![NSString isEmptyOrNull:temDic[@"templateText1Fontcount"]]) {
                textM1.templateTextFontcount     = [temDic[@"templateText1Fontcount"] floatValue];
            }
            
            textM2.templateText             = [NSString stringFromat:temDic[@"templateText2"]];
            textM2.templateTextXy           = [NSString stringFromat:temDic[@"templateText2Xy"]];
            textM2.templateTextZt           = [NSString stringFromat:temDic[@"templateText2Zt"]];
            if (![NSString isEmptyOrNull:temDic[@"templateText2Fontsize"]]) {
                textM2.templateTextFontsize     = [temDic[@"templateText2Fontsize"] floatValue];
            }
            if (![NSString isEmptyOrNull:temDic[@"templateText2Fontcount"]]) {
                textM2.templateTextFontcount     = [temDic[@"templateText2Fontcount"] floatValue];
            }
            
            textM3.templateText             = [NSString stringFromat:temDic[@"templateText3"]];
            textM3.templateTextXy           = [NSString stringFromat:temDic[@"templateText3Xy"]];
            textM3.templateTextZt           = [NSString stringFromat:temDic[@"templateText3Zt"]];
            if (![NSString isEmptyOrNull:temDic[@"templateText3Fontsize"]]) {
                textM3.templateTextFontsize     = [temDic[@"templateText3Fontsize"] floatValue];
            }
            if (![NSString isEmptyOrNull:temDic[@"templateText3Fontcount"]]) {
                textM3.templateTextFontcount     = [temDic[@"templateText3Fontcount"] floatValue];
            }

            if (![NSString isEmptyOrNull:textM1.templateText]) {
                templateM.textModel1 = textM1;
                if (![NSString isEmptyOrNull:textM2.templateText]) {
                    templateM.textModel2 = textM2;
                    if (![NSString isEmptyOrNull:textM3.templateText]) {
                        templateM.textModel3 = textM3;
                    }
                }
                else {
                    if (![NSString isEmptyOrNull:textM3.templateText]) {
                        templateM.textModel2 = textM3;
                    }
                }
            }
            else {
                if (![NSString isEmptyOrNull:textM2.templateText]) {
                    templateM.textModel1 = textM2;
                    if (![NSString isEmptyOrNull:textM3.templateText]) {
                        templateM.textModel2 = textM3;
                    }
                }
                else {
                    if (![NSString isEmptyOrNull:textM3.templateText]) {
                        templateM.textModel1 = textM3;
                    }
                }
            }
            templateM.templatename              = [NSString stringFromat:temDic[@"templateName"]];
            templateM.templateSizePx            = [NSString stringFromat:temDic[@"templateSizePx"]];
            templateM.templateImgSrc            = [NSString stringFromat:temDic[@"templateImgSrc"]];
            templateM.templateImgSrcSlt         = [NSString stringFromat:temDic[@"templateImgSrcSlt"]];
            [temArr addObject:templateM];
        }];
    }
    model.list = [temArr copy];
    return model;
}

//获取模板合成后的图片路径
- (void)ZJ_requestForGetTemplateSynthesisImg:(id)paraDic
                                     success:(SuccessBlock)success
                                      failed:(FailedBlock)failed {
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_SUBMITORDER] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic == %@",dic);
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            success([self decodeSynthesisImgJson:dic]);
            return ;
        }
        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];
}

- (ZJXiaoMiTemplateM *)decodeSynthesisImgJson:(NSDictionary *)json_dic  {
    ZJXiaoMiTemplateM *model        = [ZJXiaoMiTemplateM new];
    model.templateImgSrc            = [NSString stringFromat:json_dic[@"ggImgSrc"]];
    model.templateImgSrcSlt         = [NSString stringFromat:json_dic[@"ggImgSrcSlt"]];
    model.ID                        = [NSString stringFromat:json_dic[@"id"]];
    
    return model;
}

//上传图片
- (void)ZJ_RequestForUploadImg:(UIImage *)img
                       success:(SuccessBlock)success
                        failed:(FailedBlock)failed {
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest] uploadWithServerPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_XiaoMI_UploadImg] parameters:nil prepareExecute:^{
        
    } mediaDataArr:@[img] constructingsuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = responseObject;
        NSLog(@"dic_json = %@",dic_json);
        if (![NSString isEmptyOrNull:responseObject[@"code"]] && [dic_json[@"code"] isEqualToString:@"success"]) {
            ZJXiaoMiTemplateM *tmpM = [ZJXiaoMiTemplateM new];
            tmpM.templateImgSrc = dic_json[@"ggImgSrc"];
            tmpM.templateImgSrcSlt = dic_json[@"ggImgSrcSlt"];
            tmpM.filePathDisk = dic_json[@"filePathDisk"];
            success(tmpM);
            return;
        }
        failed(@"上传失败");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
    }];
}

@end
