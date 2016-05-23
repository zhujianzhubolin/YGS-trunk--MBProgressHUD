//
//  ReportVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/11/25.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "MoreOperationVC.h"
#import "CommentHandle.h"
#import "UserManager.h"
#import "ReportingGuidelinesVC.h"
#import "NSString+wrapper.h"

@interface MoreOperationVC () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation MoreOperationVC
{
    UITableView *infoTableV;
    NSArray *reportArr;
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
    if (self.reportType == ReportTypeContent) {
        reportArr = @[@"色情低俗",
                      @"广告骚扰",
                      @"诱导分享",
                      @"谣言",
                      @"政治敏感",
                      @"违法(暴力反恐、违禁品等)",
                      @"侵权投诉（诽谤、抄袭、冒用等）",
                      @"其他(收集隐私信息等)"];
    }
    else {
        reportArr = @[@"色情低俗",
                      @"广告骚扰",
                      @"欺诈骗钱",
                      @"政治敏感",
                      @"违法(暴力反恐、违禁品等)",
                      @"举报该用户",
                      @"侵权投诉（诽谤、抄袭、冒用等）"];
    }
}

- (void)initUI {
    if (self.reportType == ReportTypeContent) {
        self.title = @"举报内容";
    }
    else {
        self.title = @"举报用户";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(submmitReport)];
    infoTableV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    infoTableV.delegate = self;
    infoTableV.dataSource = self;
    infoTableV.tableFooterView = [AppUtils tableViewsFooterView];
    [self.view addSubview:infoTableV];
}

- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)submmitReport {
    NSString *reportContent = [self tableViewCellSelectedContent];
    if (reportContent.length <= 0) {
        [AppUtils showAlertMessageTimerClose:@"亲,您想举报什么呢"];
        return;
    }
    CommentEntity *commentE = [CommentEntity new];
    commentE.memberId = [UserManager shareManager].userModel.memberId;
    commentE.complaintId = self.idID;
    commentE.complaintType = @"REPORT";
    commentE.content = reportContent;
    
    CommentHandle *commentH = [CommentHandle new];
    [commentH executeSubmmitCommentTaskWithUser:commentE success:^(id obj) {
        [AppUtils showAlertMessage:@"举报成功，我们会在24小时内对内容进行审核，并进行相应的处理，谢谢。"];
        if (self.commentBlock) {
            self.commentBlock();
        }
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(back) userInfo:nil repeats:NO];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA
                            isShow:self.viewIsVisible];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return reportArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
    }
    return myCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imgV = [[UIImageView alloc] initWithImage:nil
                                          highlightedImage:[UIImage imageNamed:@"gou_h"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = imgV;
    imgV.highlighted = NO;
    
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"请选择举报原因";
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.backgroundColor = [AppUtils colorWithHexString:@"fcfcfc"];
        cell.textLabel.text = reportArr[indexPath.row - 1];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    
    [reportArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITableViewCell *myCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx + 1 inSection:0]];
        UIImageView *imgV = (UIImageView *)myCell.accessoryView;
        imgV.highlighted = NO;
    }];
    
    UITableViewCell *myCell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imgV = (UIImageView *)myCell.accessoryView;
    imgV.highlighted = YES;
}

- (NSString *)tableViewCellSelectedContent {
    __block NSString *content = nil;
    [reportArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITableViewCell *myCell = [infoTableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx + 1 inSection:0]];
        UIImageView *imgV = (UIImageView *)myCell.accessoryView;
        if (imgV.highlighted) {
            content = myCell.textLabel.text;
            *stop = YES;
        }
    }];
    return content;
}

@end
