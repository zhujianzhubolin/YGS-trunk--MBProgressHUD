//
//  MoreShopPingLunViewController.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/27.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "MoreShopPingLunViewController.h"
#import "Life_First.h"
#import "ShopPingLunModel.h"
#import "ZJWebProgrssView.h"
#import "TGPingJianCell.h"
#import "RatingBar.h"

@interface MoreShopPingLunViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ZJWebProgrssView * progress;
    __weak IBOutlet UITableView *pinglunTableView;
    NSMutableArray * pingJiaArray;
    BOOL isReMove;
    int pageNum;
    RatingBar * rating;
    
    NSString * totalCount;
    UIView * view1;
}

@end

@implementation MoreShopPingLunViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    pageNum = 1;
    isReMove = YES;
    pingJiaArray = [NSMutableArray array];
    
    self.title = @"商家全部评价";
    
    [self viewDidLayoutSubviewsForTableView:pinglunTableView];
    
    [pinglunTableView registerNib:[UINib nibWithNibName:@"TGPingJianCell" bundle:nil] forCellReuseIdentifier:@"PJCell"];
    pinglunTableView.delegate = self;
    pinglunTableView.dataSource = self;
    
    [self setExtraCellLineHidden:pinglunTableView];
    
    progress = [[ZJWebProgrssView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:progress];
    __block typeof(self)weakSelf = self;
    progress.loadBlock = ^{
        [weakSelf getShopPingLun];
    };
    [progress startAnimation];
    
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getShopPingLun) userInfo:nil repeats:NO];
    
    
    [pinglunTableView addLegendHeaderWithRefreshingBlock:^{
        
        isReMove = YES;
        pageNum = 1;
        
        [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getShopPingLun) userInfo:nil repeats:NO];

    }];
    
    [pinglunTableView addLegendFooterWithRefreshingBlock:^{
        
        isReMove = NO;
        pageNum++;
        
        [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getShopPingLun) userInfo:nil repeats:NO];

    }];
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 40)];
    headView.backgroundColor = [AppUtils colorWithHexString:@"DCDCDC"];
    pinglunTableView.tableHeaderView = headView;
    
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 5, IPHONE_WIDTH, 30)];
    view1.backgroundColor = [UIColor whiteColor];
    [headView addSubview:view1];
   
}


//获取商家评论
- (void)getShopPingLun{
    
    Life_First * handel = [Life_First new];
    ShopPingLunModel * model = [ShopPingLunModel new];
    model.pageSize = @"5";
    model.pageNumber = [NSString stringWithFormat:@"%d",pageNum];
    
    model.storeType = @"2601";//有数据修改
    model.storeId = [NSString stringWithFormat:@"%@",self.shopId];
    [handel getShopPingLun:model success:^(id obj) {
        
        NSLog(@"商品评价>>>>%@",obj);
        
        if (![obj[@"totalCount"] isEqual:[NSNull null]]) {
            totalCount = obj[@"totalCount"];
        }
        
        
        NSString * numStr = [NSString stringWithFormat:@"综合(共%@条)",totalCount];
        CGSize wordW = [AppUtils sizeWithString:numStr font:[UIFont systemFontOfSize:15] size:CGSizeMake(1000, 30)];
        
        
        UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, wordW.width, 30)];
        number.font = [UIFont systemFontOfSize:15];
        [view1 addSubview:number];
        NSInteger location = numStr.length - 2 - totalCount.length;
        NSRange range = NSMakeRange(location, totalCount.length);
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",numStr]];
        [str1 addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"04b6e9"] range:NSMakeRange(range.location,range.length)];
        number.attributedText = str1;
        
        
        rating = [[RatingBar alloc] initWithFrame:CGRectMake(number.frame.origin.x + number.frame.size.width + 5, 8, 75, 15)];
        [view1 addSubview:rating];
        [rating setImageDeselected:@"xingxing_n" halfSelected:@"banxing" fullSelected:@"xingxing" andDelegate:nil];
        rating.isIndicator = YES;
        
        
//        if (obj[@""]) {

//        }
//        
        [rating displayRating:4.5];
        
        
        
        if (isReMove) {
            [pingJiaArray removeAllObjects];
        }
        
        if (![obj[@"list"] isEqual:[NSNull null]]) {
            for (NSDictionary * dict in obj[@"list"]) {
                [pingJiaArray addObject:dict];
            }
        }
        
        [pinglunTableView.header endRefreshing];
        [pinglunTableView.footer endRefreshing];

        
        [progress stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:pingJiaArray]];
        [pinglunTableView reloadData];
        
    } failed:^(id obj) {
        
        [pinglunTableView.header endRefreshing];
        [pinglunTableView.footer endRefreshing];
        
        [progress stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:pingJiaArray]];
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];

    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return pingJiaArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat totalFloat = 0;
    NSString *showText = [NSString stringWithFormat:@"%@",pingJiaArray[indexPath.row][@"content"]];;
    CGSize constraint = CGSizeMake(IPHONE_WIDTH - 8*2, MAXFLOAT);
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:showText
     attributes:attributes];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    totalFloat = MAX(50 + size.height + 5, 57);
    return totalFloat;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TGPingJianCell * pjCell = [tableView dequeueReusableCellWithIdentifier:@"PJCell"];
    
    if (pjCell == nil) {
        
        pjCell = [[TGPingJianCell alloc] init];
        
    }
    
    [pjCell setPingJiaCellData:pingJiaArray[indexPath.row] isGoods:NO];
    
    return pjCell;
}

//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


@end
