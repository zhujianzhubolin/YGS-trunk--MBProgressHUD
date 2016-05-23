//
//  GoodsShopsCommentsVC.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#define ShopStarVStartTag 777

#import "GoodsShopsCommentsVC.h"
#import "MineBuyorderM.h"
#import "MineBuyShiGoodM.h"
#import "MineBuyShopsM.h"
#import "GoodsShopsCommentsCell.h"
#import "StarLevelCell.h"
#import "uploadCollectionCell.h"
#import "MultiShowing.h"
#import "GetImgFromSystem.h"
#import "UIImage+wrapper.h"
#import "NSData+wrapper.h"
#import "UserManager.h"
#import "BuyViewController.h"
#import "ZYStarLevelView.h"
//提交商品和商家评价
#import "GoodsShopsCommentModel.h"
#import "GoodsShopsCommentHandel.h"
//上传图片接口类
#import "ComplaintHandler.h"
#import "FilePostE.h"



@interface GoodsShopsCommentsVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,GetImgFromSystemDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,didSelectImgBtn>


@end

@implementation GoodsShopsCommentsVC
{
    UITableView *gscommentsTB;
    
    
    CGFloat interval;
    NSUInteger singleRowNum;
    CGFloat itemWidth;
    int postImgCount;
    MultiShowing  *multshowimg;

    //图片上传后返回的图片ID
    
    NSMutableArray *starLevelArray1;//描述相符星级的图片数组
    NSMutableArray *starLevelArray2;//物流服务星级的图片数组
    NSMutableArray *starLevelArray3;//服务态度星级的图片数组

    NSMutableArray *descArr;
    NSMutableArray *imgIDArr;
    NSMutableArray *imgPostArr;
    NSMutableArray *contentArr;
    NSMutableArray *ratingArr;
    NSMutableArray *caculateArr;
    
    NSMutableString *imgIDStr;
    NSMutableArray *postImgArr;
    
    
    NSUInteger cellClickSection;
    NSDictionary *goodsCommentDic;
}

- (void)setOrderM:(MineBuyorderM *)orderMMM {
    _orderM = orderMMM;
    

    imgPostArr=[NSMutableArray array];
    imgIDArr = [NSMutableArray array];
    contentArr = [NSMutableArray array];
    ratingArr = [NSMutableArray array];
    caculateArr = [NSMutableArray array];
    [imgPostArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    
    
    if (_ifTgorSc == ScClass)
    {
        [_orderM.orderItemInfoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self addInitialData];
        }];
    }
    else
    {
        [self addInitialData];
    }
}

- (void)addInitialData {
    NSMutableArray *imgArr = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"postImg"], nil];
    NSMutableString *emptyStr = [[NSMutableString alloc]init];
    [imgIDArr addObject:emptyStr];
    [imgPostArr addObject:imgArr];
    [ratingArr addObject:@"5"];
    [contentArr addObject:@""];
    [caculateArr addObject:[NSNumber numberWithInt:0]];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

-(void)initData
{
    [GetImgFromSystem getImgInstance].delegate = self;
    
    postImgCount = 9;
    interval = 10;
    singleRowNum = 4;
    itemWidth = (self.view.frame.size.width - interval * (singleRowNum + 1)) / singleRowNum;
    
    descArr = [NSMutableArray array];
    multshowimg =[[MultiShowing alloc]init];
    goodsCommentDic =[NSDictionary dictionary];
    
    starLevelArray1 = [[NSMutableArray alloc]initWithObjects:@"ZYOrangeNo1",@"ZYOrangeNo2",@"ZYOrangeNo3",@"ZYOrangeNo4",@"ZYOrangeNo5", nil];
    starLevelArray2 = [[NSMutableArray alloc]initWithObjects:@"ZYGreenNo1",@"ZYGreenNo2",@"ZYGreenNo3",@"ZYGreenNo4",@"ZYGreenNo5", nil];
    starLevelArray3 = [[NSMutableArray alloc]initWithObjects:@"ZYAzureNo1",@"ZYAzureNo2",@"ZYAzureNo3",@"ZYAzureNo4",@"ZYAzureNo5", nil];
}

