//
//  PostedViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "PostedViewController.h"
#import "NSData+wrapper.h"
#import "uploadCollectionCell.h"
#import "SVProgressHUD.h"
#import "UserManager.h"
#import "MultiShowing.h"
#import "UIImage+wrapper.h"
#import "ZLPhotoPickerBrowserViewController.h"

//话题分类接口类
#import "NeighbourHoodHandler.h"
#import "ClassHuaTiModel.h"
//提交话题接口类
#import "NewHuaTiModel.h"
//上传图片接口类
#import "ComplaintHandler.h"
#import "FilePostE.h"

@interface PostedViewController ()<UITextFieldDelegate,ZLPhotoPickerBrowserViewControllerDataSource>

@property(nonatomic,strong)UITextField *titleF;
@property(nonatomic,strong)UITextView *commtextView;
@property(nonatomic,strong)UILabel  *placeholderLab;

@end

@implementation PostedViewController
{
   
   
    UILabel     *labe;
   
    NSArray     *HuatiTypeArray;
    NSMutableArray *HuatiTypeMuArray;
    NSArray     *huatiTypeNameArray;
    NSInteger   didSelect;
    //图片上传后返回的图片ID
    NSMutableString *imgIDStr;
    NSMutableArray *postImgArr;
    NSMutableArray *imageArray;
    
    MultiShowing  *multshowimg;
    CGFloat interval;
    NSUInteger singleRowNum;
    CGFloat itemWidth;
    
    NSString *commmentStr;
    NSString *titleStr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hidetabbar];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title=@"我要发帖";
    self.view.backgroundColor=[AppUtils colorWithHexString:@"EEEEEA"];
    [self initData];
    [self initUI];
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getHuaTiClass) userInfo:nil repeats:NO];
}

-(void)initData{
    HuatiTypeMuArray = [[NSMutableArray alloc]init];
    huatiTypeNameArray =[[NSArray alloc]init];
    interval = 10;
    singleRowNum = 4;
    itemWidth = (self.view.frame.size.width - interval * (singleRowNum + 1)) / singleRowNum;
    
    imgIDStr =[[NSMutableString alloc]init];
    postImgArr=[[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"postImg"], nil];
    multshowimg =[[MultiShowing alloc]init];
    didSelect=-1;
    [self titleF];
    [self commtextView];
    [self placeholderLab];
}

-(void)initUI
{
    
    UIView *foolterView =[[UIView alloc]init];
    foolterView.frame=CGRectMake(0, 0, self.view.frame.size.width, 100);
    foolterView.backgroundColor=[AppUtils colorWithHexString:@"EEEEEA"];
    
    UIButton *submitBut =[UIButton buttonWithType:UIButtonTypeCustom];
    submitBut.frame=CGRectMake(15, 40, IPHONE_WIDTH-30, 40);
    [submitBut setTitle:@"发布" forState:UIControlStateNormal];
    submitBut.layer.masksToBounds=YES;
    submitBut.layer.cornerRadius=5;
    submitBut.titleLabel.font=[UIFont systemFontOfSize:G_BTN_FONT];
    [submitBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBut setBackgroundColor:[AppUtils colorWithHexString:G_BTN_BGCOLOR]];
    [submitBut addTarget:self action:@selector(submitButArr) forControlEvents:UIControlEventTouchUpInside];
    [foolterView addSubview:submitBut];

    _TableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _TableView.dataSource =self;
    _TableView.delegate =self;
    _TableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _TableView.tableFooterView=foolterView;
    _TableView.backgroundColor=[AppUtils colorWithHexString:@"EEEEEA"];
    [self.view addSubview:_TableView];
    
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,interval*2     +itemWidth) collectionViewLayout:flowLayout];
    [_CollectionView registerClass:[uploadCollectionCell class] forCellWithReuseIdentifier:SYSTEM_CELL_Col_ID];
    
    _CollectionView.scrollEnabled = YES;
    _CollectionView.userInteractionEnabled = YES;
    _CollectionView.dataSource = self;
    _CollectionView.delegate = self;
    _CollectionView.backgroundColor =[UIColor whiteColor];
    [GetImgFromSystem getImgInstance].delegate = self;
    
    UITapGestureRecognizer *endEditingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingForSelf)];
    [self.TableView addGestureRecognizer:endEditingTap];
}

- (void)endEditingForSelf {
    [self.view endEditing:YES];
}

