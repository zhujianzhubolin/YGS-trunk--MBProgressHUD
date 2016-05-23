//
//  UpLoadNewRentInfor.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "UpLoadNewRentInfor.h"
#import "uploadCollectionCell.h"
#import "GetImgFromSystem.h"
#import "MultiShowing.h"
#import "ComplaintHandler.h"
#import "FilePostE.h"
#import "NSData+wrapper.h"
#import "UIImage+wrapper.h"
#import "HouseAndGoods.h"
#import "AddNewInforModel.h"
#import "UserManager.h"
#import "ZLPhotoPickerBrowserViewController.h"
#import "ZYTextInputBar.h"

@interface UpLoadNewRentInfor ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,GetImgFromSystemDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,didSelectImgBtn,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource>

{
    __weak IBOutlet UIView *backView;
    //房屋出租相关按钮
    __weak IBOutlet UIButton *outRent;
    __weak IBOutlet UIButton *seleBtn;
    __weak IBOutlet UIButton *needRentbtn;
    
    
    __weak IBOutlet UITableView *myTableView;
    
    //跳蚤市场的几个按钮
    __weak IBOutlet UIButton *tiaozaochushou;
    __weak IBOutlet UIButton *tiaozaoqiugou;
    
    int viewwidth;
    int viewheight;
    BOOL isSelect;
    NSArray * nameArray;
    UITextField * title;
    UITextField * phone;
    UITextField * price;
    UITextField * cityTextField;
    
    //输入描述性的文字
    UITextView *mytextView;
    UILabel * phalclable;
    
    UICollectionView * CollectionView;
    
    NSMutableString *imgIDStr;
    NSMutableArray *postImgArr;
    NSMutableArray *imageArray;
    
    MultiShowing * multshowimg;
    
    BOOL isHouse;
    
    
    //防止tableView重用机制把Cell上面的数据清空
    NSString * textViewStr;
    NSString * titleStr;
    NSString * priceStr;
    NSString * phoneStr;
    
    UILabel * wordNumLable;
    
    //选择城市，pickerView
    UIPickerView * cityPicker;
    UIToolbar * cityBar;
    
    //城市数组
    NSMutableArray * cityArray;
    //城市的下标
    NSInteger cityIndex;
    
    //房屋的单位
    UILabel * houseunit;
    NSUInteger selectedIndex;
}

@end

@implementation UpLoadNewRentInfor

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    mytextView.text = textViewStr;
    
    if (textViewStr.length > 0) {
        phalclable.text = @"";
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    textViewStr = mytextView.text;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布信息";
    
    cityIndex = 0;
    
    cityArray = [NSMutableArray arrayWithObjects:@"深圳", nil];
    self.navigationController.navigationBar.translucent = YES;
    nameArray = [NSArray arrayWithObjects:@"标题：",@"电话：",@"价格：", nil];
    
    if (VIEW_IPhone4_INCH) {
        viewwidth = 320;
        viewheight = 480;
    }else if (VIEW_IPhone5_INCH){
        viewwidth = 320;
        viewheight = 568;
    }else if (VIEW_IPhone6_INCH){
        viewwidth = 375;
        viewheight = 667;
    }else{
        viewwidth = 414;
        viewheight = 736;
    }
    
    [self viewDidLayoutSubviewsForTableView:myTableView];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
    
    
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    myTableView.tableFooterView = footView;

    UIButton * upLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [upLoadBtn addTarget:self action:@selector(upLoadInfor) forControlEvents:UIControlEventTouchUpInside];
    upLoadBtn.frame = CGRectMake(20, 30, viewwidth - 40, 40);
    upLoadBtn.layer.cornerRadius = 5;
    upLoadBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    upLoadBtn.backgroundColor = [AppUtils colorWithHexString:@"FC6D22"];
    [upLoadBtn setTitle:@"发布" forState:UIControlStateNormal];
    [footView addSubview:upLoadBtn];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidKeyBoard)];
    [self.view addGestureRecognizer:tap];
    
    //底部添加图片
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, viewwidth, 70) collectionViewLayout:flowLayout];
    [CollectionView registerClass:[uploadCollectionCell class] forCellWithReuseIdentifier:SYSTEM_CELL_Col_ID];
    
    CollectionView.scrollEnabled = YES;
    CollectionView.userInteractionEnabled = YES;
    CollectionView.dataSource = self;
    CollectionView.delegate = self;
    CollectionView.backgroundColor =[UIColor whiteColor];
    [GetImgFromSystem getImgInstance].delegate = self;

    imgIDStr =[[NSMutableString alloc]init];
    postImgArr=[[NSMutableArray alloc]init];
    postImgArr=[[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"postImg"], nil]; multshowimg =[[MultiShowing alloc]init];
    
    if (self.vcType == VCTypeRental) {//房屋出售
        tiaozaochushou.hidden = YES;
        tiaozaoqiugou.hidden = YES;
        isHouse = YES;

        switch (self.rentType) {
            case RentTypeBuyHouse:
                selectedIndex = 1;
                seleBtn.selected = YES;
                break;
            case RentTypeRentHouse:
                selectedIndex = 0;
                outRent.selected = YES;
                break;
            case RentTypeWantedRent:
                selectedIndex = 2;
                needRentbtn.selected = YES;
                break;
            default:
                break;
        }
        
    }else{//跳蚤市场
        outRent.hidden = YES;
        seleBtn.hidden = YES;
        needRentbtn.hidden = YES;
        isHouse = NO;
        
        switch (self.idleType) {
            case IdleMarketTypeSell:
                selectedIndex = 0;
                tiaozaochushou.selected = YES;
                break;
            case IdleMarketTypeWantedBuy:
                selectedIndex = 1;
                tiaozaoqiugou.selected = YES;
                break;
            default:
                break;
        }
        
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:title];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:mytextView];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextViewTextDidChangeNotification"
                                                 object:mytextView];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:title];
}

