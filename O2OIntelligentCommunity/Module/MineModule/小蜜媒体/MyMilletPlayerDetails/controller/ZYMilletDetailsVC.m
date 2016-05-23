//
//  ZYMilletDetailsVC.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/23.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//



#import "ZYMilletDetailsVC.h"
#import "ZYMilletDetailsCell.h"
#import "ZLPhotoPickerBrowserViewController.h"
#import "ZYXiaoMiPayVC.h"
#import "UserManager.h"

#import "QuXiaoDindanModel.h"
#import "QuxiaoDindanHandler.h"

#import "ZYXiaoMiPlayerHandler.h"
#import "ZYXiaoMiPlayerModel.h"


@interface ZYMilletDetailsVC ()<UITableViewDataSource,UITableViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource,UIAlertViewDelegate>

@property (nonatomic,strong)NSArray *nameArray;
@property (nonatomic,strong)NSArray *nameArray2;

@end

@implementation ZYMilletDetailsVC
{
    UITableView *milletDetailsTB;
    UIAlertView *cancelOreder;
    ZYXiaoMiPlayerHandler *xiaomiHandler;
    ZYXiaoMiPlayerModel *playerM;
    UIButton *button1;
    UIButton *button2;
}

- (NSArray *)nameArray{
    if (_nameArray==nil)
    {
        _nameArray = [[NSArray alloc]initWithObjects:@"订单号：",@"标题：",@"状态：",@"金额：",@"规则：",@"日期：",@"联系人：",@"手机：",@"留言：",@"素材：",@"客服留言：", nil];
    }
    return _nameArray;
}

-(NSArray *)nameArray2
{
    if (_nameArray2==nil)
    {
         _nameArray2 = [[NSArray alloc]initWithObjects:@"订单号：",@"标题：",@"状态：",@"金额：",@"规则：",@"日期：",@"联系人：",@"手机：",@"留言：",@"素材：", nil];
    }
    return _nameArray2;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//       
//    });
    //self.navigationController.navigationBar.translucent=YES;
     [self requestDetails];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"媒体详情";
    [self initData];
    [self initUI];
    
 
}

-(void)initData
{
    
    xiaomiHandler = [ZYXiaoMiPlayerHandler new];
    
}


-(void)requestDetails
{
//    NSDictionary *dicM = [NSDictionary dictionaryWithObjectsAndKeys:
//                          _ID,@"id",
//                          [UserManager shareManager].userModel.memberId,@"memberId",
//                          @"1",@"pageNumber",
//                          @"1",@"pageSize",
//                          nil];
    NSDictionary *dicM = [NSDictionary dictionaryWithObjectsAndKeys:
                          _ID,@"id",
                          [UserManager shareManager].userModel.memberId,@"memberId",
                          @"1",@"pageNumber",
                          @"10",@"pageSize",
                          nil];

    [xiaomiHandler queryMeiTiDetailed:dicM success:^(id obj) {
        playerM =(ZYXiaoMiPlayerModel *)obj;
        NSLog(@"123==%@",playerM.linkmanPhone);
        [self btnTitleStast:playerM.status];
        [self nameArray];
        [self nameArray2];
       
        [milletDetailsTB reloadData];
    } failed:^(id obj) {
        [AppUtils showAlertMessage:@"查询详情失败！"];
    }];
}

