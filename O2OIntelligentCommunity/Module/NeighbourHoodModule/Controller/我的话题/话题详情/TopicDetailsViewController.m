//
//  TopicDetailsViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "TopicDetailsViewController.h"
#import "TopicDetailsCell.h"
#import "CommentViewControllr.h"
#import "UserManager.h"
#import <UIImageView+AFNetworking.h>
#import "MultiShowing.h"
#import "WebImage.h"
#import "WXApi.h"
#import <MJRefresh.h>
#import "CollectionViewImgCell.h"
#import "NeightbourHoodCell.h"
#import "UIView+wrapper.h"
#import "ZJWebProgrssView.h"
#import "ZJLongPressGesture.h"

//获取话题的评论列表类
#import "QueryCommentModel.h"
#import "QueryCommentHandler.h"
//删除评论接口类
#import "deleteCommentHandler.h"
#import "DeleteCommentModel.h"
//送鲜花接口类
#import "SongXianHuaModel.h"
#import "SongXianHuaHandler.h"
#import "ChangePostionButton.h"
#import "ZJLongPressGesture.h"
#import "ReportVC.h"

@interface TopicDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate,UIAlertViewDelegate,UIScrollViewDelegate>


@end

@implementation TopicDetailsViewController
{
    UITableView *infoTableV;
    NSArray *btnImgs;
    NSArray *btnTitles;
    NSMutableArray *commentArr;
    MultiShowing *multShow;
    
    NSInteger  butTag;
    
    QueryCommentHandler *queryCommentH;
    
    ZJWebProgrssView *progressV;
    
}

- (void)setHuatiM:(HuaTiListModel *)huatiM {
    _huatiM = huatiM;
    [self refreshUIForCommentCount:_huatiM.commentNumber.integerValue];
    [self refreshUIForFlowerCount:_huatiM.flowerCount.integerValue];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ReportBtn btnInstance] removeReportBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
    self.navigationController.navigationBar.translucent=YES;
    [self refreshData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
    [progressV startAnimation];
}

- (void)refreshData {
    if (queryCommentH.isUserCommentUpdate) {
        progressV.frame = CGRectMake(progressV.frame.origin.x,
                                     progressV.frame.origin.y,
                                     progressV.frame.size.width,
                                     infoTableV.contentSize.height);
        [progressV startAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startNetworkGetShopsIsHeader:YES];
        });
    }
}

-(void)initData
{
    btnTitles = [[NSArray alloc]initWithObjects:@"送鲜花",@"回复", nil];
    btnImgs = [[NSArray alloc]initWithObjects:@"hua.png",@"Pinglunnuber.png", nil];
    commentArr = [NSMutableArray array];
    queryCommentH= [QueryCommentHandler new];
}