- (void)textFiledEditChanged:(NSNotification*)obj{
    
    if ([obj.object isKindOfClass:[UITextField class]]) {
        UITextField *textTF = (UITextField *)obj.object;
        NSUInteger kMaxLength = 20;
        [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                                   inTextField:textTF];
    }
    
    if ([obj.object isKindOfClass:[UITextView class]]) {
        UITextView *textV = (UITextView *)obj.object;
        NSUInteger kMaxLength = 500;
        [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                                    inTextView:textV];
    }
}

//提交上传
- (void)upLoadInfor{
    if (isHouse) {
        
        //城市
        if (cityTextField.text.length <= 0) {
            
            [self alertMessage:@"请先选择城市!"];
            return;
        }
        
        //标题
        NSString * titleWithOutSpace = [title.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (titleWithOutSpace.length < 3) {
            
            [self alertMessage:@"标题不能少于3个字!"];
            return;
        }
        //电话
        if (![self checkTel:phone.text]) {
            [self alertMessage:@"请输入正确的手机号码!"];
            return;
        }
        //价格
        NSString * myPriceWithOutSpace = [price.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (myPriceWithOutSpace.length <= 0) {
            [self alertMessage:@"价格不能为空!"];
            return;
        }
        //描述输入内容过短,描述需要大于1个字!"输入内容过长,请控制在250字以内!
        
        //过滤掉回车键
        NSString * textWithEnter = [mytextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString * miaoshuWithOutSpace = [textWithEnter stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (miaoshuWithOutSpace.length <= 0) {
            [self alertMessage:@"描述输入内容过短,描述需要大于1个字!"];
            return;
        }
        
        if (miaoshuWithOutSpace.length > 500) {
            [self alertMessage:@"输入内容过长,请控制在500字以内!"];
            return;
        }

        
        if (postImgArr.count <= 1) {
            [self postedRequest];
        }else{
            [AppUtils showProgressMessage:@"上传图片中"];

            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(houseAdd) userInfo:nil repeats:NO];
        }
    }else{
        
        //标题
        NSString * titleWithOutSpace = [title.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (titleWithOutSpace.length < 3) {
            
            [self alertMessage:@"标题不能少于3个字!"];
            return;
        }
        //电话
        if (![self checkTel:phone.text]) {
            [self alertMessage:@"请输入正确的手机号码!"];
            return;
        }
        //价格
        NSString * myPriceWithOutSpace = [price.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (myPriceWithOutSpace.length <= 0) {
            [self alertMessage:@"价格不能为空!"];
            return;
        }
        //描述
        //过滤掉回车键
        NSString * textWithEnter = [mytextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString * miaoshuWithOutSpace = [textWithEnter stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (miaoshuWithOutSpace.length <= 0) {
            [self alertMessage:@"描述输入内容过短,描述需要大于1个字!"];
            return;
        }
        if (miaoshuWithOutSpace.length > 500) {
            [self alertMessage:@"输入内容过长,请控制在500字以内!"];
            return;
        }
        
        if (postImgArr.count <=1) {
            
            [self goodsAddRequest];
        }else{
            [AppUtils showProgressMessage:@"上传图片中"];

            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(goodsAdd) userInfo:nil repeats:NO];
        }
    }
}


//发布商品信息
- (void)goodsAdd{//商品图片上传

    dispatch_queue_t concurrentQueue = dispatch_queue_create("mySerailQueue", DISPATCH_QUEUE_CONCURRENT);
    __block NSUInteger finishCount = 0;
    
    imgIDStr = [NSMutableString new];
    
    [postImgArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != postImgArr.count - 1) {
            
            //压缩图片
            UIImage *img = obj;
            
            ComplaintHandler *complainH = [ComplaintHandler new];
            
            FilePostE *imgPost = [FilePostE new];
            imgPost.dataD = [NSString encodeBase64Data:[NSData dataTransformUnder1MFromImg:img]];
            //           imgPost.dataD = [NSString encodeBase64Data:[NSData dataTransformFromImg:[UIImage imageCompressForSize:img targetSize:CGSizeMake(img.size.width / SCALE_SIZE_IMG, img.size.height / SCALE_SIZE_IMG)]]];
            
            imgPost.entityType = @"FLEAMARKET";
            imgPost.fileName = [NSString stringWithFormat:@"跳蚤市场图片%lu.png",(unsigned long)postImgArr.count];
            
            dispatch_async(concurrentQueue, ^{
                [complainH  excuteImgPostTask:imgPost success:^(id obj) {
                    FilePostE *fileE = (FilePostE *)obj;
                    if (imgIDStr.length <= 0) {
                        [imgIDStr appendFormat:@"%@",fileE.idID];
                    }else{
                        [imgIDStr appendFormat:@",%@",fileE.idID];
                    }
                    
                    finishCount ++;
                    if (finishCount == postImgArr.count - 1) {
//                        [self submmitAllPost];
                        [self goodsAddRequest];
                    }
                } failed:^(id obj) {
                    finishCount ++;
                    if (finishCount == postImgArr.count - 1) {
//                        [self submmitAllPost];
                        [self goodsAddRequest];
                    }
                }];
            });
        }
    }];
}
//商品数据请求
- (void)goodsAddRequest{//商品最后的请求
    
    
    HouseAndGoods * handel = [HouseAndGoods new];
    AddNewInforModel * model = [AddNewInforModel new];
    model.memberid = [UserManager shareManager].userModel.memberId;
    model.wyNo = [UserManager shareManager].comModel.wyId;
    model.xqNo = [UserManager shareManager].comModel.xqNo;
    model.title = title.text;
    
    NSString * textWithEnter = [mytextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString * miaoshuWithOutSpace = [textWithEnter stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    model.activityContent = miaoshuWithOutSpace;
    model.activityType = @"2";
    
    //判断选择类型
    if (tiaozaochushou.selected) {
        model.fleaMarketType = @"1";
        
        if (postImgArr.count <= 1) {
            [self alertMessage:@"请先上传图片!"];
            return;
        }
    }
    
    if (tiaozaoqiugou.selected) {
        model.fleaMarketType = @"2";
    }
    
    model.fileId = imgIDStr;
    
    model.type = @"6";
    model.price = price.text;
    model.phone = phone.text;
    model.status = @"3";
    
    model.cityId = @"77";

    [handel AddNewGoodsInfor:model success:^(id obj) {
        
        NSLog(@"上传成功>>>>>>%@",obj);
        [AppUtils showSuccessMessage:obj[@"message"]];
        [self.navigationController popViewControllerAnimated:YES];
        [self senToBefore];
        
    } failed:^(id obj) {
        
        if (self.viewIsVisible) {
            [AppUtils showAlertMessage:W_ALL_FAIL_GET_DATA];
        }else{
            [AppUtils dismissHUD];
        }
    }];

}

//发布房屋信息>>>>图片输入内容过短,描述需要大于1个字!"]输入内容过长,请控制在250字以内!
- (void)houseAdd{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("mySerailQueue", DISPATCH_QUEUE_CONCURRENT);
    __block NSUInteger finishCount = 0;
    imgIDStr = [NSMutableString new];
    [postImgArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != postImgArr.count - 1) {
             UIImage *img = obj;
            ComplaintHandler *complainH = [ComplaintHandler new];
            FilePostE *imgPost = [FilePostE new];
            imgPost.dataD = [NSString encodeBase64Data:[NSData dataTransformUnder1MFromImg:img]];
//           imgPost.dataD = [NSString encodeBase64Data:[NSData dataTransformFromImg:[UIImage imageCompressForSize:img targetSize:CGSizeMake(img.size.width / SCALE_SIZE_IMG, img.size.height / SCALE_SIZE_IMG)]]];
            
            imgPost.entityType = @"HOUSESALE";
            imgPost.fileName = [NSString stringWithFormat:@"房屋租售图片%lu.png",(unsigned long)postImgArr.count];
            dispatch_async(concurrentQueue, ^{
                [complainH  excuteImgPostTask:imgPost success:^(id obj) {
                    FilePostE *fileE = (FilePostE *)obj;
                    if (imgIDStr.length <= 0) {
                        [imgIDStr appendFormat:@"%@",fileE.idID];
                    }else{
                        [imgIDStr appendFormat:@",%@",fileE.idID];
                    }
                    finishCount ++;
                    if (finishCount == postImgArr.count - 1) {
                        [self postedRequest];
                    }
                } failed:^(id obj) {
                    finishCount ++;
                    if (finishCount == postImgArr.count - 1) {
                        [self postedRequest];
                    }
                }];
            });
        }
    }];

}

- (void)postedRequest{//最后的信息
        HouseAndGoods * handel = [HouseAndGoods new];
        AddNewInforModel * model = [AddNewInforModel new];
        model.memberid = [UserManager shareManager].userModel.memberId;
        model.wyNo = [UserManager shareManager].comModel.wyId;
        model.xqNo = [UserManager shareManager].comModel.xqNo;
        model.title = title.text;

        NSString * textWithEnter = [mytextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString * miaoshuWithOutSpace = [textWithEnter stringByReplacingOccurrencesOfString:@" " withString:@""];
        model.activityContent = miaoshuWithOutSpace;
        model.activityType = @"2";
        model.status = @"3";
        model.cityId = @"77";
    
    
        //判断选择类型
        if (outRent.selected) {
            model.transactionType = @"1";
            if (postImgArr.count <= 1) {
                [self alertMessage:@"请先上传图片!"];
                return;
            }
        }
        if (seleBtn.selected){
            model.transactionType = @"2";
            if (postImgArr.count <= 1) {
                [self alertMessage:@"请先上传图片!"];
                return;
            }
        }
    
    
    
        if(needRentbtn.selected){
            model.transactionType = @"3";
        }
    
    
        model.type = @"2";
        model.price = price.text;
        model.phone = phone.text;
    
        model.fileId = imgIDStr;
    
        [handel AddNewHouseInfor:model success:^(id obj) {
            [AppUtils showSuccessMessage:obj[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            [self senToBefore];
        } failed:^(id obj) {
            [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA
                                isShow:self.viewIsVisible];
        }];
}


//收键盘
- (void)hidKeyBoard{
    [self.view endEditing:YES];
    [cityTextField resignFirstResponder];
    [title resignFirstResponder];
    [phone resignFirstResponder];
    [price resignFirstResponder];
    [mytextView resignFirstResponder];
    [self viewMoving:myTableView frame:CGRectMake(0, 64 + 64, viewwidth, viewheight - 64 - 64) setAnimationDuration:0.3];
}


- (void)xieyieArr:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        isSelect = YES;
    }else{
        isSelect = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (isHouse) {
        return 6;
    }else{
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (isHouse) {
        if (indexPath.section == 4) {
            return 120;
        }else if (indexPath.section == 5){
            return CollectionView.frame.size.height;
        }else{
            return 60;
        }
    }else{
        if (indexPath.section == 3) {
            return 120;
        }else if (indexPath.section == 4){
            return CollectionView.frame.size.height;
        }else{
            return 60;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (isHouse) {
        NSArray * arrayWithCity = [NSArray arrayWithObjects:@"城市：",@"标题：",@"电话：",@"价格：", nil];
        if (indexPath.section <= 3) {
            UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 60)];
            nameLabel.text = [arrayWithCity objectAtIndex:indexPath.section];
            nameLabel.textAlignment = NSTextAlignmentRight;
            nameLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:nameLabel];
            
            if (indexPath.section == 1) {
                title = [self addTextField:cell.contentView frame:CGRectMake(60, 0, viewwidth-70, 60) AndDidBeginAction:nil phold:@"一句话描述下房源吧" tag:1000+indexPath.section];
                title.text = titleStr;
                title.inputAccessoryView = [ZYTextInputBar shareInstance];
                title.clearButtonMode = UITextFieldViewModeWhileEditing;
                title.font = [UIFont systemFontOfSize:15];
                title.delegate = self;
            }else if (indexPath.section == 2){
                phone = [self addTextField:cell.contentView frame:CGRectMake(60, 0, viewwidth-70, 60) AndDidBeginAction:nil phold:@"请输入手机号" tag:1000+indexPath.section];
                phone.keyboardType = UIKeyboardTypeNumberPad;
                phone.text = phoneStr;
                phone.font = [UIFont systemFontOfSize:15];
                phone.clearButtonMode = UITextFieldViewModeWhileEditing;
                phone.delegate = self;
                phone.inputAccessoryView = [ZYTextInputBar shareInstance];
                
            }else if(indexPath.section == 3){
                price = [self addTextField:cell.contentView frame:CGRectMake(60, 0, viewwidth-120, 60) AndDidBeginAction:nil phold:@"您的理想成交价，面议为“0”" tag:1000+indexPath.section];
                price.text = priceStr;
                price.keyboardType = UIKeyboardTypeDecimalPad;
                price.delegate = self;
                price.clearButtonMode = UITextFieldViewModeWhileEditing;
                price.inputAccessoryView = [ZYTextInputBar shareInstance];
                price.font = [UIFont systemFontOfSize:15];
                houseunit = [[UILabel alloc] initWithFrame:CGRectMake(price.frame.size.width + price.frame.origin.x -10, 0, 60, 60)];
                
                houseunit.text = @"元/月";
                [cell.contentView addSubview:houseunit];
                
            }else{//选择城市
                cityTextField = [self addTextField:cell.contentView frame:CGRectMake(60, 0,viewwidth-120, 60) AndDidBeginAction:nil phold:@"请选择房源所在城市" tag:1000+indexPath.section];
                cityTextField.font = [UIFont systemFontOfSize:15];
                cityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, viewwidth, 180)];
                if (cityIndex > 0) {
                    cityTextField.text = cityArray[cityIndex - 100];
                }
                cityBar =[[UIToolbar alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width, 44)];
                UIBarButtonItem *quxiao = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(quxiaoChose)];
                UIBarButtonItem *btnDidSelectleixing = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(makeSureChoose)];
                
                UIBarButtonItem *flexibleSpaceleixing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                [cityBar setItems:[NSArray arrayWithObjects:quxiao,flexibleSpaceleixing,btnDidSelectleixing, nil]];
                cityPicker.showsSelectionIndicator =YES;
                cityPicker.delegate =self;
                cityPicker.dataSource =self;
                cityTextField.inputAccessoryView = cityBar;
                cityTextField.inputView = cityPicker;
                cityTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            }
        }else if (indexPath.section == 4){
            
            //其次在UITextView上面覆盖个UILable,UILable设置为全局变量。
            phalclable = [UILabel new];
            phalclable.frame =CGRectMake(8, -4,viewwidth - 28, 40);
            phalclable.numberOfLines = 0;
            phalclable.font = [UIFont systemFontOfSize:15];
            
            phalclable.text = @"补充下房源亮点吧!";
            
            phalclable.enabled = NO;//lable必须设置为不可用
            phalclable.backgroundColor = [UIColor clearColor];
            
            //首先定义UITextView
            mytextView = [[UITextView alloc] init];
            mytextView.frame =CGRectMake(10, 0, cell.contentView.bounds.size.width -20, cell.contentView.bounds.size.height-30);
            mytextView.font = [UIFont systemFontOfSize:15];
            mytextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            mytextView.backgroundColor = [UIColor whiteColor];
            [mytextView addSubview:phalclable];
            mytextView.delegate = self;
            mytextView.text = textViewStr;
            ZYTextInputBar * bar = [ZYTextInputBar shareInstance];
            mytextView.inputAccessoryView = bar;
            
            bar.inputBarBlock = ^{
                [self hidKeyBoard];
            };
            
            [cell.contentView addSubview:mytextView];
            
            wordNumLable = [[UILabel alloc] initWithFrame:CGRectMake(viewwidth - 80, 90, 60, 25)];
            wordNumLable.backgroundColor = [UIColor whiteColor];
            [wordNumLable bringSubviewToFront:self.view];
            [cell.contentView addSubview:wordNumLable];
            wordNumLable.textAlignment = NSTextAlignmentRight;
            wordNumLable.font = [UIFont systemFontOfSize:13];
            wordNumLable.text = @"500/500";
            
        }else{//添加图片
            [cell addSubview:CollectionView];
        }
        
    }else{//跳蚤市场的
        if (indexPath.section < 3) {
            UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 60)];
            nameLabel.text = [nameArray objectAtIndex:indexPath.section];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:nameLabel];
            
            if (indexPath.section == 0) {
                title = [self addTextField:cell.contentView frame:CGRectMake(60, 0, viewwidth-70, 60) AndDidBeginAction:nil phold:@"一句话描述下宝贝吧" tag:1000+indexPath.section];
                title.text = titleStr;
                title.font = [UIFont systemFontOfSize:15];
                title.clearButtonMode = UITextFieldViewModeWhileEditing;
                title.delegate = self;
                title.inputAccessoryView = [ZYTextInputBar shareInstance];
            }else if (indexPath.section == 1){
                phone = [self addTextField:cell.contentView frame:CGRectMake(60, 0, viewwidth-70, 60) AndDidBeginAction:nil phold:@"请输入手机号" tag:1000+indexPath.section];
                phone.keyboardType = UIKeyboardTypeNumberPad;
                phone.text = phoneStr;
                phone.font = [UIFont systemFontOfSize:15];
                phone.clearButtonMode = UITextFieldViewModeWhileEditing;
                phone.inputAccessoryView = [ZYTextInputBar shareInstance];
                phone.delegate = self;
            }else{
                price = [self addTextField:cell.contentView frame:CGRectMake(60, 0, viewwidth-90, 60) AndDidBeginAction:nil phold:@"您的理想成交价" tag:1000+indexPath.section];
                price.text = priceStr;
                price.keyboardType = UIKeyboardTypeDecimalPad;
                price.delegate = self;
                price.font = [UIFont systemFontOfSize:15];
                price.clearButtonMode = UITextFieldViewModeWhileEditing;
                price.inputAccessoryView = [ZYTextInputBar shareInstance];
                
                UILabel * unit = [[UILabel alloc] initWithFrame:CGRectMake(price.frame.size.width + price.frame.origin.x -10, 0, 30, 60)];
                unit.text = @"元";
                unit.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:unit];
            }
        }else if (indexPath.section == 3){
            
            //其次在UITextView上面覆盖个UILable,UILable设置为全局变量。
            phalclable = [UILabel new];
            phalclable.frame =CGRectMake(8, -4,cell.contentView.bounds.size.width - 28, 40);
            phalclable.textColor = [UIColor redColor];
            phalclable.numberOfLines = 0;
            phalclable.font = [UIFont systemFontOfSize:15];
            
            phalclable.text = @"补充下宝贝亮点吧!";
            
            phalclable.enabled = NO;//lable必须设置为不可用
            phalclable.backgroundColor = [UIColor clearColor];
            
            //首先定义UITextView
            mytextView = [[UITextView alloc] init];
            mytextView.frame =CGRectMake(10, 0, cell.contentView.bounds.size.width - 20, cell.contentView.bounds.size.height-30);
            mytextView.font = [UIFont systemFontOfSize:15];
            mytextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            mytextView.backgroundColor = [UIColor whiteColor];
            [mytextView addSubview:phalclable];
            mytextView.hidden = NO;
            mytextView.delegate = self;
            mytextView.text = textViewStr;
            
            
            ZYTextInputBar * bar = [ZYTextInputBar shareInstance];
            mytextView.inputAccessoryView = bar;
            
            bar.inputBarBlock = ^{
                [self hidKeyBoard];
            };
            
            [cell.contentView addSubview:mytextView];
            wordNumLable = [[UILabel alloc] initWithFrame:CGRectMake(viewwidth - 80, 90, 60, 25)];
            wordNumLable.backgroundColor = [UIColor whiteColor];
            [wordNumLable bringSubviewToFront:self.view];
            [cell.contentView addSubview:wordNumLable];
            wordNumLable.textAlignment = NSTextAlignmentRight;
            wordNumLable.font = [UIFont systemFontOfSize:13];
            wordNumLable.text = @"500/500";
            
        }else{//添加图片
            [cell addSubview:CollectionView];
        }
    }
}

