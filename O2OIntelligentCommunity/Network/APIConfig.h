
//
//  APIConfig.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>

/***************SHARE API***************/
#define SHARE_A_PATH_NOTICE_PATH        @"/wx/xq_notice!detail.action"
#define SHARE_API_RENTAL_HOST           @"/wx/house_renting!detail.action"

/***************PHONE API***************/
#define API_QUERE_PHONE_ATTRIBUTION @"http://apis.juhe.cn/mobile/get"

/***************获取最新版本信息 API***************/
#define API_VersionInfo @"/input/findUpgrade"

/***************SERVER HOST***************/
#ifdef DEBUG

    #ifdef BETA

        #define A_HOST_SUP @"192.168.3.49:"
        #define A_HOST_PDM @"192.168.3.49:"
        #define A_HOST_OMS @"192.168.3.49:"
        #define A_HOST_MDM @"192.168.3.49:"

        #define A_PORT_SUP @"11014/sup-rs"
        #define A_PORT_PDM @"11011/pdm-rs"
        #define A_PORT_OMS @"11013/oms-rs"
        #define A_PORT_MDM @"11012/mdm-rs"

    #elif DEVELOP

        #define A_HOST_SUP @"192.168.3.201:"
        #define A_HOST_PDM @"192.168.3.201:"
        #define A_HOST_OMS @"192.168.3.201:"
        #define A_HOST_MDM @"192.168.3.201:"

        #define A_PORT_SUP @"11004/sup-rs"
        #define A_PORT_PDM @"11001/pdm-rs"
        #define A_PORT_OMS @"11003/oms-rs"
        #define A_PORT_MDM @"11002/mdm-rs"

    #elif TEST

        #define A_HOST_SUP @"192.168.3.49:"
        #define A_HOST_PDM @"192.168.3.49:"
        #define A_HOST_OMS @"192.168.3.49:"
        #define A_HOST_MDM @"192.168.3.49:"

        #define A_PORT_SUP @"11004/sup-rs"
        #define A_PORT_PDM @"11001/pdm-rs"
        #define A_PORT_OMS @"11003/oms-rs"
        #define A_PORT_MDM @"11002/mdm-rs"

    #else

        #define A_HOST_SUP @"192.168.3.201:"
        #define A_HOST_PDM @"192.168.3.201:"
        #define A_HOST_OMS @"192.168.3.201:"
        #define A_HOST_MDM @"192.168.3.201:"

        #define A_PORT_SUP @"11004/sup-rs"
        #define A_PORT_PDM @"11001/pdm-rs"
        #define A_PORT_OMS @"11003/oms-rs"
        #define A_PORT_MDM @"11002/mdm-rs"

    #endif

#else

    #define A_HOST_SUP @"sup.ygs001.com"
    #define A_HOST_PDM @"pdm.ygs001.com"
    #define A_HOST_OMS @"oms.ygs001.com" 
    #define A_HOST_MDM @"mdm.ygs001.com"

    #define A_PORT_SUP @"/sup-rs"
    #define A_PORT_PDM @"/pdm-rs"
    #define A_PORT_OMS @"/oms-rs"
    #define A_PORT_MDM @"/mdm-rs"

#endif

/***************SERVER API***************/
//文件上传
#define A_PATH_FILE_POST @"/upload/AppUploads"

/***************登录/注册***************/
//登录
#define A_PATH_LOGIN @"/member/login"
//注册
#define A_PATH_REGISTER @"/member/register"
//发送手机验证码（注册）
#define A_PATH_REGISTER_VERTIFICATE_CODE @"/member/sendMsgByPhone"
//发送手机验证码（除开注册、钱包）
#define A_PATH_PHONE_VERTIFICATE_CODE @"/sms/sendSms"
//发送手机验证码（绑定小区）
#define A_PATH_BINDINGXIAOQU_CODE @"/sms/sendSmsCells"

//验证验证码的正确与否
#define A_PATH_VERTIFICATE_CODE_IS_RIGHT @"/sms/sendSmsCheck"
//找回密码
#define A_PATH_RETRIEVE @"/member/resetnewPassword"
//修改密码
#define A_PATH_UPDATE_PASS @"/member/updatePassword"
//获取用户会员信息
#define A_PATH_GET_MEMBERINFO @"/member/getMember"