- (void)backLastVC {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitButArr
{
    
    if (didSelect==-1){
        [AppUtils showAlertMessageTimerClose:@"亲,你还没有选择话题类型!"];
        return;
    }
    UITextField *titleFine =(UITextField *)[self.view viewWithTag:400];
    NSString * titleTempStr = [titleFine.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    titleStr =[titleTempStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    if(titleStr.length < 3){
        [AppUtils showAlertMessageTimerClose:@"亲,话题标题不能少于3个字!"];
        return;
    }
    
    NSString * tempStr = [_commtextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    commmentStr =[tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if([NSString isEmptyOrNull:_commtextView.text] && tempStr.length<=0){
        [AppUtils showAlertMessageTimerClose:@"亲,话题内容不能为空!"];
        return;
    }
    
    if (postImgArr.count == 1) {
        //[self postedRequest];
        [AppUtils showAlertMessageTimerClose:@"最少需要上传一张图片"];
        return;
    }
    
    [AppUtils showProgressMessage:@"上传图片中"];
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(submmitPostImg) userInfo:nil repeats:NO];
}

- (void)submmitPostImg {
    
//    if (postImgArr.count==1){
//        //[self postedRequest];
//        [AppUtils showAlertMessageTimerClose:@"最少需要上传一张图片"];
//        return;
//    }
//
    dispatch_queue_t concurrentQueue = dispatch_queue_create("mySerailQueue", DISPATCH_QUEUE_CONCURRENT);
    __block NSUInteger finishCount = 0;
    
    imgIDStr = [NSMutableString new];
    [postImgArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != postImgArr.count - 1) {
            UIImage *img = obj;
            ComplaintHandler *complainH = [ComplaintHandler new];
            FilePostE *imgPost = [FilePostE new];
            imgPost.dataD = [NSString encodeBase64Data:[NSData dataTransformUnder1MFromImg:img]];
             imgPost.entityType=@"ACTIVITY";
            imgPost.fileName = [NSString stringWithFormat:@"话题图片%lu.png",(unsigned long)postImgArr.count];
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

-(void)postedRequest
{
    [AppUtils showProgressMessage:@"提交中"];
    ClassHuaTiModel *huatiTypeM =[HuatiTypeArray objectAtIndex:didSelect];//获取话题分类里面的话题ID
    
    NewHuaTiModel *huatiM =[NewHuaTiModel new];
    NeighbourHoodHandler *huatiH =[NeighbourHoodHandler new];
    huatiM.memberid         =[UserManager shareManager].userModel.memberId;
    huatiM.wyNo             =[UserManager shareManager].comModel.wyId;
    huatiM.xqNo             =[UserManager shareManager].comModel.xqNo;
    huatiM.activityType     =huatiTypeM.ID;
    huatiM.status            =@"3";
    
    huatiM.title            =titleStr;
    huatiM.type             =@"1";
    huatiM.activityContent      =commmentStr;
    huatiM.fileId               =imgIDStr;
    huatiM.complaintType        =huatiTypeM.code;
    
    
    [huatiH NewHuaTi:huatiM success:^(id obj) {
        NSDictionary *dic =(NSDictionary *)obj;
        if ([dic[@"code"] isEqualToString:@"success"]){
            [AppUtils showSuccessMessage:W_ALL_PUBLISHED_SUC];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(backLastVC) userInfo:nil repeats:NO];
            if (self.postSucBlock) {
                self.postSucBlock();
            }
        }else{
            [AppUtils showAlertMessageTimerClose:dic[@"message"]];
        }
        
    } failed:^(id obj) {
        if (self.viewIsVisible){
            [AppUtils showAlertMessageTimerClose:obj];
        }else{
            [AppUtils dismissHUD];
        }
        
    }];
    
}

-(void)getHuaTiClass
{
    NeighbourHoodHandler *neighbourHand =[[NeighbourHoodHandler alloc]init];
    ClassHuaTiModel *huatiModel =[[ClassHuaTiModel alloc]init];
    huatiModel.wyId=[UserManager shareManager].comModel.wyId;
    [neighbourHand getTopicClass:huatiModel success:^(id obj) {
        
        HuatiTypeArray = (NSArray *)obj;
        if ([NSArray isArrEmptyOrNull:HuatiTypeArray]) {
            [AppUtils showAlertMessageTimerClose:@"话题类型为空"];
        }
    } failed:^(id obj) {
        if (self.viewIsVisible) {
           [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        }
        else {
            [AppUtils dismissHUD];
        }
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:_commtextView];
    
    
}

- (void)textFiledEditChanged1:(NSNotification*)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSUInteger kMaxLength = 20;
    [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                               inTextField:textField];
}
- (void)textViewEditChanged1:(NSNotification*)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSUInteger kMaxLength = 500;
    [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                               inTextField:textField];
}


-(void)dismissKeyBoard
{
    [_commtextView resignFirstResponder];
}


-(void)DownbutArr:(UIButton *)button
{
    for (int i = 0 ; i< HuatiTypeArray.count; i++){
        ClassHuaTiModel *huatiM =[HuatiTypeArray objectAtIndex:i];
        [HuatiTypeMuArray addObject:huatiM.typeName];
    }
    huatiTypeNameArray=[HuatiTypeMuArray copy];
    
    [[NIDropDown dropDownInstance] showDropDownWithRect:CGRectMake(IPHONE_WIDTH/2, 130, IPHONE_WIDTH/2, [huatiTypeNameArray count]*40) withButton:button withArr:huatiTypeNameArray withAccessoryType:UITableViewCellAccessoryNone withTextAligment:NSTextAlignmentCenter isSelHide:YES];
    [NIDropDown dropDownInstance].delegate = self;
    [HuatiTypeMuArray removeAllObjects];
}

-(void)xieyieArr:(UIButton *)but {
    but.selected = !but.selected;
}


#pragma mark - Set/Get
-(UITextField *)titleF
{
    if (_titleF==nil)
    {
        _titleF =[[UITextField alloc]initWithFrame:CGRectMake(15, 5, IPHONE_WIDTH-30, 30)];
        _titleF.placeholder = @"标题（一句话阐述您的观点）";
        _titleF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _titleF.keyboardType = UIKeyboardTypeDefault;
        _titleF.tag=400;
        _titleF.delegate=self;

    }
    return _titleF;
}

-(UITextView *)commtextView
{
    if (_commtextView == nil)
    {
        _commtextView =[[UITextView alloc]init];
        _commtextView.frame=CGRectMake(10,5, self.view.frame.size.width-20, 90);
        //commtextView.backgroundColor=[UIColor redColor];
        _commtextView.delegate=self;
        _commtextView.tag=300;
        _commtextView.font=[UIFont systemFontOfSize:16];
    }
    return _commtextView;
}

-(UILabel *)placeholderLab
{
    if (_placeholderLab == nil)
    {
        _placeholderLab =[[UILabel alloc]init];
        _placeholderLab.frame=CGRectMake(7, 0, 300, 30);
        _placeholderLab.text=@"这一刻的想法...";
        _placeholderLab.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _placeholderLab.font=[UIFont systemFontOfSize:16];

    }
    return _placeholderLab;
}



#pragma mark -  UITableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 40;
    }
    if (indexPath.section==1) {
        return 40;
    }
    if (indexPath.section==2) {
        return 100;
    }
    if (indexPath.section==3) {
        NSUInteger rows = (postImgArr.count % singleRowNum > 0 ? (postImgArr.count / singleRowNum + 1) : postImgArr.count / singleRowNum);
        return rows * (interval + itemWidth) + interval;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if(cell == nil){
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //[cell.contentView removeFromSuperview];
    
    if (indexPath.section==0){
        if (indexPath.row==0){
            if(didSelect==-1)
            {
                cell.textLabel.text=@"话题类型";
            }
            else
            {
                cell.textLabel.text=[huatiTypeNameArray objectAtIndex:didSelect];
            }

            UIImageView *img =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downListLight.png"]];
            
            UIButton *DownBut = [UIButton buttonWithType:UIButtonTypeCustom];
            DownBut.frame=CGRectMake(0, 0, IPHONE_WIDTH, 40);
            DownBut.backgroundColor=[UIColor clearColor];
            DownBut.tag =indexPath.row;
            img.frame=CGRectMake(DownBut.frame.size.width-22, 14, 12, 10);
            [DownBut addSubview:img];
            [DownBut addTarget:self action:@selector(DownbutArr:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:DownBut];
            
        }
    }
    else if (indexPath.section==1){
        if (indexPath.row==0){
            [cell.contentView addSubview:_titleF];
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(textFiledEditChanged1:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:_titleF];
        }
        
        
    }
    else if (indexPath.section==2){
        
       
        
        
        
        [_commtextView addSubview:_placeholderLab];
        [cell addSubview:_commtextView];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(textViewEditChanged1:)
                                                    name:@"UITextViewTextDidChangeNotification"
                                                  object:_commtextView];
        UIToolbar *topView =[[UIToolbar alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 30)];
        [topView setBarStyle:UIBarStyleDefault];
        
        UIBarButtonItem *btnSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        NSArray *buttonArray =[NSArray arrayWithObjects:btnSpace,doneButton, nil];
        [topView setItems:buttonArray];
        [_commtextView setInputAccessoryView:topView];
    }
    
    if (indexPath.section==3){
        if (indexPath.row==0){
            [cell addSubview:_CollectionView];
        }
    }
    return cell;
}

#pragma mark - NIDropDownDelegate
//下拉列表回调方法
- (void) niDropDownDelegateMethod: (NSInteger) index forBtn:(UIButton *)button{
    NSLog(@"index==%d",index);
    didSelect=index;
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
     UITableViewCell *cell =[self.TableView cellForRowAtIndexPath:indexPath];

    dispatch_async(dispatch_get_main_queue(), ^{
        cell.textLabel.text=[huatiTypeNameArray objectAtIndex:index];
    });
}

#pragma mark -  UITextView 代理方法
- (void)textViewDidChange:(UITextView *)textView;
{
    if(textView.tag==300){
        if (textView.text.length >0){
            _placeholderLab.hidden=YES;
        }else{
            _placeholderLab.hidden=NO;
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (![AppUtils isNotLanguageEmoji]) {
        return NO;
    }
    
    if ([textView isEqual:_commtextView]) {
        NSInteger strLength = textView.text.length - range.length + text.length;
        if (strLength > 500){
            return NO;
        }
    }

    return YES;
    
}

#pragma mark -  UITextField 代理方法
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.text.length < 3){
        [AppUtils showAlertMessageTimerClose:@"亲爱的，标题不能少于3个字啊！"];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(string.length==0){
        return YES;
    }
    int titleLength =20;//标题的长度
    if (![AppUtils isNotLanguageEmoji]) {
        return NO;
    }
    
    return range.location<titleLength;
}

#pragma mark - UICollectionViewDelegate 代理方法

//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return postImgArr.count;
}


//设置元素的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets top ={interval ,interval, 0, interval};
    return top;
}

//设置单元格大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(itemWidth,itemWidth);
}

//每个分区上的元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    uploadCollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:SYSTEM_CELL_Col_ID forIndexPath:indexPath];
    cell.imageBtn.tag=indexPath.row+1;

    [cell.imageBtn setBackgroundImage:postImgArr[indexPath.row] forState:UIControlStateNormal];
    cell.imageBtn.contentMode = UIViewContentModeCenter;
    cell.didimgbtnDeletget=self;
    return cell;
}

-(void)didimgBtn:(NSInteger)tag
{
    [self.view endEditing:YES];
    if (tag==postImgArr.count){
        if (postImgArr.count >= 10){
            [AppUtils showAlertMessage:@"最多上传9张图片"];
            return;
        }else{
            //[[GetImgFromSystem getImgInstance]getImgFromVC:self];
            [GetImgFromSystem getImgInstance].maxCount = 10-postImgArr.count;
            [[GetImgFromSystem getImgInstance] getImgFromVC:self];
        }
    }else{
        NSMutableArray *imgArr = [postImgArr mutableCopy];
        [imgArr removeLastObject];
        //显示放大图片
        ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
        pickerBrowser.dataSource = self;
        pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:tag - 1 inSection:0];
        // 展示控制器
        [pickerBrowser showPickerVc:self];
        
    }

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
    uploadCollectionCell * cell = (uploadCollectionCell *)[_CollectionView cellForItemAtIndexPath:indexPath];
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    photo.toView = cell.imageBtn.imageView;
    return photo;
}



#pragma mark - GetImgFromSystemDelegate
- (void)getFromImg:(NSArray *)imgArr
{
    
    [imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [postImgArr insertObject:obj atIndex:0];
    }];
    
    [_CollectionView reloadData];
    NSUInteger rows = (postImgArr.count % singleRowNum > 0 ? (postImgArr.count / singleRowNum + 1) : postImgArr.count / singleRowNum);
    
    _CollectionView.frame=CGRectMake(0, 0,_CollectionView.frame.size.width,(itemWidth + interval) * rows + interval);
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:3];
    NSArray *indexArray =[NSArray arrayWithObject:indexPath];
    [_TableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
