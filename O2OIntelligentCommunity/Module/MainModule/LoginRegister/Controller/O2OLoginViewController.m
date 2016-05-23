//
//  LoginViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "O2OLoginViewController.h"
#import "UITextField+wrapper.h"
#import "UserHandler.h"
#import "UserEntity.h"
#import "UserManager.h" 
#import "NSString+wrapper.h"
#import <SVProgressHUD.h>
#import "bindingHandler.h"
#import "BingingXQModel.h"
#import "CommunityViewCotroller.h"
#import "MyTabBarViewController.h"
#import "AppDelegate.h"
#import "LoginStorage.h"
#import "NSString+wrapper.h"
#import "ChooseXQViewController.h"
#import "MainTBViewController.h"
#import "getXQListHandler.h"
#import "SwitchVCAnimation.h"
#import "O2ORegisterViewController.h"
#import "RetrievePasswordVC.h"

typedef NS_ENUM(NSUInteger,LoginFailTag) {
    LoginFailTagUserFreeze = 214, //用户被冻结
    LoginFailTagUserLocked = 215, //用户被锁定
    LoginFailTagUserLockedOneHour = 216, //密码连续输入超过5次锁定一小时
    LoginFailTaglUserHas = 301, //账号已经在移公社存在，您可用此账号在移公社所有客户端登录并使用
    LoginFailTagUserError = 302, //未发现匹配的移付宝账号，您可重新输入或注册移公社账号
    LoginFailTagLoginSuc = 303,  //恭喜您成为移公社的一员，您可用此账号在移公社所有客户端登录并使用
    LoginFailTaglPassError = 304, //密码与移付宝账号不匹配，请重新输入！
    LoginFailTaglAbnormalConnect = 305, //通信异常，连接不上移付宝服务！
};

#ifdef SmartComJYZX

#elif SmartComYGS
    #import "MCPagerView.h"
#else

#endif

@interface O2OLoginViewController () <UITextFieldDelegate,
                                        UIAlertViewDelegate,
#ifdef SmartComJYZX

#elif SmartComYGS
                                        MCPagerViewDelegate,
#else

#endif
                                        UIScrollViewDelegate,
                                        UIAlertViewDelegate>


@property (nonatomic,assign) LoginMode loginMode;

@end

@implementation O2OLoginViewController
{
    __weak IBOutlet UITextField *userTF;
    __weak IBOutlet UITextField *passwordTF;
    __weak IBOutlet UISwitch *passwordSwitch;
    __weak IBOutlet UIButton *LoginButton;
    
    NSUInteger currentPage;
    
    __weak IBOutlet UIView *otherFuncV;
    __weak IBOutlet UIView *userYFBV;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (![LoginStorage userNoFisrtUse]) {
        self.navigationController.navigationBarHidden = YES;
    }
    else {
        self.navigationController.navigationBarHidden = NO;
    }
    
#ifdef SmartComJYZX
    self.title = @"登录";
    otherFuncV.hidden = NO;
    userYFBV.hidden = YES;
#elif SmartComYGS
    if (self.loginMode == LoginModeYGS) {
        self.title = @"登录";
        otherFuncV.hidden = NO;
        userYFBV.hidden = NO;
        [LoginButton setTitle:@"登录" forState:UIControlStateNormal];
    }
    else {
        self.title = @"移付宝专用";
        otherFuncV.hidden = YES;
        userYFBV.hidden = YES;
        [LoginButton setTitle:@"授权并登录" forState:UIControlStateNormal];
    }
#else
    
#endif

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    passwordTF.text = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
    if (self.loginMode != LoginModeYFB) {
        UIImageView *launchV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        launchV.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:launchV];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                launchV.alpha = 0;
            } completion:^(BOOL finished) {
                [launchV removeFromSuperview];
            }];
        });
    }
    
    // Do any additional setup after loading the view.
}

