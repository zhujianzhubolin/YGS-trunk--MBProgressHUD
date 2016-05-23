//
//  HttpClient.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIConfig.h"   

//HTTP REQUEST METHOD TYPE
typedef NS_ENUM(NSInteger, ZJHttpRequestType) {
    ZJHttpRequestGet,
    ZJHttpRequestPost,
    ZJHttpRequestDelete,
    ZJHttpRequestPut,
};

/**
 *  请求开始前预处理Block
 */
typedef void(^PrepareExecuteBlock)(void);

/****************   NetworkRequest   ****************/
@interface NetworkRequest : NSObject

//设置请求头的序列化类型
- (void)requestSerializerJson;

- (void)requestSerializerDefailt;

- (void)requestSerializerGetMima;

+ (NetworkRequest *)defaultRequest;

/**
 *  HTTP请求（GET、POST、DELETE、PUT）
 *
 *  @param path
 *  @param method     RESTFul请求类型
 *  @param parameters 请求参数
 *  @param prepare    请求前预处理块
 *  @param success    请求成功处理块
 *  @param failure    请求失败处理块
 */
- (void)requestWithPath:(NSString *)url
            requestType:(ZJHttpRequestType)requestType
            parameters:(id)parameters
        prepareExecute:(PrepareExecuteBlock) prepare
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



/**
 *  上传图片
 *
 *  @param path       服务器上传路径
 *  @param param      请求参数
 *  @param prepare    请求前预处理块
 *  @param mediaDatas 上传的数据数组
 *  @param success    请求成功处理块
 *  @param failure    请求失败处理块
 */
- (void)uploadWithServerPath:(NSString *)path
                  parameters:param
              prepareExecute:(PrepareExecuteBlock) prepare
                mediaDataArr:(NSArray *)mediaDatas
         constructingsuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//判断当前网络状态
- (BOOL)isConnectionReachable;
+ (void)cancelAllOperations;
@end
