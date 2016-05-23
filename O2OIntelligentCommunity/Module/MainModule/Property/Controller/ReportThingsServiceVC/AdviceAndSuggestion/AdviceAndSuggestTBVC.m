//
//  AdviceAndSuggestTBVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/9/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//
#define POST_IMG_NAME @"postImg"
#define EACH_ROW_COUNT 3
#define POST_IMG_COUNT 9

#import "AdviceAndSuggestTBVC.h"
#import "GetImgFromSystem.h"
#import "UITextField+wrapper.h"  
#import "MultiShowing.h"
#import "ShengShiJiaH.h"
#import "UserManager.h"
#import "UITextField+wrapper.h"
#import "ComplaintHandler.h"
#import "NSData+wrapper.h"
#import "UIImage+wrapper.h"
#import "ZLPhotoPickerBrowserViewController.h"
#import "NSString+wrapper.h"
#import "ZJFormView.h"  
#import "ZYTextInputBar.h"

@interface AdviceAndSuggestTBVC () <UITableViewDataSource,
                                    UITableViewDelegate,
                                    ZLPhotoPickerBrowserViewControllerDataSource,
                                    UITextViewDelegate>

@end

@implementation AdviceAndSuggestTBVC
{
    MultiShowing *multiSow;
    NSMutableString *imgIDStr;
    NSMutableArray *postImgArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    postImgArr = [NSMutableArray arrayWithObject:[UIImage imageNamed:POST_IMG_NAME]];
    multiSow = [MultiShowing new];
    imgIDStr = [NSMutableString string];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    [GetImgFromSystem getImgInstance].delegate = self;
    self.title = @"意见与建议";
    UIButton *rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemBtn.layer.cornerRadius = 5;
    CGFloat itemWidth = 30;
    rightItemBtn.frame = CGRectMake(0, 0, itemWidth*2, itemWidth);
    [rightItemBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightItemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightItemBtn.backgroundColor = [AppUtils colorWithHexString:@"fb6e22"];
    [rightItemBtn addTarget:self action:@selector(submmitClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    self.tableView.tableFooterView = [AppUtils tableViewsFooterView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)timerAfterSubmmit {
    if (postImgArr.count == 1) {
        [self submmitAllPost];
        return;
    }
    
    if (postImgArr.count > POST_IMG_COUNT + 1) {
        [AppUtils showAlertMessage:[NSString stringWithFormat:@"最多只能上传%d张图片",POST_IMG_COUNT]];
        return;
    }
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("mySerailQueue", DISPATCH_QUEUE_CONCURRENT);
    __block NSUInteger finishCount = 0;
    
    imgIDStr = [NSMutableString new];
    [postImgArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != postImgArr.count - 1) {
            UIImage *img = obj;
            
            ComplaintHandler *complainH = [ComplaintHandler new];
            FilePostE *imgPost = [FilePostE new];
            
            imgPost.dataD = [NSString encodeBase64Data:[NSData dataTransformUnder1MFromImg:img]];
            imgPost.entityType = @"UNIVERSAL";
            imgPost.fileName = [NSString stringWithFormat:@"意见和建议图片%lu.png",(unsigned long)postImgArr.count];
            
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
                        [self submmitAllPost];
                    }
                } failed:^(id obj) {
                    finishCount ++;
                    if (finishCount == postImgArr.count - 1) {
                        [self submmitAllPost];
                    }
                }];
            });
        }
    }];
}

- (void)submmitClick {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextView class]]) {
            UITextView *textV = obj;
            if ([textV.text trim].length <= 0) {
                [AppUtils showAlertMessage:@"请输入内容"];
                return;
            }
            
            [AppUtils showProgressMessage:@"上传中"];
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerAfterSubmmit) userInfo:nil repeats:NO];
            *stop = YES;
        }
    }];
}

- (void)submmitAllPost {
    [AppUtils showProgressMessage:@"提交中"];
    ShengSJNewBuiltE *newBultE = [ShengSJNewBuiltE new];
    newBultE.memberid         = [UserManager shareManager].userModel.memberId;
    newBultE.wyNo             = [UserManager shareManager].comModel.wyId;
    newBultE.xqNo             = [UserManager shareManager].comModel.xqNo;
    newBultE.title            = @"意见和建议";
    newBultE.type             = @"7";
    newBultE.activityType     = @"2";
    newBultE.cityId           = [UserManager shareManager].comModel.cityid;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextView class]]) {
            UITextView *textV = obj;
            newBultE.activityContent  = textV.text;
            *stop = YES;
        }
    }];
    
    if (imgIDStr.length > 0) {
        newBultE.fileId       = [imgIDStr copy];
    }
    
    ShengShiJiaH *shengSJH = [ShengShiJiaH new];
    [shengSJH requestForSubmmitShengShiJiaData:newBultE success:^(id obj) {
        [AppUtils showSuccessMessage:@"再次感谢您的建议"];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(backLastVC) userInfo:nil repeats:NO];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
    }];
}

- (void)backLastVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endTouch {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 50;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGFloat headerHeight = [tableView rectForHeaderInSection:section].size.height;
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, headerHeight)];
        UILabel *headerL = [[UILabel alloc] initWithFrame:CGRectMake(G_INTERVAL, 0, tableView.frame.size.width - G_INTERVAL*2, headerHeight)];
        headerL.text = @"内容";
        [headerV addSubview:headerL];
        return headerV;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 140;
        case 1:
            return [ZJFormView cellHeightForImgCount:postImgArr.count
                                     forItemInterval:G_INTERVAL
                                     forEachRowCount:EACH_ROW_COUNT
                                           formWidth:tableView.frame.size.width];
        default:
            break;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
        if (indexPath.section == 0) {
            UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(G_INTERVAL, G_INTERVAL, self.tableView.frame.size.width - G_INTERVAL*2, 140 - G_INTERVAL*2)];
            textV.inputAccessoryView = [ZYTextInputBar shareInstance];
            textV.delegate = self;
            [cell.contentView addSubview:textV];
        }
        else {
            ZJFormView *formV = [[ZJFormView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [ZJFormView cellHeightForImgCount:postImgArr.count
                                                                                                                                 forItemInterval:G_INTERVAL
                                                                                                                                 forEachRowCount:EACH_ROW_COUNT
                                                                                                                                       formWidth:tableView.frame.size.width])];
            
            __block typeof(self)weakSelf = self;
            formV.clickBlock = ^(NSInteger selectedRow){
                [weakSelf.view endEditing:YES];
            };
            
            formV.getImgBlock = ^(NSArray *imgArr) {
                postImgArr = [imgArr mutableCopy];
                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            
            formV.formType = ZJFormTypeLastImgPost;
            formV.eachRowCount = EACH_ROW_COUNT;
            formV.itemInterval = G_INTERVAL;
            [cell.contentView addSubview:formV];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITextView class]]) {
                UITextView *textV = obj;
                [textV setPlaceHolder:@"亲，您有什么意见与建议吗？欢迎您提给我们，谢谢！" fontSize:14];
                *stop = YES;
            }
        }];
    }
    else {
        [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[ZJFormView class]]) {
                ZJFormView *formV = obj;
                formV.showImgArr = postImgArr;
                [formV reloadData];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) {
        return YES;
    }
    
    if (textView.attributedText.length >= 500 || ![AppUtils isNotLanguageEmoji]) {
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length > 0) {
        [textView hidePlaceHolder];
    }
    else {
        [textView showPlaceHolder];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView hidePlaceHolder];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        [textView hidePlaceHolder];
    }
    else {
        [textView showPlaceHolder];
    }
}

@end
