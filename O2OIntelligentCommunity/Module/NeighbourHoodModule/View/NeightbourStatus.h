//
//  NeightbourStatus.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeightbourStatus : NSObject


#pragma mark  属性

@property (nonatomic,copy)NSString *headimgURLS;//头像

@property (nonatomic,copy)NSString *UserNameS;//用户名

@property (nonatomic,copy)NSString *classifyS;//分类

@property (nonatomic,copy)NSString *baiotiS;//标题

@property (nonatomic,copy)NSString *timeS;//时间

@property (nonatomic,copy)NSString *huaNumberS;//送花数量

@property (nonatomic,copy)NSString *pinglunNumberS;//评论数量

@property (nonatomic,copy)NSString *contentS;//话题内容

@property (nonatomic,copy)NSString *contentimgS;//话题图片

@property (nonatomic,copy)NSMutableArray *imgArray;//图片数组

#pragma mark - 方法
#pragma mark 根据字典初始化微博对象
- (NeightbourStatus * )initWithDictionary:(NSDictionary *)dic;

#pragma mark 初始化微博对象（静态方法）
+ (NeightbourStatus *)statusWithDictionary:(NSDictionary *)dic;


@end
