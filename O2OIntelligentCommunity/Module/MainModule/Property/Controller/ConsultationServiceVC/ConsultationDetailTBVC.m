//
//  ConsultationDetailTBVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ConsultationDetailTBVC.h"
#import "UITextField+wrapper.h"  
#import "CommentHandle.h"
#import "UserManager.h"
#import "LegalDetailHeaderV.h"

@interface ConsultationDetailTBVC () <UITableViewDataSource,
                                      UITableViewDelegate,
                                      UITextViewDelegate>

@end

@implementation ConsultationDetailTBVC
{
    UIView *buttomV;
    UITableView *infoTB;
    LegalDetailHeaderV *headerV;
    UITextView *textV;
    
    CGFloat interval;
    CGFloat headerH;
    CGFloat btnWidth;
    CGFloat btnInterval;
    NSString *phoneTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initData {
    //键盘将要出现的时候调用
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasDisappear:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    interval = 10;
    btnWidth = 40;
    btnInterval = 2;
    phoneTitle = @"马 上\n联 系";
}

- (void)initUI {
    self.title = @"详情";
    infoTB = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    infoTB.delegate = self;
    infoTB.dataSource = self;
//    infoTB.scrollEnabled = NO;
    infoTB.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    [infoTB registerClass:[UITableViewCell class] forCellReuseIdentifier:SYSTEM_CELL_ID];
    infoTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:infoTB];
    
    headerV = [[[NSBundle mainBundle] loadNibNamed:@"LegalDetailHeaderV" owner:self options:nil] lastObject];
    headerH = [headerV reloadDataWithModel:self.detailE];
    headerV.frame = CGRectMake(0, 0, infoTB.frame.size.width,headerH);
    infoTB.tableHeaderView = headerV;
    
    buttomV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - btnWidth, self.view.frame.size.width, btnWidth)];
    buttomV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.tag = 10;
    contactBtn.frame = CGRectMake(buttomV.frame.size.width - btnWidth *btnInterval - btnInterval, btnInterval, btnWidth * btnInterval, buttomV.frame.size.height -btnInterval * 2);
    contactBtn.titleLabel.numberOfLines = 2;
    contactBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    contactBtn.backgroundColor = [UIColor orangeColor];
    contactBtn.layer.cornerRadius = 5;
    contactBtn.layer.borderWidth = 1;
    contactBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    [contactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contactBtn setTitle:phoneTitle forState:UIControlStateNormal];
    [contactBtn addTarget:self action:@selector(contactBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttomV addSubview:contactBtn];
    
    textV = [[UITextView alloc] initWithFrame:CGRectMake(btnInterval, contactBtn.frame.origin.y, buttomV.frame.size.width - contactBtn.frame.size.width - btnInterval*3, contactBtn.frame.size.height)];
    textV.tag = 11;
    textV.delegate = self;
    textV.layer.cornerRadius = 5;
    textV.layer.borderWidth = 1;
    textV.layer.borderColor = [UIColor orangeColor].CGColor;
    textV.font = [UIFont systemFontOfSize:15];
    [textV setPlaceHolder:@" 给ta留言" fontSize:14];
    [buttomV addSubview:textV];
    [self.view addSubview:buttomV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideButtomTextV)];
    [infoTB addGestureRecognizer:tap];
}

- (void)contactBtnClick:(UIButton *)sender {
    if ([sender.titleLabel.text  isEqualToString:phoneTitle]) {
        [AppUtils callPhone:self.detailE.phone];
    }
    else {
        if (textV.text.length > 0) {
            [AppUtils showProgressMessage:@"正在提交中" withType:SVProgressHUDMaskTypeNone];
            CommentEntity *commentE = [CommentEntity new];
            commentE.memberId       = [UserManager shareManager].userModel.memberId;
            commentE.complaintId    = [NSNumber numberWithInteger:self.detailE.ID.integerValue];
            commentE.complaintType  = @"UNIVERSAL";
            commentE.content        =textV.text;
            
            CommentHandle *commentH = [CommentHandle new];
            [commentH executeSubmmitCommentTaskWithUser:commentE success:^(id obj) {
                
                [self.view endEditing:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sender setTitle:phoneTitle forState:UIControlStateNormal];
                });
                
                textV.text = nil;
                
                UIButton *contactbtn = (UIButton *)[buttomV viewWithTag:10];
                dispatch_async(dispatch_get_main_queue(), ^{
                    CGRect contactbtnRect = contactbtn.frame;
                    contactbtnRect.origin.y = btnInterval;
                    contactbtn.frame = contactbtnRect;
                });
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    CGRect textVRect = textV.frame;
                    textVRect.origin.y = btnInterval;
                    textVRect.size.height = btnWidth - btnInterval *2;
                    textV.frame = textVRect;
                });
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    CGRect buttomVRect = buttomV.frame;
                    buttomVRect.size.height = btnWidth + btnInterval *2;
                    buttomV.frame = buttomVRect;
                });
                
                [textV showPlaceHolder];
                [AppUtils showSuccessMessage:@"留言成功"];

            } failed:^(id obj) {
                if (self.viewIsVisible) {
                    [AppUtils showSuccessMessage:@"留言失败"];
                }
                else {
                    [AppUtils dismissHUD];
                }
            }];
        }
    }
}

- (void)hideButtomTextV {
    [self.view endEditing:YES];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect buttomVRect = buttomV.frame;
        buttomVRect.origin.y = self.view.frame.size.height - kbSize.height - buttomV.frame.size.height;
        buttomV.frame = buttomVRect;
    }];
}

- (void)keyboardWasDisappear:(NSNotification*)aNotification {
    if (buttomV.frame.origin.y != self.view.frame.size.height - btnWidth) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect buttomVRect = buttomV.frame;
            buttomVRect.origin.y = self.view.frame.size.height - btnWidth;
            buttomV.frame = buttomVRect;
        }];
    }
}

-(void)dealloc
{
    [self removeNotification];
}

-(void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
     [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return interval;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat webVHeight = infoTB.frame.size.height - interval - headerH - textV.frame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return webVHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat webVHeight = infoTB.frame.size.height - interval - headerH - textV.frame.size.height - 64;
    UIWebView *webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, webVHeight)];
    [webV loadHTMLString:self.detailE.word baseURL:nil];
    [cell.contentView addSubview:webV];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) {
        return YES;
    }
    
    if (range.location >= 100) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect textVRect = textView.frame;
        textVRect.size.height = textView.contentSize.height;
        textView.frame = textVRect;
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton *contactbtn = (UIButton *)[buttomV viewWithTag:10];
        CGRect btnRect = contactbtn.frame;
        btnRect.origin.y = buttomV.frame.size.height - btnRect.size.height - btnInterval;
        contactbtn.frame = btnRect;
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect buttomVRect = buttomV.frame;
        buttomVRect.origin.y =  CGRectGetMaxY(buttomV.frame) - textView.contentSize.height -  btnInterval *2;
        buttomVRect.size.height = textView.contentSize.height +  btnInterval *2;
        buttomV.frame = buttomVRect;
    });
    
    if ([textView.text trim].length > 0) {
        UIButton *contactBtn = (UIButton *)[buttomV viewWithTag:10];
        [contactBtn setTitle:@"发送" forState:UIControlStateNormal];
        [textView hidePlaceHolder];
    }
    else {
         UIButton *contactBtn = (UIButton *)[buttomV viewWithTag:10];
        [contactBtn setTitle:phoneTitle forState:UIControlStateNormal];
        [textView showPlaceHolder];
    }
}

@end
