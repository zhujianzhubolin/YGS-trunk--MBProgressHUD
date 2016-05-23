//
//  TopicDetailsViewController.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"
#import "HuaTiListModel.h"
#import "UMSocial.h"
//分享相关
#import "HYActivityView.h"
#import "QueryCommentModel.h"

typedef void(^CommentDetailChangeBLock)();


@interface TopicDetailsViewController : O2OBaseViewController
@property(nonatomic,strong)HuaTiListModel *huatiM;

//@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) HYActivityView *activityView;
@property (nonatomic, strong) CommentDetailChangeBLock commentChangeBlock;
@property (nonatomic, strong) QueryCommentModel *queryM;
@end