/***************保修／投诉***************/
//获取报修、投诉类型列表
#define A_PATH_COMPLAINT_TYPE @"/wyXqComplaint/getWqXqComplaitType"
//保存报修or投诉信息
#define A_PATH_COMPLAINT_SUBMIT @"/wyXqComplaint/saveWyXqComplaint"

/***************首页广告分页***************/
#define A_PATH_MAIN_AD @"/propAdvert/getPropAdvertPager"

/***************公告***************/
//公告
#define A_PATH_NOTICE @"/wyXqComplaint/findByPagerNotice"

/***************评论***************/
//获取评论
#define A_PATH_COMMENT @"/wyXqComplaint/findByPagerComment"
//删除评论
#define A_PATH_DELETE_COMMENT @"/wyXqComplaint/delComment"
//发布评论
#define A_PATH_PUBLISH_COMMENT @"/wyXqComplaint/saveMbWxComment"

//智能排序(筛选)
#define A_PATH_SORT @"/category/findProductScreening"


/**************定制版跳蚤市场相关路径*****************/
#define ADDNEWTOPIC @"/wyXqComplaint/saveWyXqActivity"
#define TIAOZAOLIEBIAO @"/wyXqComplaint/findByPagerActivity"
#define ADDPINGLUNHOUSE @"/wyXqComplaint/saveMbWxComment"
#define PINLUNLISTHOUSE @"/wyXqComplaint/findByPagerComment"

/************生活接口***********/
//各个接口端口均不一样

//券列表
#define QUANLIST @"/coupon/findCouponPage"
//下单的时候查看券列表
#define ORDERLIST @"/coupon/findCouponStore"

#define LifeHomeData @"/propAdvert/getPropAdvertId"

//抢购列表
#define QIANGGOU @"/bundle/findBuyingListPager"

//团购目录列表，目录列表共用一个接口，传参数不一致而已
#define TUANGOU @"/bundle/findGroupProductList"

//商城列表
#define SHANGCHNEG @"/category/findProductBy"

//团购目录列表
#define TUANLIEBIAO @"/category/findGroup"

//团购详情
#define TUANDETAIL @"/bundle/getFindProductId"

//获取城市列表接口路径
#define CITYLIST @"/address/findAddressList"

//分类查询
#define FENLEISEARCH @"/category/findProductType"

//商城详情
#define STOREGOODSDETAIL @"/category/findProductID"

//定时器
#define DAOJISHI @"/bundle/getEndDate"

//商城评论地址
#define SHANGCHENGPINGLUN @"/memberProductComments/findCommentList"

//获取所有的代金券列表
#define ALLDAIJINQUAN @"/coupon/findMemberCoupons"

//获取便利店所有商家
#define ALLEASYSHOP @"/category/findStoreAll"

//便利店所有的分类
#define ALLKINDSEASY @"/category/StoreCatalog"

//分类查找便利店

#define KINDSOFEASY @"/category/StoreType"
//智能排序
#define GOOSSORT @"/category/findStoreScreening"

//便利店商家信息
#define EASYSHOPDETAIL @"/category/StoreId"
//便利店商家商品列表
#define SHOPGOODSLIST @"/category/findProductAll"
//快送商品列表
#define KUAISONGLIST @"/bundle/findZbStoreList"
//商家所有商品接口
#define ALLGOODSINSHOP @"/bundle/findShopStoreList"
//便利店智能排序
#define ARRANGEGOODSINEASYSHOP @"/category/findStoreList"
//便利店智能排序接口
#define EASYGOOSSORT @"/category/findStoreBy"
//精选商家接口
#define JINGXUANSJ @"/category/selectMerchantList"
//获取家政服务类型接口
#define KINDJIAZHENG @"/propAdvert/getStoreType"
//网上商城下单
#define ORDERPATH @"/btcoms/b2-oms-receive-order"
//提交预约
#define TIJIAOYUYUE @"/propAdvert/addAppointment"
//收藏与取消收藏，针对商家的
#define SHOUCANGSHANGJIA @"/favoritesStore/saveFavoritesStore"
//添加商品收藏
#define GOODSSHOUCANG @"/memberProduct/saveMemberProduct"
//删除商品收藏
#define DELEGOODSSHOUCANG @"/memberProduct/deleteMemberProduct"
#define SHOPPINGLUN @"/memberProductComments/findCommentStoreId"
//获取默认收货地址
#define MORENADDRESS @"/address/getmemberId"
//新增一个收货地址
#define ADDNEWADRESS @"/address/saveAddress"
//修改收货地址
#define RESTADRESS @"/address/updateAddress"

