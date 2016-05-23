    //
//  CommunityViewCotroller.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#define CELL_INTERVAL 20;

#import "CommunityViewCotroller.h"
#import "CommunityCell.h"
#import <SVProgressHUD.h>
#import "NSData+wrapper.h"
#import "UserManager.h"
#import "SVProgressHUD.h"
#import "ComplaintHandler.h"
#import "FilePostE.h"
#import "BingingXQModel.h"
#import "bindingHandler.h"
#import "HousingViewController.h"

//切换小区接口类
#import "SwitchXQHandler.h"
#import "NSArray+wrapper.h"
#import "UserHandler.h"
#import "UserEntity.h"  
#import "ChooseXQViewController.h"
#import "ZJWebProgrssView.h"

@implementation CommunityViewCotroller
{
    NSIndexPath *didSelectIndex; //点击cell的标识符
    NSMutableArray *comArr; //所有小区列表
    NSMutableArray *comBindingArr; //绑定小区列表
    
    __block NSUInteger selectedIndex; //选中默认小区的标示
    UICollectionView *CollectionView;
    
    ZJWebProgrssView *progressV;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(postXQList) userInfo:nil repeats:NO];
}

- (void)initData {
    comArr = [NSMutableArray array];
    if (self.communityType == CommunityChooseTypeAdd ||
        self.communityType == CommunityChooseTypeChooseDefault) {
        BingingXQModel *xqModel = [BingingXQModel new];
        xqModel.imgPath = [NSArray arrayWithObject:[UIImage imageNamed:@"postImg"]];
        xqModel.xqNo = @"0";
        [comArr addObject:xqModel];
    }
    
    comBindingArr = [NSMutableArray array];
    selectedIndex = 0;
    self.isLoginShow = NO;
}

-(void)initUI
{
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    
    if (self.communityType == CommunityChooseTypeChooseDefault) {
        self.title = @"切换小区";
    }
    else {
        self.title=@"我的小区";
    }
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    //初始化layout
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
    [CollectionView registerClass:[CommunityCell class] forCellWithReuseIdentifier:SYSTEM_CELL_Col_ID];
    CollectionView.scrollEnabled = YES;
    CollectionView.userInteractionEnabled = YES;
    CollectionView.dataSource = self;
    CollectionView.delegate = self;
    CollectionView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:CollectionView];
    progressV = [[ZJWebProgrssView alloc] initWithFrame:self.view.bounds];
    __weak typeof(self)weakSelf = self;
    progressV.loadBlock = ^{
        [weakSelf postXQList];
    };
    
    [self.view addSubview:progressV];
    [progressV startAnimation];
}

