//
//  BXTSCommentsModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface BXTSCommentsModel : BaseEntity

@property (nonatomic,strong)NSArray *list;//对象集合

@property (nonatomic,copy)NSString *pageNumber;
@property (nonatomic,copy)NSString *pageSize;
@property (nonatomic,copy)NSString *memberId;
@property (nonatomic,copy)NSString *complaintId;//要评论的信息ID
@property (nonatomic,copy)NSString *complaintType;//评论类型
@property (nonatomic,copy)NSString *orderBy;
@property (nonatomic,copy)NSString *orderType;

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *title;//标题
@property (nonatomic,copy)NSString *content;//内容
@property (nonatomic,copy)NSString *status;//状态
@property (nonatomic,copy)NSString *createTimeStr;//创建时间
@property (nonatomic,strong)NSArray *imgPath;//图片
@property (nonatomic,copy)NSString *mbMember;//会员对象
@property (nonatomic,copy)NSString *nickName;//昵称


@end