-(void)initUI
{
    
    
    self.title=@"订单评价";
    self.view.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame= CGRectMake(0, 0, 50, 44);
//    [backBtn setTitle:@"我的订单" forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [backBtn setTitleColor:[AppUtils colorWithHexString:@"F56A03"] forState:UIControlStateNormal];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem =backItem;
    self.navigationController.navigationBar.translucent=YES;
    
    UIView *footoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 100)];
    footoView.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
    UIButton *submintBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    submintBtn.frame=CGRectMake(G_INTERVAL, 30, IPHONE_WIDTH-G_INTERVAL *2, 35);
    [submintBtn setTitle:@"发表评价" forState:UIControlStateNormal];
    [submintBtn setBackgroundColor:[AppUtils colorWithHexString:@"F56A03"]];
    submintBtn.layer.masksToBounds=YES;
    submintBtn.layer.cornerRadius=5;
    [submintBtn addTarget:self action:@selector(submintClock) forControlEvents:UIControlEventTouchUpInside];
    [footoView addSubview:submintBtn];
    
    gscommentsTB = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    gscommentsTB.dataSource=self;
    gscommentsTB.delegate=self;
    gscommentsTB.showsVerticalScrollIndicator = NO;
    gscommentsTB.tableFooterView=footoView;
    gscommentsTB.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
    //gscommentsTB.tableFooterView = [AppUtils tableViewsFooterView];
    [self viewDidLayoutSubviewsForTableView:gscommentsTB];

    [self.view addSubview:gscommentsTB];
}

-(void)submintClock{
    if (imgPostArr.count <= 0) {
        [AppUtils showAlertMessageTimerClose:@"亲,您还没有评价呢"];
        return;
    }
    
    [AppUtils showProgressMessage:@"上传中"];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(submmitPostImg) userInfo:nil repeats:NO];
}

- (void)submmitPostImg {
    __block NSUInteger postFinishiCount = 0;
    
    for (int i = 0; i<imgPostArr.count;i++ )
    {
        NSMutableArray *imgArr = imgPostArr[i];
        NSMutableString *imgIDstr =imgIDArr[i];
        if (imgArr.count <=1) {
            postFinishiCount++;
            if (postFinishiCount == imgPostArr.count) {
                [self postedRequest];
            }
            continue;
        }
        
        dispatch_queue_t concurrentQueue = dispatch_queue_create("mySerailQueue", DISPATCH_QUEUE_CONCURRENT);
        __block int finishCount = [caculateArr[i] intValue];
        
        imgIDstr = [NSMutableString new];
        [imgArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx != imgArr.count - 1) {
                UIImage *img = obj;
                
                ComplaintHandler *complainH = [ComplaintHandler new];
                FilePostE *imgPost = [FilePostE new];
                imgPost.dataD = [NSString encodeBase64Data:[NSData dataTransformUnder1MFromImg:img]];
                imgPost.entityType=@"SHOPPING";
                imgPost.fileName = [NSString stringWithFormat:@"订单商品%d评论图片%lu.png",i,(unsigned long)imgArr.count];
                
                dispatch_async(concurrentQueue, ^{
                    [complainH  excuteImgPostTask:imgPost success:^(id obj) {
                        finishCount++;
                        FilePostE *fileE = (FilePostE *)obj;
                        if (imgIDstr.length <= 0) {
                            [imgIDstr appendFormat:@"%@",fileE.idID];
                        }else{
                            [imgIDstr appendFormat:@",%@",fileE.idID];
                        }
                        
                        [imgIDArr replaceObjectAtIndex:i withObject:imgIDstr];
                        
                        if (finishCount == imgArr.count - 1) {
                            postFinishiCount++;
                        }
                        
                        NSLog(@"i = %d,sucess postFinishiCount = %lu,finishCount = %d",i,(unsigned long)postFinishiCount,finishCount);
                        if (postFinishiCount == imgPostArr.count && finishCount == imgArr.count - 1) {
                            [self postedRequest];
                        }
                    } failed:^(id obj) {
                        finishCount++;
                        NSLog(@"i = %d,failed postFinishiCount = %d,finishCount = %d",i,postFinishiCount,finishCount);
                        if (finishCount == imgArr.count - 1) {
                            postFinishiCount++;
                            finishCount = 0;
                        }
                        
                        if (postFinishiCount == imgPostArr.count && finishCount == imgArr.count - 1) {
                            [self postedRequest];
                        }
                    }];
                });
            }
        }];
    }
}