- (void)initData {
    NSDictionary *userDic = [LoginStorage decodeUserDic];
    if (![NSDictionary isDicEmptyOrNull:userDic]) {
        [UserHandler decodeLoginUser:userDic];
        NSLog(@"[UserManager shareManager].comModel.xqNo = %@",[UserManager shareManager].comModel.xqNo);
        if (![NSString isEmptyOrNull:[UserManager shareManager].comModel.xqNo]) {
            [O2OLoginViewController presentToMainVCWithAnimation:NO
                                              fromViewController:self];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UserHandler executeGetUserInfoSuccess:^(id obj) {
                } failed:^(id obj) {
                }];
            });
        }
        else {
            [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getXQList) userInfo:nil repeats:NO];
        }
    }
}

- (void)initUI {
    //    判断滑动图是否出现过，第一次调用时“isScrollViewAppear” 这个key 对应的值是nil，会进入if中
    if (![LoginStorage userNoFisrtUse]) {
        [self showScrollView];//显示滑动图
    }
    
    //设置textfield左边视图的图片和位置
    userTF.leftView = [UITextField addSideViewWithfillImg:[UIImage imageNamed:@"userInfo"]];
    userTF.keyboardType = UIKeyboardTypePhonePad;
    userTF.leftViewMode = UITextFieldViewModeAlways;
    userTF.adjustsFontSizeToFitWidth = YES;
    userTF.delegate = self;
    
    passwordTF.leftView = [UITextField addSideViewWithfillImg:[UIImage imageNamed:@"passwordInfo"]];
    passwordTF.leftViewMode = UITextFieldViewModeAlways;
    passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    passwordTF.adjustsFontSizeToFitWidth = YES;
    passwordTF.delegate = self;
    
    LoginButton.layer.cornerRadius = 8;
    
    if (![NSString isEmptyOrNull:[UserManager shareManager].userModel.phone]) {
        userTF.text = [UserManager shareManager].userModel.phone;
    }
}

-(void) showScrollView{
    
    UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    //设置UIScrollView 的显示内容的尺寸，有n张图要显示，就设置 屏幕宽度*n ，这里假设要显示4张图
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 4, self.view.frame.size.height);
    _scrollView.tag = 101;
    
    //设置翻页效果，不允许反弹，不显示水平滑动条，设置代理为自己
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat jumpBtnWidth = 50;
    jumpBtn.frame = CGRectMake(self.view.frame.size.width - jumpBtnWidth - 15, self.view.frame.size.height - 25 - jumpBtnWidth, jumpBtnWidth, jumpBtnWidth);
    
    [jumpBtn addTarget:self action:@selector(scrollViewDisappear) forControlEvents:UIControlEventTouchUpInside];
    jumpBtn.tag = 301;
    
    UIButton *experienceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat exBtnWidth = self.view.frame.size.width / 3;
    experienceBtn.frame = CGRectMake((self.view.frame.size.width - exBtnWidth) / 2,jumpBtn.frame.origin.y - 25, exBtnWidth, 45);
    experienceBtn.hidden = YES;
    
    [experienceBtn addTarget:self action:@selector(scrollViewDisappear) forControlEvents:UIControlEventTouchUpInside];
    experienceBtn.tag = 401;
  
#ifdef SmartComJYZX
    [jumpBtn setImage:[UIImage imageNamed:@"lauch_JYZX_jump"] forState:UIControlStateNormal];
    [experienceBtn setImage:[UIImage imageNamed:@"lauch_JYZX_expericeB"] forState:UIControlStateNormal];
    [experienceBtn setImage:[UIImage imageNamed:@"lauch_JYZX_expericeB_h"] forState:UIControlStateHighlighted];
#elif SmartComYGS
    [jumpBtn setImage:[UIImage imageNamed:@"lauch_YGS_jump"] forState:UIControlStateNormal];
    [experienceBtn setImage:[UIImage imageNamed:@"lauch_YGS_expericeB"] forState:UIControlStateNormal];
    [experienceBtn setImage:[UIImage imageNamed:@"lauch_YGS_expericeB_high"] forState:UIControlStateHighlighted];
#else
    
