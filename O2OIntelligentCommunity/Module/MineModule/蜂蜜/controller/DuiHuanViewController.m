//
//  DuiHuanViewController.m
//  BeeTest
//
//  Created by app on 15/11/17.
//  Copyright © 2015年 kuroneko. All rights reserved.
//

#import "DuiHuanViewController.h"
#import "NSString+wrapper.h"
#import "UserManager.h"
#import "WebVC.h"
#import "DuihuanCell.h"

//积分兑换接口类
#import "HoneyHandler.h"
#import "HoneyTradeInfoModel.h"



@interface DuiHuanViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    UILabel *honeynumberLab;
    UITextField *inPutNum;
    
    UIAlertView *alerVzhengshu;
    UIAlertView *alerVdayu;
    UIAlertView *arerVshibai;
    
    UITableView *tableV;
    HoneyHandler *honeyH;
    UIButton *duiHuanBtn;
    NSString *honeyData;
    NSString * oneYuanPerBee;
    int limt;
}

@end

@implementation DuiHuanViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self initHoneyData];
    [self getOneYuanWithBee];
}

-(void)initData
{
    honeyH = [HoneyHandler new];
}

-(void)initUI
{
    self.title = @"兑换蜂蜜";
    
    UIView *footoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 100)];
    footoView.backgroundColor =[AppUtils colorWithHexString:COLOR_MAIN];
    
    honeynumberLab = [[UILabel alloc]initWithFrame:CGRectMake(10, (65-35)/2, IPHONE_WIDTH-20, 35)];
    honeynumberLab.tag=1001;
    honeynumberLab.text=@"¥ 0.00";
    honeynumberLab.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    honeynumberLab.textAlignment=NSTextAlignmentCenter;
    [footoView addSubview:honeynumberLab];
    
    duiHuanBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    duiHuanBtn.frame=CGRectMake(10, 65, IPHONE_WIDTH-20, 35);
    [duiHuanBtn setTitle:@"兑换" forState:UIControlStateNormal];
    //金额不对的时候不让兑换
    duiHuanBtn.backgroundColor =[AppUtils colorWithHexString:@"fa6900"];
    duiHuanBtn.layer.masksToBounds=YES;
    duiHuanBtn.layer.cornerRadius=5;
    [duiHuanBtn addTarget:self action:@selector(sureDuiHuan) forControlEvents:UIControlEventTouchUpInside];
    [footoView addSubview:duiHuanBtn];
    
    tableV = [[UITableView alloc]init];
    tableV.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT);
    tableV.dataSource=self;
    tableV.delegate  =self;
    tableV.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
    tableV.tableFooterView=footoView;
    [self.view addSubview:tableV];
    
    [tableV registerNib:[UINib nibWithNibName:@"DuihuanCell" bundle:nil] forCellReuseIdentifier:@"duihuancell"];

}

//获取积分数据
-(void)initHoneyData
{
    HoneyTradeInfoModel *honeyM = [HoneyTradeInfoModel new];
    honeyM.memberId=[UserManager shareManager].userModel.memberId;
    [honeyH queryVIPHoneyInfo:honeyM success:^(id obj) {
        
        honeyData =(NSString *)obj;
         NSString *honeyDataInt = [NSString stringWithFormat:@"%.0f",[honeyData floatValue]];
        
        UILabel *honeyLab =(UILabel *)[self.view viewWithTag:1000];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *Str1 =@"蜂蜜余额共:";
            NSString *Str2 =@"滴";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@",Str1,honeyDataInt,Str2]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, Str1.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fa6900"] range:NSMakeRange(Str1.length, honeyDataInt.length)];
            NSInteger length =Str1.length+ honeyDataInt.length;
            NSLog(@"length=%ld",(long)length);
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(length, 1)];
            
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, Str1.length)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:23] range:NSMakeRange(Str1.length, honeyDataInt.length)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(length, 1)];
            honeyLab.attributedText=str;
        });
    } failed:^(id obj) {
        [AppUtils showAlertMessageTimerClose:obj];
    }];
    
}