-(void)initUI
{
    
    self.title=@"话题详情";
    self.view.backgroundColor=[UIColor whiteColor];

    infoTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:UITableViewStyleGrouped];
    infoTableV.dataSource =self;
    infoTableV.delegate =self;
    [infoTableV registerClass:[NeightbourHoodCell class] forCellReuseIdentifier:@"NeightbourHoodCellID"];
    [infoTableV registerClass:[TopicDetailsCell class] forCellReuseIdentifier:SYSTEM_CELL_ID];
    infoTableV.backgroundColor =[AppUtils colorWithHexString:COLOR_MAIN];
    //infoTableV.tableFooterView = [AppUtils tableViewsFooterView];
    
    __block __typeof(self)weakSelf = self;
    [infoTableV addLegendHeaderWithRefreshingBlock:^{//下拉刷新
        [weakSelf startNetworkGetShopsIsHeader:YES];
    }];
    
    [infoTableV addLegendFooterWithRefreshingBlock:^{//上拉加载更多
        [weakSelf startNetworkGetShopsIsHeader:NO];
    }];
    [self.view addSubview:infoTableV];

    NeightbourHoodCell *cell = [infoTableV dequeueReusableCellWithIdentifier:@"NeightbourHoodCellID"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.frame=CGRectMake(0, 0, IPHONE_WIDTH, cell.frame.size.height);
    cell.cellType=@"topicDetaols";
    infoTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [cell sethuatidic:self.huatiM isShowAll:YES];

    
    UIView *flowerAndReplyV = [self headerFlowerAndReplyView];
    flowerAndReplyV.frame = CGRectMake(cell.frame.origin.x, cell.frame.size.height, flowerAndReplyV.frame.size.width, flowerAndReplyV.frame.size.height);
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, cell.frame.size.height + flowerAndReplyV.frame.size.height)];
    [headerV addSubview:cell];
    [headerV addSubview:flowerAndReplyV];
    infoTableV.tableHeaderView = headerV;
    
    ZJLongPressGesture *pressGesture = [[ZJLongPressGesture alloc] initWithTarget:self action:@selector(nilSymbol) toView:cell.contentView];
    pressGesture.pressBlock = ^{
        [self pushToReportVC:_huatiM.ID.intValue];
    };
    [cell.contentView addGestureRecognizer:pressGesture];


    [self setInfoTabFooter];
    
    CGFloat progressVHeight = infoTableV.frame.size.height - headerV.frame.size.height - 60;
    
    if (progressVHeight < 100) {
        progressVHeight = 100;
    }
    
    progressV = [[ZJWebProgrssView alloc]initWithFrame:CGRectMake(0, headerV.frame.size.height, IPHONE_WIDTH, progressVHeight)];

    [infoTableV addSubview:progressV];
    
    progressV.loadBlock =^{
        [weakSelf startNetworkGetShopsIsHeader:YES];
    };
}

- (void)setInfoTabFooter {
//    if ([NSArray isArrEmptyOrNull:commentArr]) {
//        UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 150)];
//        infoTableV.tableFooterView = footerV;
//    }
//    else {
//        infoTableV.tableFooterView = [AppUtils tableViewsFooterView];
//    }
}

- (UIView *)headerFlowerAndReplyView{
    CGFloat interval = 15;
    CGFloat singleBtnWidth = (infoTableV.frame.size.width - (btnTitles.count + 1) * interval) / 2;
    CGFloat btnHeight = 40;
    
    UIView *eventButtomV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, infoTableV.frame.size.width, interval *2 + btnHeight)];
    eventButtomV.backgroundColor=[UIColor whiteColor];
    
    UIImageView *lineimgV =[[UIImageView alloc]initWithFrame:CGRectMake(0, eventButtomV.frame.size.height-interval+10, IPHONE_WIDTH, interval-10)];
    lineimgV.backgroundColor =[AppUtils colorWithHexString:@"D7D7D7"];
    [eventButtomV addSubview:lineimgV];
    
    for (int i = 0; i < btnTitles.count; i++)
    {
        ChangePostionButton *flowersBut=[[ChangePostionButton alloc] initWithFrame:CGRectMake(interval +  i *(interval + singleBtnWidth), interval-5, singleBtnWidth, btnHeight)];
        flowersBut.layer.cornerRadius = 3;
        flowersBut.tag = i + 100;
        flowersBut.backgroundColor=[AppUtils colorWithHexString:@"D7D7D7"];
        flowersBut.titleLabel.font=[UIFont systemFontOfSize:14];
        
        switch (i ) {
            case 0: {
                if (self.huatiM.flowerCount.integerValue > 99) {
                    [flowersBut setTitle:[NSString stringWithFormat:@"%@(%@+)",btnTitles[i],self.huatiM.flowerCount] forState:UIControlStateNormal];
                }
                else {
                    [flowersBut setTitle:[NSString stringWithFormat:@"%@(%@)",btnTitles[i],self.huatiM.flowerCount] forState:UIControlStateNormal];
                }
            }
                break;
            case 1: {
                if (self.huatiM.flowerCount.integerValue > 99) {
                    [flowersBut setTitle:[NSString stringWithFormat:@"%@(%@+)",btnTitles[i],self.huatiM.commentNumber] forState:UIControlStateNormal];
                }
                else {
                    [flowersBut setTitle:[NSString stringWithFormat:@"%@(%@)",btnTitles[i],self.huatiM.commentNumber] forState:UIControlStateNormal];
                }
            }
                break;
            default:
                break;
        }
        
        [flowersBut setImage:[UIImage imageNamed:btnImgs[i]] forState:UIControlStateNormal];
        [flowersBut setInternalPositionType:ButtonInternalLabelPositionRight spacing:5];
        [flowersBut addTarget:self action:@selector(butaselect:) forControlEvents:UIControlEventTouchUpInside];
        [eventButtomV addSubview:flowersBut];
    }
    return eventButtomV;
}

