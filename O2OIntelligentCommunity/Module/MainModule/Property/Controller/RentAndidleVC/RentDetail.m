//
//  RentDetail.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//defaultImg_w

#import "RentDetail.h"
#import "DescCell.h"
#import "RentPinLunCell.h"
#import "UserManager.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import <UIImageView+AFNetworking.h>
//分享相关
#import "HYActivityView.h"
#import "PinLunLieBiao.h"
#import "PingLunList.h"
#import "PinLunModel.h"
#import <MJRefresh.h>
#import "MultiShowing.h"
#import "WebImage.h"
#import "WXApi.h"
#import "DeleteCommentModel.h"
#import "deleteCommentHandler.h"
#import "ZLPhotoPickerBrowserViewController.h"

//举报相关
#import "ZJLongPressGesture.h"
#import "ReportBtn.h"
#import "ReportVC.h"
#import "ZJWebProgrssView.h"

// 判断大小
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define ChatHeight 41.0

@interface RentDetail ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UMSocialUIDelegate,UIScrollViewDelegate,DeleteDetailPinLun,UIAlertViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource>
{
    
    __weak IBOutlet UITableView *myDetail;

    UIView * mylightBack;
    UIView * mybackView;
    
    UITextField * myinPutTextField;
    
    float _sendBackViewHeight;
    
    int viewwidth;
    
    int viewheight;
    
    CGFloat temHeight;
    
    UIScrollView * imageScrollView;
    
    UILabel * noticeLable;
    
    BOOL isHouse;
    
    NSMutableArray * pingLunListArray;
    
    __block int pageNum;
    
    NSMutableArray * myimageArray;
    
    UILabel * numLable;
    
    MultiShowing * multShow;
    
    NSString * pinglunIDinDetail;
    
    int currentPage;
    
    NSString * totalPage;
    
    ZJWebProgrssView *_progressV;

    
}
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) HYActivityView *activityView;

@end