//获取所有小区列表,yes为所有小区列表,no为绑定小区列表
-(void)postXQList {
    BingingXQModel *bindM =[BingingXQModel new];
    bindingHandler *bindH =[bindingHandler new];
    bindM.pageNumber=@"1";
    bindM.pageSize=@"1000";

    if (self.communityType == CommunityChooseTypeBinding) {
        bindM.isBinding=@"Y";
    }

    bindM.wyId = [UserManager shareManager].comModel.wyId;
    NSLog(@"[UserManager shareManager].userModel.memberId = %@",[UserManager shareManager].userModel.memberId);
    bindM.merberId=[UserManager shareManager].userModel.memberId;
    bindM.orderType = @"asc";
    bindM.orderBy = @"dateCreated";
    
    [bindH requsetForGetCommunityDataForModel:bindM success:^(id obj) {
        if (self.communityType == CommunityChooseTypeAdd ||
            self.communityType == CommunityChooseTypeChooseDefault) {
            [comArr removeAllObjects];
            BingingXQModel *xqModel = [BingingXQModel new];
            xqModel.imgPath = [NSArray arrayWithObject:[UIImage imageNamed:@"postImg"]];
            xqModel.xqNo = @"0";
            [comArr addObject:xqModel];
        }
        else if (self.communityType == CommunityChooseTypeBinding){
            [comBindingArr removeAllObjects];
        }
        else if (self.communityType == CommunityChooseTypeChooseAll) {
            [comArr removeAllObjects];
        }
        else {
            
        }
        //返回小区列表为空
        NSArray *recvArr = (NSArray *)obj;
        if ([NSArray isArrEmptyOrNull:recvArr]) {
            [AppUtils showAlertMessageTimerClose:@"未获取到小区列表"];
            if (self.communityType == CommunityChooseTypeAdd ||
                self.communityType == CommunityChooseTypeChooseDefault) {
                [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:comArr]];
            }
            else {
                [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:recvArr]];
            }
            [CollectionView reloadData];
            
            if (self.communityType == CommunityChooseTypeChooseDefault ||
                self.communityType == CommunityChooseTypeChooseAll) {
                [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popLastVC) userInfo:nil repeats:NO];
            }
            return;
        }
        
        if (self.communityType == CommunityChooseTypeAdd ||
            self.communityType == CommunityChooseTypeChooseDefault) {
            [comArr removeAllObjects];
            [recvArr enumerateObjectsUsingBlock:^(id obj1, NSUInteger idx, BOOL *stop) {
                [comArr addObject:obj1];
            }];
            
            BingingXQModel *xqModel = [BingingXQModel new];
            xqModel.imgPath = [NSArray arrayWithObject:[UIImage imageNamed:@"postImg"]];
            xqModel.xqNo = @"0";
            [comArr addObject:xqModel];
            
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:comArr]];
        }
        else if (self.communityType == CommunityChooseTypeBinding){
            [recvArr enumerateObjectsUsingBlock:^(id obj1, NSUInteger idx, BOOL *stop) {
                BingingXQModel *recvbinDingM = obj1;
                switch (self.comLimits) {
                    case ComLimitsClassifyProperty: {
                        if (![NSString isEmptyOrNull:recvbinDingM.propertyConst] && [recvbinDingM.propertyConst isEqualToString:@"Y"]) {
                            [comBindingArr addObject:recvbinDingM];
                        }
                    }
                        break;
                    case ComLimitsClassifyPark: {
                        if (![NSString isEmptyOrNull:recvbinDingM.parkingFees] && [recvbinDingM.parkingFees isEqualToString:@"Y"]) {
                            [comBindingArr addObject:recvbinDingM];
                        }
                    }
                        break;
                    case ComLimitsClassifyPass: {
                        if (![NSString isEmptyOrNull:recvbinDingM.pass] && [recvbinDingM.pass isEqualToString:@"Y"]) {
                            [comBindingArr addObject:recvbinDingM];
                        }
                    }
                        break;
                    case ComLimitsClassifyRepair: {
                        if (![NSString isEmptyOrNull:recvbinDingM.repair] && [recvbinDingM.repair isEqualToString:@"Y"]) {
                            [comBindingArr addObject:recvbinDingM];
                        }
                    }
                        break;
                    case ComLimitsClassifyComplaint: {
                        if (![NSString isEmptyOrNull:recvbinDingM.complaints] && [recvbinDingM.complaints isEqualToString:@"Y"]) {
                            [comBindingArr addObject:recvbinDingM];
                        }
                    }
                        break;
                    case ComLimitsClassifyOption: {
                        if (![NSString isEmptyOrNull:recvbinDingM.opinion] && [recvbinDingM.opinion isEqualToString:@"Y"]) {
                            [comBindingArr addObject:recvbinDingM];
                        }
                    }
                        break;
                        
                    default: {
                        [comBindingArr addObject:recvbinDingM];
                    }
                        break;
                }
            }];
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:comBindingArr]];
        }
        else if (self.communityType == CommunityChooseTypeChooseAll) {
            comArr = [obj mutableCopy];
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:comArr]];
        }
        else {
            [progressV stopAnimationNormalIsNoData:YES];
        }
        
        [AppUtils dismissHUD];
        [CollectionView reloadData];
    } failed:^(id obj) {
        if (self.communityType == CommunityChooseTypeAdd ||
            self.communityType == CommunityChooseTypeChooseDefault) {
            BingingXQModel *xqModel = [BingingXQModel new];
            xqModel.imgPath = [NSArray arrayWithObject:[UIImage imageNamed:@"postImg"]];
            xqModel.xqNo = @"0";
            comArr = [NSMutableArray arrayWithObject:xqModel];
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:comArr]];
        }
        else if (self.communityType == CommunityChooseTypeBinding){
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:comBindingArr]];
        }
        else if (self.communityType == CommunityChooseTypeChooseAll){
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:comArr]];
        }
        else {
            [progressV stopAnimationFailIsNoData:YES];
        }
        
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA
                            isShow:self.viewIsVisible];
    }];
}