#endif
    //在UIScrollView 上加入 UIImageView
    for (int i = 0 ; i < 4; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i , 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        //将要加载的图片放入imageView 中
        
#ifdef SmartComJYZX 
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"lauch_JYZX_%d.jpg",i+1]];
#elif SmartComYGS
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"lauch_YGS_%d.jpg",i+1]];
#else
        
#endif
        
        imageView.image = image;
        
        [_scrollView addSubview:imageView];
    }
    
    [self.view addSubview:_scrollView];
    [self.view addSubview:jumpBtn];
    [self.view addSubview:experienceBtn];
    
#ifdef SmartComJYZX
    
#elif SmartComYGS
    // Pager
    MCPagerView *pagerView = [[MCPagerView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2, self.view.frame.size.height - 50, 200, 40)];
    pagerView.tag = 201;
    [pagerView setImage:[UIImage imageNamed:@"lauch_YGS_page"]
       highlightedImage:[UIImage imageNamed:@"lauch_YGS_page_select"]
                 forKey:@"a"];
    currentPage = 0;
    [pagerView setPattern:@"aaaa"];
    pagerView.delegate = self;
    [self.view addSubview:pagerView];
#else
    
#endif
}

- (void)removeLauchScollV {
    //拿到 view 中的 UIScrollView 和 UIPageControl
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:101];
    UIButton *exBtn = (UIButton *)[self.view viewWithTag:401];
    self.navigationController.navigationBarHidden = NO;
    [exBtn removeFromSuperview];
    
    UIButton *jumpBtn = (UIButton *)[self.view viewWithTag:301];
    [jumpBtn removeFromSuperview];
#ifdef SmartComJYZX
    
#elif SmartComYGS
    MCPagerView *page = (MCPagerView *)[self.view viewWithTag:201];
    [page removeFromSuperview];
#else
    
#endif
    //设置滑动图消失的动画效果图
    [UIView animateWithDuration:1.0f animations:^{
        [scrollView animateFadeOut:1.0];
//        scrollView.center = CGPointMake(self.view.frame.size.width/2, 1.5 * self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [scrollView removeFromSuperview];
    }];
//    //将滑动图启动过的信息保存到 NSUserDefaults 中，使得第二次不运行滑动图
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginSuccess {
    passwordTF.text = nil;
    NSLog(@"[UserManager shareManager].comModel.xqNo  =%@",[UserManager shareManager].userModel.memberId);
    if (![NSString isEmptyOrNull:[UserManager shareManager].comModel.xqNo]) { //直接跳到首页，表示登录成功
        [AppUtils dismissHUD];
        [O2OLoginViewController presentToMainVCWithAnimation:YES
                                          fromViewController:self];
    }
    else {
        [self getXQList];
    }
}

//获取所有小区列表
-(void)getXQList
{
    [AppUtils showProgressMessage:W_ALL_PROGRESS];
    getXQListModel *xqM =[getXQListModel new];
    getXQListHandler *xqH =[getXQListHandler new];
    xqM.pageNumber  =@"1";
    xqM.pageSize    =@"1000";
    xqM.orderBy     =@"dateCreated";
    xqM.orderType   =@"desc";
    
#ifdef SmartComJYZX
    xqM.comapyanyId = P_WYID;
#elif SmartComYGS
    xqM.isCustomized = P_IS_CUSTOMIZED;
#else
    
#endif
    
    [xqH postXQList:xqM success:^(id obj) {
        NSArray  *xqAllList =(NSArray *)obj;
        [AppUtils dismissHUD];
        
        ChooseXQViewController *choose = [[ChooseXQViewController alloc]init];
        if (![NSArray isArrEmptyOrNull:xqAllList]) {
            choose.allXQArray = [xqAllList copy];
        }
        
        [self.navigationController pushViewController:choose animated:YES];
    } failed:^(id obj) {
        [UserHandler logout];
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
    }];
}