@implementation RentDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"数据源>>>%@",_dataSocure);
    
    if (![_dataSocure[@"imgPath"] isEqual:[NSNull null]]) {
        myimageArray = _dataSocure[@"imgPath"];
    }
    pingLunListArray = [NSMutableArray array];
    pageNum = 1;
    
    if (VIEW_IPhone4_INCH) {
        viewwidth = 320;
        viewheight = 480;
    }else if (VIEW_IPhone5_INCH){
        viewwidth = 320;
        viewheight = 568;
    }else if (VIEW_IPhone6_INCH){
        viewwidth = 375;
        viewheight = 667;
    }else{
        viewwidth = 414;
        viewheight = 736;
    }
    
    
    #ifdef SmartComJYZX
    
    if (self.vcType == VCTypeRental) {
        self.title = @"房屋详情";
        isHouse = YES;
    }else{
        self.title = @"宝贝详情";
        isHouse = NO;
    }
    
    #elif SmartComYGS
    
    self.title = @"闲置详情";

    #else
        
    #endif
    
    __block __typeof(self)weakSelf = self;
    
    mylightBack = [[UIView alloc] initWithFrame:CGRectMake(0, viewheight - ChatHeight, viewwidth, ChatHeight)];
    mylightBack.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:mylightBack];
    
    
    mybackView = [[UIView alloc] initWithFrame:CGRectMake(5, 2, viewwidth -10, mylightBack.frame.size.height - 4)];
    mybackView.backgroundColor = [UIColor orangeColor];
    [mylightBack addSubview:mybackView];
    
    mybackView.layer.cornerRadius = 5;
    mybackView.clipsToBounds = YES;

    myinPutTextField = [[UITextField alloc] init];
    myinPutTextField.frame =CGRectMake(1, 1, mybackView.frame.size.width - 2, mybackView.frame.size.height - 2);
    myinPutTextField.font = [UIFont systemFontOfSize:14];
    myinPutTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    myinPutTextField.backgroundColor = [UIColor whiteColor];
    [myinPutTextField addSubview:noticeLable];
    myinPutTextField.delegate = self;
    myinPutTextField.placeholder = @"  给ta留言吧~";
    [mybackView addSubview:myinPutTextField];
    myinPutTextField.returnKeyType = UIReturnKeySend;
    
    
    myinPutTextField.layer.cornerRadius = 5;
    myinPutTextField.clipsToBounds = YES;
    
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    myinPutTextField.leftView = leftView;
    myinPutTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    if (myimageArray.count <= 0) {
        
        UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, CGFLOAT_MIN)];
        myDetail.tableHeaderView = headView;
        
    }else{
    
        //设置顶部图片
        UIView * imageBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,viewwidth, 150 *2)];
        myDetail.tableHeaderView = imageBackView;
        
        
        //滚动视图部分
        imageScrollView = [[UIScrollView alloc] initWithFrame:
                           CGRectMake(0, 0, viewwidth, imageBackView.frame.size.height)];
        imageScrollView.contentSize = CGSizeMake(viewwidth * myimageArray.count, imageBackView.frame.size.height);
        imageScrollView.pagingEnabled = YES;
        imageScrollView.delegate = self;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        [imageBackView addSubview:imageScrollView];
        
        
        if (myimageArray.count > 0) {
            for (int i = 0; i < myimageArray.count; i ++) {
                
                UIImageView * myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewwidth * i, 0, viewwidth, imageBackView.frame.size.height * 2)];
                
                [imageScrollView addSubview:myImageView];
                
                myImageView.tag = 10000 + i;
                myImageView.contentMode = UIViewContentModeScaleAspectFill;
                myImageView.clipsToBounds = YES;
                
                myImageView.image = [UIImage imageNamed:@"enLargeImg"];
                [myImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",myimageArray[i]]] placeholderImage:[UIImage imageNamed:@"enLargeImg"]];
                myImageView.userInteractionEnabled = YES;
                
                UITapGestureRecognizer * shouImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage)];
                [myImageView addGestureRecognizer:shouImage];
                
            }
            
            //显示当前页码的数量  numberInput
            UIImageView * numView = [[UIImageView alloc] initWithFrame:CGRectMake(viewwidth - 50, imageBackView.frame.size.height - 30, 35, 20)];
            numView.image = [UIImage imageNamed:@"numberInput"];
            [imageBackView addSubview:numView];
            
            numLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 25, 16)];
            [numView addSubview:numLable];
            numLable.font = [UIFont systemFontOfSize:13];
            numLable.textAlignment = NSTextAlignmentCenter;
            numLable.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)myimageArray.count];
            numLable.textColor = [UIColor whiteColor];
        }else{
            UIImageView * myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, viewwidth, imageBackView.frame.size.height)];
            [imageBackView addSubview:myImageView];
            myImageView.image = [UIImage imageNamed:@"enLargeImg"];
            myImageView.contentMode = UIViewContentModeScaleAspectFill;
            myImageView.clipsToBounds = YES;
        }
        
    }
    
   
    
    
    
    myDetail.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN,CGFLOAT_MIN)];
    myDetail.delegate = self;
    myDetail.dataSource = self;
    [self viewDidLayoutSubviewsForTableView:myDetail];
    
    if (isHouse) {
        UIBarButtonItem * rightbar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiang"] style:UIBarButtonItemStylePlain target:self action:@selector(sharedInfor)];
        self.navigationItem.rightBarButtonItem = rightbar;
    }
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissKeyBoard)];
    [self.view addGestureRecognizer:tap];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beginFreshUI) userInfo:nil repeats:NO];
    
    //下拉刷新
    [myDetail addLegendHeaderWithRefreshingBlock:^{
        pageNum = 1;
        [self getPinLunList:YES];
    }];
    
    [myDetail addLegendFooterWithRefreshingBlock:^{
        pageNum ++;
        NSLog(@"%d",pageNum);
        [self getPinLunList:NO];
    }];
    
    
    _progressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 100)];
    _progressV.loadBlock = ^{
        [weakSelf getPinLunList:YES];
    };
    _progressV.backgroundColor = [UIColor clearColor];
    myDetail.tableFooterView = _progressV;
    [_progressV startAnimation];

    [self reguestKeyBoard];
}

- (void)beginFreshUI{
    [myDetail.header beginRefreshing];
}

- (void)showBigImage{
    
    [[ReportBtn btnInstance] removeReportBtn];
    
    if ([myinPutTextField isFirstResponder]) {
        [myinPutTextField resignFirstResponder];
    }else{
        currentPage = (int)imageScrollView.contentOffset.x/viewwidth;
        ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
        pickerBrowser.dataSource = self;
        pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:currentPage inSection:0];
        // 展示控制器
        [pickerBrowser showPickerVc:self];
    }
}

//2、图片放大控件更换，需要设置代理；
#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return myimageArray.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj = [myimageArray objectAtIndex:indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    photo.toView = imageScrollView.subviews[currentPage];
    return photo;
}