- (void)refreshUIForFlowerCount:(NSUInteger)flowerCount {
    ChangePostionButton *huabutton =(ChangePostionButton *)[self.view viewWithTag:100];
    if (self.huatiM.flowerCount.integerValue > 99) {
        [huabutton setTitle:[NSString stringWithFormat:@"%@(%lu+)",@"送鲜花",flowerCount] forState:UIControlStateNormal];
    }
    else {
        [huabutton setTitle:[NSString stringWithFormat:@"%@(%lu)",@"送鲜花",flowerCount] forState:UIControlStateNormal];
    }
    NSLog(@"%@",self.huatiM.commentNumber);
}

- (void)refreshUIForCommentCount:(NSUInteger)commentNumber {
    ChangePostionButton *commentbutton =(ChangePostionButton *)[self.view viewWithTag:101];
    if (self.huatiM.flowerCount.integerValue > 99) {
        [commentbutton setTitle:[NSString stringWithFormat:@"%@(%lu+)",@"回复",commentNumber] forState:UIControlStateNormal];
    }
    else {
        [commentbutton setTitle:[NSString stringWithFormat:@"%@(%lu)",@"回复",commentNumber] forState:UIControlStateNormal];
    }
}

- (void)startNetworkGetShopsIsHeader:(BOOL)isHeader{
    QueryCommentModel *queryM =[QueryCommentModel new];
    queryM.pageSize=@"5";
    queryM.orderBy = @"dateCreated";
    queryM.orderType = @"desc";
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 _huatiM.ID,@"complaintId",
                                 @"0",@"status",
                                 @"ACTIVITY",@"complaintType",
                                 nil];
    queryM.queryMap = queryMapDic;
    
    [queryCommentH queryTopicComment :queryM success:^(id obj) {
        queryCommentH.isUserCommentUpdate = NO;
        NSArray *recvArr =(NSArray *)obj;
        commentArr=[recvArr mutableCopy];
        [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:commentArr]];
        [AppUtils tableViewEndMJRefreshWithTableV:infoTableV];
        [infoTableV reloadData];
        [self setInfoTabFooter];
        [self refreshUIForCommentCount:commentArr.count];
    } failed:^(id obj) {
        queryCommentH.isUserCommentUpdate = YES;
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:commentArr]];
        [AppUtils tableViewEndMJRefreshWithTableV:infoTableV];
    } isHeader:isHeader];
}

-(void)imgTap:(UITapGestureRecognizer *)tap
{
    multShow =[[MultiShowing alloc]init];
    
    NSMutableArray *imgArr = [NSMutableArray array];
    [_huatiM.imgPath enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        WebImage *webImg = [WebImage new];
        webImg.url = obj;
        [imgArr addObject:webImg];
    }];
    
    [multShow ShowImageGalleryFromView:self.view ImageList:imgArr ImgType:ImgTypeFromWeb Scale:2.0];
}