-(void)initUI
{
    
    
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 50)];
    UIFont *btnFont = [UIFont systemFontOfSize:14];
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame =CGRectMake(IPHONE_WIDTH- 90, 10, 80, 30);
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.backgroundColor =[AppUtils colorWithHexString:@"fa6900"];
    button1.titleLabel.font=btnFont;
    [button1.layer setMasksToBounds:YES];
    [button1.layer setCornerRadius:5];
    [button1 setTitle:@"1" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(Button1ChickAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button1];
    button1.hidden=YES;
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(IPHONE_WIDTH -180, 10, 80, 30);
    [button2 setTitleColor:[AppUtils colorWithHexString:@"20AADB"] forState:UIControlStateNormal];
    button2.titleLabel.font=btnFont;
    [button2.layer setMasksToBounds:YES];
    [button2.layer setCornerRadius:5];
    [button2.layer setBorderWidth:1];
    [button2.layer setBorderColor:[AppUtils colorWithHexString:@"20AADB"].CGColor];
    [button2 setTitle:@"2" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(Button2ChickAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button2];
    button2.hidden=YES;
    
    [self btnTitleStast:playerM.status];
    
    milletDetailsTB  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    milletDetailsTB.dataSource =self;
    milletDetailsTB.delegate = self;
    milletDetailsTB.showsVerticalScrollIndicator =NO;
    milletDetailsTB.tableFooterView=footView;
    milletDetailsTB.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
    milletDetailsTB.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:milletDetailsTB];
}

-(void)btnTitleStast:(NSString *)str
{
    if ([str isEqualToString:@"new"] || [str isEqualToString:@"place_success"] || [str isEqualToString:@"place_fail"] ||[str isEqualToString:@"pay_fail"])
    {
        [button1 setTitle:@"立即付款" forState:UIControlStateNormal];
        [button2 setTitle:@"取消订单" forState:UIControlStateNormal];
    }
    else if ([str isEqualToString:@"canceled_user"])
    {
        button1.hidden=NO;
        button2.hidden=NO;
    }
    else if ([str isEqualToString:@"canceled_auto"])
    {
        button1.hidden=NO;
        button2.hidden=NO;
    }
    else if ([str isEqualToString:@"pay_success"])
    {
        button2.hidden=YES;
        [button1 setTitle:@"联系客服" forState:UIControlStateNormal];
    }
    else if ([str isEqualToString:@"audit_success"])
    {
        button2.hidden=YES;
        [button1 setTitle:@"联系客服" forState:UIControlStateNormal];
    }
    else if ([str isEqualToString:@"audit_fail"])
    {
        button2.hidden=YES;
        [button1 setTitle:@"联系客服" forState:UIControlStateNormal];
    }
    else
    {
        button1.hidden=NO;
        button2.hidden=NO;
    }

}

