//
//  ZYCommentDetailsVC.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/4/18.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//
typedef void(^SonghuaisPingLunSuccessBlock)();

#import "O2OBaseViewController.h"
#import "UMSocial.h"
#import "HuaTiListModel.h"

@interface ZYCommentDetailsVC : O2OBaseViewController
@property(nonatomic,strong)HuaTiListModel *huatiM;
@property(nonatomic,strong)SonghuaisPingLunSuccessBlock caozuoBlock;


@end
