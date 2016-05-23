//
//  GoodsPinLun.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "GoodsPinLun.h"
#import "MorePinLunCell.h"
#import "Life_First.h"
#import "PinLunModel.h"
#import <MJRefresh.h>

//举报相关
#import "ZJLongPressGesture.h"
#import "ReportBtn.h"
#import "ReportVC.h"

@interface GoodsPinLun ()<UITableViewDataSource,UITableViewDelegate>{

    __weak IBOutlet UITableView *goodsPinLunList;
    
    
    NSMutableArray * listArray;
    
    int viewwidth;
    int viewheight;
    __block int pageNum;
}
@end

@implementation GoodsPinLun

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品评论";
    
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
    
    pageNum = 1;
    
    listArray = [NSMutableArray array];
    
    goodsPinLunList.delegate = self;
    goodsPinLunList.dataSource = self;
    
    [goodsPinLunList registerNib:[UINib nibWithNibName:@"MorePinLunCell" bundle:nil] forCellReuseIdentifier:@"pinLunCell"];
    
    [self viewDidLayoutSubviewsForTableView:goodsPinLunList];
    [self setExtraCellLineHidden:goodsPinLunList];
    
//    [self getPinLunList:YES];
    
    [goodsPinLunList addLegendHeaderWithRefreshingBlock:^{
        pageNum = 1;
        [self getPinLunList:YES];
    }];
    [goodsPinLunList addLegendFooterWithRefreshingBlock:^{
       
        pageNum++;
        
        [self getPinLunList:NO];
        
    }];
    
    [goodsPinLunList.header beginRefreshing];
}


//获取商城品论列表
- (void)getPinLunList:(BOOL)isRemoveData{
    
    Life_First * handel = [Life_First new];
    PinLunModel * model = [PinLunModel new];
    model.productId = [NSNumber numberWithLong:[_productId intValue]];
    model.pageNumber = [NSNumber numberWithLong:pageNum];
    model.pageSize = [NSNumber numberWithLong:5];
    
    if (isRemoveData) {
        [listArray removeAllObjects];
    }
    
    [handel getPinLunInStore:model success:^(id obj) {
        NSLog(@"评论列表>>>>%@",obj);
        
        for (NSDictionary * dict in obj[@"list"]) {
            [listArray addObject:dict];
        }
        [goodsPinLunList reloadData];
        
        if ([goodsPinLunList.header isRefreshing]) {
            [goodsPinLunList.header endRefreshing];
        }
        
        if ([goodsPinLunList.footer isRefreshing]) {
            [goodsPinLunList.footer endRefreshing];
        }
    } failed:^(id obj) {
        
        if ([goodsPinLunList.header isRefreshing]) {
            [goodsPinLunList.header endRefreshing];
        }
        if ([goodsPinLunList.footer isRefreshing]) {
            [goodsPinLunList.footer endRefreshing];
        }
        
        if (self.viewIsVisible) {
//            [AppUtils showErrorMessage:@"获取商品评论失败"];
        }
        else {
            [AppUtils dismissHUD];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = nil;
    if ([listArray[indexPath.row][@"content"] isEqual:[NSNull null]]) {
        text = @"";
    }else{
        text = listArray[indexPath.row][@"content"];
    }
    
    CGFloat imageH = 0;
    
    if ([listArray[indexPath.row] isEqual:[NSNull null]]) {
        imageH = 0;
    }else{
        
        if ([listArray[indexPath.row][@"file"] isEqual:[NSNull null]]) {
            imageH = 0;
        }else{
            if ([listArray[indexPath.row][@"file"] count] > 0) {
                imageH = 70;
            }else{
                imageH = 0;
            }
        }
    }
    
    CGSize constraint = CGSizeMake(viewwidth - 61 - 5, 20000.0f);
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:text
     attributes:attributes];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    CGFloat height = MAX(size.height + 50 + imageH +5, 73);
    
    return height + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MorePinLunCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pinLunCell"];
    if (cell == nil) {
        cell = [[MorePinLunCell alloc] init];
    }
    
    if (listArray.count > 0) {
        [cell cellData:listArray[indexPath.row] isCollectionHide:NO];
    }
    
    ZJLongPressGesture *pressGesture = [[ZJLongPressGesture alloc] initWithTarget:self action:@selector(nilSymbol) toView:cell.contentView];
    pressGesture.pressBlock = ^{
        [self pushToReportVC:indexPath.row];
    };
    [cell.contentView addGestureRecognizer:pressGesture];
    
    return cell;
}

//举报话题
- (void)pushToReportVC:(NSUInteger)dataIndex {
    ReportVC *reportVC = [ReportVC new];
    reportVC.idID = [NSNumber numberWithInt:[listArray[dataIndex][@"commentId"] intValue]];
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
