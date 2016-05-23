//
//  CommentViewControllr.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "CommentViewControllr.h"
#import "UserManager.h"

//主动评论接口类
#import "CommentEntity.h"
#import "CommentHandle.h"

//意见反馈接口类
#import "OpinionFeedbackModel.h"
#import "OpinionFeedbackHandler.h"
#import "UITextField+wrapper.h"

@implementation CommentViewControllr
{
    UITextView *HuiFutextview;
    UILabel    *promptLab;
//    UILabel    *placeholderLabe;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self hidetabbar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    //设置导航栏文字颜色
    
    if (_isSwitchPage==CommentPageTopic)
    {
        self.title=@"话题评论";
    }
    else if (_isSwitchPage==CommentPageFeedBack)
    {
        self.title=@"意见反馈";
    }
    else if (_isSwitchPage==CommentPageRepairs)
    {
        self.title=@"报修评论";
    }
    else if (_isSwitchPage==CommentPageComplain)
    {
        self.title=@"投诉评论";
    }
    
    self.view.backgroundColor=[AppUtils colorWithHexString:@"EBEBF1"];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,30)];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setTitleColor:[AppUtils colorWithHexString:@"fa6900"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchprogram)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    
    
    [self initUI];
    
}

-(void)initUI
{
    CGFloat placeFont = 14;
    
//    placeholderLabe =[[UILabel alloc]init];
//    placeholderLabe.frame=CGRectMake(5, 3, IPHONE_WIDTH-20, 25);
//    placeholderLabe.font=[UIFont systemFontOfSize:14];


    
//    placeholderLabe.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    
    HuiFutextview = [[UITextView alloc]initWithFrame:CGRectMake(10,10, self.view.frame.size.width-20, 150)];
    HuiFutextview.delegate=self;
    HuiFutextview.backgroundColor=[UIColor whiteColor];
    HuiFutextview.font=[UIFont systemFontOfSize:16];
//    [HuiFutextview addSubview:placeholderLabe];
    
    if (_isSwitchPage==CommentPageTopic) {
        [HuiFutextview setPlaceHolder:@"快给我的话题写评论吧" fontSize:placeFont];
        //        placeholderLabe.text=@"快给我的话题写评论吧";
    }
    else if (_isSwitchPage==CommentPageFeedBack) {
        
        //        placeholderLabe.text=M_MINE_FEEDBACK;
        [HuiFutextview setPlaceHolder:M_MINE_FEEDBACK fontSize:placeFont];
    }
    else if (_isSwitchPage==CommentPageRepairs) {
        [HuiFutextview setPlaceHolder:@"快为我的报修说点什么吧！" fontSize:placeFont];
        //        placeholderLabe.text=@"快为我的报修说点什么吧！";
    }
    else if (_isSwitchPage==CommentPageComplain) {
        [HuiFutextview setPlaceHolder:@"快为我的投诉说点什么吧！" fontSize:placeFont];
        //        placeholderLabe.text=@"快为我的投诉说点什么吧！";
    }
    
    [self.view addSubview:HuiFutextview];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textViewEditChanged1:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:HuiFutextview];
    
    UIToolbar *topView =[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *btnSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray *buttonArray =[NSArray arrayWithObjects:btnSpace,doneButton, nil];
    [topView setItems:buttonArray];
    [HuiFutextview setInputAccessoryView:topView];

    promptLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, self.view.frame.size.width-20, 30)];
    promptLab.text=@"你还可以输入200字";
    promptLab.font=[UIFont systemFontOfSize:16];
    promptLab.textColor =[UIColor grayColor];
    [self.view addSubview:promptLab];
}

- (void)textViewEditChanged1:(NSNotification*)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSUInteger kMaxLength = 200;
    [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                               inTextField:textField];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextViewTextDidChangeNotification"
                                                 object:HuiFutextview];
}

-(void)dismissKeyBoard
{
    [HuiFutextview resignFirstResponder];
}

#pragma mark - UITextView 代理方法
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length > 0) {
        [textView hidePlaceHolder];
    }
    else {
        [textView showPlaceHolder];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView hidePlaceHolder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        [textView hidePlaceHolder];
    }
    else {
        [textView showPlaceHolder];
    }
    
    if (textView.text.length > 200) {
        dispatch_async(dispatch_get_main_queue(), ^{
            promptLab.text = @"您还可以输入0字";
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            promptLab.text = [NSString stringWithFormat:@"您还可以输入%u字",200 - textView.text.length];
        });
    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) {
        return YES;
    }
    
    if (textView.attributedText.length >= 200 || ![AppUtils isNotLanguageEmoji]) {
        return NO;
    }
    return YES;
}