//多少滴对应1元
- (void)getOneYuanWithBee{
    HoneyTradeInfoModel * model = [HoneyTradeInfoModel new];
    HoneyHandler * handel = [HoneyHandler new];
    model.reference = @"yigongshe";
    
    [handel beeToOneYuan:model success:^(id obj) {
        
        oneYuanPerBee = (NSString *)obj;
        NSLog(@"oneYuanPerBee==%@",oneYuanPerBee);
        limt = [oneYuanPerBee intValue];
        UILabel *oneYuan1 =(UILabel *)[self.view viewWithTag:1002];
        oneYuan1.text = [NSString stringWithFormat:@"%@滴=1元",oneYuanPerBee];
        
    } failed:^(id obj) {
        
    }];
}

- (void)sureDuiHuan{

    if ([NSString isEmptyOrNull:inPutNum.text])
    {
        [AppUtils showAlertMessageTimerClose:@"亲爱的，您还没有输入要兑换的数额啊！"];
        return;
    }
    if([inPutNum.text intValue] <limt)
    {
        [AppUtils showAlertMessageTimerClose:@"亲爱的，您输入要兑换的数额不能少于100滴！"];
        return;
    }

    if([inPutNum.text intValue] > [honeyData floatValue])
    {
        inPutNum.text=@"";
        UILabel *moneyLab =(UILabel *)[tableV viewWithTag:1001];
        moneyLab.text=@"¥ 0.00";
        alerVdayu = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您输入的数字大于蜂蜜余额，马上了解赚蜂蜜？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"查看规则", nil];
        [alerVdayu show];
        return;
    }
    
    if ([inPutNum.text intValue] >5000)
    {
        [AppUtils showAlertMessageTimerClose:@"亲爱的，每次兑换不能大于5000！"];
        return;
    }
    
    if ([inPutNum.text intValue] %limt !=0)
    {
        alerVzhengshu =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"不是整倍数，无法识别并兑换噢 ！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"重新输入", nil];
        [alerVzhengshu show];
        
        return;
    }


    HoneyHandler        *myhoneyH = [HoneyHandler new];
    HoneyTradeInfoModel *honeyM = [HoneyTradeInfoModel new];
    honeyM.memberId=[UserManager shareManager].userModel.memberId;
    honeyM.integral = [NSNumber numberWithInt:[inPutNum.text intValue]];
    [myhoneyH exchangeHoney:honeyM success:^(id obj) {
        NSDictionary *dic =(NSDictionary *)obj;
        int yue = [inPutNum.text intValue] /limt;
        NSString *yuestr =[NSString stringWithFormat:@"兑换成功！\n钱包余额额增加%d元",yue];
        [AppUtils showAlertMessageTimerClose:yuestr];
        if (self.duihuanblock) {
            self.duihuanblock();
        }
        [self initHoneyData];
        [inPutNum resignFirstResponder];
        inPutNum.text=@"";
        [self.navigationController popViewControllerAnimated:YES];
        
    } failed:^(id obj) {
        if (self.viewIsVisible) {
            arerVshibai = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:obj delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"再兑换", nil];
            [arerVshibai show];
        }
        else {
            [AppUtils dismissHUD];
        }

    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [inPutNum resignFirstResponder];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    if (alertView == alerVzhengshu)
    {
        if (buttonIndex==1)
        {
            inPutNum.text=@"";
        }
    }
    else if (alertView == alerVdayu)
    {
        if (buttonIndex==1)
        {
            WebVC *honeyV = [WebVC new];
            honeyV.title =@"蜂蜜规则";
            honeyV.webURL = @"http://wxssj.ygs001.com/bjsm/getHoneyRule.html";
            [self.navigationController pushViewController:honeyV animated:YES];
        }
    }
    else if (alertView == arerVshibai)
    {
        if (buttonIndex==1)
        {
            inPutNum.text=@"";
            [inPutNum becomeFirstResponder];
        }
    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 10;
    }
    return 5;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 97;
    }
    else
    {
        return 44;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString *cellIdentifier =@"duihuancell";
        DuihuanCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell =[[DuihuanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.honyNu.tag=1000;
        
        cell.oneYuan.tag = 1002;
        
        return cell;

    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
        if (cell==nil)
        {
            cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        inPutNum =[[UITextField alloc]initWithFrame:CGRectMake(10, 0, IPHONE_WIDTH-20, 44)];
        inPutNum.delegate=self;
        [inPutNum becomeFirstResponder];
        inPutNum.placeholder=@"请输入整百滴数～";
        inPutNum.keyboardType = UIKeyboardTypePhonePad;
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(textFieldEditChanged1:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:inPutNum];

        UIToolbar *topView =[[UIToolbar alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 30)];
        [topView setBarStyle:UIBarStyleDefault];
        
        UIBarButtonItem *btnSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(honeydismissKeyBoard)];
        NSArray *buttonArray =[NSArray arrayWithObjects:btnSpace,doneButton, nil];
        [topView setItems:buttonArray];
        [inPutNum setInputAccessoryView:topView];

        [cell.contentView addSubview:inPutNum];
        return cell;
    }
}

-(void)honeydismissKeyBoard
{
    [inPutNum resignFirstResponder];
//    if (inPutNum.text.length !=0 && [inPutNum.text intValue]>=100 && [inPutNum.text intValue]%100 ==0)
//    {
//        int moneyNumber =[inPutNum.text intValue]/100;
//        UILabel *moneyLab =(UILabel *)[tableV viewWithTag:1001];
//        NSString *stringInt = [NSString stringWithFormat:@"%d",moneyNumber];
//        float floatString = [stringInt floatValue];
//        moneyLab.text=[NSString stringWithFormat:@"¥ %.2f ",floatString];
//    }

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:inPutNum];
    
    
}
- (void)textFieldEditChanged1:(NSNotification*)obj{
    UITextField *textField = (UITextField *)obj.object;
     UILabel *moneyLab =(UILabel *)[tableV viewWithTag:1001];
    NSLog(@"textField==%@",textField.text);
    if ([textField.text intValue] <limt) {

        moneyLab.text =@"¥ 0 元";
        return;
    }
    if ([textField.text intValue] %limt==0) {
        int yue = [inPutNum.text intValue] /limt;
        UILabel *moneyLab =(UILabel *)[tableV viewWithTag:1001];
        NSString *stringInt = [NSString stringWithFormat:@"%d",yue];
        float floatString = [stringInt floatValue];
        moneyLab.text=[NSString stringWithFormat:@"¥ %.0f 元",floatString ];

    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"%@",string);
    if(string.length==0){
        return YES;
    }
    int titleLength =10;//标题的长度
    if (![AppUtils isNotLanguageEmoji]) {
        return NO;
    }
    
    return range.location<titleLength;
}


//#pragma mark - UITextFieldDelegate
//-(void)textFieldDidEndEditing:(UITextField *)textField;
//{
//    if (textField==inPutNum)
//    {
//        [inPutNum resignFirstResponder];
//        if (inPutNum.text.length !=0 && [inPutNum.text intValue]>=100 && [inPutNum.text intValue]%100 ==0)
//        {
//            int moneyNumber =[inPutNum.text intValue]/100;
//            UILabel *moneyLab =(UILabel *)[tableV viewWithTag:1001];
//            NSString *stringInt = [NSString stringWithFormat:@"%d",moneyNumber];
//            float floatString = [stringInt floatValue];
//            moneyLab.text=[NSString stringWithFormat:@"¥ %.2f ",floatString];
//        }
//        else
//        {
//            alerVzhengshu =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"输入的非整百数字，无法识别并兑换噢 ！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"重新输入", nil];
//            [alerVzhengshu show];
//        }
//        
//        
//    }
//   
//}




@end
