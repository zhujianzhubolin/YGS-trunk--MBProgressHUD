//
//  ManagerialReportDetailVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ComAffairsDetailVC.h"
#import "NSString+wrapper.h"

@interface ComAffairsDetailVC () <UITableViewDataSource,
                                        UITableViewDelegate>

@end

@implementation ComAffairsDetailVC
{
    UITableView *infoTB;
    CGFloat titleH;
    CGFloat dateCreateH;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initData {
    titleH = 40;
    dateCreateH = 30;
    
    CGFloat interval = 15;
    CGSize titleSize = [AppUtils sizeWithString:self.detailE.title font:[UIFont systemFontOfSize:19] size:CGSizeMake(IPHONE_WIDTH - interval *2, 150)];
    titleH = titleSize.height + 20;
    
    if ([NSString isEmptyOrNull:self.detailE.dateCreated]) {
        dateCreateH = 0;
    }
}

- (void)initUI {
    infoTB = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    infoTB.scrollEnabled = NO;
    infoTB.delegate = self;
    infoTB.dataSource = self;
    [infoTB registerClass:[UITableViewCell class] forCellReuseIdentifier:SYSTEM_CELL_ID];
    infoTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:infoTB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 40;
    switch (indexPath.row) {
        case 0: {
            return titleH;
        }
            break;
        case 1: {
            return dateCreateH;
        }
            break;
        case 2: {
            return self.view.frame.size.height - titleH - dateCreateH;
        }
            break;
        default:
            break;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.font = [UIFont boldSystemFontOfSize:19];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.text = self.detailE.title;
            cell.textLabel.numberOfLines = 4;
        }
            break;
        case 1:
            cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.text = [NSString stringWithFormat:@"发布时间: %@",self.detailE.updateTimeStr];
            break;
        case 2: {
            UIWebView *webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height - titleH - dateCreateH - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
            [webV loadHTMLString:self.detailE.word baseURL:nil];
            [cell.contentView addSubview:webV];
        }
            break;
        default:
            break;
    }
}

@end