//获取所有的收货地址
#define  GETALLADRESSLIST @"/address/getAll"

//删除一个收货地址
#define DELETEADRESS @"/address/deleteAddress"

//设置默认收货地址
#define DEFAULTADRESS @"/address/setAddress"

//获取热搜标签

#define HOTSEARCH @"/category/getPopular"
/************我的接口***********/
//缴费
#define Paycostinterface @"/bizincr1/findCount"
//修改个人信息
#define ChangePersonalinterface @"/wyXqComplaint/updateMemberBase"
//修改密码
#define ChangePasswordinterface @"/member/updatePassword"
//开通钱包
#define OPenMoneBaginterface @"/mycard/activateMyCard"
//修改钱包支付密码
#define AlterMoneyPasswordinterface @"/mycard/editPayPassword"
// 钱包充值
#define MineTopUpinterface @"/mycard/onlineRecharge"
//忘记密码
#define ForgetzhifuPasswordinterface @"/mycard/checkResetPayPsd"
//检查身份通过后设置交易密码
#define ConfirmIdPasswordinterface @"/mycard/resetPayPsd"
//钱包信息
#define MoneyBagInfo @"/mycard/queryMycard"
//钱包
#define MineMoneyInfointerface @"/mycard/getMyCardList"
//钱包支付
#define MineMoneyBagPayinterface @"/mycard/payment"
//意见反馈
#define MineOpinionFeedback @"/input/saveFeedback"

/*
 *
 * ＊＊＊＊＊＊  小区的接口 ＊＊＊＊＊＊＊
 *
 */

//绑定小区新接口
#define MineBinding @"/wyXqComplaint/newSaveMbHouseBinding"

//添加未绑定小区
#define MineaddXQ @"/wyXqComplaint/saveHouse"

//获取用户添加的小区列表
#define bingingXQList @"/wyXqComplaint/findByPagerMbHouseBinding"

// 切换小区
#define SwitchXQinterface @"/wyXqComplaint/changexq"

//根据小区查楼栋和单元
#define QueryFloorUnitinterface @"/wyXqComplaint/findHouseInfoByXqId?"

//获取城市列表
#define XQCitylist @"/wyXqComplaint/findByCity"

//获取小区列表
#define PostXQList @"/wyXqComplaint/findByXq"

//获取我的收藏列表
#define MineSCList @"/category/getMemberProductAll"
//获取收藏的商家列表
#define MineShangJia @"/category/getFavoritesStoreList"

//删除我的租售和我的闲置
#define MineDelectRentalBady @"/wyXqComplaint/delUniversal"

//获取报修和投诉评论列表
#define MineBXTSComments @"/wyXqComplaint/findByPagerComment"

//获取报修或者投诉列表
#define BaoxiuTousu @"/wyXqComplaint/findByPagerWyXqComplaint"

//获取我的订单
#define MineBuyList @"/oms-wd/findByOrderInfo"
//重新选择支付方式下单
#define MineZhifu @"/btcoms/appPayment"
//删除订单
#define MineDeleteDingDan @"/oms-wd/isDelete"
//取消订单
#define MineCancelDindan @"/oms-retchg/b2c-oms-cancel-order"
//确认收货
#define MineAffirmConsignee @"/oms-wd/confirmReceipt"
//获取预约列表
#define MineYUYUEList @"/propAdvert/getTmdmId"
//取消预约
#define CancelYuYue @"/propAdvert/updateAppointment"
//评论预约
#define CommentYuyue @"/memberProductComments/saveProductComments"
//商品和商家评价
#define GoodsShopSComment @"/memberProductComments/saveOrderProductComments"
//兑券
#define DuiQuanRequest @"/coupon/chargeCoupon"
//查询生活圈里面的商家分类
#define StoreCloseRequest @"/category/StoreCatalog"


