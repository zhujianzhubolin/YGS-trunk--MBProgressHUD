//
//  AddNewAdress.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/9/1.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "AddNewAdress.h"
#import "AdressAdd.h"
#import "AllAdressList.h"
#import "Life_First.h"
#import "UserManager.h"
#import "AdresslistCell.h"
#import "ZJWebProgrssView.h"
#import "ManagerAdress.h"


@interface AddNewAdress ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    __weak IBOutlet UITableView *addresslist;

    NSMutableArray * dataSocure;
    
    NSInteger deleteRow;
    ZJWebProgrssView * progress;
    
    UIAlertView *alertV;
    BOOL isHasDefailAddress;
}

@end

@implementation AddNewAdress

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hidetabbar];
    
    [progress startAnimation];
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(getAdressList) userInfo:nil repeats:NO];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    isHasDefailAddress = NO;
    self.title = @"选择收货地址";
    addresslist.delegate = self;
    addresslist.dataSource = self;
    
    addresslist.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, CGFLOAT_MIN)];
    
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(50, 0, viewwidth, 50)];
//    addresslist.tableHeaderView = view;
    
    
    
    progress = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, 64, IPHONE_WIDTH, IPHONE_HEIGHT - 64)];
    [self.view addSubview:progress];
    __block typeof(self)weakSelf = self;
    progress.loadBlock = ^{
        [weakSelf getAdressList];
    };
    

    
//    UIView * myBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, viewwidth, 40)];
//    myBackView.backgroundColor = [UIColor whiteColor];
//    [view addSubview:myBackView];
//    
//    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
//    imageView.image = [UIImage imageNamed:@"tianjiadizhi"];
//    [myBackView addSubview:imageView];
//    
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(10, 50, 0, 0)];
//    button.frame = CGRectMake(0, 0, viewwidth, 30);
//    [button setTitle:@"添加新地址" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
//    [myBackView addSubview:button];
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(managerAdress)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    [addresslist registerNib:[UINib nibWithNibName:@"AdresslistCell" bundle:nil] forCellReuseIdentifier:@"AdressCell"];
    
    NSLog(@"屏幕宽度>>>%f",IPHONE_WIDTH);
    
}

- (void)managerAdress{
    
    ManagerAdress * adress = [[ManagerAdress alloc] init];
    adress.title=@"管理收货地址";
    [self.navigationController pushViewController:adress animated:YES];

}

- (void)getAdressList{
    
    Life_First * handel = [Life_First new];
    AllAdressList * list = [AllAdressList new];
    list.memberId = [UserManager shareManager].userModel.memberId;
    [handel getAllAdress:list success:^(id obj) {
        
        NSLog(@"收货地址列表>>>>%@",obj);
        dataSocure = obj[@"list"];

        for (int i = 0; i < dataSocure.count; i++)
        {
            NSDictionary *dic =dataSocure[i];
            if (![NSDictionary isDicEmptyOrNull:dic])
            {
                BOOL isMoren = [dic[@"isDefault"] boolValue];
                if (isMoren)
                {
                    isHasDefailAddress = YES;
                    break;
                }
            }
        }

        [addresslist reloadData];
        [progress stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:dataSocure]];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
        [progress stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:dataSocure]];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataSocure.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * adresstr = [NSString stringWithFormat:@"%@",[dataSocure objectAtIndex:indexPath.section][@"addressName"]];
    CGSize frameY = [AppUtils sizeWithString:adresstr font:[UIFont systemFontOfSize:13] size:CGSizeMake(IPHONE_WIDTH - 8 - 51, CGFLOAT_MAX)];
    
    return frameY.height +31 +15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AdresslistCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AdressCell"];
    
    if (cell == nil) {
        cell = [[AdresslistCell alloc] init];
    }
    
    BOOL isGou = [dataSocure[indexPath.section][@"isDefault"] boolValue];
    
    if (isGou) {
        cell.isSelectGou.hidden = NO;
    }else{
        cell.isSelectGou.hidden = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellData:dataSocure[indexPath.section]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.ismine) {
        return;
    }
    
    if (!isHasDefailAddress)
    {
       UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"当前未设置默认收货地址，是否将此地址设为默认？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"设为默认", nil];
        alertView.tag=indexPath.section;
        NSLog(@"alertV.tag = %d",alertView.tag);
        alertView.delegate = self;
        [alertView show];
    }
    else
    {
        [self alertDelegateback:indexPath.section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(void)alertDelegateback:(NSUInteger)alertTag
{
    if (_adressdele &&[_adressdele respondsToSelector:@selector(SenAdress:)]) {
        
        [_adressdele SenAdress:[dataSocure objectAtIndex:alertTag]];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark <UIAlertViewDelegate>

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndes = %d",buttonIndex);
    
    if (buttonIndex==0)
    {
        [self alertDelegateback:alertView.tag];
    }
    else
    {
        
        NSString * addressId =[NSString stringWithFormat:@"%@",[dataSocure objectAtIndex:alertView.tag][@"id"]];
        Life_First *handle = [Life_First new];
        SetDefaultAdress *addressM =[SetDefaultAdress new];
        addressM.addressId = addressId;
        [handle setDefaultAdress:addressM success:^(id obj) {
            [self alertDelegateback:alertView.tag];
        } failed:^(id obj) {
        }];
        
        
        
    }
    

}

////删除一条记录
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    NSLog(@"点击了删除");
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除该收货地址?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
//}



//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    if (buttonIndex == 1) {
//        Life_First * handel = [Life_First new];
//        AllAdressList * adress = [AllAdressList new];
//        adress.addressId = dataSocure[deleteRow][@"id"];
//        [handel deleteAdress:adress success:^(id obj) {
//            
//            NSLog(@"删除结果>>>>%@",obj);
//            
//            dataSocure = nil;
//            [self getAdressList];
//            
//        } failed:^(id obj) {
//            if (self.viewIsVisible) {
//                [AppUtils showErrorMessage:@"删除收货地址失败"];
//            }
//            else {
//                [AppUtils dismissHUD];
//            }
//        }];
//    }
//}

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    deleteRow = indexPath.section;
//    
//    return @"删除";
//}


//- (void)addNewAddress{
//    
//    AdressAdd * add= [[AdressAdd alloc] init];
//    [self.navigationController pushViewController:add animated:YES];
//}

@end