//键盘注册通知
- (void)reguestKeyBoard{

    //键盘将要出现的时候调用
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasDisappear:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//键盘将要出现的时候
- (void)keyboardWasShown:(NSNotification*)paramNotification
{
    CGSize size = [[paramNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _sendBackViewHeight = size.height;
    [UIView animateWithDuration:0.000001 animations:^{
        mylightBack.frame = CGRectMake(0, HEIGHT - ChatHeight - size.height, WIDTH, ChatHeight);
    }];
}

//键盘将要消失的时候
- (void)keyboardWasDisappear:(NSNotification*)paramNotification{
    
    [UIView animateWithDuration:0.1 animations:^{
        mylightBack.frame = CGRectMake(0, HEIGHT - ChatHeight , WIDTH, ChatHeight);
    }];
    
}


//获取品论列表
- (void)getPinLunList:(BOOL)isRemoveData{
    
    PinLunLieBiao * model = [PinLunLieBiao new];
    PingLunList * handel = [PingLunList new];

    model.pageNumber = [NSString stringWithFormat:@"%d",pageNum];
    model.pageSize = @"5";
    model.status = @"0";
    model.orderType = @"desc";
    model.orderBy = @"dateCreated";
    model.memberid = [UserManager shareManager].userModel.memberId;
    model.complaintId = [NSString stringWithFormat:@"%@",_dataSocure[@"id"]];
    
    if (isHouse) {
        model.complaintType = @"HOUSESALE";
    }else{
        model.complaintType = @"FLEAMARKET";
    }
    
    if (isRemoveData) {
        [pingLunListArray removeAllObjects];
    }else{
    
    }
    [handel GetHousePingLUn:model success:^(id obj) {
        NSLog(@"评论列表数据>>>>>%@",obj);
        
        if (![obj[@"totalCount"] isEqual:[NSNull null]]) {
            totalPage = obj[@"totalCount"];
        }else{
            totalPage = @"0";
        }
        
        
        if (![obj[@"list"] isEqual:[NSNull null]]) {
            
            for (NSDictionary * dict in obj[@"list"]) {
                [pingLunListArray addObject:dict];
            }
            
            [_progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:pingLunListArray]];
            
            
            if (pingLunListArray.count > 0) {
                
                UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, CGFLOAT_MIN)];
                myDetail.tableFooterView = view;
                
            }
            
            [myDetail reloadData];
        }
        
        if ([myDetail.header isRefreshing]) {
            [myDetail.header endRefreshing];
        }
        
        if ([myDetail.footer isRefreshing]) {
            [myDetail.footer endRefreshing];
        }
        
    } failed:^(id obj) {
        if ([myDetail.header isRefreshing]) {
            [myDetail.header endRefreshing];
        }
        if ([myDetail.footer isRefreshing]) {
            [myDetail.footer endRefreshing];
        }
        
        [_progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:pingLunListArray]];
        
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA];
    }];
}