/*************邻里****************/

//获取话题分类
#define TopicClass @"/wyXqComplaint/getTopicType"
//获取话题列表
#define HuatiList @"/wyXqComplaint/findByPagerActivity"
//新建话题（我要发帖）
#define NeighbourHoodNewHuaTi @"/wyXqComplaint/saveWyXqActivity"
//删除话题
#define DeltelComment @"/wyXqComplaint/delComment"
//送鲜花
#define SongXianHuainterface @"/wyXqComplaint/saveFlowerRecord"

/***************增值业务***************/
//手机充值、查询订单
#define API_PHONE_CHONGZHI @"/bizincr/saveMobileChar"
//查询收费单位
#define API_CHAXUN_UNIT @"/bizincr1/listSdmUnit"
//查询物业费的订单信息
#define API_PRO_PROPERTY_ORDER @"/bizincr1/listWT"
//查询停车费的订单信息
#define API_PRO_PARK_ORDER @"/bizincr1/listWTCar"


#ifdef SmartComJYZX
#define API_PRO_PROPERTY_ORDER @"/bizincr1/listWTJY"
#elif SmartComYGS

#else

#endif

//物业费提交订单
#define API_PRO_SUBMMINT_ORDER @"/bizincr1/saveWT"
//停车费下单
#define API_PARK_SUBMMINT_ORDER @"/bizincr1/saveCar"

//交通罚款查询当前缴费省包含的市
#define API_TRAFFIC_PROVINCE_INCLUDE_CITIES @"/input/findJtfk"
//交通罚款查询所有可缴费城市
#define API_TRAFFIC_ALLPROVINCE @"/input/findSS"
//交通罚款根据cityID查询当前的省市
#define API_TRAFFIC_CITY @"/input/defaultCity"
//交通罚款单查询
#define API_TRAFFIC_ORDER @"/bizincr/listjtfkFromThird"
//交通罚款车牌发动机号和车架号尾数查询
#define API_TRAFFIC_CAR_BITS @"/input/jtfkInput"
//交通罚款下单
#define API_TRAFFIC_SUBMMIT_ORDER @"/bizincr/save"
//水电燃订单查询
#define API_WATER_ELEC_COAR_ORDER @"/bizincr1/listSdmQuery"
//水电燃下单
#define API_WATER_ELEC_COAR_SUBMIT_ORDER @"/bizincr1/saveSdm"


//惠团购相关路径
#define TGList @"/bundle/findGroupProductList"
#define HTFenlei @"/category/findGroup"
#define TGShopGoods @"/bundle/findGroupStoreList"
#define DELETEPINGLUN @"/memberProductComments/getCommentId"
/***************地图***************/

//获取小区周边商家
#define API_MAP_XQ_ZHOUBIAN @"/propAdvert/getCommunityId"



#ifdef SmartComJYZX

#elif SmartComYGS

/*
 * 蜂蜜
 */

//查询会员相关的积分交易信息
#define POSTHONEYINFO @"/pointBusinessRecord/getPointRecordByMemberId"
//查询会员的积分数据
#define POSTVipHoneyInfo @"/pointBusinessRecord/getPointByMemberId"
//蜂蜜兑换
#define PostExchangeHoney @"/integral/integralExchange"
//多少蜂蜜对应一元
#define BeeToOneYuan @"/integral/getPointintegral"

/*
 * 小蜜媒体
 */

//模板列表
#define A_XiaoMI_TemplateList @"/gg/listMb"
//图片上传
#define A_XiaoMI_UploadImg @"/gg/uploadServlet"
//广告播放规则列表
#define API_ADVERTISEMENT_RULE @"/gg/listRegular"
//上传素材并
#define API_SUBMITORDER @"/gg/uploadGg"
//下单
#define API_ORDER @"/gg/order"
//修改订单
#define API_DWONORDER @"/gg/updateTradeType"
//小蜜机器的个数
#define API_XIAOMINUMBER @"/gg/listZd"
//我的媒体列表
#define A_XiaoMI_Mine_PlayerList @"/gg/listOrderGg"
#else

#endif





@interface APIConfig : NSObject

@end