- (void)popLastVC {
    [self.navigationController popViewControllerAnimated:YES];
}

//切换小区
-(void)switchXQ:(BingingXQModel *)xqModel
{
    [AppUtils showProgressMessage:W_ALL_PROGRESS withType:SVProgressHUDMaskTypeNone];
    
    BingingXQModel *switchM =[BingingXQModel new];
    SwitchXQHandler *switchH = [SwitchXQHandler new];
    switchM.merberId =[UserManager shareManager].userModel.memberId;
    switchM.xqNo =xqModel.xqNo;
    
    [switchH switchXQH:switchM success:^(id obj1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTI_COMMUNITY_CHANGE object:nil];
        
        //获取并修改用户信息
        [UserHandler executeGetUserInfoSuccess:^(id obj) {
            [self modifyUserPara:[UserManager shareManager].comModel];
            [AppUtils showSuccessMessage:obj1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self popLastVC];
            });
        } failed:^(id obj) {
            [UserManager shareManager].comModel = xqModel;
            [self modifyUserPara:[UserManager shareManager].comModel];
            [AppUtils showSuccessMessage:obj1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self popLastVC];
            });
        }];  
    } failed:^(id obj) {
        [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
    }];
}

- (void)modifyUserPara:(BingingXQModel *)xqModel {
    //请求成功后改变选中颜色
    [comArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CommunityCell *cell = (CommunityCell *)[CollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        cell.defaultXqImgV.hidden = YES;
        BingingXQModel *xqM = (BingingXQModel *)obj;
        if (![NSString isEmptyOrNull:xqModel.xqNo] && [xqModel.xqNo isEqualToString:xqM.xqNo]) {
            [UserManager shareManager].comModel = xqM;
            selectedIndex = idx;
        }
    }];
    
    CommunityCell *cell = (CommunityCell *)[CollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    cell.defaultXqImgV.hidden = NO;
    
    //从登陆页面进来
    if (self.isLoginShow) {
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(dismissVCToMain) userInfo:nil repeats:NO];
    }
}

- (void)dismissVCToMain {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshCollectionViewForCell:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    CommunityCell *comCell =(CommunityCell *)cell;
    BingingXQModel *bindM;
    if (self.communityType == CommunityChooseTypeAdd) {
        bindM = comArr[indexPath.row];
//        [comCell reloadCellData:bindM];
//        if (![NSString isEmptyOrNull:bindM.xqNo] && [bindM.xqNo isEqualToString:[UserManager shareManager].comModel.xqNo]) {
//            comCell.defaultXqImgV.hidden = NO;
//        }
//        else {
//            comCell.defaultXqImgV.hidden = YES;
//        }
    }
    else if (self.communityType == CommunityChooseTypeChooseDefault ||
             self.communityType == CommunityChooseTypeChooseAll) {
        bindM = comArr[indexPath.row];
//        [comCell reloadCellData:bindM];
//        if (![NSString isEmptyOrNull:bindM.xqNo] && [bindM.xqNo isEqualToString:[UserManager shareManager].comModel.xqNo]) {
//            comCell.defaultXqImgV.hidden = NO;
//        }
//        else {
//            comCell.defaultXqImgV.hidden = YES;
//        }
    }
    else if (self.communityType == CommunityChooseTypeBinding) {
        bindM = comBindingArr[indexPath.row];
//        [comCell reloadCellData:bindM];
//        if (![NSString isEmptyOrNull:bindM.xqNo] && [bindM.xqNo isEqualToString:[UserManager shareManager].comModel.xqNo]) {
//            comCell.defaultXqImgV.hidden = NO;
//        }
//        else {
//            comCell.defaultXqImgV.hidden = YES;
//        }
    }
    
    [comCell reloadCellData:bindM];
    if (![NSString isEmptyOrNull:bindM.xqNo] && [bindM.xqNo isEqualToString:[UserManager shareManager].comModel.xqNo]) {
        comCell.defaultXqImgV.hidden = NO;
    }
    else {
        comCell.defaultXqImgV.hidden = YES;
    }
}

