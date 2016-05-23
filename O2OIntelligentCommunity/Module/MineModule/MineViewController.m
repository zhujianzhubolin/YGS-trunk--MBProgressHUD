//
//  MineviewController.m
//  O2OIntelligentCommuni
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#define M_TEXT_SIZE  14
#define M_NUM_SIZE  17

#import "MineviewController.h"
#import "BuyViewController.h"
#import "JiaoFeiVC.h"
#import "OpenMoneyBagVC.h"
#import "MoneyBagVC.h"
#import "RepairsViewController.h"
#import "CollectionViewtroller.h"
#import "MovePublicClubViewController.h"
#import "CommunityViewCotroller.h"
#import "PersonalinfoViewController.h"
#import "SetViewController.h"
#import "UserManager.h"
#import "ShoppingCar.h"
#import "RentalVC.h"
#import "VoucherVC.h"

//#import <UIButton+AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "AddNewAdress.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

#ifdef SmartComJYZX
#elif SmartComYGS
#import "HoneyVC.h"
#import "ZYXiaoMiPlayerVC.h"
#else

#endif



#import "UserEntity.h"
#import "UserHandler.h"

@implementation MineViewController
{
    NSArray *textArray;
    NSArray *iconGroup1Array;
    NSArray *iconGroup2Array;
    NSArray *nameGroup1Array;
    NSArray *nameGroup2Array;
    
    NSMutableArray *allVoucherList; //代金卷
    
    UIButton * qianbao;
    UIButton * fengmi;
    UIButton * daijinquan;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar];
    [self refreshUI];
    [self freshDataBeeAndQianBao];
    self.navigationController.navigationBar.translucent=YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getUserData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    __weak __typeof(self)weakSelf = self;
    [self.navigationItem addRightItemWithImgName:@"seting" action:^{
        [weakSelf SetArr];
    }];
    //titleArr = [[NSArray alloc]initWithObjects:@"钱包",@"蜂蜜", nil];
    allVoucherList = [NSMutableArray array];
    [self initUI];
}

//获取用户信息
-(void)getUserData
{
    [UserHandler executeGetUserInfoSuccess:^(id obj) {
    } failed:^(id obj) {
    }];
}

//刷新钱包蜂蜜数据
- (void)freshDataBeeAndQianBao{
    [UserHandler executeGetUserInfoSuccess:^(id obj) {
        [self reSetUI];
    } failed:^(id obj) {
        [self reSetUI];
    }];
}

- (void)reSetUI{
    NSString * qianBaoMoney;
    NSString * fengMiMoney ;
    NSString * daijinMoney ;
    if ([NSString isEmptyOrNull:[UserManager shareManager].userModel.tradeMenoy] && [[UserManager shareManager].userModel.tradeMenoy intValue] <= 0){
        qianBaoMoney = @"点击开通\n钱包";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",qianBaoMoney]];
        [qianbao setAttributedTitle:[[self resetAttributedStr:str textLength:0] copy]
                           forState:UIControlStateNormal];
    }
    else{
        qianBaoMoney = [NSString stringWithFormat:@"%@元\n钱包",[UserManager shareManager].userModel.tradeMenoy];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",qianBaoMoney]];
        [qianbao setAttributedTitle:[[self resetAttributedStr:str textLength:3] copy]
                           forState:UIControlStateNormal];
    }
    
    if ([NSString isEmptyOrNull:[UserManager shareManager].userModel.integral]){
        fengMiMoney = @"0";
    }
    else{
        fengMiMoney =[UserManager shareManager].userModel.integral;
    }
    
    if ([NSString isEmptyOrNull:[UserManager shareManager].userModel.optCounter]){
        daijinMoney = @"0";
    }
    else{
        daijinMoney =[UserManager shareManager].userModel.optCounter;
    }
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@滴\n蜂蜜",fengMiMoney]];
    [fengmi setAttributedTitle:[[self resetAttributedStr:str1 textLength:2] copy] forState:UIControlStateNormal];
    
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@张\n代金券",daijinMoney]];
    [daijinquan  setAttributedTitle:[[self resetAttributedStr:str2 textLength:3] copy] forState:UIControlStateNormal];
}