//发布新评论
- (void)addNewPinLun{
    
    NSString * upStr = [myinPutTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (upStr.length <= 0) {
        [AppUtils showErrorMessage:@"评论内容不能为空!"];
        return;
    }
    PinLunListModel * model = [PinLunListModel new];
    PingLunList * list = [PingLunList new];
    model.merberId = [UserManager shareManager].userModel.memberId;
    model.complaintId = [NSString stringWithFormat:@"%@",_dataSocure[@"id"]];
    if (isHouse) {
        model.complaintType = @"HOUSESALE";
    }else{
        model.complaintType = @"FLEAMARKET";
    }
    model.content = myinPutTextField.text;
    [list AddPingLun:model success:^(id obj) {
        NSLog(@"新评论发布记过>>>>%@",obj);

        if ([obj[@"code"] isEqualToString:@"success"]) {

            [myDetail.header beginRefreshing];
            myinPutTextField.text = @"";
            noticeLable.text = @"给ta留言吧~";
            
            [AppUtils showAlertMessageTimerClose:@"亲爱的,谢谢您的评价!"];
            
        }else{
            [self alertMessage:[NSString stringWithFormat:@"%@",obj[@"message"]]];
        }
    } failed:^(id obj) {
        [self alertMessage:@"评论发布失败"];
        myinPutTextField.text = @"";
        noticeLable.text = @"给ta留言吧~";

    }];
}



- (void)sharedInfor{

    UIImage *shareImg = [UIImage imageNamed:P_SHARE_IMAGE];
    NSString *shareURL = [NSString stringWithFormat:@"%@%@?id=%@",SHARE_API_HOST,SHARE_API_RENTAL_HOST,_dataSocure[@"id"]];
    NSLog(@"%@",shareURL);
    NSString *shareStr = nil;
    if (_dataSocure[@"title"] > 0) {
        shareStr = [NSString stringWithFormat:@"租售:%@",_dataSocure[@"title"]];
    }
    else {
        shareStr = @"租售";
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
            NSLog(@"install--安装");
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
        }else{
            NSLog(@"no---没安装");
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


// 这是一种很好的键盘下移方式

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (![AppUtils isNotLanguageEmoji]) {
        return NO;
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if ([string isEqualToString:@"\n"]) {
        
        [[ReportBtn btnInstance] removeReportBtn];

        //发布品论
        [self addNewPinLun];
        [self disMissKeyBoard];
        return NO;
    }
    return YES;
    
}


- (void)disMissKeyBoard{
    if ([myinPutTextField isFirstResponder]) {
        [myinPutTextField resignFirstResponder];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return pingLunListArray.count +1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [AppUtils tableViewFooterPromptWithPNumber:pageNum withPCount:[totalPage intValue] forTableV:myDetail];

    
    if (indexPath.section == 0) {

        NSString *text = _dataSocure[@"activityContent"];
        CGSize constraint = CGSizeMake(viewwidth - (8 * 2), 20000.0f);
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:text
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        CGFloat height = MAX(size.height + 95, 120);
        
        return height + (10 * 2);
        
    }else{
        
        NSString *text;

        if (pingLunListArray.count > 0) {
            
            text = pingLunListArray[indexPath.section - 1][@"content"];
            
        }else{
            
            text = @"";
        }
        
        CGSize constraint = CGSizeMake(viewwidth - (8 * 3) -74, 20000.0f);
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:text
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        CGFloat height = MAX(size.height + 30, 80);
        
        return height + (10 * 2);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        DescCell * desc = [tableView dequeueReusableCellWithIdentifier:@"descCell"];
        if (desc == nil) {
            desc = [[[NSBundle mainBundle] loadNibNamed:@"DescCell" owner:self options:nil] lastObject];
        }
        return desc;
        
    }else{
        RentPinLunCell * pin = [tableView dequeueReusableCellWithIdentifier:@"descCell1"];
        if (pin == nil) {
            pin = [[[NSBundle mainBundle] loadNibNamed:@"RentPinLunCell" owner:self options:nil] lastObject];
        }
        return pin;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DescCell * desc = (DescCell *)cell;

        ZJLongPressGesture *pressGesture = [[ZJLongPressGesture alloc] initWithTarget:self action:@selector(nilSymbol) toView:desc.contentView];
        pressGesture.pressBlock = ^{
            [self pushToReportVC:indexPath.row];
        };
        [desc.contentView addGestureRecognizer:pressGesture];
        [desc setCellData:_dataSocure];
    }else{
        RentPinLunCell * pin = (RentPinLunCell *)cell;
        pin.mydelete = self;
        
        if (pingLunListArray.count > 0) {
            [pin setCellData:[pingLunListArray objectAtIndex:indexPath.section -1]];
        }
        
        ZJLongPressGesture *pressGesture = [[ZJLongPressGesture alloc] initWithTarget:self action:@selector(nilSymbol) toView:pin.contentView];
        pressGesture.pressBlock = ^{
            [self pushToReportVC1:indexPath.section -1];
        };
        [pin.contentView addGestureRecognizer:pressGesture];
    }
}

//举报话题
- (void)pushToReportVC:(NSUInteger)dataIndex {
    ReportVC *reportVC = [ReportVC new];
    reportVC.idID = [NSNumber numberWithInt:[_dataSocure[@"id"] intValue]];
    
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    [self.navigationController pushViewController:reportVC animated:YES];
}
//举报评论
- (void)pushToReportVC1:(NSUInteger)dataIndex {
    ReportVC *reportVC = [ReportVC new];
    reportVC.idID = [NSNumber numberWithInt:[pingLunListArray[dataIndex][@"id"] intValue]];
    
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    [self.navigationController pushViewController:reportVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[ReportBtn btnInstance] removeReportBtn];
}



//删除品论
- (void)delteMyPinLun:(NSString *)pinlunID{

    //举报按钮存在，就取消他
    [[ReportBtn btnInstance] removeReportBtn];

    
    pinglunIDinDetail = pinlunID;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除该评论?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
            DeleteCommentModel *huatiM =[DeleteCommentModel new];
            deleteCommentHandler *deleteH =[deleteCommentHandler new];
            huatiM.ID = pinglunIDinDetail;
        
            [deleteH deleteComment:huatiM success:^(id obj) {
        
                [AppUtils showSuccessMessage:obj];
        
                [myDetail.header beginRefreshing];
        
            } failed:^(id obj) {
                [AppUtils showAlertMessageTimerClose:@"删除评论失败!"];
                [myDetail.header beginRefreshing];
        
            }];
    }
}

//删除评论实际操作
//- (void)deletePinLunAfterAlert:(NSString )

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    numLable.text = [NSString stringWithFormat:@"%d/%lu",(int)scrollView.contentOffset.x/viewwidth + 1,(unsigned long)myimageArray.count];
}


//提示框
- (void)alertMessage:(NSString *)message{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

//动态计算TextView高度
- (float)heightForString:(UITextView *)addTextView fontSize:(float)fontSize andWidth:(float)width
{
    addTextView.font = [UIFont systemFontOfSize:fontSize];
    CGSize deSize = [addTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

@end
