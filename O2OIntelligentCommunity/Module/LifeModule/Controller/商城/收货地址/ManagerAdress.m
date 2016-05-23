//
//  ManagerAdress.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/3/1.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ManagerAdress.h"
#import "AdressAdd.h"
#import "AllAdressList.h"
#import "Life_First.h"
#import "UserManager.h"
#import "AdresslistCell.h"
#import "ZJWebProgrssView.h"
@interface ManagerAdress ()<UITableViewDataSource,UITableViewDelegate>

{
    
    __weak IBOutlet UITableView *managertableView;
    
    NSMutableArray * dataSocure;
    
    NSInteger deleteRow;
    ZJWebProgrssView * progress;
}

@end

@implementation ManagerAdress

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [progress startAnimation];
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(getAdressList) userInfo:nil repeats:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    managertableView.delegate = self;
    managertableView.dataSource = self;
    
    managertableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, CGFLOAT_MIN)];

    
    progress = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, 64, IPHONE_WIDTH, IPHONE_HEIGHT - 64)];
    [self.view addSubview:progress];
    __block typeof(self)weakSelf = self;
    progress.loadBlock = ^{
        [weakSelf getAdressList];
    };

    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addNewAddress)];
    
    [managertableView registerNib:[UINib nibWithNibName:@"AdresslistCell" bundle:nil] forCellReuseIdentifier:@"AdressCell"];

    self.navigationItem.rightBarButtonItem = right;
}

- (void)getAdressList{
    
    Life_First * handel = [Life_First new];
    AllAdressList * list = [AllAdressList new];
    list.memberId = [UserManager shareManager].userModel.memberId;
    [handel getAllAdress:list success:^(id obj) {
        
        NSLog(@"收货地址列表>>>>%@",obj);
        dataSocure = obj[@"list"];
        [managertableView reloadData];
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

//选中编辑
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AdressAdd * adress = [[AdressAdd alloc] init];
    adress.EditingAddStr=@"bianji";
    adress.adressDict = dataSocure[indexPath.section];
    [self.navigationController pushViewController:adress animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


//删除一条记录
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([dataSocure[indexPath.section][@"isDefault"] boolValue]) {
        
        [AppUtils showAlertMessage:@"当前收货地址为默认收货地址，不可删除！"];
        
    }else{
        NSLog(@"点击了删除");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除该收货地址?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        Life_First * handel = [Life_First new];
        AllAdressList * adress = [AllAdressList new];
        adress.addressId = dataSocure[deleteRow][@"id"];
        [handel deleteAdress:adress success:^(id obj) {

            NSLog(@"删除结果>>>>%@",obj);

            dataSocure = nil;
            [progress startAnimation];
            [self getAdressList];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:k_NOTI_ORDER_ADDORESS_CHANGE object:self];

        } failed:^(id obj) {
            if (self.viewIsVisible) {
                [AppUtils showErrorMessage:@"删除收货地址失败"];
            }
            else {
                [AppUtils dismissHUD];
            }
        }];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{

    deleteRow = indexPath.section;

    return @"删除";
}


- (void)addNewAddress{

    AdressAdd * add= [[AdressAdd alloc] init];
    if (dataSocure.count > 0) {
        add.isEmpty = NO;
    }else{
        add.isEmpty = YES;
    }
    
    [self.navigationController pushViewController:add animated:YES];
}

@end
