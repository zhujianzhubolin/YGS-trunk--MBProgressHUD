//
//  AdvertiseHandler.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/4.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "ADEntity.h"

@interface AdvertiseHandler : BaseHandler
@property (nonatomic, copy) NSString *mainAdPNumber;
@property (nonatomic, copy) NSString *mainAdPCount;
@property (nonatomic, strong) NSMutableArray *mainAdArr;

//首页获取顶部广告
- (void)executeMainTopAdvertiseTaskWithUser:(ADEntity *)adE
                                    success:(SuccessBlock)success
                                     failed:(FailedBlock)failed;

//首页获取底部广告
- (void)executeMainButtomAdvertiseTaskWithUser:(ADEntity *)adE
                                       success:(SuccessBlock)success
                                        failed:(FailedBlock)failed
                                      isHeader:(BOOL)isheader;
@end