#pragma mark - event
- (IBAction)YFBLoginClick:(id)sender {
    UIStoryboard *loginSTB = [UIStoryboard storyboardWithName:@"LoginRegister" bundle:nil];
    UINavigationController *loginNav = [loginSTB instantiateInitialViewController];
    O2OLoginViewController *yfbVC = (O2OLoginViewController *)loginNav.topViewController;
    yfbVC.loginMode = LoginModeYFB;
    [self.navigationController pushViewController:yfbVC animated:YES];
}

- (void)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginAction:(id)sender {
    [AppUtils closeKeyboard];
    if (![AppUtils isMobileNumber:userTF.text]) {
        [AppUtils showAlertMessage:W_ALL_PHONE_ERR_FORMAT];
        return;
    }
    
    if (passwordTF.text.length == 0) {
        [AppUtils showAlertMessage:@"请输入密码"];
        return;
    }
    
    if (passwordTF.text.length < 6) {
        [AppUtils showAlertMessage:W_ALL_PASS_LENGTH];
        return;
    }
    
    [AppUtils showProgressMessage:@"登录中..."];
    
    UserHandler *loginH = [UserHandler new];
    UserEntity *userE = [UserEntity new];
    userE.accountName = userTF.text;
    userE.password    = [NSString md5_32Bit_String:passwordTF.text];
    loginH.loginMode = self.loginMode;
    if (self.loginMode == LoginModeYGS) {
        userE.loginType   = @"mobilePhone";
    }
    else {
        userE.loginType   = @"eeepay";
    }
    
    userE.reference   = P_REFERENCE;
    
    [loginH executeLoginTaskWithUser:userE success:^(id obj) {
        [self loginSuccess];
    } failed:^(id obj) {
        UserOwnEntity *userEntity = obj;
        NSString *failCode = userEntity.code;
        NSString *failMessage = userEntity.message;
        NSString *alertTitle = @"温馨提示";

        if (self.loginMode == LoginModeYGS) {
            if (failCode.integerValue == LoginFailTagUserFreeze) {
                [AppUtils dismissHUD];
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:failMessage delegate:self cancelButtonTitle:@"联系客服" otherButtonTitles:@"取消", nil];
                failAlert.tag = LoginFailTagUserFreeze;
                [failAlert show];
            }
            else if (failCode.integerValue == LoginFailTagUserLocked) {
                [AppUtils showAlertMessage:failMessage];
            }
            else if (failCode.integerValue == LoginFailTagUserLockedOneHour) {
                [AppUtils dismissHUD];
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:failMessage delegate:self cancelButtonTitle:@"找回密码" otherButtonTitles:@"取消", nil];
                failAlert.tag = LoginFailTagUserLockedOneHour;
                [failAlert show];
            }
            else {
                [AppUtils showErrorMessage:failMessage];
            }
        }
        else {
            if ([NSString isEmptyOrNull:failCode]) {
                [AppUtils showAlertMessageTimerClose:failMessage];
                return;
            }
            
            if (failCode.integerValue == LoginFailTaglAbnormalConnect) {
                [AppUtils dismissHUD];
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:failMessage delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"移公社登录",nil];
                failAlert.tag = LoginFailTaglAbnormalConnect;
                [failAlert show];
            }
            else if (failCode.integerValue == LoginFailTaglUserHas) {
                [AppUtils dismissHUD];
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:failMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                failAlert.tag = LoginFailTaglUserHas;
                [failAlert show];
            }
            else if (failCode.integerValue == LoginFailTaglPassError) {
                [AppUtils dismissHUD];
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:failMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新输入", nil];
                failAlert.tag = LoginFailTaglPassError;
                [failAlert show];
            }
            else if (failCode.integerValue == LoginFailTagUserError) {
                [AppUtils dismissHUD];
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:failMessage delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:@"去注册", nil];
                failAlert.tag = LoginFailTagUserError;
                [failAlert show];
            }
            else if (failCode.integerValue == LoginFailTagLoginSuc) {
                [AppUtils dismissHUD];
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:failMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                failAlert.tag = LoginFailTagLoginSuc;
                [failAlert show];
            }
            else {
                [AppUtils showAlertMessageTimerClose:failMessage];
            }
        }
    }];
}

