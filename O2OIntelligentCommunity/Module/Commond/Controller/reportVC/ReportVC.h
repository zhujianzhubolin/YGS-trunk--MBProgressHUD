//
//  ReportVC.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/11/25.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

typedef void (^ReportSucBlock)();

#import "O2OBaseViewController.h"

@interface ReportVC : O2OBaseViewController
@property (nonatomic, strong) ReportSucBlock commentBlock;

@property (nonatomic,copy) NSString *auditId;
@property (nonatomic,copy) NSNumber *idID;

@end
