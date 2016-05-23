//
//  AdTBViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "NoticeTBVC.h"
#import "NoticeCell.h"
#import "NoticeEntity.h"
#import "UITextField+wrapper.h"
#import "NoticeDetailVC.h"
#import "NoticeTBH.h"
#import <MJRefresh.h>
#import "UserManager.h"
#import "UIView+wrapper.h"
#import "ZJWebProgrssView.h"

@interface NoticeTBVC () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation NoticeTBVC
{
    IBOutlet UITableView *infoTableview;
    ZJWebProgrssView *progressV;
    NoticeTBH *noticeTBH;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:k_NOTI_COMMUNITY_CHANGE
                                                  object:nil];
}

- (void)isCommunityChange {
    noticeTBH.isNoticeNeedUpdate = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
    [progressV startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startNetwork:YES];
    });
    // Do any additional setup after loading the view.
}

- (void)initData {
    noticeTBH = [NoticeTBH new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isCommunityChange) name:k_NOTI_COMMUNITY_CHANGE object:nil];
}

- (void)initUI {
    self.title = @"小区公告";
    
    __block __typeof(self)weakSelf = self;
    
    [infoTableview addLegendHeaderWithRefreshingBlock:^{
        [weakSelf startNetwork:YES];
    }];
    
    [infoTableview addLegendFooterWithRefreshingBlock:^{
        [weakSelf startNetwork:NO];
    }];
    
    progressV = [[ZJWebProgrssView alloc] initWithFrame:infoTableview.bounds];
    [infoTableview addSubview:progressV];
    progressV.loadBlock = ^ {
        [weakSelf startNetwork:YES];
    };
}

- (void)startNetwork:(BOOL)isHeader {
        NoticeEntity *noticeTaskE = [NoticeEntity new];
        noticeTaskE.pageSize    = @"10";
        noticeTaskE.orderBy     = @"dateCreated";
        noticeTaskE.orderType   = @"desc";
        
        NoticeEntity *queryMapE = [NoticeEntity new];
        queryMapE.xqNo          = [UserManager shareManager].comModel.xqNo;
        queryMapE.noticeStatus  = @"1";
        
        NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:queryMapE.xqNo,@"xqNo",
                                                                                queryMapE.noticeStatus,@"noticeStatus",
                                     nil];
        noticeTaskE.queryMap = queryMapDic;
        
        [noticeTBH executeNoticeContentTaskWithUser:noticeTaskE success:^(id obj) {
            noticeTBH.isNoticeNeedUpdate = NO;
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:noticeTBH.noticeInfoArr]];
            [infoTableview reloadData];
            [AppUtils tableViewEndMJRefreshWithTableV:infoTableview];
        } failed:^(id obj) {
            [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA
                                isShow:self.viewIsVisible];
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:noticeTBH.noticeInfoArr]];
            [AppUtils tableViewEndMJRefreshWithTableV:infoTableview];
        }
        isHeader:isHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 158;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [AppUtils tableViewFooterPromptWithPNumber:noticeTBH.currentPage.integerValue
                                    withPCount:noticeTBH.pageCount.integerValue
                                     forTableV:tableView];
   return noticeTBH.noticeInfoArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeCell *cell = (NoticeCell *)[tableView dequeueReusableCellWithIdentifier:@"NoticeCellID"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeCell *noticeCell = (NoticeCell *)cell;
    NoticeEntity *entity = noticeTBH.noticeInfoArr[indexPath.section];
    [noticeCell reloadDataWithModel:entity];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *mainStoryB = [UIStoryboard storyboardWithName:@"MainTBViewController" bundle:nil];
    NoticeDetailVC *noticeDVC = [mainStoryB instantiateViewControllerWithIdentifier:@"NoticeDetailVCID"];
    NoticeEntity *entity = noticeTBH.noticeInfoArr[indexPath.section];
    noticeDVC.noticeE = entity;
    [self.navigationController pushViewController:noticeDVC animated:YES];
}

@end