//pickerView选择确定
- (void)makeSureChoose{
    [self hidKeyBoard];
    NSInteger row =[cityPicker selectedRowInComponent:0];
    cityIndex = row + 100;
    cityTextField.text = [cityArray objectAtIndex:row];
}

//pickerView选择取消
- (void)quxiaoChose{
    [self hidKeyBoard];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"完成编辑");
    
    if ([textField isEqual:title]) {
        titleStr = title.text;
    }
    if ([textField isEqual:phone]) {
        phoneStr = phone.text;
    }
    if ([textField isEqual:price]) {
        priceStr = price.text;
    }

}


#pragma UITextField  输入的回调
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (![AppUtils isNotLanguageEmoji]) {
        return NO;
    }
    
    if ([textField isEqual:phone]) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11){
            [phone resignFirstResponder];
            return NO;
        }
    }
    
    if ([textField isEqual:title]) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 20){
            [title resignFirstResponder];
            return NO;
        }
    }
    
    if ([textField isEqual:price]) {
 
        //排除满格的时候不能删除
        if ([string isEqualToString:@""]) {
            return YES;
        }
       return [AppUtils textFieldLimitDecimalPointWithDigits:2 WithText:price.text shouldChangeCharactersInRange:range replacementString:string] && textField.text.length < 9;
    }
    return YES;
}


