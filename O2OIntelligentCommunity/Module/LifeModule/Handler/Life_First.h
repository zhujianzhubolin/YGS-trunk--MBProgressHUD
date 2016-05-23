//
//  Life_First.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "SVProgressHUD.h"
#import "BaseHandler.h"
#import "lifefirst.h"
#import "QiangGouModel.h"
#import "QiangGouLife.h"
#import "AllEasyShop.h"
#import "HuiTuanGouAllModel.h"
#import "HuiTuanGouMuLuModel.h"
#import "FenLeiSearchModel.h"
#import "ShangChengMuLu.h"
#import "ShangChengGoodsModel.h"
#import "StoreGoodsDetailModel.h"
#import "DaoJIShi.h"
#import "PinLunModel.h"
#import "EasyFenLei.h"
#import "EasyShopSortModel.h"
#import "EasyShopInfo.h"
#import "ShopGoodsList.h"
#import "EasyShopGoodsConditionSearch.h"
#import "EasyGoodArrange.h"
#import "TuanGouDetailModel.h"
#import "YuYueModel.h"
#import "DaiJinQuanModel.h"
#import "JiFenModel.h"
#import "ShouCangGoods.h"
#import "ShopPingLunModel.h"
#import "JingXuanModel.h"
#import "MoRenAddress.h"
#import "AddNewDressModel.h"
#import "AllAdressList.h"
#import "SetDefaultAdress.h"

@interface Life_First : BaseHandler


//获取生活首页信息详情,头部
- (void)getHomeData:(lifefirst *)user success:(SuccessBlock)success failed:(FailedBlock)failed;

//生活首页倒计时
-(void)getTime:(DaoJIShi *)shijian success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取惠团购广告页面
- (void)getAdverHuituangou:(lifefirst *)huituan success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取开抢广告页面
- (void)getAdverkaiqiang:(lifefirst *)kaiqiang success:(SuccessBlock)success failed:(FailedBlock)failed;

//抢购列表
- (void)getKaiQiang:(QiangGouModel *)qiang success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取所有的惠团购
- (void)HuiTuanGouAll:(HuiTuanGouAllModel *)tuangou success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取团购目录列表---便利店所有分类列表
- (void)MuLuLieBiao:(HuiTuanGouMuLuModel *)mulu success:(SuccessBlock)success failed:(FailedBlock)failed;


//惠团购分类搜索
//- (void)HuiTuanFenLeiSearch:(FenLeiSearchModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed;

//惠团购获取城市列表接口---公用倒计时Model
- (void)getCityList:(DaoJIShi *)list success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取惠团购详情接口
- (void)getTuanGouDetail:(TuanGouDetailModel *)detail success:(SuccessBlock)success failed:(FailedBlock)failed;

//网上商城相关
//1.获取网上商城所有分类
- (void)getStoreOnLineMuLu:(ShangChengMuLu *)mulu success:(SuccessBlock)success failed:(FailedBlock)failed;

//根据类型查找商城商品
- (void)searchStoreGoodsList:(ShangChengGoodsModel *)shangcheng success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取商城商品详情
-(void)getStoreGoodsDetail:(StoreGoodsDetailModel *)detail success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取商品评论列表
- (void)getPinLunInStore:(PinLunModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed;



//获取便利店所有商家(没有筛选之前的)>>>>>>>>>>这个接口可以获取到所有的商家相关的，
- (void)getAllEasyShop:(PinLunModel *)mode success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取便利店所有的分类
- (void)getEasyAllKinds:(SuccessBlock)success failed:(FailedBlock)failed;

//根据分类搜索所有的便利店商家（添加筛选条件的）
//- (void)SearchShopByCondition:(EasyFenLei *)model success:(SuccessBlock)success failed:(FailedBlock)failed;

//便利店智能排序接口
- (void)SortEasyShop:(EasyShopSortModel *)sort success:(SuccessBlock)success failed:(FailedBlock)failed;

//便利店根据商家ID获取商家信息
- (void)getShopInfor:(EasyShopInfo *)shop success:(SuccessBlock)success failed:(FailedBlock)failed;

//根据便利店商家ID查询所有商品
- (void)getShopAllGoods:(ShopGoodsList *)goodslist success:(SuccessBlock)success failed:(FailedBlock)failed;

//根据商家ID查询商家所有的快送商品
- (void)getKuaiSongList:(ShopGoodsList *)goodslist success:(SuccessBlock)success failed:(FailedBlock)failed;

//根据商家ID查询商家所有的商品列表
- (void)getAllGoodsInShop:(ShopGoodsList *)goodsList success:(SuccessBlock)success failed:(FailedBlock)failed;


//根据目录结果查询便利店商品
- (void)SearchEasyShopGoodsByCondition:(EasyShopGoodsConditionSearch *)condition success:(SuccessBlock)success failed:(FailedBlock)failed;
//便利店商品智能排序
- (void)arrangeGoodEasyshop:(EasyGoodArrange *)range success:(SuccessBlock)success failed:(FailedBlock)failed;


//首页精选商家数据
- (void)JingXuanShangJia:(JingXuanModel *)model succes:(SuccessBlock)success failed:(FailedBlock)failed;


//获取家政服务类型EasyShopInfo    用  Model
- (void)getJiaZhengLeiXing:(EasyShopInfo *)info success:(SuccessBlock)success failed:(FailedBlock)failed;

//提交家政预约
-(void)uploadYuYue:(YuYueModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed;

//查询所有的代金券列表
- (void)getAllDaiJinQuan:(DaiJinQuanModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed;

//商城商品下单
- (void)GetOrderNo:(NSMutableDictionary *)dict success:(SuccessBlock)success failed:(FailedBlock)failed;

//商家收藏---添加与取消在一起
- (void)ShopShouCang:(ShouCangGoods *)shou success:(SuccessBlock)success failed:(FailedBlock)failed;

//添加商品收藏
- (void)StoreGoods:(ShouCangGoods *)goods success:(SuccessBlock)success failed:(FailedBlock)failed;

//删除商品收藏
- (void)DeleGoodsShou:(ShouCangGoods *)goods success:(SuccessBlock)success failed:(FailedBlock)failed;
//获取商家评论列表接口
- (void)getShopPingLun:(ShopPingLunModel *)ping success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取默认收货地址
- (void)GetMoRenAddress:(MoRenAddress *)address success:(SuccessBlock)success failed:(FailedBlock)failed;

//添加一个收货地址
- (void)addNewAdress:(AddNewDressModel *)adress success:(SuccessBlock)success failed:(FailedBlock)failed;

//修改收货地址
- (void)resertAdress:(AddNewDressModel *)adress success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取所有的收货地址
- (void)getAllAdress:(AllAdressList *)list success:(SuccessBlock)success failed:(FailedBlock)failed;

//删除一个收货地址
- (void)deleteAdress:(AllAdressList *)list success:(SuccessBlock)success failed:(FailedBlock)failed;


//添加默认收货地址
- (void)setDefaultAdress:(SetDefaultAdress *)defaultAdress success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