- (NSMutableAttributedString *)resetAttributedStr:(NSMutableAttributedString *)str
                                       textLength:(NSUInteger)textlength{
    NSRange numRange = NSMakeRange(0,str.length - (textlength + 1));
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:numRange];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:M_NUM_SIZE] range:numRange];
    
    NSRange strRange = NSMakeRange(str.length - textlength ,textlength);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:strRange];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:M_TEXT_SIZE] range:strRange];
    return str;
}

- (void)refreshUI {
    UIImageView *headimageV = (UIImageView *)[self.view viewWithTag:201];
    [headimageV setImageWithURL:[NSURL URLWithString:[UserManager shareManager].userModel.photoUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];

    UILabel *nameLabe = (UILabel *)[self.view viewWithTag:202];
    nameLabe.text = [UserManager shareManager].userModel.nickName;
    
    UILabel *isofficialUserLable = (UILabel *)[self.view viewWithTag:3];
    if ([UserManager shareManager].isBinding) {
        isofficialUserLable.text = @"小区住户";
    }
    else {
        isofficialUserLable.text = @"正式用户";
    }
}

-(void)initUI
{
    self.view.backgroundColor = [AppUtils colorWithHexString:@"eeeeea"];
    CGFloat tuxiangImgHigth =60;
#ifdef SmartComJYZX
    CGFloat headViewHigth =140;
#elif SmartComYGS
    CGFloat headViewHigth =195;
#else
    
#endif
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headViewHigth)];
    headView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UIImageView *backimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headView.frame.size.height)];
    backimage.image=[UIImage imageNamed:@"myHeadView.png"];
    [headView addSubview:backimage];
    UIImageView *tuxiangImg = [[UIImageView alloc]init];
    
#ifdef SmartComJYZX
    tuxiangImg.frame=CGRectMake(self.view.frame.size.width/2-80, (backimage.frame.size.height-tuxiangImgHigth)/2, tuxiangImgHigth, tuxiangImgHigth);
#elif SmartComYGS
    tuxiangImg.frame=CGRectMake(self.view.frame.size.width/2-80, (backimage.frame.size.height-tuxiangImgHigth -55)/2, tuxiangImgHigth, tuxiangImgHigth);
#else
    
#endif
    
    tuxiangImg.tag = 201;
    tuxiangImg.layer.cornerRadius = tuxiangImg.frame.size.height / 2;
    tuxiangImg.contentMode=UIViewContentModeScaleAspectFill;
    tuxiangImg.layer.masksToBounds = YES;
    [tuxiangImg setImageWithURL:[NSURL URLWithString:[UserManager shareManager].userModel.photoUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    tuxiangImg.userInteractionEnabled=YES;
    [headView addSubview:tuxiangImg];
    
    UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Clickedimg:)];
    [headView addGestureRecognizer:Tap];
    
    CGFloat nameLabWidth = 140,nameLabHigth = 30;
    
#ifdef SmartComJYZX
    UILabel *nameLabe = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, (backimage.frame.size.height-tuxiangImgHigth)/2+tuxiangImgHigth/2-nameLabHigth, nameLabWidth, nameLabHigth)];
#elif SmartComYGS
    UILabel *nameLabe = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, (backimage.frame.size.height-tuxiangImgHigth -55)/2+tuxiangImgHigth/2-nameLabHigth, nameLabWidth, nameLabHigth)];
#else
    
#endif
    
    nameLabe.tag = 202;
    //    nameLabe.text= [UserManager shareManager].alias;
    nameLabe.textColor=[UIColor blackColor];
    [headView addSubview:nameLabe];
    
    UILabel *isofficialUserLable =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, CGRectGetMaxY(nameLabe.frame), nameLabWidth, nameLabHigth)];
    isofficialUserLable.tag = 3;
    //    isofficialUserLable.text=[UserManager shareManager].role;
    isofficialUserLable.textColor=[UIColor grayColor];
    [headView addSubview:isofficialUserLable];
    
#ifdef SmartComJYZX
    
