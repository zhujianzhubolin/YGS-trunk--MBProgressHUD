//
//  NoticeDetailVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "NoticeDetailVC.h"
#import "NoticeDHeaderV.h"
#import "NoticeDCell.h"
#import <MJRefresh.h>
#import "CommentHandle.h"
#import "SubmitCommentVC.h"
#import "UserManager.h"
#import "UMSocial.h"
#import "HYActivityView.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "ZJLongPressGesture.h"
#import "ReportVC.h"
#import "UIView+wrapper.h"
#import "ReportBtn.h"
#import "ZJWebProgrssView.h"

@interface NoticeDetailVC () <UITableViewDataSource,
                                UITableViewDelegate,
                                NoticeDHeaderVDelegate,
                                UMSocialUIDelegate,
                                UIScrollViewDelegate>

@property (nonatomic, strong) HYActivityView *activityView;

@end

@implementation NoticeDetailVC
{
    IBOutlet UITableView *infoTableView;
    NSMutableArray *commentArr;
    NSMutableArray *commentShowArr;
    NoticeDHeaderV *headerV;
    UITapGestureRecognizer *dismissReportTap;
    ZJWebProgrssView *progressV;
    CommentHandle *commentH;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
    
    if (commentH.isNeedRefresh) {
        [progressV startAnimation];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshData];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ReportBtn btnInstance] removeReportBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [progressV startAnimation];
    // Do any additional setup after loading the view.
}

- (void)refreshData {
    if (commentH.isNeedRefresh) {
        progressV.frame = CGRectMake(progressV.frame.origin.x,
                                     progressV.frame.origin.y,
                                     progressV.frame.size.width,
                                     infoTableView.contentSize.height);
        [progressV startAnimation];
        [self startNetworkIsHeader:YES];
    }
}

- (void)initData {
    commentArr = [NSMutableArray array];
    commentShowArr = [NSMutableArray array];
    commentH = [CommentHandle new];
}

- (void)initUI {
    self.title = @"详情";
    infoTableView.tableFooterView = [AppUtils tableViewsFooterView];
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButton.frame = CGRectMake(0, 0, 60, 30);
    rightBarButton.layer.cornerRadius = 3;
    [rightBarButton setTitle:@"分享" forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[AppUtils colorWithHexString:@"fc6d22"] forState:UIControlStateNormal];
    [rightBarButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBarButton addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];

    headerV = [[[NSBundle mainBundle] loadNibNamed:@"NoticeDHeaderV" owner:self options:nil] lastObject];
    headerV.delegate = self;
    [headerV reloadHeaderVDataWithModel:self.noticeE];
    headerV.frame = CGRectMake(0, 0, headerV.frame.size.width, headerV.contentHeight);
    infoTableView.tableHeaderView = headerV;
    [self viewDidLayoutSubviewsForTableView:infoTableView];
    
    __block __typeof(self)weakSelf = self;
    [infoTableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf startNetworkIsHeader:YES];
    }];
    
    [infoTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf startNetworkIsHeader:NO];
    }];
    
    [self setInfoTabFooter];
    dismissReportTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeReportBtn)];
    [self.view addGestureRecognizer:dismissReportTap];

    CGFloat propressHeight = self.view.frame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame)- headerV.contentHeight;
    if (propressHeight <= 100) {
        propressHeight = 100;
    }
    
    progressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(infoTableView.frame.origin.x,
                                                                   headerV.frame.size.height,
                                                                   infoTableView.frame.size.width,
                                                                   propressHeight)];
    [infoTableView addSubview:progressV];
    progressV.loadBlock = ^ {
        [weakSelf startNetworkIsHeader:YES];
    };
}

- (void)setInfoTabFooter {
    if ([NSArray isArrEmptyOrNull:commentShowArr]) {
        UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, infoTableView.frame.size.width, 100)];
        infoTableView.tableFooterView = footerV;
    }
    else {
        infoTableView.tableFooterView = [AppUtils tableViewsFooterView];
    }
    
    if (!progressV.isHidden) {
        [infoTableView bringSubviewToFront:progressV];
    }
}

- (void)removeReportBtn {
    [[ReportBtn btnInstance] removeReportBtn];
}

- (void)dealloc {
    [self.view removeGestureRecognizer:dismissReportTap];
}

- (void)startNetworkIsHeader:(BOOL)isHeader {
    CommentEntity *discussE = [CommentEntity new];
    
    discussE.pageNumber = commentH.currentPage;
    discussE.pageSize = @"10";
    discussE.orderBy = @"dateCreated";
    discussE.orderType = @"desc";
    
    CommentEntity *queryMapE = [CommentEntity new];
    queryMapE.complaintId = self.noticeE.idID;
    queryMapE.complaintType = @"NOTICE";
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 queryMapE.complaintId,@"complaintId",
                                 queryMapE.complaintType,@"complaintType",
                                 nil];

    discussE.queryMap = queryMapDic;
    [commentH executeCommentTaskWithUser:discussE success:^(id obj) {
        commentH.isNeedRefresh = NO;
        commentArr = (NSMutableArray *)obj;
        [commentShowArr removeAllObjects];
        
        [commentArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CommentEntity *commentE = (CommentEntity *)obj;
            if (![NSString isEmptyOrNull:commentE.status] && [commentE.status isEqualToString:@"0"]) {
                [commentShowArr addObject:commentE];
            }
        }];
       
        [AppUtils tableViewEndMJRefreshWithTableV:infoTableView];
        [headerV refreshCommentNum:commentShowArr.count];
        [infoTableView reloadData];
        [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:commentShowArr]];
        [self setInfoTabFooter];
    } failed:^(id obj) {
        commentH.isNeedRefresh = NO;
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA
                            isShow:self.viewIsVisible];
        [AppUtils tableViewEndMJRefreshWithTableV:infoTableView];
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:commentShowArr]];
    } isHeader:isHeader];
}

