//
//  LocalUtils.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#ifdef SmartComJYZX
//************  定制版  ************//
//应用信息
#define APP_versionName                       @"shengshijia_ios"

//盛世嘉物业
#define P_USER_PROTOCAL                 @"http://wxssj.ygs001.com/bjsm/userAgreement_20151201.html"
#define P_DOWNLOAD_LINK                 @"http://wxssj.ygs001.com/weixin_ssj/wx/near!loadapp.action"
#define P_PASS_SHARE                    @"http://wxssj.ygs001.com/"
#define P_OFFICIAL_WEBSITE              @"http://www.ssjpm.com/"
#define P_CHECKSTAND_NMAE               @"盛世嘉"
#define P_NMAE                          @"嘉园在线"
#define P_CATEGORY_ID                   @"200"
#define P_WYID                          @"-1"
#define P_SHARE_IMAGE                   @"iphone_Icon_JYZX_60"
#define P_MAIN_AD_IMG                   @"p_main_ad_JYZX.jpg"
#define P_ADVICE_PHONE                  @"0755-26730021"
#define P_SERVICE_PHONE                 @"400-89-59418"
#define P_REFERENCE                     @"shengshijia"  //来源   盛世嘉：  shengshijia  移公社：yigongshe
#define P_MAIN_IMG                      @"p_main_img_JYZX"
#define P_MINE_IMG                      @"p_mine_JYZX_24"
#define P_IS_CUSTOMIZED                 @"Y"
#define P_COMMEN_PROBLEMS               @"http://wxssj.ygs001.com/bjsm/helpApp.html"
#define P_WEB_MEDIA                     @""

//电话归属地查询
#define PHONE_QUERE_KEY                 @"ed70a9fc312269557cfa246935bf01d4"

//分享,注意分享的URL types也需要变化
#define P_UM_KEY                        @"55eea5f1e0f55a3c7100236a"
#define P_APPWB_ID                      @"92118424"//@"wb3451898723"
#define P_APPID_QQ                      @"1104986099"
#define P_APPKEY_QQ                     @"g1MBaQ53pVnax8jm"

  #ifdef DEBUG//测试环境
    //分享API
    #define SHARE_API_HOST          @"http://wx.ygs001.com/weixin_ssj"

    //分享,注意分享的URL types也需要变化
    #define P_APPID_WX              @"wx1324adf32d144ddd"
    #define P_APPKEY_WX             @"f4acef7c5259ed6832c0fa818559fbb3"

    // 更改商户把相关参数后可测试  测试环境的 账号帐户资料、支付,还需要配置商户ID和密钥
    #define APP_ID                  @"wx1324adf32d144ddd"               //APPID
    #define ENVIRONMENT             @"SSJRD"

  #else//生产环境
    //分享API
    #define SHARE_API_HOST          @"http://wxssj.ygs001.com/weixin_ssj"

    //分享,注意分享的URL types也需要变化
    #define P_APPID_WX              @"wx1c6f2b037f4687fe"
    #define P_APPKEY_WX             @"f4acef7c5259ed6832c0fa818559fbb3"

    // 更改商户把相关参数后可测试  生产环境的 账号帐户资料、支付,还需要配置商户ID和密钥
    #define APP_ID                  @"wx1c6f2b037f4687fe"               //APPID
    #define ENVIRONMENT             @"SSJ"

  #endif

#elif SmartComYGS
//************  标准版  ************//
//应用信息
#define APP_versionName                       @"yigongshe_ios"

//移公社
#define P_USER_PROTOCAL                 @"http://wxssj.ygs001.com/bjsm/userAgreement_20151228.html"
#define P_DOWNLOAD_LINK                 @"http://weixin.ygs001.com/weixin/wx/near!loadapp.action"
#define P_PASS_SHARE                    @"http://wxssj.ygs001.com/ewm/passYGS.html?"
#define P_OFFICIAL_WEBSITE              @"www.ygs001.com"
#define P_CHECKSTAND_NMAE               @"移公社"
#define P_NMAE                          @"移公社"
#define P_CATEGORY_ID                   @"201"
#define P_WYID                          @"1700"
#define P_SHARE_IMAGE                   @"iphone_Icon_YGS_60"
#define P_MAIN_AD_IMG                   @"p_main_ad_YGS.jpg"
#define P_ADVICE_PHONE                  @""
#define P_SERVICE_PHONE                 @"400-89-59418"
#define P_REFERENCE                     @"yigongshe"  //来源   盛世嘉：  shengshijia  移公社：yigongshe
#define P_MAIN_IMG                      @"p_main_img_YGS"
#define P_MINE_IMG                      @"p_mine_YGS_24"
#define P_IS_CUSTOMIZED                 @"N"
#define P_COMMEN_PROBLEMS               @"http://wxssj.ygs001.com/bjsm/helpAppYGS.html"
#define P_WEB_MEDIA                     @"http://wxssj.ygs001.com/bjsm/honeybeeMedia.html"