#elif SmartComYGS
    
    //添加一个背景View
    UIView * tBackView = [[UIView alloc] initWithFrame:CGRectMake(0, headViewHigth - 55, IPHONE_WIDTH, 55)];
    tBackView.backgroundColor = [AppUtils colorWithHexString:@"EDEFEB"];
    [headView addSubview:tBackView];
    NSString * qianBaoMoney = [UserManager shareManager].userModel.tradeMenoy;
    NSString * fengMiMoney = [UserManager shareManager].userModel.integral;
    NSString * daijinMoney = [UserManager shareManager].userModel.optCounter;
    NSMutableAttributedString *str;
    
    if([NSString isEmptyOrNull:qianBaoMoney] || [qianBaoMoney intValue] <= 0)
    {
        str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@点击开通\n钱包",qianBaoMoney]];
        ;
    }
    else
    {
        str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元\n钱包",qianBaoMoney]];
        ;
    }
    qianbao = [UIButton buttonWithType:UIButtonTypeCustom];
    qianbao.frame = CGRectMake(0, 0, IPHONE_WIDTH/3 -1, 55);
    qianbao.backgroundColor = [UIColor whiteColor];
    [qianbao setAttributedTitle:[[self resetAttributedStr:str textLength:2] copy]
                       forState:UIControlStateNormal];
    qianbao.titleLabel.numberOfLines=2;
    qianbao.titleLabel.textAlignment = NSTextAlignmentCenter;
    qianbao.titleLabel.minimumScaleFactor=6;
    [qianbao addTarget:self action:@selector(gotoQianBao) forControlEvents:UIControlEventTouchUpInside];
    [tBackView addSubview:qianbao];
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@滴\n蜂蜜",fengMiMoney]];
    
    fengmi = [UIButton buttonWithType:UIButtonTypeCustom];
    fengmi.frame = CGRectMake(IPHONE_WIDTH/3, 0, IPHONE_WIDTH/3-1, 55);
    fengmi.backgroundColor = [UIColor whiteColor];
    [fengmi setAttributedTitle:[[self resetAttributedStr:str1 textLength:2] copy]
                      forState:UIControlStateNormal];
    fengmi.titleLabel.numberOfLines=2;
    fengmi.titleLabel.textAlignment = NSTextAlignmentCenter;
    fengmi.titleLabel.minimumScaleFactor=6;
    [fengmi addTarget:self action:@selector(gotoFengMi) forControlEvents:UIControlEventTouchUpInside];
    [tBackView addSubview:fengmi];
    
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"代金券:%@张",daijinMoney]];
    daijinquan = [UIButton buttonWithType:UIButtonTypeCustom];
    daijinquan.frame = CGRectMake(IPHONE_WIDTH/3*2, 0, IPHONE_WIDTH/3, 55);
    daijinquan.backgroundColor = [UIColor whiteColor];
    [daijinquan setAttributedTitle:[[self resetAttributedStr:str2 textLength:3] copy]
                          forState:UIControlStateNormal];
    daijinquan.titleLabel.numberOfLines=2;
    daijinquan.titleLabel.textAlignment = NSTextAlignmentCenter;
    daijinquan.titleLabel.minimumScaleFactor=6;
    [daijinquan addTarget:self action:@selector(gotoDaiJinQuan) forControlEvents:UIControlEventTouchUpInside];
    [tBackView addSubview:daijinquan];
    
#else
    
#endif
    
    _TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _TableView.dataSource=self;
    _TableView.delegate=self;
    _TableView.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
    //_TableView.separatorStyle = UITableViewCellAccessoryNone;
    _TableView.showsVerticalScrollIndicator =NO;
    _TableView.tableHeaderView=headView;
    _TableView.tableFooterView=[AppUtils tableViewsFooterView];
    
    [self viewDidLayoutSubviewsForTableView:_TableView];
    [self.view addSubview:_TableView];
    
}

//前往钱包页面
- (void)gotoQianBao{
    
    if ([[UserManager shareManager].userModel.isCardActivate isEqualToString:@"1"])//开通钱包
    {
        MoneyBagVC *money =[[MoneyBagVC alloc]init];
        money.navigationItem.backBarButtonItem=[AppUtils navigationBackButtonWithNoTitle];
        [self.navigationController pushViewController:money animated:YES];
    }
    else if ([[UserManager shareManager].userModel.isCardActivate isEqualToString:@"0"])//没有开通钱包
    {
        OpenMoneyBagVC *monebay =[[OpenMoneyBagVC alloc]init];
        
        [self.navigationController pushViewController:monebay animated:YES];
    }
    else
    {
        [AppUtils showAlertMessageTimerClose:@"未获取到钱包信息"];
    }
}

#ifdef SmartComJYZX
#elif SmartComYGS
//前往蜂蜜页面
- (void)gotoFengMi{
    HoneyVC *honeVC =[[HoneyVC alloc]init];
    [self.navigationController pushViewController:honeVC animated:YES];
}

