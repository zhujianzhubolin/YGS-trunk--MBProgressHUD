//
//  ViewController.h
//  SearchDisplayC
//
//  Created by user on 15/9/10.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "O2OBaseViewController.h"
#import "SearchCellEntity.h"
#import "BaseHandler.h"

typedef void (^TableViewCellConfigurate)(id cell,SearchCellEntity *searchE);
typedef void (^SearchCellClickBlock)(SearchCellEntity *searchE);
typedef void (^SearchFromWebBlock)(NSString *searchStr); //返回的数组也只能存放SearchCellEntity

@interface SearchVC : O2OBaseViewController

@property (nonatomic, strong) SearchCellClickBlock clickBlock; //点击cell的回调
@property (nonatomic, strong) SearchFromWebBlock webBlock; //网络搜索请求后的回调
@property (nonatomic, strong) NSArray *searchLocalArr; //本地搜索时使用的数组,只能存放SearchCellEntity,并且搜索字符串为searchString
@property (nonatomic, strong) NSString *placeholder; //默认显示为搜索
//下面的方法在搜索内容为自定义的cell时调用
/*
 *  @param aCellClass                                复用cell的类名
 *  @param aCellheight                               cell的高度,<=0则为44.
 *  @param aCellID                                   cell的复用标示符
 *  @param aCellStyle                                cell的展示样式,只有当使用系统的cell才有效
 *  @param aCellConfigureBlock                       配置每个cell的的内容
 *  @param isFromNib                                 是否使用nib加载

 */

//使用系统的cell
- (void)searchForSystemCellWithCellID:(NSString *)aCellID
                            cellHight:(CGFloat)aCellheight
                            cellStyle:(UITableViewCellStyle)aCellStyle
                                isNib:(BOOL)isFromNib
            tableViewCellConfigufate:(TableViewCellConfigurate)cellConfigurate;

//使用自定义的cell
- (void)searchForCustomCellWithCellClassName:(Class)aCellClass
                                      cellID:(NSString *)aCellID
                                  cellHeight:(CGFloat)aCellheight
                                       isNib:(BOOL)isFromNib
                    tableViewCellConfigufate:(TableViewCellConfigurate)cellConfigurate;


//网络请求刷新
- (void)reloadWebSearchData:(NSArray *)searchArr;
@end

