//
//  TGShopDetailViewController.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/18.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "TGShopDetailViewController.h"
//#import "TuanGouShangJiaCell.h"
#import "MapViewController.h"
#import "Life_First.h"
#import "EasyShopInfo.h"
#import "UserManager.h"
#import "YingYeZhiZhao.h"
#import "TGPingJianCell.h"
#import "AllKuaiSongViewController.h"
#import "ZJWebProgrssView.h"
#import "GoodsViewController.h"
#import "DeletePingLunModel.h"
#import "TGHandel.h"
#import "RatingBar.h"
#import "SDCycleScrollView.h"
#import "MultiShowing.h"
#import "WebImage.h"
#import "ZLPhotoPickerBrowserViewController.h"
#import <UIImageView+AFNetworking.h>
#import <UIView+SDAutoLayout.h>

@interface TGShopDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SDCycleScrollViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource>

@property(nonatomic,strong)SDCycleScrollView *dScollView;
@property(nonatomic,strong)UILabel *pageIndexlab;


@end

@implementation TGShopDetailViewController
{
    __weak IBOutlet UITableView *tgShopDetail;
    
    
    NSMutableArray * localImageArray;
    
    UIButton * teleBtn;
    UIButton * YYZZBtn;
    NSIndexPath * deleIndex;
    UIButton * myshoucangbtn;
    NSDictionary * shopDict;
    
    //商家里面经营类型的数组
    NSMutableArray * kindArray;
    NSMutableArray * pingJiaArray;
    ZJWebProgrssView * progress;
    
    int pageNum;
    BOOL isRemoveAll;
    
    int totalCount;
    NSString * totalPingJia;
    
    ZJWebProgrssView *_progressV;
    NSMutableArray * shopInforArray;
    
    BOOL isRz;
    RatingBar *rating;
    
    
    MultiShowing  *multiS;
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hidetabbar];
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(getShopInfor) userInfo:nil repeats:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageNum = 1;
    isRemoveAll = YES;
    
    [tgShopDetail registerNib:[UINib nibWithNibName:@"TuanGouShangJiaCell" bundle:nil] forCellReuseIdentifier:@"SJCell"];
    [tgShopDetail registerNib:[UINib nibWithNibName:@"TGPingJianCell" bundle:nil] forCellReuseIdentifier:@"PJCell"];

    tgShopDetail.delegate = self;
    tgShopDetail.dataSource = self;
    
    kindArray = [NSMutableArray array];
    pingJiaArray = [NSMutableArray array];
    shopInforArray = [NSMutableArray array];
    multiS = [MultiShowing new];
    
    [self viewDidLayoutSubviewsForTableView:tgShopDetail];
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 5)];
    tgShopDetail.tableHeaderView = headView;
    
    localImageArray = [NSMutableArray array];
    