//前往代金券
-(void)gotoDaiJinQuan
{
    VoucherVC *vouchvc =[VoucherVC new];
    [self.navigationController pushViewController:vouchvc animated:YES];
}

#else

#endif

-(void)Clickedimg:(UITapGestureRecognizer *)recognizer
{
    PersonalinfoViewController *personaalin = [[PersonalinfoViewController alloc]init];
    [self.navigationController pushViewController:personaalin animated:YES];
}

-(void)SetArr
{
    SetViewController *set =[[SetViewController alloc]init];
    [self.navigationController pushViewController:set animated:YES];
}

- (void)shareClick {
    UIImage *shareImg       = [UIImage imageNamed:P_SHARE_IMAGE];
    NSString *shareURL      = P_DOWNLOAD_LINK;
    NSString *shareTitle    = P_NMAE;
    NSString *shareContent  = [NSString stringWithFormat:@"欢迎来到%@，神一样的APP，神一样的功能！",P_NMAE];
    
    if (!self.activityView) {
        self.activityView = [[HYActivityView alloc]initWithTitle:@"分享到" referView: [UIApplication sharedApplication].keyWindow];
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 2;
        ButtonView *bv = [[ButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"lfxinlangweibo"] handler:^(ButtonView *buttonView){
            
            [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"%@:%@",shareContent,shareURL] shareImage:shareImg socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }];
        [self.activityView addButtonView:bv];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            [UMSocialQQHandler setQQWithAppId:P_APPID_QQ appKey:P_APPKEY_QQ url:shareURL];
            bv = [[ButtonView alloc]initWithText:@"QQ好友" image:[UIImage imageNamed:@"lfQQ"] handler:^(ButtonView *buttonView){
                NSLog(@"QQ");
                [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareContent image:shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
                [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareContent image:shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                    
                }];
                
            }];
            [self.activityView addButtonView:bv];
        }
        
        bv = [[ButtonView alloc]initWithText:@"短信" image:[UIImage imageNamed:@"lfduanxin"] handler:^(ButtonView *buttonView){
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:[NSString stringWithFormat:@"%@:%@",shareContent,shareURL] image:shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];

        }];
        [self.activityView addButtonView:bv];
    }
    [self.activityView show];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
#ifdef SmartComJYZX
    switch (section){
        case 0:
            return 5;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
#elif SmartComYGS
    
    #ifdef BETA
        switch (section){
            case 0:
                return 4;
                break;
            case 1:
                return 2;
                break;
            case 2:
                return 2;
                break;
            case 3:
                return 0;
                break;
                
            default:
                return 0;
                break;
        }
    #else
        switch (section){
            case 0:
                return 4;
                break;
            case 1:
                return 1;
                break;
            case 2:
                return 2;
                break;
            case 3:
                return 2;
                break;
                
            default:
                return 0;
                break;
        }

    #endif

#else
    
#endif
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vw =[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 10)];
    vw.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    return vw;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
#ifdef SmartComJYZX
    static NSString *cellidentifier =@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell==nil){
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section==0){
        if (indexPath.row==0){
            cell.imageView.image=[UIImage imageNamed:@"moneybag"];
            cell.textLabel.text=@"钱包";
        }
        else if (indexPath.row==1){
            cell.imageView.image=[UIImage imageNamed:@"mineshopcar"];
            cell.textLabel.text=@"购物车";
        }
        else if (indexPath.row==2){
            cell.imageView.image=[UIImage imageNamed:@"pay"];
            cell.textLabel.text=@"订单";
        }
        else if (indexPath.row==3){
            cell.imageView.image=[UIImage imageNamed:@"thewallet"];
            cell.textLabel.text=@"缴费";
        }
        else if (indexPath.row==4){
            cell.imageView.image=[UIImage imageNamed:@"collection"];
            cell.textLabel.text=@"收藏";
        }
    }
    else if (indexPath.section==1){
        if (indexPath.row==0){
            cell.imageView.image=[UIImage imageNamed:@"rental"];
            cell.textLabel.text=@"租售";
        }
        else if (indexPath.row==1){
            cell.imageView.image=[UIImage imageNamed:@"idle"];
            
            cell.textLabel.text=@"宝贝";
        }
        else if (indexPath.row==2){
            cell.imageView.image=[UIImage imageNamed:@"theorder"];
            cell.textLabel.text=@"报事";
        }
    }
    else if (indexPath.section==2){
        if (indexPath.row==0){
            cell.imageView.image=[UIImage imageNamed:@"community"];
            cell.textLabel.text=@"我的小区";
        }
        else if (indexPath.row==1){
            cell.imageView.image=[UIImage imageNamed:@"neighbor"];
            cell.textLabel.text=@"邀请邻居";
        }
    }
    else if (indexPath.section==3){
        if (indexPath.row==0){
            cell.imageView.image=[UIImage imageNamed:@"p_mine_JYZX_24"];
            cell.textLabel.text=[NSString stringWithFormat:@"关于%@",P_NMAE];
        }
    }
    return cell;