#pragma UITextView的输入回调
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    textViewStr = textView.text;
    
    if (![AppUtils isNotLanguageEmoji]) {
        return NO;
    }
    
    NSInteger strLength = textView.text.length - range.length + text.length;
    if (strLength > 500){
        if ([text isEqualToString:@""]) {
            return YES;
        }else{
            [mytextView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        if (isHouse) {
            phalclable.text = @"补充下房源亮点吧!";
        }else{
            phalclable.text = @"补充下宝贝亮点吧!";
        }
    }else{
        phalclable.text = @"";
        wordNumLable.text = [NSString stringWithFormat:@"%lu/500",500 - mytextView.text.length];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


//房屋出租圈选内容
- (IBAction)buttonClick:(UIButton *)sender {
    
    if (sender.tag == 100) {//出租
        outRent.selected = YES;
        seleBtn.selected = NO;
        needRentbtn.selected = NO;
        houseunit.text = @"元/月";
        selectedIndex = 0;
        title.placeholder = @"一句换描述下房源吧";
        price.placeholder = @"您的理想成交价,面议为0";
        phalclable.text = @"补充下房源的亮点吧!";
        mytextView.text = @"";

    }else if (sender.tag == 101){//求租
        outRent.selected = NO;
        seleBtn.selected = NO;
        needRentbtn.selected = YES;
        houseunit.text = @"元/月";
        selectedIndex = 2;
        
        title.placeholder = @"一句换描述下房屋要求";
        price.placeholder = @"您能接受的成交价,面议为0";
        phalclable.text = @"补充下您对房屋的各种需求吧!";
        mytextView.text = @"";

    }else{//出售
        outRent.selected = NO;
        seleBtn.selected = YES;
        needRentbtn.selected = NO;
        houseunit.text = @"万/套";
        selectedIndex = 1;
        
        title.placeholder = @"一句换描述下房源吧";
        price.placeholder = @"您的理想成交价,面议为0";
        phalclable.text = @"补充下房源的亮点吧!";
        mytextView.text = @"";
    }
}

//跳蚤市场圈选内容
- (IBAction)tiaozao:(UIButton *)sender {
    
    if (sender.tag == 10) {
        tiaozaochushou.selected = YES;
        tiaozaoqiugou.selected = NO;
        selectedIndex = 0;

        mytextView.text = @"";
        phalclable.text = @"补充下宝贝亮点吧!";

    }else{
        tiaozaochushou.selected = NO;
        tiaozaoqiugou.selected = YES;
        selectedIndex = 1;
        mytextView.text = @"";
        phalclable.text = @"补充下宝贝亮点吧!";
    }
}


- (UITextField *)addTextField:(UIView *)view frame:(CGRect)frame AndDidBeginAction:(SEL)beginAction phold:(NSString *)phold tag:(long)tag{
    
    UITextField * field = [[UITextField alloc] initWithFrame:frame];
    field.placeholder = phold;
    field.tag = tag;
    field.textAlignment = NSTextAlignmentLeft;
    [view addSubview:field];
    
    if (beginAction != nil)
    {
        [field addTarget:self action:beginAction forControlEvents:UIControlEventEditingDidBegin];
    }
    
    return field;
}

//编辑textView，滚动视图
- (void)textViewDidBeginEditing:(UITextView *)textView{

    [self viewMoving:myTableView frame:CGRectMake(0, -100, viewwidth, viewheight - 64) setAnimationDuration:0.3];
    
}



//视图滚动
-(void)viewMoving:(UIView *)View frame:(CGRect)frame setAnimationDuration:(double)moveTime
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:moveTime];//动画时间长度，单位秒，浮点数
    View.frame = frame;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)refreshCollectionViewForCell:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    uploadCollectionCell *uploadCell = (uploadCollectionCell *)cell;
    [uploadCell.imageBtn setImage:[postImgArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    //    [cell.imageBtn setBackgroundImage:[postImgArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    uploadCell.imageBtn.tag = indexPath.row + 1;
    uploadCell.didimgbtnDeletget = self;
}

#pragma mark - UICollectionView 代理方法
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return postImgArr.count;
}

//设置元素的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top ={5 ,10,5 ,5};
    return top;
}