//电话归属地查询
#define PHONE_QUERE_KEY                 @"ed70a9fc312269557cfa246935bf01d4"

//分享,注意分享的URL types也需要变化
#define P_UM_KEY                        @"568b3cbee0f55a6089002195"
#define P_APPWB_ID                      @"1359636526"
#define P_APPID_QQ                      @"1104977527"
#define P_APPKEY_QQ                     @"of7yGLKpVZWrg30b"

  #ifdef DEBUG//测试环境
    //分享API
    #define SHARE_API_HOST          @"http://weixin.ygs001.com/weixin"

    //分享,注意分享的URL types也需要变化
    #define P_APPID_WX              @"wxd11fe76c3bca4bbe"
    #define P_APPKEY_WX             @"p0m9n8n76vc0x9b6e2re1x0iwqo4bt3k"

    // 更改商户把相关参数后可测试  测试环境的 账号帐户资料、支付,还需要配置商户ID和密钥
    #define APP_ID                  @"wxd11fe76c3bca4bbe"               //APPID
    #define ENVIRONMENT             @"YGSRD"

  #else//生产环境
    //分享API
    #define SHARE_API_HOST          @"http://wechat.ygs001.com/weixin"

    //分享,注意分享的URL types也需要变化
    #define P_APPID_WX              @"wx10cffa2b72763370"
    #define P_APPKEY_WX             @"gb9xf6b6d0nm240okx2b7nfdp0m9n8nb"

    // 更改商户把相关参数后可测试  生产环境的 账号帐户资料、支付,还需要配置商户ID和密钥
    #define APP_ID                  @"wx10cffa2b72763370"               //APPID
    #define ENVIRONMENT             @"YGS"

  #endif

//标准版专属
    #define APP_version             @"YGS"

#else

#endif


//************  通用  ************//
#define URL_YGS                         @"http://www.ygs001.com"

#define TAB_ITEM_HEIGHT                 40 //topbar顶部item的高度
#define PHONE_INPUT_BITS                11 //手机号输入位数
#define AUTH_CODE_INPUT_BITS            6 //验证码输入位数
#define SEARCH_INPUT_LENGTH             50 //搜索输入位数
#define START_NET_TIME                  0.8 //试图控制器初始化停留时间
#define LENGTH_USER_NAME                10//用户名的中文长度

#define G_BTN_BGCOLOR                   @"FC6D22"
#define G_BTN_FONT                      18
#define G_TAB_ITEM_FONT                 14
#define G_LIST_ICON_WIDTH
#define G_COLLECT_IMG_WIDTH


//************  通知  ************//
#define k_NOTI_COMMUNITY_CHANGE         @"k_NOTI_COMMUNITY_CHANGE" //默认小区切换后的通知
#define k_NOTI_COMMUNITY_GO_BINDING     @"k_NOTI_COMMUNITY_GO_BINDING" //小区提示去绑定的通知

#define k_NOTI_ORDER_ADDORESS_CHANGE    @"k_NOTI_ORDER_ADDORESS_CHANGE" //订单地址切换
//************  整体  ************//
#define W_ALL_NO_NETWORK                @"网络好像离家出走了喔"
#define W_ALL_FAIL_GET_DATA             [[NetworkRequest defaultRequest] isConnectionReachable] ? @"小蜜走神ing，请稍后再试~" : W_ALL_NO_NETWORK
#define W_ALL_NO_DATA_NOTICE            @"暂时没有公告账单哦"
#define W_ALL_NO_DATA_PROPERTY          @"暂时没有物业账单哦"
#define W_ALL_NO_SERVER                 @"本小区暂未开通此项服务，敬请期待！"
#define W_ALL_NO_DATA_SEARCH            @"亲爱的我找不到喔，换个关键词看看？"
#define W_ALL_PROGRESS                  @"疯狂加载中"
#define W_ALL_LOGOUT                    @"亲爱的你确定要离开了吗?"
#define W_ALL_AFTER_COMMENT             @"亲爱的谢谢您的评价!"
#define W_ALL_NO_BINDING                @"亲爱的，你还未进行业户绑定，马上去绑定？"
#define W_ALL_PHONE_ERR_FORMAT          @"亲爱的,您的手机号码格式不对喔"
#define W_ALL_PASS_LENGTH               @"亲爱的,您输入的密码长度不对喔"
#define W_ALL_SENDCODE_SUC              @"验证码发送成功!\n请留意您的短信喔"
#define W_ALL_INPUT_CODE                @"快输入手机收到的验证码吧!"
#define W_ALL_PUBLISHED_SUC             @"恭喜您!发表成功!"