-(void)postedRequest
{
     [AppUtils showProgressMessage:@"提交中"];
    
    GoodsShopsCommentModel * goodshopM =[GoodsShopsCommentModel new];
    GoodsShopsCommentHandel * goodshopH = [GoodsShopsCommentHandel new];
     NSMutableArray *goodArr = [NSMutableArray array];
    
    if (_ifTgorSc == ScClass)
    {
        [_orderM.orderItemInfoList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GoodsShopsCommentsCell *goodCell = (GoodsShopsCommentsCell *)[gscommentsTB cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:idx]];
            if ([NSString isEmptyOrNull:[goodCell getCommentContent]])
            {
                
            }
            
            MineBuyShiGoodM *shitigoodM=[_orderM.orderItemInfoList objectAtIndex:idx];
            NSMutableString *imgID =[imgIDArr objectAtIndex:idx];
            
            NSLog(@"[goodCell getCommentContent] = %@",[goodCell getCommentContent]);
            NSString *commentStr = @"";
            if (![NSString isEmptyOrNull:[goodCell getCommentContent]]) {
                commentStr = [goodCell getCommentContent];
            }
            
            NSDictionary *goodsDic =[NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:shitigoodM.commodityId.integerValue],@"productId",
                                     [NSNumber numberWithInteger:[UserManager shareManager].userModel.memberId.integerValue],@"memberId",
                                     [NSNumber numberWithFloat:[goodCell getCommentRating]],@"rating",
                                     commentStr,@"content",
                                     self.mineshopsM.orderNo,@"orderItemId",
                                     self.mineshopsM.merchantNo,@"merchantId",
                                     imgID,@"imgId",
                                     [NSNumber numberWithInteger:P_WYID.integerValue],@"companyId", nil];
            [goodArr addObject:goodsDic];
        }];
        
        
        ZYStarLevelView *descripV = (ZYStarLevelView *)[gscommentsTB viewWithTag:ShopStarVStartTag + 1];
        ZYStarLevelView *logisticsV= (ZYStarLevelView *)[gscommentsTB viewWithTag:ShopStarVStartTag + 2];
        ZYStarLevelView *serverV = (ZYStarLevelView *)[gscommentsTB viewWithTag:ShopStarVStartTag + 3];
        
        //    NSLog(@"%lu",(unsigned long)[descripV starLevelVSelectNumber]);
        NSDictionary *queryDic =[NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInteger:_mineshopsM.merchantNo.integerValue],@"storeId",
                                 [NSNumber numberWithInteger:[UserManager shareManager].userModel.memberId.integerValue],@"userId",
                                 [NSString stringWithFormat:@"%lu",(unsigned long)[descripV starLevelVSelectNumber]],@"conformityDegree",
                                 [NSString stringWithFormat:@"%lu",(unsigned long)[serverV starLevelVSelectNumber]],@"serviceAttitude",
                                 [NSString stringWithFormat:@"%lu",(unsigned long)[logisticsV starLevelVSelectNumber]],@"deliverySpeed",
                                 [NSNumber numberWithInteger:P_WYID.integerValue],@"companyId",
                                 goodArr,@"memberProductComment", nil];
        goodshopM.queryMap=queryDic;

    }
    else
    {
//        [_orderM.o nrderItemInfoList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger idx = 0;
            GoodsShopsCommentsCell *goodCell = (GoodsShopsCommentsCell *)[gscommentsTB cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:idx]];
            if ([NSString isEmptyOrNull:[goodCell getCommentContent]])
            {
                
            }
            
            MineBuyShiGoodM *shitigoodM=[_orderM.orderItemInfoList objectAtIndex:idx];
            NSMutableString *imgID =[imgIDArr objectAtIndex:idx];
            
            NSLog(@"[goodCell getCommentContent] = %@",[goodCell getCommentContent]);
            NSString *commentStr = @"";
            if (![NSString isEmptyOrNull:[goodCell getCommentContent]]) {
                commentStr = [goodCell getCommentContent];
            }
            
        NSDictionary *goodsDic =[NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInteger:shitigoodM.productCode.integerValue],@"productId",
                                 [NSNumber numberWithInteger:[UserManager shareManager].userModel.memberId.integerValue],@"memberId",
                                 [NSNumber numberWithFloat:[goodCell getCommentRating]],@"rating",
                                 commentStr,@"content",
                                 self.mineshopsM.orderNo,@"orderItemId",
                                 self.mineshopsM.merchantNo,@"merchantId",
                                 imgID,@"imgId",
                                 [NSNumber numberWithInteger:P_WYID.integerValue],@"companyId", nil];
        [goodArr addObject:goodsDic];
