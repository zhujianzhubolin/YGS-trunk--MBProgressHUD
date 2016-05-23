//
//  ComplainSaveE.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ComplaintSaveE : BaseEntity

@property (nonatomic, copy) NSString *memberid;
@property (nonatomic, copy) NSString *wyNo;
@property (nonatomic, copy) NSString *xqNo;
@property (nonatomic, copy) NSString *complaintType;
@property (nonatomic, copy) NSString *complaintTitle;
@property (nonatomic, copy) NSString *complaintContent;
@property (nonatomic, copy) NSString *complaintStatus;
@property (nonatomic, copy) NSString *contactPerson;
@property (nonatomic, copy) NSString *contactPhone;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *fileId;
@property (nonatomic, copy) NSString *contactAddress; //报修、投诉地址
@property (nonatomic, copy) NSString *source; //来源 AZ：安卓   IOS:苹果    WX:微信  ZD:终端

@property (nonatomic, copy) NSNumber *idID;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *code;
@end