//    localImageArray = [NSMutableArray arrayWithObjects:@"dingwei",@"PeiSongArea",@"phone_n",@"YingYeZhiZhao_L", nil];
    
    self.title = @"商家详情";
    totalPingJia = @"";
    
    progress = [[ZJWebProgrssView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:progress];
    __block typeof(self)weakSelf = self;
    progress.loadBlock = ^{
        [weakSelf getShopInfor];
    };
    [progress startAnimation];
    
    myshoucangbtn= [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [myshoucangbtn setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [myshoucangbtn setImage:[UIImage imageNamed:@"shoucang_h"] forState:UIControlStateSelected];
    [myshoucangbtn addTarget:self action:@selector(ShouCangGoods:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:myshoucangbtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem2;
    
//    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(getShopInfor) userInfo:nil repeats:NO];
    
    
    [tgShopDetail addLegendHeaderWithRefreshingBlock:^{
        pageNum = 1;
        isRemoveAll = YES;
        [self getShopPingLun];
    }];
    
    [tgShopDetail addLegendFooterWithRefreshingBlock:^{
        pageNum++;
        isRemoveAll = NO;
        [self getShopPingLun];
    }];
    
    _progressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 100)];
    _progressV.loadBlock = ^{
        [weakSelf getShopPingLun];
    };
    _progressV.backgroundColor = [UIColor clearColor];
    tgShopDetail.tableFooterView = _progressV;
    [_progressV startAnimation];
}

- (void)getShopInfor{
    
    Life_First * handel = [Life_First new];
    EasyShopInfo * info = [EasyShopInfo new];
    info.storeId = [NSNumber numberWithLong:[self.shopId intValue]];

    info.memberId = [UserManager shareManager].userModel.memberId;
    [handel getShopInfor:info success:^(id obj) {
        
        shopDict = (NSDictionary *)obj;
        
        NSLog(@"商家信息>>>>>%@",obj);
        
        [kindArray removeAllObjects];
        [shopInforArray removeAllObjects];
        
        if (![obj[@"entity"] isEqual:[NSNull null]]) {
            
            //storeGroupProduct-----商家团购
            if ([obj[@"entity"][@"storeGroupProduct"] isEqualToString:@"Y"]) {
                [kindArray addObject:@"查看商家的团购"];
            }
            //storeProduct-----商家快送
            if ([obj[@"entity"][@"storeProduct"] isEqualToString:@"Y"]) {
                [kindArray addObject:@"查看商家的快送商品"];
            }
            //storeShop-----商家商城
            if ([obj[@"entity"][@"storeShop"] isEqualToString:@"Y"]) {
                [kindArray addObject:@"查看商家的商城商品"];
            }
            
            if ([obj[@"entity"][@"status"] isEqualToString:@"Y"]) {
                myshoucangbtn.selected = YES;
            }else{
                myshoucangbtn.selected = NO;
            }
            
            
            
//            localImageArray = [NSMutableArray arrayWithObjects:@"dingwei",@"PeiSongArea",@"phone_n",@"YingYeZhiZhao_L", nil];

            //配置商家信息
            //商家地址
            if (![obj[@"entity"][@"latitude"] isEqual:[NSNull null]] && ![obj[@"entity"][@"latitude"] isEqual:[NSNull null]]) {
                [shopInforArray addObject:[NSString stringWithFormat:@"商家地址:%@",obj[@"entity"][@"storeAddress"]]];
                [localImageArray addObject:@"dingwei"];
            }
            
            //配送范围
            if (![obj[@"entity"][@"range"] isEqual:[NSNull null]]) {
                [shopInforArray addObject:[NSString stringWithFormat:@"配送范围:%@",obj[@"entity"][@"range"]]];
                [localImageArray addObject:@"PeiSongArea"];
            }
            
            //商家电话
            if (![obj[@"entity"][@"phone"] isEqual:[NSNull null]]) {
                [shopInforArray addObject:[NSString stringWithFormat:@"商家电话:%@",obj[@"entity"][@"phone"]]];
                [localImageArray addObject:@"phone_n"];
            }
            
            //营业执照
            if (![obj[@"entity"][@"yyzzImg"] isEqual:[NSNull null]]) {
                [shopInforArray addObject:[NSString stringWithFormat:@"营业执照"]];
                [localImageArray addObject:@"YingYeZhiZhao_L"];
            }
        
            
            //认证状态
            if ([obj[@"entity"][@"rzStatus"] isEqual:[NSNull null]] || [obj[@"entity"][@"rzStatus"] isEqualToString:@"未认证"]) {

                isRz = NO;
            }else{
                isRz = YES;
            }
            
            
            [progress stopAnimationNormalIsNoData:NO];
            
        }else{
        
            [progress stopAnimationNormalIsNoData:YES];

        }

        [self getShopPingLun];
        
    } failed:^(id obj) {
        [progress stopAnimationFailIsNoData:YES];
    }];
    
}




//获取商家评论
- (void)getShopPingLun{

    Life_First * handel = [Life_First new];
    ShopPingLunModel * model = [ShopPingLunModel new];
    model.pageSize = @"10";
    model.pageNumber = [NSString stringWithFormat:@"%d",pageNum];
    
    model.storeType = @"2601";//有数据修改
    
    model.storeId = [NSString stringWithFormat:@"%@",self.shopId];
    
    [handel getShopPingLun:model success:^(id obj) {
        
        NSLog(@"商品评价>>>>%@",obj);
        
        if (isRemoveAll) {
            [pingJiaArray removeAllObjects];
        }
        
        if (![obj[@"pageCount"] isEqual:[NSNull null]]) {
            totalCount = [obj[@"pageCount"] intValue];
        }else{
            totalCount = 1;
        }
        
        if (![obj[@"list"] isEqual:[NSNull null]]) {
            for (NSDictionary * dict in obj[@"list"]) {
                [pingJiaArray addObject:dict];
            }
        }
        
        [_progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:pingJiaArray]];
        
        if (pingJiaArray.count > 0 || !isRz) {
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, CGFLOAT_MIN)];
            tgShopDetail.tableFooterView = view;
            
        }
        
        [tgShopDetail.header endRefreshing];
        [tgShopDetail.footer endRefreshing];
        
        totalPingJia = [NSString stringWithFormat:@"%@",obj[@"totalCount"]];
        
        [tgShopDetail reloadData];
        
    } failed:^(id obj) {
        [tgShopDetail.header endRefreshing];
        [tgShopDetail.footer endRefreshing];
        [_progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:pingJiaArray]];
    }];
    
    
}



