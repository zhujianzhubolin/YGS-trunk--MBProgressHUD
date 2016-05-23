//
//  ReportingGuidelinesVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/11/26.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "ReportingGuidelinesVC.h"

@interface ReportingGuidelinesVC () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation ReportingGuidelinesVC
{
    UITableView *infoTableV;
    CGFloat headerHeight;
    NSString *content;
    CGFloat contentFont;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    content = [NSString stringWithFormat:@"你应保证你的举报行为基于善意，并代表你本人真实意思.%@作为中立的服务平台，受到你举报后，会尽快按照相关法律法规的规定独立判断并进行处理。%@将会采取合理的措施保护你的个人信息；除法律法规规定的情形外，未经用户许可%@不会向第三方公开、透露你的个人信息",P_NMAE,P_NMAE,P_NMAE];
    headerHeight = 70;
    contentFont = 17;
    self.title = @"举报须知";
    infoTableV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    infoTableV.dataSource = self;
    infoTableV.delegate = self;
    infoTableV.tableFooterView = [AppUtils tableViewsFooterView];
    infoTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view = infoTableV;
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, infoTableV.frame.size.width, headerHeight)];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text= @"举报须知";
    infoTableV.tableHeaderView = titleL;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize contentSize = [AppUtils sizeWithString:content
                                             font:[UIFont systemFontOfSize:contentFont]
                                             size:CGSizeMake(IPHONE_WIDTH, MAXFLOAT)];
    return contentSize.height + 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    myCell.textLabel.textAlignment = NSTextAlignmentLeft;
    myCell.textLabel.font = [UIFont systemFontOfSize:contentFont];
    myCell.textLabel.numberOfLines = 0;
    myCell.textLabel.text = content;
    return myCell;
}

@end