-(void)butaselect:(UIButton *)but
{
    [[ReportBtn btnInstance] removeReportBtn];
    if (but.tag==100)
    {
        NSLog(@"送花");

        NSLog(@"activityType===%@",_huatiM.activityType);
        SongXianHuaModel *songhuaM =[SongXianHuaModel new];
        SongXianHuaHandler *songhuaH =[SongXianHuaHandler new];
        songhuaM.memberId =[UserManager shareManager].userModel.memberId;
        songhuaM.complaintType=@"ACTIVITY";
        songhuaM.activityId   =_huatiM.ID;
        [songhuaH SongHua:songhuaM success:^(id obj) {
            if (self.commentChangeBlock){
                self.commentChangeBlock();
            }
            [self refreshUIForFlowerCount:self.huatiM.flowerCount.integerValue +1];
            UIImageView *flowersImgV =[[UIImageView alloc]initWithFrame:CGRectMake(IPHONE_WIDTH/2-50, IPHONE_HEIGHT/2-50, 100, 100)];
            flowersImgV.image=[UIImage imageNamed:@"ic_flower_change"];
            flowersImgV.alpha = 0;
            [self.view addSubview:flowersImgV];
            
            [flowersImgV animateFadeOut:1.0f];
        } failed:^(id obj) {
            [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
        }];
    }
    else if (but.tag==101)
    {
        NSLog(@"回复");
        
        
        CommentViewControllr *comment = [[CommentViewControllr alloc]init];
        comment.huatiM =_huatiM;
        comment.complaintType=@"ACTIVITY";
        comment.isSwitchPage=CommentPageTopic;
        comment.pinlunBlock =^()
        {
            queryCommentH.isUserCommentUpdate=YES;
            if (self.commentChangeBlock) {
                self.commentChangeBlock();
            }
        };
        [self.navigationController pushViewController:comment animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[ReportBtn btnInstance] removeReportBtn];
}

#pragma mark UITableViewDeletge
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [AppUtils tableViewFooterPromptWithPNumber:queryCommentH.currentPage.integerValue
                                    withPCount:queryCommentH.pageCount.integerValue
                                     forTableV:infoTableV];
    return commentArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicDetailsCell *topCell = (TopicDetailsCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return topCell.frame.size.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[ReportBtn btnInstance] removeReportBtn];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    QueryCommentModel *queryM =commentArr[indexPath.section];
    [cell setCellData:queryM];
    
    cell.deleteBut.tag=indexPath.section;
    if (![queryM.memberId isEqualToString:[UserManager shareManager].userModel.memberId]) {
        cell.deleteBut.hidden=YES;
    }
    else
    {
        cell.deleteBut.hidden=NO;
    }
    [cell.deleteBut addTarget:self action:@selector(deletebutarr:) forControlEvents:UIControlEventTouchUpInside];
    
    ZJLongPressGesture *pressGesture = [[ZJLongPressGesture alloc] initWithTarget:self action:@selector(nilSymbol) toView:cell.contentView];
    pressGesture.pressBlock = ^{
        QueryCommentModel *entity = commentArr[indexPath.section];
        [self pushToReportVC:entity.ID.intValue];
    };
    [cell.contentView addGestureRecognizer:pressGesture];
    return cell;
}

- (void)pushToReportVC:(int)huatiID {
    ReportVC *reportVC = [ReportVC new];
    reportVC.idID = [NSNumber numberWithInt:huatiID];
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    [self.navigationController pushViewController:reportVC animated:YES];
}

-(void)deletebutarr:(UIButton *)button
{
    [[ReportBtn btnInstance] removeReportBtn];
    butTag=button.tag;
    UIAlertView *slerV =[[UIAlertView alloc]initWithTitle:nil message:@"亲,确认删除该评论吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [slerV show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",buttonIndex);
    if (buttonIndex==1)
    {
        QueryCommentModel *commentM =[commentArr objectAtIndex:butTag];
        DeleteCommentModel *huatiM =[DeleteCommentModel new];
        deleteCommentHandler *deleteH =[deleteCommentHandler new];
        huatiM.ID =commentM.ID;
        
        [deleteH deleteComment:huatiM success:^(id obj) {
            if (self.commentChangeBlock) {
                self.commentChangeBlock();
            }
            queryCommentH.isUserCommentUpdate=YES;
            [self refreshData];
            [self setInfoTabFooter];
            [AppUtils dismissHUD];
        } failed:^(id obj) {
            queryCommentH.isUserCommentUpdate=YES;
            [AppUtils tableViewEndMJRefreshWithTableV:infoTableV];
            [AppUtils showErrorMessage:obj
                                isShow:self.viewIsVisible];
        }];

    }
    
}

@end