//收藏商品
- (void)ShouCangGoods:(UIButton *)sender{

    Life_First * handel = [Life_First new];
    ShouCangGoods * shop = [ShouCangGoods new];
    
    shop.memberId = [UserManager shareManager].userModel.memberId;
    shop.storeId = [NSString stringWithFormat:@"%@",self.shopId];
    if (sender.selected) {
        shop.isDeleted = @"1";//取消收藏
    }else{
        shop.isDeleted = @"0";//收藏
    }
    
    [handel ShopShouCang:shop success:^(id obj) {
        
        if ([obj[@"code"] isEqualToString:@"success"]) {
            
            sender.selected = !sender.selected;
            
            if (sender.selected) {
                [AppUtils showAlertMessageTimerClose:@"商家收藏成功!"];
            }else{
                [AppUtils showAlertMessageTimerClose:@"取消商家收藏!"];
            }
            
        }else{
            [AppUtils showAlertMessageTimerClose:[NSString stringWithFormat:@"%@",obj[@"message"]]];
        }
        
    } failed:^(id obj) {
        if (self.viewIsVisible) {
            if (sender.selected) {
                [AppUtils showAlertMessageTimerClose:@"商家收藏失败!"];
            }else{
                [AppUtils showAlertMessageTimerClose:@"取消商家收藏失败!"];
            }
        }
        else {
            [AppUtils dismissHUD];
        }
    }];

}

#pragma mark get/set
-(SDCycleScrollView *)dScollView
{
    if (_dScollView == nil)
    {
        _dScollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width-self.view.frame.size.width/4)
                                                        delegate:self
                                                placeholderImage:[UIImage imageNamed:@"ZYShangjiashangchuan"]];
        _dScollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _dScollView.currentPageDotColor = [UIColor whiteColor];
        _dScollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _dScollView.showPageControl=NO;
        
        
        [_dScollView addSubview:self.pageIndexlab];

    }
    return _dScollView;
}

-(UILabel *)pageIndexlab
{
    if (_pageIndexlab == nil)
    {
        _pageIndexlab = [[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-40, self.view.frame.size.width-self.view.frame.size.width/4-40, 30, 30)];
        _pageIndexlab.backgroundColor =[AppUtils colorWithHexString:COLOR_MAIN];
        _pageIndexlab.textColor=[UIColor whiteColor];
        _pageIndexlab.layer.masksToBounds=YES;
        _pageIndexlab.layer.cornerRadius=15;
        _pageIndexlab.font=[UIFont systemFontOfSize:13];
        _pageIndexlab.text= @"0/0";
        _pageIndexlab.textAlignment=NSTextAlignmentCenter;
    }
    return _pageIndexlab;
}

