//
//  SetViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "SetViewController.h"
#import "SetCell.h"
#import "CommentViewControllr.h"
#import "O2OLoginViewController.h"
#import "UserManager.h"
#import "MainTBViewController.h"
#import "UserHandler.h"
#import "ZJSandboxHelper.h"

#import "WebVC.h"
#import "AboutViewController.h"

@interface SetViewController ()<UIAlertViewDelegate>

@end
@implementation SetViewController
{

    NSArray *iconArray;
    NSArray *nameArray;
    NSArray *dataArray;
    
    NSArray *section0IconArr;
    NSArray *section1IconArr;
    NSArray *section2IconArr;
    
    NSArray *section0NameArr;
    NSArray *section1NameArr;
    NSArray *section2NameArr;
    
    UIAlertView *eliminateBufferAlert;//清除缓存
    UIAlertView *exitLoginAlerV;//退出登录
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"设置";
    self.view.backgroundColor=[AppUtils colorWithHexString:@"EEEEEA"];
    
    iconArray =[[NSArray alloc]initWithObjects:@"kefudianhua",@"yijianfankui",@"cleanWaste", nil];
    nameArray =[[NSArray alloc]initWithObjects:@"技术热线",@"意见反馈",@"清除缓存", nil];
    dataArray =[[NSArray alloc]initWithObjects:P_SERVICE_PHONE,@"",@"0KB", nil];
    
    section0IconArr =[[NSArray alloc]initWithObjects:@"kefudianhua",@"yijianfankui", nil];
    section1IconArr =[[NSArray alloc]initWithObjects:@"user",@"yinsi",@"jiShuZhiChi", nil];
    section2IconArr =[[NSArray alloc]initWithObjects:@"cleanWaste", nil];
    
    section0NameArr =[[NSArray alloc]initWithObjects:@"技术热线",@"意见反馈", nil];
    
#ifdef SmartComJYZX
    section1NameArr =[[NSArray alloc]initWithObjects:@"用户协议",@"常见问题",@"技术支持", nil];

#elif SmartComYGS
     section1NameArr =[[NSArray alloc]initWithObjects:@"用户协议",@"常见问题",@"关于我们", nil];
#else
    
#endif
   
    section2NameArr =[[NSArray alloc]initWithObjects:@"清除缓存", nil];
    
    [self initUI];
}

-(void)initUI
{
    UIView *footView =[[UIView alloc]init];
    footView.frame=CGRectMake(0, 0, IPHONE_WIDTH, 100);
    footView.backgroundColor=[AppUtils colorWithHexString:@"EEEEEA"];
    
    UIButton *exitButton =[UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.frame=CGRectMake(G_INTERVAL_BIG, 20, IPHONE_WIDTH-G_INTERVAL_BIG *2, 40);
    exitButton.layer.masksToBounds=YES;
    exitButton.layer.cornerRadius=5;
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitButton setBackgroundColor:[AppUtils colorWithHexString:@"fa6900"]];
    //exitButton.layer.c
    [exitButton addTarget:self action:@selector(exitButtonArr) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:exitButton];
    
    
    _TableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _TableView.dataSource =self;
    _TableView.delegate =self;
    _TableView.backgroundColor=[AppUtils colorWithHexString:@"EEEEEA"];
    _TableView.tableFooterView=footView;
    [self.view addSubview:_TableView];
    
}

