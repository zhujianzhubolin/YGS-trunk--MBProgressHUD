//
//  EasyCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendTelePhoneNum <NSObject>

- (void)telePhoneNum:(NSString *)str;

@end

@interface EasyShoppingCell : UITableViewCell

@property(nonatomic,weak) id<SendTelePhoneNum>phoneDele;

- (void)getData:(id)mydata;

@end