//2、图片放大控件更换，需要设置代理；
#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    NSArray *imgURLCountArr = shopDict[@"entity"][@"storeImgList"];
    return imgURLCountArr.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *imgURLCountArr = shopDict[@"entity"][@"storeImgList"];
    id imageObj = [imgURLCountArr objectAtIndex:indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    
    UIImageView * myImageView = [[UIImageView alloc] initWithFrame:self.dScollView.bounds];
   
    [myImageView setImageWithURL:[NSURL URLWithString:imgURLCountArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"enLargeImg"]];
    photo.toView = myImageView;
    
    return photo;
}



#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    pickerBrowser.dataSource = self;
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView scrollToPageIndex:(NSInteger)index
{
     NSArray *imgURLCountArr = shopDict[@"entity"][@"storeImgList"];
    self.pageIndexlab.text=[NSString stringWithFormat:@"%ld/%lu",(long)index+1,(unsigned long)imgURLCountArr.count];
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [AppUtils tableViewFooterPromptWithPNumber:pageNum withPCount:totalCount forTableV:tgShopDetail];
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        
        return 5;
        
    }else if (section == 1){
    
        return kindArray.count;
        
    }else if (section == 2){
        return shopInforArray.count;
    }else{
        
        if (isRz) {
            return pingJiaArray.count;
        }else{
            return 0;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//60

    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            return self.view.frame.size.width, self.view.frame.size.width-self.view.frame.size.width/4-5;
        }
        else if (indexPath.row==1)
        {
           
            CGSize contentSize =[AppUtils sizeWithString:shopDict[@"entity"][@"name"] font:[UIFont systemFontOfSize:14] size:CGSizeMake(IPHONE_WIDTH-20-60, 1000)];
            if (contentSize.height>30)
            {
                return contentSize.height+15;
            }
            else
            {
                return 44;
            }

        }
        else if (indexPath.row==4)
        {
            NSString *Str=[NSString stringWithFormat:@"主营业务:/n%@",shopDict[@"entity"][@"bizArea"]];
            CGSize contentSize =[AppUtils sizeWithString:Str font:[UIFont systemFontOfSize:14] size:CGSizeMake(IPHONE_WIDTH-20, 1000)];
            if (contentSize.height>30)
            {
                return contentSize.height+15;
            }
            else
            {
                return 44;
            }

        }
        else
        {
            return 44;
        }
    }else if (indexPath.section == 1){
        return 40;
    }else if (indexPath.section == 2){
        return 40;
    }else{
        
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
        

        BOOL isImage;
        
        NSArray * imageArray = (NSArray *)pingJiaArray[indexPath.row][@"file"];
        
        if (![pingJiaArray[indexPath.row][@"file"] isEqual:[NSNull null]] && imageArray.count > 0) {
            isImage = YES;
        }else{
            isImage = NO;
        }
        
        CGFloat totalWithImage = 0;
        if (isImage) {
            totalWithImage = totalFloat + 70;
        }else{
            totalWithImage = totalFloat ;
        }
        return totalWithImage;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
    
        UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
        if (Cell==nil)
        {
            Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
            Cell.accessoryType = UITableViewCellAccessoryNone;
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [Cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        
        UIFont *font = [UIFont systemFontOfSize:14];
        UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(G_INTERVAL, 0, (IPHONE_WIDTH-G_INTERVAL)*2, 44)];
        textL.font=font;
        [Cell.contentView addSubview:textL];

        if (indexPath.row==0)
        {
            [Cell.contentView addSubview:self.dScollView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 NSArray *imgURLCountArr = shopDict[@"entity"][@"storeImgList"];
                if (![NSArray isArrEmptyOrNull:imgURLCountArr]) {
                    self.pageIndexlab.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)imgURLCountArr.count];
                    self.dScollView.imageURLStringsGroup = imgURLCountArr;
                }
            });
            
           
            UIImageView *linexImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.width-self.view.frame.size.width/4-5, IPHONE_WIDTH, 5)];
            linexImg.backgroundColor =[AppUtils colorWithHexString:@"EEEEF4"];
            [Cell.contentView addSubview:linexImg];
        }
        else if (indexPath.row==1)
        {
            textL.text=shopDict[@"entity"][@"name"];
            textL.numberOfLines=0;
            
            CGSize contentSize =[AppUtils sizeWithString:textL.text font:font size:CGSizeMake(IPHONE_WIDTH-G_INTERVAL*3-60, 1000)];
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect textRect = textL.frame;
                textRect.origin.y = contentSize.height > 30 ? G_INTERVAL :(44-contentSize.height)/2;
                
                textRect.size.height = contentSize.height;
                textRect.size.width = IPHONE_WIDTH - G_INTERVAL *3-60;
                textL.frame = textRect;
            });

            textL.textColor=[UIColor orangeColor];
            
            UILabel *rzLab = [[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-70, 10, 60, 24)];
            rzLab.text = @"已认证";
            rzLab.textColor=[UIColor orangeColor];
            rzLab.layer.borderColor=[UIColor orangeColor].CGColor;
            rzLab.textAlignment=NSTextAlignmentCenter;
            rzLab.font=font;
            rzLab.layer.masksToBounds=YES;
            rzLab.layer.cornerRadius=5;
            rzLab.layer.borderWidth=1;
            [Cell.contentView addSubview:rzLab];
            
            if (shopDict!=nil)
            {
                if ([shopDict[@"entity"][@"rzStatus"] isEqual:[NSNull null]]) {
                    rzLab.hidden = YES;
                }else{
                    if ([shopDict[@"entity"][@"rzStatus"] isEqualToString:@"已认证"]) {
                        rzLab.hidden = NO;
                    }else{
                        rzLab.hidden = YES;
                    }
                }
                
            }

        }
        else if (indexPath.row==2)
        {
           textL.text=@"综合评分：";
            
            rating =[[RatingBar alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-85, (44-15)/2, 75, 15)];
            [Cell.contentView addSubview:rating];
            
            [rating setImageDeselected:@"xingxing_n" halfSelected:@"banxing" fullSelected:@"xingxing" andDelegate:nil];
            rating.isIndicator = YES;
            
            NSString * str = [NSString stringWithFormat:@"%@",shopDict[@"entity"][@"score"]];
            [rating displayRating:[str floatValue]];
        }

        else if (indexPath.row==3)
        {
            NSString * serverStart = nil;
            
            NSString * serverEnd = nil;
            
            if ([NSString isEmptyOrNull:shopDict[@"entity"][@"storeStartDate"]]) {
                serverStart = @"00:00";
            }else{
                serverStart = shopDict[@"entity"][@"storeStartDate"];
            }
    
            if ([NSString isEmptyOrNull:shopDict[@"entity"][@"storeEndDate"]]) {
                serverEnd = @"24:00";
            }else{
                serverEnd = shopDict[@"entity"][@"storeEndDate"];
            }

            textL.text=[NSString stringWithFormat:@"营业时间:  %@~%@",serverStart,serverEnd];
        }

        else if (indexPath.row==4)
        {
        
            if ([NSString isEmptyOrNull:shopDict[@"entity"][@"bizArea"]])
            {
                textL.text=[NSString stringWithFormat:@"主营业务:"];
            }
            else
            {
                textL.text=[NSString stringWithFormat:@"主营业务:%@",shopDict[@"entity"][@"bizArea"]];
            }
            textL.numberOfLines=0;
            
            CGSize contentSize =[AppUtils sizeWithString:textL.text font:[UIFont systemFontOfSize:14] size:CGSizeMake(IPHONE_WIDTH-20, 1000)];
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect textRect = textL.frame;
                textRect.origin.y = contentSize.height > 30 ? G_INTERVAL/2 :(44-contentSize.height)/2;

                textRect.size.height = contentSize.height;
                textRect.size.width = IPHONE_WIDTH - G_INTERVAL *2;
                textL.frame = textRect;
            });
        }
        return Cell;
    }else if (indexPath.section == 3){//评价
        TGPingJianCell * pjCell = [tableView dequeueReusableCellWithIdentifier:@"PJCell"];
        if (pjCell == nil) {
            pjCell = [[TGPingJianCell alloc] init];
        }
        [pjCell setPingJiaCellData:pingJiaArray[indexPath.row] isGoods:NO];
        return pjCell;
    }
    else{//商家信息
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        
        [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];

        
        if (shopDict != nil) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.section == 1) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel * shopKind = [UILabel addlable:cell.contentView frame:CGRectMake(10, 0, IPHONE_WIDTH - 10, 40) text:@"" textcolor:[UIColor blackColor]];
                shopKind.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:shopKind];
                shopKind.text = [kindArray objectAtIndex:indexPath.row];
            }
            
            if (indexPath.section == 2) {
                if ([shopInforArray[indexPath.row] hasPrefix:@"商家地址"]) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 18, 20)];
                imageView.backgroundColor = [UIColor clearColor];
                imageView.image = [UIImage imageNamed:localImageArray[indexPath.row]];
                [cell.contentView addSubview:imageView];
                
                UILabel * descLable = [UILabel addlable:cell frame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 10, 0,IPHONE_WIDTH - imageView.frame.origin.x - imageView.frame.size.width - 5 - 30, 40) text:@"" textcolor:[UIColor blackColor]];
                descLable.backgroundColor = [UIColor clearColor];
                
                descLable.text = [shopInforArray objectAtIndex:indexPath.row];
                
                if ([shopInforArray[indexPath.row] hasPrefix:@"商家电话"]) {
                    
                    teleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    teleBtn.frame = CGRectMake(0, 5, tableView.frame.size.width, 30);
                    teleBtn.layer.cornerRadius = 5;
                    [teleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                    [teleBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, G_INTERVAL)];
                    [teleBtn setImage:[UIImage imageNamed:@"shangjiadianhua"] forState:UIControlStateNormal];
                    [teleBtn addTarget:self action:@selector(MakeTelePhoneCall) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:teleBtn];
                    
                }else if ([shopInforArray[indexPath.row] hasPrefix:@"营业执照"]){
                    
                    YYZZBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    YYZZBtn.frame = CGRectMake(0, 5, tableView.frame.size.width, 30);
                    [YYZZBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                    [YYZZBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, G_INTERVAL)];
                    [YYZZBtn setImage:[UIImage imageNamed:@"YingYeZhiZhao"] forState:UIControlStateNormal];
                    YYZZBtn.layer.cornerRadius = 5;
                    [YYZZBtn addTarget:self action:@selector(seeYYZZ) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:YYZZBtn];
                
                }else{
                
                }
                
            }
            
            if (indexPath.section == 3) {

            
            }

        }
        
        return cell;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 2) {
        
        if ([shopInforArray[indexPath.row] hasPrefix:@"商家地址"]) {//查看地图
            MapViewController * map = [[MapViewController alloc] init];
            map.dataDict = shopDict;
            [self.navigationController pushViewController:map animated:YES];
        }
        
    }
    
    if (indexPath.section == 1) {
        
        NSString * kinStr = [kindArray objectAtIndex:indexPath.row];
        NSLog(@">>>>>%@",kinStr);//查看商家的团购  查看商家的快送商品 查看商家的商城商品

        if ([kinStr isEqualToString:@"查看商家的团购"]) {
            AllKuaiSongViewController * all = [[AllKuaiSongViewController alloc] init];
            all.shopId = self.shopId;
            [self.navigationController pushViewController:all animated:YES];
        }
        
        if ([kinStr isEqualToString:@"查看商家的快送商品"]) {
            UIStoryboard *easydetail = [UIStoryboard storyboardWithName:@"LifeViewController" bundle:nil];
            GoodsViewController *detaileasy = [easydetail instantiateViewControllerWithIdentifier:@"EasygoodsList"];
            detaileasy.shopID = [NSString stringWithFormat:@"%@",shopDict[@"entity"][@"id"]];
            detaileasy.shopName = [NSString stringWithFormat:@"%@",shopDict[@"entity"][@"name"]];
            detaileasy.catalogid = @"50";
            [self.navigationController pushViewController:detaileasy animated:YES];
        }
        
        if ([kinStr isEqualToString:@"查看商家的商城商品"]) {
            UIStoryboard *easydetail = [UIStoryboard storyboardWithName:@"LifeViewController" bundle:nil];
            GoodsViewController *detaileasy = [easydetail instantiateViewControllerWithIdentifier:@"EasygoodsList"];
            detaileasy.shopID = [NSString stringWithFormat:@"%@",shopDict[@"entity"][@"id"]];
            detaileasy.shopName = [NSString stringWithFormat:@"%@",shopDict[@"entity"][@"name"]];
            detaileasy.catalogid = @"201";
            [self.navigationController pushViewController:detaileasy animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section==1)
    {
        NSString *detailStr = shopDict[@"entity"][@"details"];
        if (![NSString isEmptyOrNull:detailStr])
        {
            detailStr = [NSString stringWithFormat:@"商家描述:%@",detailStr];
            CGSize detailSize = [AppUtils sizeWithString:detailStr
                                                    font:[UIFont systemFontOfSize:FONT_SIZE - 1]
                                                    size:CGSizeMake(tableView.frame.size.width - G_INTERVAL *2, CGFLOAT_MAX)];
            
            return MAX(detailSize.height + G_INTERVAL *2, 30);
        }
        else
        {
            return CGFLOAT_MIN;
        }
    }
    else if (section == 3) {
        
        if (isRz) {
            return 30;
        }else{
            return CGFLOAT_MIN;
        }
        
    }else{
        return CGFLOAT_MIN;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 ||
        section == 1) {
        return CGFLOAT_MIN;
    }
    else if (section == 3) {
        return 5;
    }else{
        return 5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        NSString *detailStr = shopDict[@"entity"][@"details"];
        if (![NSString isEmptyOrNull:detailStr]) {
            detailStr = [NSString stringWithFormat:@"商家描述:%@",detailStr];
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
            view.backgroundColor = [AppUtils colorWithHexString:@"eeefea"];
            UILabel *detailL = [UILabel addWithFrame:CGRectZero
                                           textColor:[UIColor lightGrayColor]
                                            fontSize:FONT_SIZE - 1
                                                text:detailStr];
            [view sd_addSubviews:@[detailL]];
            
            detailL.sd_layout
            .leftSpaceToView(view,10)
            .rightSpaceToView(view,10)
            .topSpaceToView(view,10)
            .autoHeightRatio(0);

            return view;
        }
        else {
            return nil;
        }
    }
    else if (section == 3) {
        
        if (isRz) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 30)];
            view.backgroundColor = [UIColor whiteColor];
            [UILabel addlable:view frame:CGRectMake(10, 0, IPHONE_WIDTH - 10, 30) text:[NSString stringWithFormat:@"评价(%@)",totalPingJia] textcolor:[UIColor blackColor]];
            return view;
        }else{
            UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, CGFLOAT_MIN)];
            return view1;
            
        }
    }else{
        return nil;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        
        if ([pingJiaArray[indexPath.row][@"memberId"] isEqualToString:[UserManager shareManager].userModel.memberId]) {
            return YES;
        }else{
            return NO;
        }
        
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
        NSString * CommentID = [NSString stringWithFormat:@"%@",pingJiaArray[deleIndex.row][@"commentId"]];
        [self deletePingLunWithCommentID:CommentID];
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
            [self getShopPingLun];
        }else{
            
        }
        [AppUtils showAlertMessageTimerClose:obj[@"message"]];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
    }];
}


//打电话
- (void)MakeTelePhoneCall{

    [AppUtils callPhone:[NSString stringWithFormat:@"%@",shopDict[@"entity"][@"phone"]]];
    
}

//查看营业执照
- (void)seeYYZZ{
    
    if (![shopDict[@"entity"] isEqual:[NSNull null]]) {
        if (![shopDict[@"entity"][@"yyzzImg"] isEqual:[NSNull null]]) {
            YingYeZhiZhao * zz = [[YingYeZhiZhao alloc] init];
            zz.imageUrl = shopDict[@"entity"][@"yyzzImg"];
            [self.navigationController pushViewController:zz animated:YES];
        }else{
            [AppUtils showAlertMessageTimerClose:@"该商家暂无营业执照"];
        }
    }else{
        [AppUtils showAlertMessageTimerClose:@"该商家暂无营业执照"];

    }
}

@end