//************  小区  ************//
#define W_COM_BANDING_SUC               @"您的绑定申请已提交，我们会尽快完成审核。感谢您对我们的信任~"

//************  报修、投诉  ************//
#define W_REPAIR_NO_DATA_SUB            @"亲爱的您不能交白卷喔!"
#define W_REPAIR_NO_TYPE_SUB            @"亲爱的忘记勾选报修设施了啦!"
#define W_REPAIR_NO_CONTENT_SUB         @"亲爱的你的报修内容是什么呢?"
#define W_REPAIR_NO_USERNAME            @"用户姓名不能为空哦~"
#define W_REPAIR_SUC_SUB                @"亲爱的，你的报修提交成功！报修单号是："
#define W_COMPLAIN_SUC_SUB              @"您的投诉提交成功啦,记得别忘记投诉单号喔!您的投诉单号是："

//************  缴费  ************//
#define W_CHARGE_NO_SEL_AGREE           @"记得勾选缴费协议喔!"
//话费
#define W_PHONE_NO_INPUT                @"亲爱的你想给谁充值呢?"
//交通罚款
#define W_TRAFFIC_NO_IDCODE             @"亲爱的别忘了车辆识别码喔!"
#define W_TRAFFIC_NO_ENGINE_NUM         @"亲爱的别忘了车辆发动机号喔!"
#define W_TRAFFIC_NO_CAR_NUM            @"亲爱的别忘了车牌号码,5位的喔"
//#define W_TRAFFIC_NO_RESULT             @"亲爱的我找不到喔,快检查一下吧"
#define W_TRAFFIC_NO_CHARGE             @"最少选择一项吧"
#define W_TRAFFIC_NO_Data               @"温馨提示：\n部分地区违章记录出通知书时间为5个工作日或以上。历时再生成通知书。"
#define W_TRAFFIC_QUERING               @"温馨提示：\n各地区可查询违章通知记录以当地交管网时间为准。"

//停车费
#define W_PARK_NO_INPUT_CAR_NUM         @"亲爱的别忘了车牌号码喔!"
#define W_PARK_NO_CAR_NUM               @"亲爱的没有找到这个车牌号喔!"
//水电燃
#define W_PARK_NO_INPUT_USER_NUM        @"亲爱的别忘了输入用户编号喔!"
#define W_PARK_NO_INPUT_CHARGE_UNIT     @"亲爱的好像漏了写收费单位喔!"

//************ 通行证 ************//
#define W_PASSPERMIT_NO_VISITER         @"亲爱的想邀请谁呢?"
#define W_PASSPERMIT_NO_VALIDITY        @"有效期时间为一个月以内"

//************ 登录/注册/密码 ************//
#define W_REGISTER_SUC                  @"恭喜您!注册成功啦,欢迎成为我们的一份子"
#define W_PASSWORD_NO_EQUAL             @"两次输入的密码不一样啊,快检查检查吧!"
#define W_PASSWORD_MODIFY_SUC           @"恭喜您!密码修改成功啦!"
#define W_PASSWORD_LENGTH               @"密码只能6-16位哦"

//************ 我的 ************//
#define M_MINEBUY_ORDERCOMMENT_LENGTH         @"评语要最少五个字喔!"
#define M_MINEBUY_ORDERSUBMITCOMMONT_SUCCESS  @"恭喜您,评价成功了!"
#define M_MINEBUY_CONFIRMGOODS                @"亲爱的,确定收到宝贝了吗?"
#define M_MINEBUY_DELETEORDER                 @"亲爱的,确定要删除订单吗？"
#define M_MINEBUY_CANCELORDER                 @"亲爱的,确定要取消订单了吗？"
//************ 我的邀请邻居 ************//
#define M_MINE_INVITATION_SUCCESS             @"恭喜您，邀请成功!"
#define M_MINE_INVITATION_PHONENUMBER         @"亲爱的,您的手机号码格式不对喔~~"
//************ 我的报事 ************//
#define M_MINE_REPAIRS_REMINDER_SUCCESS       @"恭喜您,催单成功，物业将尽快处理！"
#define M_MINE_CONCELREPAIRS                  @"亲爱的,您确定要取消报修吗？"
#define M_MINE_REPAIRS_COMMENT_LENGTH         @"亲爱的.评论最少要5个字喔!"
#define M_MINE_REPAIRS_COMMENT_SUCCESS        @"恭喜您,评价成功！"
#define M_MINE_COMPLAINT_CONCELCOMPLAINT      @"亲爱的,您确定要取消投诉吗？"
#define M_MINE_COMPLAINE_CONCELCOMMENTLENGTH  @"亲爱的.评论最少要5个字喔!"
#define M_MINE_COMPLAINE_CONCELCOMMENT_SUCCES @"恭喜您,评价成功"
//************ 我的意见反馈 ************//
#define M_MINE_FEEDBACK                       @"亲，您遇到什么系统问题啦，或有什么功能建议吗？欢迎您提给我们，谢谢！"
#define M_MINE_FEEDBACK_SUCCESS               @"恭喜您!发表成功!"
#define M_MINE_FEEDBACK_ERROR                 @"抱歉，意见提交失败！"
//************ 我的清除缓存 ************//
#define M_MINE_EILMINATE                      @"确定要清除本地的缓存了吗？"
#define M_MINE_EILMINATE_SUCCES               @"缓存已清除干净了!"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppUtils.h"
#import "UserDefaultsUtils.h"

