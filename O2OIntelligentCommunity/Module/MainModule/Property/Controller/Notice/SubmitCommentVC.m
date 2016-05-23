//
//  SubmitCommentVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "SubmitCommentVC.h"
#import "SubmitComCell.h"
#import "CommentHandle.h"
#import "UserManager.h" 
#import "NSString+wrapper.h"    

@interface SubmitCommentVC () <UITableViewDataSource,
                                UITableViewDelegate,
                                UITextViewDelegate>

@end

@implementation SubmitCommentVC
{
    IBOutlet UITableView *infoTableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)initUI {
    self.title = @"评论";
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarButton addTarget:self action:@selector(submitCommentClick) forControlEvents:UIControlEventTouchUpInside];
    rightBarButton.frame = CGRectMake(0, 0, 60, 30);
    rightBarButton.layer.cornerRadius = 3;
    [rightBarButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[AppUtils colorWithHexString:@"fc6d22"] forState:UIControlStateNormal];
    [rightBarButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self viewDidLayoutSubviewsForTableView:infoTableView];
    
}

- (void)submitCommentClick {
    SubmitComCell *cell = (SubmitComCell *)[infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if ([cell.textV.text trim].length <= 0) {
        [AppUtils showAlertMessage:@"评论内容不能为空"];
        return;
    }
    
    CommentEntity *commentE = [CommentEntity new];
    commentE.memberId = [UserManager shareManager].userModel.memberId;
    commentE.complaintId = self.idID;
    commentE.complaintType = self.complaintType;
    commentE.content = cell.textV.text;
    
    CommentHandle *commentH = [CommentHandle new];
    [commentH executeSubmmitCommentTaskWithUser:commentE success:^(id obj) {
        [AppUtils showSuccessMessage:obj];
        if (self.commentBlock) {
            self.commentBlock();
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failed:^(id obj) {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA
                            isShow:self.viewIsVisible];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubmitComCell *cell = (SubmitComCell *)[tableView dequeueReusableCellWithIdentifier:@"submitCommentCellID"];
    return cell;
}

@end