//每个分区上的元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    uploadCollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:SYSTEM_CELL_Col_ID forIndexPath:indexPath];
    if ([AppUtils systemVersion] < 8) {
        [self refreshCollectionViewForCell:cell forIndexPath:indexPath];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppUtils systemVersion] >= 8) {
        [self refreshCollectionViewForCell:cell forIndexPath:indexPath];
    }
}

- (void)didimgBtn:(NSInteger)tag{
    
    int MaxImage = 10;
    
    [UIView animateWithDuration:0.1 animations:^{
        [self hidKeyBoard];

    } completion:^(BOOL finished) {
        if (tag==postImgArr.count)
        {
            
            if (postImgArr.count >= 10) {
                [AppUtils showAlertMessage:@"最多上传9张图片"];
                return;
            }else{
                [GetImgFromSystem getImgInstance].maxCount = MaxImage - postImgArr.count;
                [[GetImgFromSystem getImgInstance]getImgFromVC:self];
            }
        }
        else
        {
            NSMutableArray *imgArr = [postImgArr mutableCopy];
            [imgArr removeLastObject];
            
            ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
            pickerBrowser.dataSource = self;
            pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:tag - 1 inSection:0];
            // 展示控制器
            [pickerBrowser showPickerVc:self];
        }

    }];
}