typedef NS_ENUM(NSUInteger, TopViewButtonTag) {
    ButtonTagLeft = 1,  //topview上左边按钮的tag
    ButtonTagTitle, //topview上中间主题按钮的tag
    ButtonTagTwoRight, //topview上右边第二个按钮的tag
    ButtonTagRight //topview上最右边按钮的tag
};

//从不同的界面跳转到我的小区界面
typedef NS_ENUM(NSUInteger, CommunityChooseType) {
    CommunityChooseTypeAdd, //添加小区并切换为默认
    CommunityChooseTypeChooseDefault, //在所有小区中切换默认小区
    CommunityChooseTypeChooseAll, //在所有小区中切换小区 (但不作为默认处理)
    CommunityChooseTypeBinding //选择用户当前绑定的小区
};

typedef NS_ENUM(NSUInteger, ButtonInternalPositionType) {
    ButtonInternalLabelPositionRight, // Label位置在右边，默认
    ButtonInternalLabelPositionLeft, // Label位置在左边
    ButtonInternalLabelPositionTop, // Label位置在上面
    ButtonInternalLabelPositionButtom // Label位置在下面
};

//小区的权限控制
typedef NS_ENUM(NSUInteger, ComLimitsClassify) {
    ComLimitsClassifyProperty, //缴物业费权限
    ComLimitsClassifyPark, //缴停车费权限
    ComLimitsClassifyPass, //通行证的权限
    ComLimitsClassifyRepair, //保修的权限
    ComLimitsClassifyComplaint, //投诉的权限
    ComLimitsClassifyOption //意见和建议的权限
};

typedef NS_ENUM(NSUInteger, ChargeType) { //缴费的样式
    ChargeTypeWater = 1,
    ChargeTypeElec,
    ChargeTypeCoal,
    ChargeTypeProperty,
    ChargeTypePark,
    ChargeTypeTraffic,
    ChargeTypePhone,
    ChargeTypeOnlineShop,
    ChargeTypeWalletRecharge
};

typedef NS_ENUM(NSUInteger, FilePostType) { //文件上传业务类型
    FilePostTypeNotice,
    FilePostTypeRepair,
    FilePostTypeComplaint,
    FilePostTypePlayTogether,
    FilePostTypeHelpGroup,
    FilePostTypeSecondhandgoods,
    FilePostTypeGossip
};

typedef NS_ENUM(NSUInteger, PayType) { //支付方式
    PayTypeQianBao = 1,
    PayTypeWeiXin,
};

typedef NS_ENUM(NSUInteger,CommentPage)
{
    CommentPageTopic,//话题评论
    CommentPageRepairs,//报修评论
    CommentPageComplain,//投诉评论
    CommentPageFeedBack//意见反馈
};

typedef NS_ENUM(NSUInteger,VCTypeRen) {
    VCTypeRental,
    VCTypeIdle
};

@interface LocalUtils : NSObject
/********************* Type Utils **********************/
//根据上传文件类型返回上传的字段
+ (NSString *)stringFotFilePostType:(FilePostType)type;

//根据缴费类型返回缴费的标题
+ (NSString *)titleForChargeType:(ChargeType)type;

//根据缴费类型返回缴费字段
+ (NSString *)chargeStrForChargeType:(ChargeType)type;

//根据商家类型ID获取商家类型
+ (NSString *)merchantsCategoryForCategoryID:(NSUInteger)categoryId;

//根据payType返回支付类型参数
+ (NSString *)payTypeStrForPayType:(PayType)payType;

//简称是否是直辖市
+ (BOOL)isSepcialCity:(NSString *)city;

//缴费body参数
+ (NSString *)chargeBodyForCharegeType:(ChargeType)chargeType;
@end