#pragma marl <普通点击动作>
-(void)Button1ChickAction
{
    NSString *str=playerM.status;
    if ([str isEqualToString:@"new"] || [str isEqualToString:@"place_success"] || [str isEqualToString:@"place_fail"] ||[str isEqualToString:@"pay_fail"])
    {
        ZYXiaoMiPayVC *payvc =[[ZYXiaoMiPayVC alloc]init];
        payvc.downOrderType=AginDownOrder;
        payvc.milletM = playerM;
        [self.navigationController pushViewController:payvc animated:YES];
    }
    else if ([str isEqualToString:@"canceled_user"] || [str isEqualToString:@"pay_success"] ||[str isEqualToString:@"audit_success"] ||[str isEqualToString:@"audit_fail"])
    {
        [AppUtils callPhone:playerM.linkmanPhone];
    }

}
-(void)Button2ChickAction
{
    NSString *str=playerM.status;
    if ([str isEqualToString:@"new"] || [str isEqualToString:@"place_success"] || [str isEqualToString:@"place_fail"] ||[str isEqualToString:@"pay_fail"])
    {
        cancelOreder =[[UIAlertView alloc]initWithTitle:nil message:M_MINEBUY_CANCELORDER delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
        [cancelOreder show];

    }
    else if ([str isEqualToString:@"canceled_user"])
    {
    }
    else if ([str isEqualToString:@"canceled_auto"])
    {
      
    }
    else if ([str isEqualToString:@"pay_success"])
    {
       
    }
    else if ([str isEqualToString:@"audit_success"])
    {
        
    }
    else if ([str isEqualToString:@"audit_fail"])
    {
        
    }
    else
    {
        
    }

}

#pragma mark <UIAlertViewDelegate>
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex＝%ld",(long)buttonIndex);
    if(buttonIndex==1)
    {
        [AppUtils showProgressMessage:@"取消订单中"];
        
        QuXiaoDindanModel *quxiaoM =[QuXiaoDindanModel new];
        QuxiaoDindanHandler *quxiaoH =[QuxiaoDindanHandler new];
        quxiaoM.orderSubNo =playerM.ID;
        [quxiaoH CancelDindan:quxiaoM success:^(id obj) {


            [AppUtils showSuccessMessage:obj];
        } failed:^(id obj) {
            [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
        }];

    }
    
}


#pragma mark <UITableViewDataSource,UITableViewDelegate>

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([NSString isEmptyOrNull:playerM.ggText2]) {
        return _nameArray2.count;
    }
    else
    {
        return _nameArray.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
           UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZYMilletDetailsCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ZYMilletDetailsCell"];
    if (cell==nil) {
        cell = [[ZYMilletDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZYMilletDetailsCell"];
    }
    [cell detailsData:_nameArray[indexPath.section]];
    if (indexPath.section==0)
    {
        [cell detailsContent:playerM.ID content2:@"" index:0];
    }
    else if (indexPath.section==1)
    {
        [cell detailsContent:playerM.ggTitle content2:@"" index:1];
    }
    else if (indexPath.section==2)
    {
        [cell detailsContent:playerM.status content2:playerM.dateCreated index:2];
    }
    else if (indexPath.section==3)
    {
        NSString *moneyStr =[NSString stringWithFormat:@"%@元",playerM.saleAmount];
        [cell detailsContent:moneyStr content2:@"" index:3];
    }
    else if (indexPath.section==4)
    {
        [cell detailsContent:playerM.chargeConfigName content2:@"" index:4];
    }
    else if (indexPath.section==5)
    {
          NSString *str =[NSString stringWithFormat:@"%@ 至 %@",playerM.ggServiceDateStart,playerM.ggServiceDateEnd];
        [cell detailsContent:str content2:@"" index:5];
    }
    else if (indexPath.section==6)
    {
        [cell detailsContent:playerM.linkmanName content2:@"" index:6];
    }
    else if (indexPath.section==7){
        [cell detailsContent:playerM.linkmanPhone content2:@"" index:7];
    }
    else if (indexPath.section==8)
    {
        if(![NSString isEmptyOrNull:playerM.remarkUser])
        {
             [cell detailsContent:playerM.remarkUser content2:@"" index:8];
        }
    }
    else if (indexPath.section==9)
    {
        [cell detailsContent:@"" content2:@"" index:9];
        UIImageView *imgV =[[UIImageView alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-45, 5, 35, 35)];
        imgV.tag = 10000;
        imgV.image =[UIImage imageNamed:@"ZYSucai"];
        [cell.contentView addSubview:imgV];
    }
    else if (indexPath.section==10)
    {
        [cell detailsContent:playerM.ggText2 content2:@"" index:10];
    }
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 7)
    {
        if (indexPath.row==0)
        {
            [AppUtils callPhone:playerM.linkmanPhone];
        }
    }
    else if (indexPath.section==9)
    {
        if (indexPath.row==0)
        {
            ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
            pickerBrowser.dataSource = self;
            pickerBrowser.currentIndexPath = indexPath;
            // 展示控制器
            [pickerBrowser showPickerVc:self];
        }
    }
}

//2、图片放大控件更换，需要设置代理；
#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return 1;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj = playerM.ggImgSrc;
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    ZYMilletDetailsCell * cell = (ZYMilletDetailsCell *)[milletDetailsTB cellForRowAtIndexPath:indexPath];
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    
    for (UIView *subview in cell.contentView.subviews) {
        if ([subview isKindOfClass:[UIImageView class]])
        {
            photo.toView = (UIImageView *)subview;
            break;
        }
    }
    return photo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