- (IBAction)passwordSecureClick:(UISwitch *)sender {
    passwordTF.secureTextEntry = !sender.isOn;
}

- (void)dismissAlertV:(NSTimer *)timer {
    UIAlertView *alertV = (UIAlertView *)timer.userInfo;
    [alertV dismissWithClickedButtonIndex:0 animated:YES];
}

+ (void)presentToMainVCWithAnimation:(BOOL)isAnimation
                  fromViewController:(UIViewController *)fromVC {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.myTBVC.selectedIndex = 1;
    [UserManager shareManager].isFromLogin = YES;
    
    [fromVC.navigationController presentViewController:appDelegate.myTBVC animated:isAnimation completion:^{
        [fromVC.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat current = scrollView.contentOffset.x /scrollView.frame.size.width;\
    if (current < currentPage) {
        scrollView.scrollEnabled = NO;
    }
    else {
        scrollView.scrollEnabled = YES;
    }
}

#ifdef SmartComJYZX

#elif SmartComYGS
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        int current = scrollView.contentOffset.x/self.view.frame.size.width;
        //根据scrollView 的位置对page 的当前页赋值
        MCPagerView *pageView = (MCPagerView *)[self.view viewWithTag:201];
        pageView.page = current;
    }
}
#else

#endif



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    currentPage = current;
    
#ifdef SmartComJYZX
    
#elif SmartComYGS
    MCPagerView *pageView = (MCPagerView *)[self.view viewWithTag:201];
    pageView.page = current;
#else
    
#endif

    
    if (currentPage == 3) {
        UIButton *experienceBtn = (UIButton *)[self.view viewWithTag:401];
        experienceBtn.hidden = NO;
        
        UIButton *jumpBtn = (UIButton *)[self.view viewWithTag:301];
        [jumpBtn removeFromSuperview];
    }
}

-(void)scrollViewDisappear{
    [LoginStorage saveUserNoFirstUse:YES];
    [self removeLauchScollV];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    
    int passwordInputLength = 18;
    //限定输入字符的属性
    if (textField == userTF) {
        return range.location < PHONE_INPUT_BITS;
    }
    if (textField == passwordTF) {
        return range.location < passwordInputLength && [AppUtils isNotLanguageEmoji];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == LoginFailTaglPassError) {
        if (buttonIndex == 1) {
            passwordTF.text = nil;
            [passwordTF becomeFirstResponder];
        }
    }
    else if (alertView.tag == LoginFailTagUserError) {
        if (buttonIndex == 0) {
            userTF.text = nil;
            passwordTF.text = nil;
            [userTF becomeFirstResponder];
        }
        else if (buttonIndex == 1) {
            UIStoryboard *loginSTB = [UIStoryboard storyboardWithName:@"LoginRegister" bundle:nil];
            O2ORegisterViewController *registerVC = [loginSTB instantiateViewControllerWithIdentifier:@"O2ORegisterViewControllerID"];
            [self.navigationController pushViewController:registerVC animated:YES];
        }
    }
    else if (alertView.tag == LoginFailTagLoginSuc) {
        if (buttonIndex == 0) {
            [self loginSuccess];
        }
    }
    else if (alertView.tag == LoginFailTaglUserHas) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == LoginFailTaglAbnormalConnect) {
        if (buttonIndex == 0) {
            [self loginAction:nil];
        }
        else if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == LoginFailTagUserFreeze ||
             alertView.tag == LoginFailTagUserLockedOneHour) {
        if (buttonIndex == 0) {
            UIStoryboard *loginStory = [UIStoryboard storyboardWithName:@"LoginRegister" bundle:nil];
            RetrievePasswordVC *retrieveVC = [loginStory instantiateViewControllerWithIdentifier:@"RetrievePasswordVC"];
            [self.navigationController pushViewController:retrieveVC animated:YES];
        }
    }
}

@end
