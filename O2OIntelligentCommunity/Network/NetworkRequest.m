//
//  HttpClient.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "NetworkRequest.h"

@interface NetworkRequest()
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation NetworkRequest

- (void)requestSerializerJson {
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
}

- (void)requestSerializerGetMima {
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
}

- (void)requestSerializerDefailt {
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"Content-Type"];
}

- (id)init{
    if (self = [super init]){
        // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];

        self.manager = [AFHTTPRequestOperationManager manager];
        //响应可接受的数据的类型
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    }
    return self;
}

+ (NetworkRequest *)defaultRequest
{
    static NetworkRequest *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)requestWithPath:(NSString *)url
            requestType:(ZJHttpRequestType)requestType
             parameters:(id)parameters
         prepareExecute:(PrepareExecuteBlock) prepare
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    //请求的URL
    NSLog(@"requestOperationWithPath:%@",url);
    
    //对中文和一些特殊字符进行编码
    NSString *requestURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //判断网络状况（有链接：执行请求；无链接：弹出提示）
    
    if ([self isConnectionReachable]) {
        //预处理（显示加载信息啥的）
        if (prepare) {
            prepare();
        }
        switch (requestType) {
            case ZJHttpRequestGet:
            {
                [self.manager GET:requestURL
                       parameters:parameters
                          success:success
                          failure:failure];
            }
                break;
            case ZJHttpRequestPost:
            {
                [self.manager POST:requestURL
                        parameters:parameters
                           success:success
                           failure:failure];
            }
                break;
            case ZJHttpRequestDelete:
            {
                [self.manager DELETE:requestURL
                          parameters:parameters
                             success:success
                             failure:failure];
            }
                break;
            case ZJHttpRequestPut:
            {
                [self.manager PUT:requestURL
                       parameters:parameters
                          success:success
                          failure:failure];
            }
                break;
            default:
                break;
        }
    }else{
        //网络错误咯
        [self.manager GET:@"http"
               parameters:nil
                  success:success
                  failure:failure];
        //发出网络异常通知广播
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"k_NOTI_NETWORK_ERROR" object:nil];
    }
}

- (void)uploadWithServerPath:(NSString *)path
                  parameters:param
              prepareExecute:(PrepareExecuteBlock) prepare
                mediaDataArr:(NSArray *)mediaDatas
         constructingsuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    //请求的URL
    NSLog(@"uploadWithServerPath path:%@",path);
    
    //判断网络状况（有链接：执行请求；无链接：弹出提示）
    if ([self isConnectionReachable]) {
        //预处理（显示加载信息啥的）
        if (prepare) {
            prepare();
        }
    AFHTTPRequestOperation *operation = [self.manager POST:path
                                                parameters:param
                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                
                                 for (NSInteger i = 0; i < mediaDatas.count; i++) {
                                     NSObject *everyObj = [mediaDatas objectAtIndex:i];
                                     if ([everyObj isKindOfClass:[UIImage class]]) {     // 图片
                                        UIImage *eachImg = [mediaDatas objectAtIndex:i];
                                             //NSData *eachImgData = UIImagePNGRepresentation(eachImg);
                                        NSData *eachImgData = UIImageJPEGRepresentation(eachImg, 0.5);
                                        [formData appendPartWithFileData:eachImgData
                                                                    name:[NSString stringWithFormat:@"img%ld", i+1]
                                                                fileName:[NSString stringWithFormat:@"img%ld.jpg", i+1]
                                                                mimeType:@"image/jpeg"];
                                     }
                                 }
                            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                success(operation,responseObject);
                                NSLog(@"post img success");
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(operation,error);
                                NSLog(@"post img file fail error=%@", error);
                            }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        UIWindow *systemWindow = [UIApplication sharedApplication].keyWindow;
//        NSLog(@"bytesWritten=%ld, totalBytesWritten=%lld, totalBytesExpectedToWrite=%lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
//        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//        [progressView addObserver:self
//                       forKeyPath:@"progress"
//                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
//        CGFloat progressSide = systemWindow.frame.size.width / 2;
//        progressView.frame = CGRectMake(systemWindow.frame.size.width - progressSide, systemWindow.frame.size.height - progressSide, progressSide, progressSide);
//        [systemWindow addSubview:progressView];
//        [progressView setProgress:totalBytesWritten*1.0/totalBytesExpectedToWrite
//                         animated:YES];
    }];
    }
}

//看看网络是不是给力
- (BOOL)isConnectionReachable {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (void)cancelAllOperations {
    [[NetworkRequest defaultRequest].manager.operationQueue cancelAllOperations];
}

@end
