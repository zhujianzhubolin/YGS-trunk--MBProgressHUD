//
//  KuaiSongLanController.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/12/7.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "KuaiSongLanController.h"
#import "CarCell.h"

@interface KuaiSongLanController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    NSMutableArray * dataSocureArray;
    __weak IBOutlet UITableView *goodsListTableView;
    __weak IBOutlet UILabel *totalPrice;
    UIButton * mybtn;
}

@end

@implementation KuaiSongLanController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"快送篮";

    [self viewDidLayoutSubviewsForTableView:goodsListTableView];
    goodsListTableView.dataSource = self;
    goodsListTableView.delegate = self;
    
    mybtn= [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [mybtn setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [mybtn addTarget:self action:@selector(clearBasket) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mybtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

    dataSocureArray = [NSMutableArray arrayWithObjects:@"苹果",@"梨子",@"香蕉",@"冬枣",@"柚子",@"火龙果",@"哈密瓜",@"橘子", nil];
    
    [goodsListTableView registerNib:[UINib nibWithNibName:@"CarCell" bundle:nil] forCellReuseIdentifier:@"CarCellID"];

    [self setExtraCellLineHidden:goodsListTableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataSocureArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 83;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CarCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CarCellID"];
    
    if (cell == nil) {
        
        cell = [[CarCell alloc] init];
        
    }
    
    return cell;
}







//清空购物篮
- (void)clearBasket{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否移除全部商品？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        [dataSocureArray removeAllObjects];
        [goodsListTableView reloadData];
    }
}

//全选购物篮
- (IBAction)selectAll:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    for (int i = 0; i < dataSocureArray.count; i ++) {
        CarCell * cell = (CarCell *)[goodsListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIButton * cellbutton = (UIButton *)[cell viewWithTag:10];
        
        if (sender.selected) {
            cellbutton.selected = YES;
        }else{
            cellbutton.selected = NO;
        }
    }
}

//立即购买
- (IBAction)buyNow:(UIButton *)sender {
    
    
}


//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


@end
