//
//  SubmitCommentVC.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

typedef void (^CommentSucBlock)();
#import "BaseTableViewController.h"

@interface SubmitCommentVC : BaseTableViewController
@property (nonatomic, strong) CommentSucBlock commentBlock;
@property (nonatomic,copy) NSNumber *idID;
@property (nonatomic,copy) NSString *complaintType;
@end