//        }];
    
        
        //    NSLog(@"%lu",(unsigned long)[descripV starLevelVSelectNumber]);
        NSDictionary *queryDic =[NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInteger:_mineshopsM.merchantNo.integerValue],@"storeId",
                                 [NSNumber numberWithInteger:[UserManager shareManager].userModel.memberId.integerValue],@"userId",
                                 @"5",@"conformityDegree",
                                  @"5",@"serviceAttitude",
                                  @"5",@"deliverySpeed",
                                 [NSNumber numberWithInteger:P_WYID.integerValue],@"companyId",
                                 goodArr,@"memberProductComment", nil];
        goodshopM.queryMap=queryDic;


    }
    
   
    
    [goodshopH goodShopComment:goodshopM success:^(id obj) {
        [AppUtils showAlertMessageTimerClose:obj];
        if (self.commentSuccessBlock) {
            self.commentSuccessBlock();
        }
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popLastVC) userInfo:nil repeats:NO];
    } failed:^(id obj) {
        if (self.viewIsVisible) {
            [AppUtils showAlertMessageTimerClose:obj];
        }
        else {
            [AppUtils dismissHUD];
        }
    }];
}

- (void)popLastVC {
    __block BOOL isPop = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BuyViewController class]]) {
            isPop = YES;
            [self.navigationController popToViewController:obj animated:YES];
            return;
            *stop = YES;
        }
    }];
    
    if (!isPop) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
     
#pragma mark -UITableViewDeletget

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_ifTgorSc ==ScClass)
    {
        return _orderM.orderItemInfoList.count+1;
    }
    else
    {
        return 1;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //MineBuyorderM *orderM =[_buyshopsM.orderSubInfoList objectAtIndex:0];
    if (section==_orderM.orderItemInfoList.count)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //MineBuyorderM *orderM =[_buyshopsM.orderSubInfoList objectAtIndex:0];
    if (section==_orderM.orderItemInfoList.count)
    {
        return 30;
    }
    else
    {
        return 5;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
   
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 30)];
    if (section==_orderM.orderItemInfoList.count)
    {
        headView.backgroundColor =[AppUtils colorWithHexString:COLOR_MAIN];
        UILabel *headLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, IPHONE_WIDTH-10, 30)];
        headLab.text=@"商家评论";
        headLab.font=[UIFont systemFontOfSize:14];
        [headView addSubview:headLab];
    }
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MineBuyorderM *orderM =[_buyshopsM.orderSubInfoList objectAtIndex:0];
    
    if (indexPath.section==_orderM.orderItemInfoList.count)
    {
        return 130;
    }
    else
    {
        if (indexPath.row==0)
        {
            return 130;
        }
        else
        {
            NSMutableArray *imgArr = imgPostArr[indexPath.section];
            //NSLog(@"cellHeightForImgArr = %f,imgArr.conut  =%d",[self cellHeightForImgArr:imgArr],imgArr.count);
            return [self cellHeightForImgArr:imgArr]+10;
            //return 70;
        }
    }
}