-(void)searchprogram
{
    
    NSString *tempStr= [HuiFutextview.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *tempStr2 =[tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (tempStr2.length <=0)
    {
        [AppUtils showAlertMessageTimerClose:@"亲爱的，意见内容不能为空!"];
        return;
    }
    
    [AppUtils showProgressMessage:@"提交中"];
    if (_isSwitchPage==CommentPageTopic)//评论话题
    {
        CommentEntity *commentM =[CommentEntity new];
        commentM.memberId = [UserManager shareManager].userModel.memberId;
        commentM.complaintId =[NSNumber numberWithLong:[_huatiM.ID floatValue]];
        commentM.complaintType =_complaintType;
        commentM.content  =tempStr2;
        
        CommentHandle *commentH = [CommentHandle new];
        [commentH executeSubmmitCommentTaskWithUser:commentM success:^(id obj) {
            [AppUtils showSuccessMessage:@"亲爱的,谢谢您的评价"];
            if (self.pinlunBlock)
            {
                self.pinlunBlock();
            }
            
            [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME
                                             target:self
                                           selector:@selector(backBarButtonItemClick)
                                           userInfo:nil
                                            repeats:NO];
        } failed:^(id obj) {
            [AppUtils showErrorMessage:@"不好意思，您提交的话题评论迷路了！"
                                isShow:self.viewIsVisible];
        }];
        
    }
    else if(_isSwitchPage==CommentPageFeedBack)//意见反馈
    {
        OpinionFeedbackModel *opfbM =[OpinionFeedbackModel new];
        OpinionFeedbackHandler *opfbH =[OpinionFeedbackHandler new];
        opfbM.memberInfoid=[UserManager shareManager].userModel.memberId;
        opfbM.content=HuiFutextview.text;
        opfbM.devicetype=@"IOS";
        opfbM.versioncode=[NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
        NSBundle*bundle =[NSBundle mainBundle];
        NSDictionary*info =[bundle infoDictionary];
        NSString*prodName =[info objectForKey:@"CFBundleDisplayName"];
        opfbM.appname=prodName;
        
        
        [opfbH opinionfeedback:opfbM success:^(id obj) {
            [AppUtils showSuccessMessage:@"您的建议意见提交成功，我们尽快改进！"];
            [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME
                                             target:self
                                           selector:@selector(backBarButtonItemClick)
                                           userInfo:nil
                                            repeats:NO];
            
        } failed:^(id obj) {
            [AppUtils showErrorMessage:@"不好意思，您提交的建议迷路了"
                                isShow:self.viewIsVisible];
        }];
    }
    else if (_isSwitchPage==CommentPageRepairs)
    {
        CommentEntity *commentM =[CommentEntity new];
        commentM.memberId = [UserManager shareManager].userModel.memberId;
        commentM.complaintId =[NSNumber numberWithLong:[_idID floatValue]];
        commentM.complaintType =_complaintType;
        commentM.content  =HuiFutextview.text;
        
        CommentHandle *commentH = [CommentHandle new];
        [commentH executeSubmmitCommentTaskWithUser:commentM success:^(id obj) {
            [AppUtils showSuccessMessage:M_MINE_FEEDBACK_SUCCESS];
            
            [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME
                                             target:self
                                           selector:@selector(backBarButtonItemClick)
                                           userInfo:nil
                                            repeats:NO];
        } failed:^(id obj) {
            [AppUtils showErrorMessage:@"不好意思，您提交的报修评论迷路了！"
                                isShow:self.viewIsVisible];
        }];
        
    }
    else if (_isSwitchPage==CommentPageComplain)
    {
        NSLog(@"投诉");
        
        CommentEntity *commentM =[CommentEntity new];
        commentM.memberId = [UserManager shareManager].userModel.memberId;
        commentM.complaintId =[NSNumber numberWithLong:[_idID floatValue]];
        commentM.complaintType =_complaintType;
        commentM.content  =HuiFutextview.text;
        
        CommentHandle *commentH = [CommentHandle new];
        [commentH executeSubmmitCommentTaskWithUser:commentM success:^(id obj) {
            [AppUtils showSuccessMessage:M_MINE_FEEDBACK_SUCCESS];
            
            [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME
                                             target:self
                                           selector:@selector(backBarButtonItemClick)
                                           userInfo:nil
                                            repeats:NO];
        } failed:^(id obj) {
            [AppUtils showErrorMessage:@"不好意思，您提交的投诉评论迷路了！"
                                isShow:self.viewIsVisible];
        }];
    }
}

-(void)backBarButtonItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
