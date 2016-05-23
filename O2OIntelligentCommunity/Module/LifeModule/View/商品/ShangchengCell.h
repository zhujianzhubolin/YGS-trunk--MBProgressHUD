//
//  ShangchengCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GouWuCheClickBlock)(CGPoint gouWuChePoint);

@protocol ChangeCarNum <NSObject>

- (void)setNewNum;

@end


@interface ShangchengCell : UITableViewCell


@property (nonatomic, strong) GouWuCheClickBlock cellClickBlock;

@property(nonatomic,weak) id<ChangeCarNum>numDele;

- (void)getDataFromeController:(id)object;

@end