- (void)shareClick {
    [[ReportBtn btnInstance] removeReportBtn];
    UIImage *shareImg = [UIImage imageNamed:P_SHARE_IMAGE];
    NSString *shareURL = [NSString stringWithFormat:@"%@%@?id=%@",SHARE_API_HOST,SHARE_A_PATH_NOTICE_PATH,self.noticeE.idID];
    NSLog(@"shareURL = %@",shareURL);
    NSString *shareStr = nil;
    if (self.noticeE.noticeTitle.length > 0) {
        shareStr = [NSString stringWithFormat:@"%@公告:%@",[UserManager shareManager].comModel.xqName,self.noticeE.noticeTitle];
    }
    else {
        shareStr = [NSString stringWithFormat:@"%@公告",[UserManager shareManager].comModel.xqName];
    }
    
    if (!self.activityView) {
        self.activityView = [[HYActivityView alloc]initWithTitle:@"分享到" referView:[UIApplication sharedApplication].keyWindow];
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 2;
        ButtonView *bv = [[ButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"lfxinlangweibo"] handler:^(ButtonView *buttonView){
            NSLog(@"点击新浪微博");
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@:%@",shareStr,shareURL] shareImage:shareImg socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }];
        [self.activityView addButtonView:bv];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            [UMSocialQQHandler setQQWithAppId:P_APPID_QQ appKey:P_APPKEY_QQ url:shareURL];
            bv = [[ButtonView alloc]initWithText:@"QQ好友" image:[UIImage imageNamed:@"lfQQ"] handler:^(ButtonView *buttonView){
                NSLog(@"QQ");
                [UMSocialData defaultData].extConfig.qqData.title = P_NMAE;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareStr image:shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                }];
            }];
            [self.activityView addButtonView:bv];
        }
        
        if ([WXApi isWXAppInstalled]) {
            [UMSocialWechatHandler setWXAppId:P_APPID_WX appSecret:P_APPKEY_WX url:shareURL];
            bv = [[ButtonView alloc]initWithText:@"微信好友" image:[UIImage imageNamed:@"lfweixin"] handler:^(ButtonView *buttonView){
                NSLog(@"微信");
                [UMSocialData defaultData].extConfig.wechatSessionData.title = P_NMAE;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareStr image:shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                }];
                
            }];
            [self.activityView addButtonView:bv];
        }
        
        bv = [[ButtonView alloc]initWithText:@"短信" image:[UIImage imageNamed:@"lfduanxin"] handler:^(ButtonView *buttonView){
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:[NSString stringWithFormat:@"%@:%@",shareStr,shareURL] image:shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
            
        }];
        [self.activityView addButtonView:bv];
    }
    [self.activityView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentEntity *entity = commentShowArr[indexPath.row];
    return [NoticeDCell contentHeightForEntity:entity];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [AppUtils tableViewFooterPromptWithPNumber:commentH.currentPage.integerValue
                                    withPCount:commentH.pageCount.integerValue
                                     forTableV:tableView];
    return commentShowArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeDCell *cell = (NoticeDCell *)[tableView dequeueReusableCellWithIdentifier:@"noticeDCellID"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeDCell *noticeCell = (NoticeDCell *)cell;
    noticeCell.tag = indexPath.row + 1;
    noticeCell.deleteBlock = ^(NSString *idID) {
        [[ReportBtn btnInstance] removeReportBtn];
        [commentH executeDeleteCommentTaskWithUser:idID success:^(id obj) {
            commentH.isNeedRefresh = YES;
            [self refreshData];
        } failed:^(id obj) {
            [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA
                                isShow:self.viewIsVisible];
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:commentShowArr]];
        }];
    };
    
    ZJLongPressGesture *pressGesture = [[ZJLongPressGesture alloc] initWithTarget:self action:@selector(nilSymbol) toView:cell.contentView];
    pressGesture.pressBlock = ^{
        [self pushToReportVC:indexPath.row];
    };
    [cell.contentView addGestureRecognizer:pressGesture];
    
    CommentEntity *entity = commentShowArr[indexPath.row];
    [noticeCell reloadDataWithModel:entity withNum:commentShowArr.count - indexPath.row];
}

- (void)pushToReportVC:(NSUInteger)dataIndex {
    CommentEntity *entity = commentShowArr[dataIndex];
    ReportVC *reportVC = [ReportVC new];
    reportVC.idID = [NSNumber numberWithInt:entity.idID.intValue];

    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    [self.navigationController pushViewController:reportVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[ReportBtn btnInstance] removeReportBtn];
}

#pragma mark - NoticeDHeaderVDelegate
- (void)commentClickNextVC {
    UIStoryboard *mainStoryB = [UIStoryboard storyboardWithName:@"MainTBViewController" bundle:nil];
    SubmitCommentVC *submmitVC = [mainStoryB instantiateViewControllerWithIdentifier:@"SubmitCommentVCID"];
    submmitVC.commentBlock = ^{
        commentH.isNeedRefresh = YES;
    };
    submmitVC.idID = self.noticeE.idID;
    submmitVC.complaintType = @"sNOTICE";
    [self.navigationController pushViewController:submmitVC animated:YES];
}

@end
