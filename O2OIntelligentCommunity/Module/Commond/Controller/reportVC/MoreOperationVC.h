//
//  MoreOperationVC.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/2/2.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

typedef NS_ENUM(NSUInteger,ReportType) {
    ReportTypeContent,
    ReportTypeUser
};

typedef void (^ReportSucBlock)();

#import "O2OBaseViewController.h"

@interface MoreOperationVC : O2OBaseViewController
@property (nonatomic, strong) ReportSucBlock commentBlock;

@property (nonatomic,copy) NSString *auditId;
@property (nonatomic,copy) NSNumber *idID;
@property (nonatomic,assign) ReportType reportType;

@end
