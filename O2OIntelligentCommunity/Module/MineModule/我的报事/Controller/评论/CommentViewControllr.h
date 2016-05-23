//
//  CommentViewControllr.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"
#import "HuaTiListModel.h"

typedef void(^PingLunChenggongBLock)();


@interface CommentViewControllr : O2OBaseViewController<UITextViewDelegate>

@property(nonatomic,assign)CommentPage isSwitchPage;//判断是哪个界面调用
@property(nonatomic,strong)HuaTiListModel *huatiM;//话题评论
@property (nonatomic, strong) PingLunChenggongBLock pinlunBlock;//切换小区后的block


//报修和投诉的评论
@property(nonatomic,copy)NSString *idID;//要评论的话题Id
@property(nonatomic,copy)NSString *complaintType;//要评论的话题type






@end