#pragma mark - UICollectionView 代理方法
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.communityType == CommunityChooseTypeAdd ||
        self.communityType == CommunityChooseTypeChooseDefault ||
        self.communityType == CommunityChooseTypeChooseAll)
    {
        return comArr.count;
    }
    else if (self.communityType == CommunityChooseTypeBinding) {
        return comBindingArr.count;
    }
    else {
        return 0;
    }
}

//设置元素的间隔
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat insetsWitdh = CELL_INTERVAL;
    return UIEdgeInsetsMake(insetsWitdh, insetsWitdh, insetsWitdh, insetsWitdh);
}

//每个分区上的元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityCell *cell =(CommunityCell *)[collectionView dequeueReusableCellWithReuseIdentifier:SYSTEM_CELL_Col_ID forIndexPath:indexPath];
    if ([AppUtils systemVersion] < 8) {
        [self refreshCollectionViewForCell:cell forIndexPath:indexPath];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppUtils systemVersion] >= 8) {
        [self refreshCollectionViewForCell:cell forIndexPath:indexPath];
    }
}

//设置单元格大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     CGFloat insetsWitdh = CELL_INTERVAL;
    return CGSizeMake((CollectionView.frame.size.width - 4 * insetsWitdh) / 2,(CollectionView.frame.size.width - 4 * insetsWitdh)/ 2 + 20);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //添加小区
    if ((self.communityType == CommunityChooseTypeAdd || self.communityType == CommunityChooseTypeChooseDefault) &&
        indexPath.row == comArr.count - 1) {
        if (indexPath.row == comArr.count - 1) {
            ChooseXQViewController *choose = [[ChooseXQViewController alloc]init];
            choose.myXQArr = [comArr copy];
            choose.comAddFinishedBlock = ^{
                [self postXQList];
            };
            [self.navigationController pushViewController:choose animated:YES];
            return;
        }
    }
    
    if (self.communityType == CommunityChooseTypeAdd) {
        
        BingingXQModel *bindM = comArr[indexPath.row];
        switch (bindM.isCheckPassType) {
            case XQRenZhengTypeSuccess: {
                [AppUtils showAlertMessageTimerClose:@"该小区已绑定"];
                return;
            }
                break;
            case XQRenZhengTypeWaitCheck: {
                [AppUtils showAlertMessageTimerClose:@"该小区正在认证中"];
                return;
            }
                break;
            default: {
                UIAlertView *aler =[[UIAlertView alloc]initWithTitle:@"温馨提示 " message:@"当前小区还未进行业户绑定，是否绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定", nil];
                [aler show];
                aler.tag = indexPath.row;
            }
                break;
        }
    }
    else if (self.communityType == CommunityChooseTypeChooseDefault) {
        //切换默认小区
        [self switchXQ:comArr[indexPath.row]];
        if (self.comBlock)
        {
            self.comBlock(comArr[indexPath.row]);
        }
    }
    else if (self.communityType == CommunityChooseTypeChooseAll) {
        //切换所有小区
        [self popLastVC];
        if (self.comBlock)
        {
            self.comBlock(comArr[indexPath.row]);
        }
    }
    else if (self.communityType == CommunityChooseTypeBinding)
    {
        if (self.comBlock)
        {
            self.comBlock(comBindingArr[indexPath.row]);
        }
        
        [comBindingArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UICollectionViewCell *cell = [CollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
            cell.backgroundColor = [UIColor clearColor];
        }];
        
        UICollectionViewCell *cell = [CollectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor lightGrayColor];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        BingingXQModel *bingindM =[comArr objectAtIndex:alertView.tag];
        HousingViewController *bindingV =[[HousingViewController alloc]init];
        bindingV.xqModel = bingindM;
        bindingV.nextBlock = ^{
            [self postXQList];
        };
        [self.navigationController pushViewController:bindingV animated:YES];
    }
}

@end
