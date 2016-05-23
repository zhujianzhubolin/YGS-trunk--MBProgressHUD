//
//  ZSDPaymentView.h
//  demo
//
//  Created by shaw on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FinishInputBlock)(NSString *inputStr);
typedef void(^CloseDialogBlock)();

@interface ZSDPaymentView : UIView

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *goodsName;
@property (nonatomic,assign) CGFloat amount;

@property (nonatomic, strong) FinishInputBlock finishBlock;//完成输入后的block
@property (nonatomic, strong) CloseDialogBlock closeBlock;


-(void)show;

@end