- (CGFloat)cellHeightForImgArr:(NSArray *)imgArr {
    
    
    NSUInteger rows = imgArr.count % singleRowNum > 0 ? (imgArr.count / singleRowNum + 1) : imgArr.count / singleRowNum;
    NSLog(@"rows = %ld,imgPostArr.count singleRowNum = %lu",rows,imgArr.count % singleRowNum);
    NSLog(@"rows * (interval + itemWidth)+2 ==%f",rows * (interval + itemWidth)+2);
    return rows * (interval + itemWidth)+2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //MineBuyorderM *orderM =[_buyshopsM.orderSubInfoList objectAtIndex:0];
    if (indexPath.section==_orderM.orderItemInfoList.count)
    {
        static NSString *cellIdentifier =@"StarLevelCell";
        StarLevelCell *Cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (Cell==nil)
        {
            Cell =[[StarLevelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
             Cell.selectionStyle=UITableViewCellAccessoryNone;
        }
       
        
        CGFloat LabeWidth =80;
        CGFloat labeHigth =30;
        CGFloat btnInterval  =10;
        
        UILabel *describeLab =[[UILabel alloc]initWithFrame:CGRectMake(btnInterval, btnInterval, LabeWidth, labeHigth)];
        describeLab.text=@"描述相符";
        [Cell.contentView addSubview:describeLab];
        
        UILabel *logisticsLab = [[UILabel alloc]initWithFrame:CGRectMake(btnInterval, CGRectGetMaxY(describeLab.frame)+btnInterval, LabeWidth, labeHigth)];
        logisticsLab.text=@"发货速度";
        [Cell.contentView addSubview:logisticsLab];
        
        UILabel *serviceLab =[[UILabel alloc]initWithFrame:CGRectMake(btnInterval, CGRectGetMaxY(logisticsLab.frame)+btnInterval, LabeWidth, labeHigth)];
        serviceLab.text=@"服务态度";
        [Cell.contentView addSubview:serviceLab];
        
        ZYStarLevelView *describeStarleve =[[ZYStarLevelView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(describeLab.frame), 10, IPHONE_WIDTH-(describeLab.frame.size.width+btnInterval*2), labeHigth) defaultcolorImg:[UIImage imageNamed:@"ZYDefaultColor"] imgAarray:starLevelArray1];
        describeStarleve.layer.masksToBounds=YES;
        describeStarleve.layer.cornerRadius=4;
        describeStarleve.tag=ShopStarVStartTag+1;
        [Cell.contentView addSubview:describeStarleve];
        
        ZYStarLevelView *logisticsStarleve =[[ZYStarLevelView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logisticsLab.frame), logisticsLab.frame.origin.y, IPHONE_WIDTH-(describeLab.frame.size.width+btnInterval*2), labeHigth) defaultcolorImg:[UIImage imageNamed:@"ZYDefaultColor"] imgAarray:starLevelArray2];
        logisticsStarleve.layer.masksToBounds=YES;
        logisticsStarleve.layer.cornerRadius=4;
        logisticsStarleve.tag=ShopStarVStartTag+2;
        [Cell.contentView addSubview:logisticsStarleve];
        
        ZYStarLevelView *serviceStarleve =[[ZYStarLevelView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(serviceLab.frame), serviceLab.frame.origin.y, IPHONE_WIDTH-(serviceLab.frame.size.width+btnInterval*2), labeHigth) defaultcolorImg:[UIImage imageNamed:@"ZYDefaultColor"] imgAarray:starLevelArray3];
        serviceStarleve.layer.masksToBounds=YES;
        serviceStarleve.layer.cornerRadius=4;
        serviceStarleve.tag=ShopStarVStartTag+3;

        [Cell.contentView addSubview:serviceStarleve];
        
        return Cell;
        
    }
    else
    {
        if (indexPath.row==0)
        {
            static NSString *cellIdentifier =@"GoodsShopsCell";
            GoodsShopsCommentsCell *Cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (Cell==nil)
            {
                Cell =[[GoodsShopsCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                Cell.selectionStyle=UITableViewCellAccessoryNone;
            }
            
            
            if (_ifTgorSc ==ScClass)
            {
                [Cell setGoodsinfo:[_orderM.orderItemInfoList objectAtIndex:indexPath.row] ifTgOrSc:@"shangcheng"];
            }
            else
            {
                [Cell setGoodsinfo:[_orderM.orderItemInfoList objectAtIndex:indexPath.row] ifTgOrSc:@"tuangou"];
            }
            

            return Cell;
        }
        else
        {
            UITableViewCell *Cell =[tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
            if (Cell==nil)
            {
                Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
                Cell.selectionStyle=UITableViewCellAccessoryNone;
            }
            
            UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            
            UICollectionView *collectionTB = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,[self cellHeightForImgArr:imgPostArr[indexPath.section]]) collectionViewLayout:flowLayout];
            [collectionTB registerClass:[uploadCollectionCell class] forCellWithReuseIdentifier:SYSTEM_CELL_Col_ID];
            
            collectionTB.scrollEnabled = YES;
            collectionTB.userInteractionEnabled = YES;
            collectionTB.dataSource = self;
            collectionTB.delegate = self;
            collectionTB.backgroundColor =[UIColor whiteColor];
            collectionTB.tag=indexPath.section+1;
            
            [Cell.contentView addSubview:collectionTB];
            return Cell;
        }
    }
}





#pragma mark - UICollectionViewDelegate 代理方法

//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger cellIndex = collectionView.tag - 1;
    if (cellIndex < imgPostArr.count) {
        NSMutableArray *imgArr = imgPostArr[cellIndex];
        NSLog(@"numberOfItemsInSectionimgArr.count = %d",imgArr.count);
        return imgArr.count;
    }
   
    return 0;
}


//设置元素的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top ={interval ,interval, 0, interval};
    return top;
}

