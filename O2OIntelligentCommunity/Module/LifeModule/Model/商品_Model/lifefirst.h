//
//  lifefirst.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface lifefirst : BaseEntity


//传给后台的数据
//物业ID
@property (nonatomic,copy) NSNumber * companyId;
//小区ID
@property(nonatomic,copy) NSNumber * communityhouseId;
//广告位置类型
@property(nonatomic,copy) NSString * code;





//后台返回的数据小区广告
@property(nonatomic,copy) NSString * imageURL;
@property(nonatomic,copy) NSString * imageID;
@property(nonatomic,copy) NSString * imagename;
@property(nonatomic,copy) NSString * imagedescription;

//惠团购广告返回数据
@property(nonatomic,copy) NSString * htimageURL;
@property(nonatomic,copy) NSString * htimageID;
@property(nonatomic,copy) NSString * htimagename;
@property(nonatomic,copy) NSString * htimagedescription;

//开抢后台返回数据
@property(nonatomic,copy) NSString * kqimageURL;
@property(nonatomic,copy) NSString * kqimageID;
@property(nonatomic,copy) NSString * kqimagename;
@property(nonatomic,copy) NSString * kqimagedescription;



@end
