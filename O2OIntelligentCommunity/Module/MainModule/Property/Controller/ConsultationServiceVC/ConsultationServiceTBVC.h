//
//  ConsultationServiceTBVC.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ConsultationType) {
    ConsultationTypeLegal = 1, //1:法务咨询
    ConsultationTypeFinancial, //2:财务咨询
    ConsultationTypeTax //3:税务咨询
};

#import "O2OBaseViewController.h"

@interface ConsultationServiceTBVC : O2OBaseViewController

@end