//设置单元格大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(itemWidth,itemWidth);
}

//每个分区上的元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    uploadCollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:SYSTEM_CELL_Col_ID forIndexPath:indexPath];
    cell.cellIndex = collectionView.tag - 1;
    NSMutableArray *imgArr = imgPostArr[collectionView.tag-1];
    NSLog(@"cellForItemAtIndexPath");
    cell.imageBtn.tag=indexPath.row+TAG_BEGIN_CELL;

    //[cell.imageBtn setBackgroundColor:[AppUtils colorForRandom]];
    [cell.imageBtn setBackgroundImage:imgArr[indexPath.row] forState:UIControlStateNormal];
    cell.didimgbtnDeletget=self;
    return cell;
}

-(void)didimgBtnIndex:(NSInteger)btnIndex cellIndex:(NSUInteger)cellIndex
{
    [self.view endEditing:YES];
    cellClickSection = cellIndex;
    NSMutableArray *imgArr = imgPostArr[cellClickSection];
    
    if (btnIndex==imgArr.count - 1)
    {
        if (imgArr.count >= postImgCount + 1)
        {
            [AppUtils showAlertMessage:[NSString stringWithFormat:@"最多只能上传%d张图片",postImgCount]];
            return;
        }
        else{
            [GetImgFromSystem getImgInstance].maxCount = postImgCount + 1 - imgArr.count;
            [[GetImgFromSystem getImgInstance] getImgFromVC:self];
        }
    }
    else
    {
        NSMutableArray *showImgs = [imgArr mutableCopy];
        [showImgs removeLastObject];
        [multshowimg ShowImageGalleryFromView:gscommentsTB ImageList:showImgs ImgType:ImgTypeFromImg Scale:2.0];
    }
}

#pragma mark - GetImgFromSystemDelegate
- (void)getFromImg:(NSArray *)imgArr;
{
        NSMutableArray *rowImgArr = imgPostArr[cellClickSection];
        
        [imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [rowImgArr insertObject:obj atIndex:rowImgArr.count - 1];
        }];
        
        [imgPostArr replaceObjectAtIndex:cellClickSection withObject:rowImgArr];
        
        [gscommentsTB reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:cellClickSection]] withRowAnimation:UITableViewRowAnimationNone];
    
        UITableViewCell *tbCell = [gscommentsTB cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:cellClickSection]];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tbCell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"collcv.p = %@",obj);
            if ([obj isKindOfClass:[UICollectionView class]]) {
                UICollectionView *collcV = obj;
                NSLog(@"collcv.p = %p",collcV);
                [collcV reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    collcV.frame=CGRectMake(0, 0,collcV.frame.size.width,[self cellHeightForImgArr:rowImgArr]);
                });
                *stop = YES;
            }
        }];

//    });
    

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
//    [gscommentsTB reloadSections:[NSIndexSet indexSetWithIndex:cellClickSection] withRowAnimation:UITableViewRowAnimationAutomatic];
//    });
//        UICollectionView *collcV = (UICollectionView *)[gscommentsTB viewWithTag:cellClickSection + 1];
//        NSLog(@"UICollectionViewcollcV.tag = %d",collcV.tag);
//        NSLog(@"UICollectionViewcollcv.p = %p",collcV);
//        [collcV reloadData];
    

}
@end
