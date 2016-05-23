//
//  MorePinLun.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/20.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MorePinLun.h"
#import "MorePinLunCell.h"
#import "PinLunModel.h"
#import "Life_First.h"
#import <MJRefresh.h>

//举报相关
#import "ZJLongPressGesture.h"
#import "ReportBtn.h"
#import "ReportVC.h"

@interface MorePinLun ()<UITableViewDataSource,UITableViewDelegate>

{
    
    IBOutlet UITableView *pinLunTableView;
    NSMutableArray * pinglunListArray;
    __block int pageNum;
    
    int viewwidth;
    int viewheight;
}

@end

@implementation MorePinLun

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    pageNum = 1;
    pinglunListArray = [NSMutableArray array];
    [pinLunTableView registerNib:[UINib nibWithNibName:@"MorePinLunCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    pinLunTableView.showsVerticalScrollIndicator = NO;
    self.title = @"商家评论";
    [self viewDidLayoutSubviewsForTableView:pinLunTableView];
    [self setExtraCellLineHidden:pinLunTableView];
    
    __block __typeof(self)weakTableView = self;

    [pinLunTableView addLegendHeaderWithRefreshingBlock:^{
        pageNum = 1;
        [weakTableView getShopPingLun:YES];
    }];
    
    [pinLunTableView addLegendFooterWithRefreshingBlock:^{
        pageNum = pageNum +1;
        [weakTableView getShopPingLun:NO];
    }];
    
    [pinLunTableView.header beginRefreshing];
    
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
}

//获取商家评论
- (void)getShopPingLun:(BOOL)isDataRemove{
    
    Life_First * handel = [Life_First new];
    ShopPingLunModel * model = [ShopPingLunModel new];
    model.pageSize = @"5";
    model.pageNumber = [NSString stringWithFormat:@"%d",pageNum];
    model.storeType = _storeType;//有数据修改
    model.storeId = _storeId;
    [handel getShopPingLun:model success:^(id obj) {
        NSLog(@"所有评论>>>>%@",obj);
        
        if ([pinLunTableView.header isRefreshing]) {
            [pinLunTableView.header endRefreshing];
        }
        
        if ([pinLunTableView.footer isRefreshing]) {
            [pinLunTableView.footer endRefreshing];
        }
        
        if (isDataRemove) {
            
            [pinglunListArray removeAllObjects];
            
        }
        
        for (NSDictionary * dict in obj[@"list"]) {
            [pinglunListArray addObject:dict];
        }

        [pinLunTableView reloadData];
    } failed:^(id obj) {
        
        if ([pinLunTableView.header isRefreshing]) {
            [pinLunTableView.header endRefreshing];
        }
        
        if ([pinLunTableView.footer isRefreshing]) {
            [pinLunTableView.footer endRefreshing];
        }

        if (self.viewIsVisible) {
//            [AppUtils showErrorMessage:@"查询评论失败"];
        }
        else {
            [AppUtils dismissHUD];
        }
    }];
}


//商家评论暂时没有接口
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString * text = nil;
    
    if ([pinglunListArray[indexPath.row][@"content"] isEqual:[NSNull null]]) {
        text = @"";
    }else{
        text = pinglunListArray[indexPath.row][@"content"];
    }
    
    CGSize constraint = CGSizeMake(viewwidth - (8 * 3) -60, 20000.0f);
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:text
     attributes:attributes];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    CGFloat height = MAX(size.height + 45, 65);
    
    return height + 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return pinglunListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MorePinLunCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell  = [[MorePinLunCell alloc] init];
    }
    
    ZJLongPressGesture *pressGesture = [[ZJLongPressGesture alloc] initWithTarget:self action:@selector(nilSymbol) toView:cell.contentView];
    pressGesture.pressBlock = ^{
        [self pushToReportVC:indexPath.row];
    };
    [cell.contentView addGestureRecognizer:pressGesture];
    
    [cell cellData:(NSDictionary *)[pinglunListArray objectAtIndex:indexPath.row] isCollectionHide:YES];
    
    return cell;
}

//举报话题
- (void)pushToReportVC:(NSUInteger)dataIndex {
    ReportVC *reportVC = [ReportVC new];
    reportVC.idID = [NSNumber numberWithInt:[pinglunListArray[dataIndex][@"commentId"] intValue]];
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    [self.navigationController pushViewController:reportVC animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[ReportBtn btnInstance] removeReportBtn];
}


//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}



@end
