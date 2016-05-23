//
//  TGPingJianViewController.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "TGPingJianViewController.h"
#import "GoodsPingJiaCell.h"
#import "Life_First.h"
#import "PinLunModel.h"
#import "ZJWebProgrssView.h"
#import "RatingBar.h"
#import "DeletePingLunModel.h"
#import "TGHandel.h"
#import "UserManager.h"
@interface TGPingJianViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    
    __weak IBOutlet UITableView *pingjiaTableView;
    NSMutableArray * pingLunListArray;
    
    int pageNum;
    BOOL isRemoveAll;
    ZJWebProgrssView *progressV;
    RatingBar * rating;
    NSString * totalCount;
    UIView * view1;
    NSIndexPath * deleIndex;
    NSString * pageCount;
    UILabel * number;
}

@end

@implementation TGPingJianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更多评价";
    
    pingjiaTableView.delegate = self;
    pingjiaTableView.dataSource =self;
    
    pageNum = 1;
    
    pingLunListArray  = [NSMutableArray array];
    
    [pingjiaTableView addLegendHeaderWithRefreshingBlock:^{
        
        pageNum = 1;
        isRemoveAll = YES;
        [self SeePinLun];
    }];
    
    
    [pingjiaTableView addLegendFooterWithRefreshingBlock:^{
        
        pageNum ++;
        isRemoveAll = NO;
        [self SeePinLun];
    }];
    
    
    
    __block typeof (self)weakSelf = self;

    progressV = [[ZJWebProgrssView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:progressV];
    
    progressV.loadBlock = ^ {
        [NSTimer scheduledTimerWithTimeInterval:0.8 target:weakSelf selector:@selector(SeePinLun) userInfo:nil repeats:NO];

    };
    [progressV startAnimation];
    
    [pingjiaTableView registerNib:[UINib nibWithNibName:@"GoodsPingJiaCell" bundle:nil] forCellReuseIdentifier:@"PJCell"];
    [self setExtraCellLineHidden:pingjiaTableView];
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(SeePinLun) userInfo:nil repeats:NO];
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 40)];
    headView.backgroundColor = [AppUtils colorWithHexString:@"DCDCDC"];
    pingjiaTableView.tableHeaderView = headView;
    
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 2, IPHONE_WIDTH, 36)];
    view1.backgroundColor = [UIColor whiteColor];
    [headView addSubview:view1];
}

//查看评论
- (void)SeePinLun{
    Life_First * handel = [Life_First new];
    PinLunModel * model = [PinLunModel new];
    model.productId = [NSNumber numberWithLong:[self.goodsID intValue]];
    model.pageNumber = [NSNumber numberWithLong:pageNum];
    model.pageSize = [NSNumber numberWithLong:10];

    [handel getPinLunInStore:model success:^(id obj) {
        
        NSLog(@"评价列表>>>>>%@",obj);
        
        if (![obj[@"pageCount"] isEqual:[NSNull null]]) {
            pageCount = obj[@"pageCount"];
        }
        
        totalCount = nil;
        
        if (![obj[@"totalCount"] isEqual:[NSNull null]]) {
            totalCount = obj[@"totalCount"];
        }
        
        
        [number removeFromSuperview];
        [rating removeFromSuperview];
        
        NSString * numStr = [NSString stringWithFormat:@"综合(共%@条)",totalCount];
        CGSize wordW = [AppUtils sizeWithString:numStr font:[UIFont systemFontOfSize:15] size:CGSizeMake(1000, 30)];
        
        
        number = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, wordW.width, 30)];
        number.font = [UIFont systemFontOfSize:15];
        [view1 addSubview:number];
        
        
        
        NSInteger location = numStr.length - 2 - totalCount.length;
        NSRange range = NSMakeRange(location, totalCount.length);
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",numStr]];
        [str1 addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"04b6e9"] range:NSMakeRange(range.location,range.length)];
        number.attributedText = str1;
        
        
        

        
        
        rating = [[RatingBar alloc] initWithFrame:CGRectMake(number.frame.origin.x + number.frame.size.width + 5, 8, 75, 15)];
        [view1 addSubview:rating];
        [rating setImageDeselected:@"star_gray" halfSelected:@"starBlueHalf" fullSelected:@"star_blue" andDelegate:nil];
        rating.isIndicator = YES;
        
        if (![obj[@"keyword"] isEqual:[NSNull null]]) {
            
            [rating displayRating:[obj[@"keyword"] floatValue]];
            
        }else{
            
            [rating displayRating:0];
            
        }
        
        if (isRemoveAll) {
            
            [pingLunListArray removeAllObjects];
        }
        
        if (![obj[@"list"] isEqual:[NSNull null]]) {
            
            
            for (NSDictionary * ping in obj[@"list"]) {
                
                [pingLunListArray addObject:ping];
                
                NSLog(@"评价Array>>>>>%@",ping);
                
            }
        }
        
        
        [pingjiaTableView.header endRefreshing];
        [pingjiaTableView.footer endRefreshing];
        
        [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:pingLunListArray]];
        [pingjiaTableView reloadData];

    } failed:^(id obj) {
        [pingjiaTableView.header endRefreshing];
        [pingjiaTableView.footer endRefreshing];
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:pingLunListArray]];
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    [AppUtils tableViewFooterPromptWithPNumber:pageNum withPCount:[pageCount intValue] forTableV:pingjiaTableView];

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSLog(@"刷新次数");
    
    return pingLunListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    return 60;

    //上面高度30
    //动态计算lable的高度
    NSString *showText = [NSString stringWithFormat:@"%@",pingLunListArray[indexPath.row][@"content"]];;
    CGSize constraint = CGSizeMake(IPHONE_WIDTH - 20, MAXFLOAT);
    
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:showText
     attributes:attributes];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    BOOL isImage;
    
    if (![pingLunListArray[indexPath.row][@"file"] isEqual:[NSNull null]] && [pingLunListArray[indexPath.row][@"file"] count] > 0) {
        isImage = YES;
    }else{
        isImage = NO;
    }
    
    
    CGFloat totalHeight;
    
    if (isImage) {
        totalHeight = 30 + 70 + rect.size.height + 15;
    }else{
        totalHeight = 30  + rect.size.height + 15;
    }

    return totalHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsPingJiaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PJCell"];
    
    if (cell == nil) {
        
        cell = [[GoodsPingJiaCell alloc] init];
        
    }
    
        [cell GoodsPingJIa:pingLunListArray[indexPath.row]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([pingLunListArray[indexPath.row][@"memberId"] isEqualToString:[UserManager shareManager].userModel.memberId]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的评价非常重要，是否删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    deleIndex = indexPath;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {//删除评论
        NSString * commentId = pingLunListArray[deleIndex.row][@"commentId"];
        [self deletePingLunWithCommentID:commentId];
    }
}


//删除评论
- (void)deletePingLunWithCommentID:(NSString *)commentId{
    
    TGHandel * handel = [TGHandel new];
    DeletePingLunModel * model = [DeletePingLunModel new];
    model.commentId = commentId;
    
    [handel deletePingLun:model success:^(id obj) {
        
        NSLog(@"删除修改>>>>>%@",obj);
        
        if ([obj[@"code"] isEqualToString:@"success"]) {
            
            [pingjiaTableView.header beginRefreshing];
            
        }else{
            
        }
        [AppUtils showAlertMessageTimerClose:obj[@"message"]];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
    }];
}


//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor redColor];
    [tableView setTableFooterView:view];
}

@end
