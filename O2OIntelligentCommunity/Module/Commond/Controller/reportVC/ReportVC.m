//
//  ReportVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/11/25.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "ReportVC.h"
#import "ReportingGuidelinesVC.h"
#import "MoreOperationVC.h"
#import "CommentHandle.h"
#import "UserManager.h"

@interface ReportVC () <UITableViewDataSource,
                        UITableViewDelegate,
                        UIAlertViewDelegate>

@end

@implementation ReportVC
{
    UITableView *infoTableV;
    NSArray *listArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initData {
    listArr = @[@"举报内容",@"举报用户",@"屏蔽用户"];
}

- (void)initUI {
    self.title = @"更多";
 
    infoTableV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    infoTableV.delegate = self;
    infoTableV.dataSource = self;
    infoTableV.tableFooterView = [AppUtils tableViewsFooterView];
    [self.view addSubview:infoTableV];
    
    UIButton *footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    footerBtn.frame = CGRectMake(0, 0, infoTableV.frame.size.width, 50);
    [footerBtn setTitle:@"举报须知" forState:UIControlStateNormal];
    [footerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [footerBtn addTarget:self action:@selector(footerClick) forControlEvents:UIControlEventTouchUpInside];
    infoTableV.tableFooterView = footerBtn;
}

- (void)footerClick {
    ReportingGuidelinesVC *reportGuidVC = [ReportingGuidelinesVC new];
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    [self.navigationController pushViewController:reportGuidVC animated:YES];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submmitReport {
    NSString *reportContent = @"屏蔽用户";

    CommentEntity *commentE = [CommentEntity new];
    commentE.memberId = [UserManager shareManager].userModel.memberId;
    commentE.complaintId = self.idID;
    commentE.complaintType = @"REPORT";
    commentE.content = reportContent;
    
    CommentHandle *commentH = [CommentHandle new];
    [commentH executeSubmmitCommentTaskWithUser:commentE success:^(id obj) {
        [AppUtils showAlertMessage:@"您的屏蔽用户请求已经接受，我们会在24小时内做出相应的处理，谢谢。"];
        if (self.commentBlock) {
            self.commentBlock();
        }
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(back) userInfo:nil repeats:NO];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA
                            isShow:self.viewIsVisible];
    }];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
    }
    return myCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath    {
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.backgroundColor = [AppUtils colorWithHexString:@"fcfcfc"];
    cell.textLabel.text = listArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            MoreOperationVC *reportVC = [MoreOperationVC new];
            reportVC.reportType = ReportTypeContent;
            reportVC.idID = self.idID;
            self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
            [self.navigationController pushViewController:reportVC animated:YES];
        }
            break;
        case 1:{
            MoreOperationVC *reportVC = [MoreOperationVC new];
            reportVC.reportType = ReportTypeUser;
            reportVC.idID = self.idID;
            self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
            [self.navigationController pushViewController:reportVC animated:YES];
        }
            break;
        case 2:{
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"屏蔽用户，您将无法看到该用户的任何话题和评论，是否确认屏蔽"
                                   
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"确定", nil];
            [alertV show];
        }
            break;
        default:
            
            break;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self submmitReport];
    }
}

@end
