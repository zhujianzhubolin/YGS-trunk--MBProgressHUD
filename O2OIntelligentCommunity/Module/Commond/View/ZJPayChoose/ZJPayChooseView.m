//
//  ZJPayChooseView.m
//  testZHIFU
//
//  Created by user on 16/3/9.
//  Copyright © 2016年 ygs. All rights reserved.
//

#define PAYVIEW_ROWHEIGHT 44
#define ZJPay_SeletedImg @"gou_h"
#define ZJPay_UnSeletedImg @"gou"

#import "WXApi.h"
#import "ZJPayChooseView.h"

@interface ZJPayChooseView ()

@property (nonatomic, strong)UITableView *payTBView;
@property (nonatomic, copy)ZJPayModel *payQianbaoM;
@property (nonatomic, copy)ZJPayModel *payWeixinM;
@property (nonatomic,strong) NSArray *payMothodArr;

@end

@implementation ZJPayChooseView


- (id)initWithFrame:(CGRect)frame {
    CGRect rect = frame;
    rect.size.height = PAYVIEW_ROWHEIGHT *self.payMothodArr.count;
    frame = rect;
    self = [super initWithFrame:frame];
    if (self) {
        [self payTBView];
        [self payMothodArr];
    }
    return self;
}

- (ZJPayModel *)payQianbaoM {
    if (!_payQianbaoM) {
        _payQianbaoM = [ZJPayModel new];
        _payQianbaoM.payImgStr = @"myPay";
        _payQianbaoM.payName = @"钱包支付";
        _payQianbaoM.isSelected = NO;
        _payQianbaoM.selectedImgStr = ZJPay_SeletedImg;
        _payQianbaoM.unselectedImgStr = ZJPay_UnSeletedImg;
    }
    return _payQianbaoM;
}

- (ZJPayModel *)payWeixinM {
    if (!_payWeixinM) {
        _payWeixinM = [ZJPayModel new];
        _payWeixinM.payImgStr = @"weChatPay";
        _payWeixinM.payName = @"微信支付";
        _payWeixinM.isSelected = NO;
        _payWeixinM.selectedImgStr = ZJPay_SeletedImg;
        _payWeixinM.unselectedImgStr = ZJPay_UnSeletedImg;
    }
    return _payWeixinM;
}

- (NSArray *)payMothodArr {
    if (!_payMothodArr) {
        NSMutableArray *payArr = [NSMutableArray array];
        self.payQianbaoM.isSelected = YES;
        self.paymethod = PayMethodQianbao;
        [payArr addObject:self.payQianbaoM];
        
        if ([WXApi isWXAppInstalled]) {
            [payArr addObject:self.payWeixinM];
        }
        
        _payMothodArr = [NSArray arrayWithArray:payArr];
    }
    return _payMothodArr;
}

- (UITableView *)payTBView {
    if (!_payTBView) {
        _payTBView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _payTBView.delegate = self;
        _payTBView.dataSource = self;
        _payTBView.rowHeight = PAYVIEW_ROWHEIGHT;
        _payTBView.scrollEnabled = NO;
        [self viewDidLayoutSubviewsForTableView:_payTBView];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        footerView.backgroundColor = [UIColor clearColor];
        _payTBView.tableFooterView = footerView;
        [self addSubview:_payTBView];
    }
    return _payTBView;
}

- (void)reloadData {
    [_payTBView reloadData];
}

- (void)chooseClick:(UIButton *)btn {
    [self.payMothodArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZJPayModel *payM = self.payMothodArr[idx];
        payM.isSelected = NO;
        UITableViewCell *cell = [self.payTBView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        UIButton *cellBtn = (UIButton *)cell.accessoryView;
        cellBtn.selected = NO;
    }];
    ZJPayModel *payM = self.payMothodArr[btn.tag - 1];
    payM.isSelected = YES;
    btn.selected = YES;
    
    if ([payM.payName isEqualToString:self.payQianbaoM.payName]) {
        self.paymethod = PayMethodQianbao;
    }
    else if ([payM.payName isEqualToString:self.payWeixinM.payName]) {
        self.paymethod = PayMethodWeiXin;
    }
    else {
        NSLog(@"无支付类型");
    }
}

-(void)viewDidLayoutSubviewsForTableView:(UITableView *)tableview
{
    if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

#pragma mark- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.payMothodArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *systemCellID = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemCellID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    ZJPayModel *payM = self.payMothodArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:payM.payImgStr];
    cell.textLabel.text = payM.payName;
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnheight = self.payTBView.rowHeight / 3;
    chooseBtn.frame = CGRectMake(0, 0, btnheight, btnheight);
    [chooseBtn setBackgroundImage:[UIImage imageNamed:payM.selectedImgStr] forState:UIControlStateSelected];
    [chooseBtn setBackgroundImage:[UIImage imageNamed:payM.unselectedImgStr] forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
    chooseBtn.tag = indexPath.row + 1;
    cell.accessoryView = chooseBtn;
    chooseBtn.selected = payM.isSelected;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [self.payTBView cellForRowAtIndexPath:indexPath];
    UIButton *cellBtn = (UIButton *)cell.accessoryView;
    [self chooseClick:cellBtn];
}

@end
