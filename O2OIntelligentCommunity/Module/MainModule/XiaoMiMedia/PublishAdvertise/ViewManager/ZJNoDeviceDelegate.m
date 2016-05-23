//
//  ZJNoDeviceDelegate.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/4/7.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#define CONTENTL_TAG 10000

#import "ZJNoDeviceDelegate.h"
#import "ZJNoDeviceCell.h"

@implementation ZJNoDeviceDelegate
{
    NSString *qPrompt;
}

- (void)updateUIForPromptInformation:(NSString *)prompt {
    if (![NSString isEmptyOrNull:prompt]) {
        qPrompt = prompt;
        [self.noDeviceTB reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)updateUIForComInfo:(BingingXQModel *)comM {
    ZJNoDeviceCell *cell = [self.noDeviceTB cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell updateUIForComInfo:comM];
}

#pragma mark -<UITableViewDataSource,UITableViewDelegate>

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
        return 5;
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 44;
    }
    else
    {
        CGSize promtSize = [AppUtils sizeWithString:qPrompt font:[UIFont systemFontOfSize:FONT_SIZE] size:CGSizeMake(IPHONE_WIDTH - G_INTERVAL *2, CGFLOAT_MAX)];
        return 25 + G_INTERVAL*2 + promtSize.height;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        ZJNoDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJNoDeviceCell"];

        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZJNoDeviceCell class]) owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        UILabel *tishiL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 25)];
        tishiL.text=@"温馨提示";        
        tishiL.textAlignment=NSTextAlignmentCenter;
        [tishiL setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [cell.contentView addSubview:tishiL];
        
        
        
        UILabel *comentL = [[UILabel alloc]initWithFrame:CGRectMake(G_INTERVAL, CGRectGetMaxY(tishiL.frame)+G_INTERVAL, IPHONE_WIDTH-G_INTERVAL*2, 100)];
        comentL.numberOfLines=0;
        comentL.font=[UIFont systemFontOfSize:FONT_SIZE];
        comentL.text= qPrompt;
        comentL.tag = CONTENTL_TAG;
        [comentL sizeToFit];
        [cell.contentView addSubview:comentL];

        return cell;
    }
    
    
}


@end