//2、图片放大控件更换，需要设置代理；
#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return postImgArr.count - 1;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj = [postImgArr objectAtIndex:indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    uploadCollectionCell * cell = (uploadCollectionCell *)[CollectionView cellForItemAtIndexPath:indexPath];
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    
    photo.toView = cell.imageBtn.imageView;
    return photo;
}


//设置单元格大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70 - 10,70 - 10);
}


#pragma mark - GetImgFromSystemDelegate
- (void)getFromImg:(NSArray *)imgArr{
    
    [imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [postImgArr insertObject:obj atIndex:0];
    }];
    [CollectionView reloadData];
    
    NSUInteger imgNum = (CollectionView.frame.size.width - 10) / 70;
    NSUInteger rows = (postImgArr.count % imgNum > 0 ? (postImgArr.count / imgNum + 1) : (postImgArr.count / imgNum));


    CollectionView.frame=CGRectMake(0, 0,CollectionView.frame.size.width, 70 * rows);
    
    int sectionNum;
    
    if (isHouse) {
        sectionNum = 3;
    }else{
        sectionNum = 2;
    }
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:sectionNum];
    NSArray *indexArray =[NSArray arrayWithObject:indexPath];
    [myTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma UIPickerView 代理
//相当于多少段
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//每段里面的列表数量
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1;
}

//每一个列表里面显示的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return cityArray[row];
}


//把传过来的tableID传过去
- (void)senToBefore{
    
    if (_freshdele && [_freshdele respondsToSelector:@selector(freshWitchTable:)]) {
        [_freshdele freshWitchTable:selectedIndex];
    }

}

//提示框
- (void)alertMessage:(NSString *)message{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}

//验证手机号的合法性
- (BOOL)checkTel:(NSString *)str
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

@end
