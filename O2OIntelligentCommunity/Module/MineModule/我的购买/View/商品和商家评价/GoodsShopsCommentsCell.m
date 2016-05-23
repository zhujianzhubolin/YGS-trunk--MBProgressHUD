//
//  GoodsShopsCommentsCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "GoodsShopsCommentsCell.h"
#import <UIImageView+AFNetworking.h>
#import "RatingBar.h"
#import "uploadCollectionCell.h"
#import "MultiShowing.h"
#import "GetImgFromSystem.h"

@interface GoodsShopsCommentsCell ()<RatingBarDelegate,UITextViewDelegate>

@end

@implementation GoodsShopsCommentsCell
{
    UIImageView *headImgV;
    UILabel     *goodsNameLab;
    RatingBar   *rating;
    UITextView  *describeTV;
    CGFloat     interval;
    
    UILabel *placeholderLab;
    
    CGFloat ratingValue;
}

- (NSString *)getCommentContent {
    NSString * tempStr = [describeTV.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

- (CGFloat)getCommentRating {
    return rating.rating;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        interval=10;
        
        headImgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
        //headImgV.image=[UIImage imageNamed:@"touxiang"];
        [self.contentView addSubview:headImgV];
        
        goodsNameLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImgV.frame)+interval, 10, IPHONE_WIDTH-CGRectGetMaxX(headImgV.frame)-10, 60)];
        goodsNameLab.text=@"获得哈根达斯和工商拱手送 i 后";
        goodsNameLab.numberOfLines=2;
        goodsNameLab.font=[UIFont systemFontOfSize:14];
        //goodsNameLab.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:goodsNameLab];
        
        rating =[[RatingBar alloc]init];
        rating.frame=CGRectMake(CGRectGetMaxX(headImgV.frame)+interval, CGRectGetMaxY(goodsNameLab.frame)-20, 75, 15);
        [rating setImageDeselected:@"xingxing_n" halfSelected:@"banxing" fullSelected:@"xingxing" andDelegate:self];
        rating.isIndicator = NO;
        [self.contentView addSubview:rating];
        
        
        UIImageView *lineImgV =[[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headImgV.frame)+5, IPHONE_WIDTH, 0.6)];
        lineImgV.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self.contentView addSubview:lineImgV];
        
        placeholderLab =[[UILabel alloc]init];
        
        placeholderLab.frame=CGRectMake(7, 0, 300, 30);
        placeholderLab.text=@"说出你最想说的话！最多200字";
        placeholderLab.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        placeholderLab.font=[UIFont systemFontOfSize:14];
        
        describeTV = [[UITextView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lineImgV.frame)+5, IPHONE_WIDTH-10, 50)];
    
        [describeTV addSubview:placeholderLab];
        //describeTV.backgroundColor=[UIColor redColor];
        describeTV.delegate=self;
        [self.contentView addSubview:describeTV];
        UIToolbar *topView =[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        [topView setBarStyle:UIBarStyleDefault];
        
        UIBarButtonItem *btnSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        NSArray *buttonArray =[NSArray arrayWithObjects:btnSpace,doneButton, nil];
        [topView setItems:buttonArray];
        [describeTV setInputAccessoryView:topView];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(textViewEditChanged:)
                                                    name:@"UITextViewTextDidChangeNotification"
                                                  object:describeTV];
        
//        UIImageView *lineImgV2 =[[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(describeTV.frame), IPHONE_WIDTH, 1)];
//        lineImgV2.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
//        [self.contentView addSubview:lineImgV2];
    }
    return self;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:describeTV];
    
    
}
- (void)textViewEditChanged:(NSNotification*)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSUInteger kMaxLength = 200;
    [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                               inTextField:textField];
}

-(void)setGoodsinfo:(MineBuyShiGoodM *)goodM ifTgOrSc:(NSString *)str
{
    if ([str isEqualToString:@"shangcheng"]) {
        [headImgV setImageWithURL:[NSURL URLWithString:goodM.imgPath] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
        
        goodsNameLab.text=goodM.commodityName;
        CGSize priceSize = [AppUtils sizeWithString:goodsNameLab.text font:goodsNameLab.font size:CGSizeMake(IPHONE_WIDTH-CGRectGetMaxX(headImgV.frame)-interval, goodsNameLab.frame.size.height)];
        CGFloat interval = 10;
        dispatch_async(dispatch_get_main_queue(), ^{
            goodsNameLab.frame = CGRectMake(CGRectGetMaxX(headImgV.frame)+interval, goodsNameLab.frame.origin.y, priceSize.width, priceSize.height);
        });

        

        
        [rating displayRating:5];

    }
    else if ([str isEqualToString:@"tuangou"])
    {
        [headImgV setImageWithURL:[NSURL URLWithString:goodM.imgPath] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
        
        goodsNameLab.text=goodM.productName;
        
        [rating displayRating:5];

    }
    
    
}

- (void)ratingChanged:(float)newRating
{
    NSLog(@"%f",newRating);
    
    ratingValue = newRating;

}

-(void)dismissKeyBoard
{
    [describeTV resignFirstResponder];
}

#pragma mark -  UITextView 代理方法
- (void)textViewDidChange:(UITextView *)textView;
{
        if (textView.text.length >0)
        {
            placeholderLab.hidden=YES;
        }
        else
        {
            placeholderLab.hidden=NO;
        }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (![AppUtils isNotLanguageEmoji]) {
        return NO;
    }
    
    if ([textView isEqual:describeTV]) {
        NSInteger strLength = textView.text.length - range.length + text.length;
        if (strLength > 200){
            return NO;
        }
    }
    
    return YES;
    
}




@end