#elif SmartComYGS
    
    static NSString *cellidentifier =@"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell==nil){
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section==0){
        if (indexPath.row==0){
            cell.imageView.image=[UIImage imageNamed:@"mineshopcar"];
            cell.textLabel.text=@"购物车";
        }
        else if (indexPath.row==1){
            cell.imageView.image=[UIImage imageNamed:@"pay"];
            cell.textLabel.text=@"订单";
        }
        else if (indexPath.row==2){
            cell.imageView.image=[UIImage imageNamed:@"thewallet"];
            cell.textLabel.text=@"缴费";
        }
        else if (indexPath.row==3){
            cell.imageView.image=[UIImage imageNamed:@"collection"];
            cell.textLabel.text=@"收藏";
        }
    }
    #ifdef BETA
        else if (indexPath.section==1){
            
            if (indexPath.row==0){
                cell.imageView.image=[UIImage imageNamed:@"idle"];
                cell.textLabel.text=@"闲置";
            }
            if (indexPath.row==1){
                cell.imageView.image=[UIImage imageNamed:@"theorder"];
                cell.textLabel.text=@"报事";
            }
            
        }
        else if (indexPath.section==2){
            if (indexPath.row==0){
                cell.imageView.image=[UIImage imageNamed:@"community"];
                cell.textLabel.text=@"我的小区";
            }
            else if (indexPath.row==1){
                cell.imageView.image=[UIImage imageNamed:@"neighbor"];
                cell.textLabel.text=@"邀请邻居";
            }
        }
    #else
        else if (indexPath.section==1){
            if (indexPath.row==0){
                cell.imageView.image=[UIImage imageNamed:@"ZYSucai"];
                cell.textLabel.text=@"媒体";
            }
        }
        else if (indexPath.section==2){
            if (indexPath.row==0){
                cell.imageView.image=[UIImage imageNamed:@"idle"];
                cell.textLabel.text=@"闲置";
            }
            if (indexPath.row==1){
                cell.imageView.image=[UIImage imageNamed:@"theorder"];
                cell.textLabel.text=@"报事";
            }
        }
        else if (indexPath.section==3){
            if (indexPath.row==0){
                cell.imageView.image=[UIImage imageNamed:@"community"];
                cell.textLabel.text=@"我的小区";
            }
            else if (indexPath.row==1){
                cell.imageView.image=[UIImage imageNamed:@"neighbor"];
                cell.textLabel.text=@"邀请邻居";
            }
        }
    #endif
    return cell;
    
#else
    