-(void)exitButtonArr
{
    exitLoginAlerV =[[UIAlertView alloc]initWithTitle:nil message:@"亲爱的你确定要离开了吗?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
    [exitLoginAlerV show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView == exitLoginAlerV)
    {
        if (buttonIndex==1)
        {
            [UserHandler logout];
            [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
            self.navigationController.tabBarController.selectedIndex = 0;
            [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(selectedOneNav) userInfo:nil repeats:NO];
            
        }

    }
    else if (alertView == eliminateBufferAlert)
    {
        if (buttonIndex == 1)
        {
#ifdef SmartComJYZX
            [self clearCache:[ZJSandboxHelper libCachePath]];
            [self clearCache:[ZJSandboxHelper tmpPath]];
            
            [AppUtils showSuccessMessage:@"清除缓存成功"];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_TableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
#elif SmartComYGS
            [self clearCache:[ZJSandboxHelper libCachePath]];
            [self clearCache:[ZJSandboxHelper tmpPath]];
            
            [AppUtils showSuccessMessage:@"清除缓存成功"];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [_TableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
#else
            
#endif

            

        }
    }
}

- (void)selectedOneNav {
    
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#ifdef SmartComJYZX
    return 1;
#elif SmartComYGS
    return 3;
#else
    
#endif

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
#ifdef SmartComJYZX
    return nameArray.count;
#elif SmartComYGS
    if (section==0)
    {
        return section0NameArr.count;
    }
    else if (section==1)
    {
        return section1NameArr.count;
    }
    else
    {
        return section2NameArr.count;
    }
#else
    
#endif

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef SmartComJYZX
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if (cell == nil) {
        cell = [[SetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
    }
    
    [cell setIcon:[UIImage imageNamed:[iconArray objectAtIndex:indexPath.row]]];
    [cell setNameLabe:[nameArray objectAtIndex:indexPath.row]];
    if (indexPath.row==0) {
        [cell setDataStringLabe:[dataArray objectAtIndex:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row==1) {
        [cell setDataStringLabe:[dataArray objectAtIndex:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row==2) {
        CGFloat libPath =[self folderSizeAtPath:[ZJSandboxHelper libCachePath]];
        CGFloat tmpPath =[self folderSizeAtPath:[ZJSandboxHelper tmpPath]];
        [cell setDataStringLabe:[NSString stringWithFormat:@"%.1f M",libPath + tmpPath]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;

#elif SmartComYGS
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if (cell == nil) {
        cell = [[SetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
    }
    if (indexPath.section==0)
    {
        [cell setIcon:[UIImage imageNamed:[section0IconArr objectAtIndex:indexPath.row]]];
        [cell setNameLabe:[section0NameArr objectAtIndex:indexPath.row]];
        [cell setDataStringLabe:[dataArray objectAtIndex:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section==1)
    {
        [cell setIcon:[UIImage imageNamed:[section1IconArr objectAtIndex:indexPath.row]]];
        [cell setNameLabe:[section1NameArr objectAtIndex:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section==2)
    {
        [cell setIcon:[UIImage imageNamed:[section2IconArr objectAtIndex:indexPath.row]]];
        [cell setNameLabe:[section2NameArr objectAtIndex:indexPath.row]];
        CGFloat libPath =[self folderSizeAtPath:[ZJSandboxHelper libCachePath]];
        CGFloat tmpPath =[self folderSizeAtPath:[ZJSandboxHelper tmpPath]];
        [cell setDataStringLabe:[NSString stringWithFormat:@"%.1f M",libPath + tmpPath]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;

#else
    
#endif

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
#ifdef SmartComJYZX
    if (indexPath.row==0)
    {
        [AppUtils callPhone:P_SERVICE_PHONE];
    }
    else if (indexPath.row==1)
    {
        CommentViewControllr *comment = [[CommentViewControllr alloc]init];
        comment.isSwitchPage=CommentPageFeedBack;
        [self.navigationController pushViewController:comment animated:YES];
    }
    else if (indexPath.row==2)
    {
        CGFloat libP =[self folderSizeAtPath:[ZJSandboxHelper libCachePath]];
        CGFloat tmpP =[self folderSizeAtPath:[ZJSandboxHelper tmpPath]];
        CGFloat libtmp = libP+tmpP;
        NSString *libtmpstr =[NSString stringWithFormat:@"%.1f",libtmp];
        
        if([libtmpstr isEqualToString:@"0.0"]) {
            [AppUtils showAlertMessageTimerClose:@"已经没有缓存可以清理了，亲"];
        }
        else {
            eliminateBufferAlert =[[UIAlertView alloc]initWithTitle:nil
                                                            message:@"清除缓存会丢失本地缓存数据，确认清除？"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"取消",@"确认", nil];
            [eliminateBufferAlert show];
        }
    }

#elif SmartComYGS
    if (indexPath.section==0)
    {
        if (indexPath.row==0) {
            [AppUtils callPhone:P_SERVICE_PHONE];
        }else if (indexPath.row==1){
            CommentViewControllr *comment = [[CommentViewControllr alloc]init];
            comment.isSwitchPage=CommentPageFeedBack;
            [self.navigationController pushViewController:comment animated:YES];
        }
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            WebVC *webVC = [WebVC new];
            webVC.title=@"协议";
            webVC.webURL = P_USER_PROTOCAL;
            [self.navigationController pushViewController:webVC animated:YES];
            
        }
        else if (indexPath.row==1)
        {
            WebVC *changJianWenTiV = [WebVC new];
            changJianWenTiV.title=@"常见问题";
            changJianWenTiV.webURL = P_COMMEN_PROBLEMS;
            [self.navigationController pushViewController:changJianWenTiV animated:YES];
            
            
        }
        else if (indexPath.row==2)
        {
            AboutViewController *about = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:about animated:YES];
        }
        
    }
    else if (indexPath.section==2)
    {
        if (indexPath.row==0) {
            CGFloat libP =[self folderSizeAtPath:[ZJSandboxHelper libCachePath]];
            CGFloat tmpP =[self folderSizeAtPath:[ZJSandboxHelper tmpPath]];
            CGFloat libtmp = libP+tmpP;
            NSString *libtmpstr =[NSString stringWithFormat:@"%.1f",libtmp];
            
            if([libtmpstr isEqualToString:@"0.0"]) {
                [AppUtils showAlertMessageTimerClose:@"已经没有缓存可以清理了，亲"];
            }
            else {
                eliminateBufferAlert =[[UIAlertView alloc]initWithTitle:nil
                                                                message:@"清除缓存会丢失本地缓存数据，确认清除？"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"取消",@"确认", nil];
                [eliminateBufferAlert show];
            }

        }
    }
#else
    
#endif

   
}

//-(void)clearCacheSuccess
//{
//    
//#ifdef SmartComJYZX
//    [self clearCache:[ZJSandboxHelper libCachePath]];
//    [self clearCache:[ZJSandboxHelper tmpPath]];
//    
//    [AppUtils showSuccessMessage:@"清除缓存成功"];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
//    [_TableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//
//    
//#elif SmartComYGS
//    [self clearCache:[ZJSandboxHelper libCachePath]];
//    [self clearCache:[ZJSandboxHelper tmpPath]];
//    
//    [AppUtils showSuccessMessage:@"清除缓存成功"];
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
//    [_TableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//
//#else
//    
//#endif
//
//}

#pragma mark - 缓存处理
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

-(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
//    [[SDImageCache sharedImageCache] cleanDisk];
}

@end