#endif
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
#ifdef SmartComJYZX
    //其他代码
    if(indexPath.section==0){
        if (indexPath.row==0){
            if ([[UserManager shareManager].userModel.isCardActivate isEqualToString:@"1"])//开通钱包
            {
                MoneyBagVC *money =[[MoneyBagVC alloc]init];
                money.navigationItem.backBarButtonItem=[AppUtils navigationBackButtonWithNoTitle];
                [self.navigationController pushViewController:money animated:YES];
            }
            else if ([[UserManager shareManager].userModel.isCardActivate isEqualToString:@"0"])//没有开通钱包
            {
                OpenMoneyBagVC *monebay =[[OpenMoneyBagVC alloc]init];
                [self.navigationController pushViewController:monebay animated:YES];
            }
            else
            {
                [AppUtils showAlertMessageTimerClose:@"未获取到钱包信息"];
            }
            
        }
        else if (indexPath.row==1){
            ShoppingCar *shopcar =[[ShoppingCar alloc]init];
            shopcar.isMine=YES;
            [self.navigationController pushViewController:shopcar animated:YES];
        }
        else if (indexPath.row==2){
            BuyViewController *buy = [[BuyViewController alloc]init];
            [self.navigationController pushViewController:buy animated:YES];
            
        }
        else if (indexPath.row==3){
            JiaoFeiVC *jiaofei =[[JiaoFeiVC alloc]init];
            [self.navigationController pushViewController:jiaofei animated:YES];
        }
        else if (indexPath.row==4){
            CollectionViewtroller *collection = [[CollectionViewtroller alloc]init];
            [self.navigationController pushViewController:collection animated:YES];
        }
    }
    else if (indexPath.section==1){
        if (indexPath.row==0){
            RentalVC *rental =[[RentalVC alloc]init];
            rental.vcType = VCTypeRental;
            [self.navigationController pushViewController:rental animated:YES];
        }
        if (indexPath.row==1){
            RentalVC *rental =[[RentalVC alloc]init];
            rental.vcType = VCTypeIdle;
            [self.navigationController pushViewController:rental animated:YES];
        }
        if (indexPath.row==2){
            RepairsViewController *repairs =[[RepairsViewController alloc]init];
            [self.navigationController pushViewController:repairs animated:YES];
        }
    }
    else if (indexPath.section==2){
        if (indexPath.row==0){
            CommunityViewCotroller *community = [[CommunityViewCotroller alloc]init];
            community.communityType = CommunityChooseTypeAdd;
            [self.navigationController pushViewController:community animated:YES];
            
        }
        if (indexPath.row==1){
            [self shareClick];
        }
    }
    else if (indexPath.section==3){
        if (indexPath.row==0){
            MovePublicClubViewController *movepublicclub =[[MovePublicClubViewController alloc]init];
            [self.navigationController pushViewController:movepublicclub animated:YES];
        }
    }
#elif SmartComYGS
    //其他代码
    if(indexPath.section==0){
        if (indexPath.row==0){
            ShoppingCar *shopcar =[[ShoppingCar alloc]init];
            shopcar.isMine=YES;
            [self.navigationController pushViewController:shopcar animated:YES];
        }
        else if (indexPath.row==1){
            BuyViewController *buy = [[BuyViewController alloc]init];
            [self.navigationController pushViewController:buy animated:YES];
            
        }
        else if (indexPath.row==2){
            JiaoFeiVC *jiaofei =[[JiaoFeiVC alloc]init];
            [self.navigationController pushViewController:jiaofei animated:YES];
        }
        else if (indexPath.row==3){
            CollectionViewtroller *collection = [[CollectionViewtroller alloc]init];
            [self.navigationController pushViewController:collection animated:YES];
        }
    }
    #ifdef BETA
        else if (indexPath.section==1){
            if (indexPath.row==0){
                RentalVC *rental =[[RentalVC alloc]init];
                rental.vcType = VCTypeIdle;
                [self.navigationController pushViewController:rental animated:YES];
            }
            else if (indexPath.row==1){
                RepairsViewController *repairs =[[RepairsViewController alloc]init];
                [self.navigationController pushViewController:repairs animated:YES];
            }
        }
        else if (indexPath.section==2){
            if (indexPath.row==0){
                CommunityViewCotroller *community = [[CommunityViewCotroller alloc]init];
                community.communityType = CommunityChooseTypeAdd;
                [self.navigationController pushViewController:community animated:YES];
            }
            if (indexPath.row==1){
                [self shareClick];
            }
        }

    #else
        else if (indexPath.section==1){
            ZYXiaoMiPlayerVC *playervc =[[ZYXiaoMiPlayerVC alloc]init];
            [self.navigationController pushViewController:playervc animated:YES];
        }
        else if (indexPath.section==2){
            if (indexPath.row==0){
                RentalVC *rental =[[RentalVC alloc]init];
                rental.vcType = VCTypeIdle;
                [self.navigationController pushViewController:rental animated:YES];
            }
            else if (indexPath.row==1){
                RepairsViewController *repairs =[[RepairsViewController alloc]init];
                [self.navigationController pushViewController:repairs animated:YES];
            }
        }
        else if (indexPath.section==3)
        {
            if (indexPath.row==0){
                CommunityViewCotroller *community = [[CommunityViewCotroller alloc]init];
                community.communityType = CommunityChooseTypeAdd;
                [self.navigationController pushViewController:community animated:YES];
            }
            if (indexPath.row==1){
                [self shareClick];
            }
        }
    #endif
    
#else
    
#endif
}



@end
