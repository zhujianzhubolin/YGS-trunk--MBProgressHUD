//
//  HousingViewController.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/4/19.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//


typedef NS_ENUM(NSUInteger,PickerViewItemTag) {
    PickerViewItemTagFloor = 100,
    PickerViewItemTagUnit,
    PickerViewItemTagRoom,
    PickerViewItemTagRelation,
};

typedef NS_ENUM(NSUInteger,PickerViewTag) {
    PickerViewTagFloor = 10000,
    PickerViewTagUnit,
    PickerViewTagRoom,
    PickerViewTagRelation,
};

#import "HousingViewController.h"
#import "BindingCell.h"
#import "TestingViewController.h"

#import "QueryFlootUnitModel.h"
#import "QueryFlootUnitHandler.h"

@interface HousingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSArray *flootArray;//楼栋
@property (nonatomic,strong) NSArray *unitArray;//单元
@property (nonatomic,strong) NSArray *roomArray;//房号

@property (nonatomic,strong) UITextField *floorTextF;
@property (nonatomic,strong) UITextField *unitTextF;
@property (nonatomic,strong) UITextField *roomTextF;
@property (nonatomic,strong) UITextField *relationTextF;

@property (nonatomic,strong) UIPickerView *floorPickerV;
@property (nonatomic,strong) UIPickerView *unitPickerV;
@property (nonatomic,strong) UIPickerView *roomPickerV;
@property (nonatomic,strong) UIPickerView *relationPickerV;

@end

@implementation HousingViewController
{
    UITableView *bindingTB;

    NSMutableArray *nameArray;
    NSArray *relationArr;//关系
    
    NSString *roomPhone;
    NSString *rooIdStr;
}


- (void)setFlootArray:(NSArray *)flootArray {
    _flootArray = flootArray;
    UIPickerView *flootPickV =[self pickVFromTextF:self.floorTextF];
    [flootPickV reloadAllComponents];
}

-(void)setUnitArray:(NSArray *)unitArray
{
    _unitArray = unitArray;
    UIPickerView *unitPickV =[self pickVFromTextF:self.unitTextF];
    [unitPickV reloadAllComponents];
}

-(void)setRoomArray:(NSArray *)roomArray
{
    _roomArray = roomArray;
    UIPickerView *roomPickV = [self pickVFromTextF:self.floorTextF];
    [roomPickV reloadAllComponents];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(postQueryflootunit) userInfo:nil repeats:NO];


}

-(void)initData
{
    nameArray = [[NSMutableArray alloc]initWithObjects:@"楼        栋 :",@"单        元 :",@"房        号 :",@"与业主关系：", nil];

    
    relationArr = [NSArray arrayWithObjects:
                   [NSDictionary dictionaryWithObject:@"业主" forKey:@"1"],
                   [NSDictionary dictionaryWithObject:@"租客" forKey:@"2"],
                   [NSDictionary dictionaryWithObject:@"亲朋" forKey:@"3"],
                   nil];

    self.flootArray = [NSArray array];//楼栋
    self.unitArray  = [NSArray array];//单元
    self.roomArray  = [NSArray array];//房号
}

-(void)initUI
{
    self.title=@"业主绑定";
    self.view.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width , 100)];
    footerView.backgroundColor = [AppUtils colorWithHexString:@"eeeeea"];
    UIButton *SubmitBut = [UIButton buttonWithType:UIButtonTypeCustom];
    SubmitBut.frame=CGRectMake(20, 20, IPHONE_WIDTH-40, 40);
    SubmitBut.layer.masksToBounds=YES;
    SubmitBut.layer.cornerRadius=5;
    SubmitBut.titleLabel.font = [UIFont systemFontOfSize:G_BTN_FONT];
    SubmitBut.backgroundColor = [AppUtils colorWithHexString:G_BTN_BGCOLOR];
    [SubmitBut setTitle:@"下一步" forState:UIControlStateNormal];
    [SubmitBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SubmitBut addTarget:self action:@selector(clickBtnForNextAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:SubmitBut];
    
    bindingTB =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    bindingTB.dataSource=self;
    bindingTB.delegate=self;
    bindingTB.showsVerticalScrollIndicator = NO;
    bindingTB.tableFooterView = footerView;
    bindingTB.backgroundColor =[AppUtils colorWithHexString:COLOR_MAIN];
    bindingTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:bindingTB];
}


-(UIPickerView *)pickVFromTextF:(UITextField *)textTF
{
    return (UIPickerView *)textTF.inputView;
}

- (UITextField *)textFieldAllocInitWithTitle:(NSString *)title
                                     withTag:(NSUInteger)itemTag{
    CGRect tfFrame = CGRectMake(100, 5, IPHONE_WIDTH - 110, 40);
    UITextField *newTF = [[UITextField alloc] initWithFrame:tfFrame];
    newTF.borderStyle = UITextBorderStyleRoundedRect;
    newTF.placeholder = title;
    newTF.delegate = self;
    
    UIToolbar *localToolbar =[[UIToolbar alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width, 44)];
    UIBarButtonItem *btnDidSelectleixing = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(clickBtnForPickerViewSure:)];
    btnDidSelectleixing.tag = itemTag;
    UIBarButtonItem *flexibleSpaceleixing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(IPHONE_WIDTH/2-100, 0, 200, 44)];
    lable.text = title;
    lable.textAlignment = NSTextAlignmentCenter;
    [localToolbar addSubview:lable];
    [localToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceleixing,btnDidSelectleixing, nil]];
    newTF.inputAccessoryView = localToolbar;
    
    UIPickerView *newPickerV = [[UIPickerView alloc] initWithFrame:CGRectMake(0, IPHONE_HEIGHT, IPHONE_WIDTH, 180)];
    newPickerV.tag=itemTag+10000;
    newPickerV.showsSelectionIndicator =YES;
    newPickerV.delegate =self;
    newPickerV.dataSource =self;
    newTF.inputView = newPickerV;
    return newTF;
}

#pragma mark - Event
-(void)clickBtnForNextAction
{
    [self.view endEditing:YES];
    if ([AppUtils isMobileNumber:_floorTextF.text]) {
        [AppUtils showAlertMessage:W_ALL_PHONE_ERR_FORMAT];
        return;
    }
    
    if (nameArray.count==4 && [NSString isEmptyOrNull:_unitTextF.text])
    {
        [AppUtils showAlertMessage:@"单元号不能为空！"];
        return;
    }
    
    if ([NSString isEmptyOrNull:_roomTextF.text])
    {
        [AppUtils showAlertMessage:@"房号不能为空！"];
        return;
    }
    
    __block __typeof(NSString *)identity;
    [relationArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *relationDic = obj;
        if ([_relationTextF.text isEqualToString:relationDic.allValues[0]]) {
            identity= relationDic.allKeys[0];
        }
    }];
    
    if ([NSString isEmptyOrNull:_relationTextF.text])
    {
        [AppUtils showAlertMessage:@"与业主关系不能为空！"];
        return;
    }
    
    QueryFlootUnitModel *queryM;
    NSInteger row =[[self pickVFromTextF:self.floorTextF] selectedRowInComponent:0];
    if (row < self.flootArray.count) {
        queryM =[self.flootArray objectAtIndex:row];
    }
    
    QueryFlootUnitModel *unitM;
    NSInteger unitRow =[[self pickVFromTextF:self.unitTextF] selectedRowInComponent:0];
    if (unitRow < self.unitArray.count) {
        unitM =[self.unitArray objectAtIndex:unitRow];
    }
    
    TestingViewController *testvc = [[TestingViewController alloc]init];
    testvc.louDongStr=queryM.ID;
    testvc.danYanStr=unitM.ID;
    testvc.fangHaoStr=self.roomTextF.text;
    testvc.guanXiStr=identity;
    testvc.phoneStr=roomPhone;
    testvc.roomIdStr=rooIdStr;
    testvc.xqModel=_xqModel;
    testvc.comBindingFinishedBlock = ^{
        if (self.nextBlock){
            self.nextBlock();
        }
    };
    [self.navigationController pushViewController:testvc animated:YES];
}

//UIPickerView确认按钮事件
-(void)clickBtnForPickerViewSure:(UIBarButtonItem *)barBut
{
    [self.view endEditing:YES];
    
    switch (barBut.tag) {
        case PickerViewItemTagFloor: {
            if (![NSArray isArrEmptyOrNull:self.flootArray]) {
                NSInteger row =[[self pickVFromTextF:self.floorTextF] selectedRowInComponent:0];
                if (row < self.flootArray.count) {
                    QueryFlootUnitModel *queryM =[self.flootArray objectAtIndex:row];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.floorTextF.text = queryM.houseName;
                        self.unitTextF.text= nil;
                        self.roomTextF.text = nil;
                    });
                    
                    QueryFlootUnitModel *queryMM =[QueryFlootUnitModel new];
                    QueryFlootUnitHandler *queryH =[QueryFlootUnitHandler new];
                    queryMM.xqId  =_xqModel.xqNo;
                    queryMM.type  = @"2";
                    queryMM.parentId = queryM.ID;
                    
                    [queryH QueryFlootUnit:queryMM success:^(id obj) {
                        NSArray *recArr =  (NSArray *)obj;
                        
                        NSMutableArray *recUnitArr =[NSMutableArray array];
                        NSMutableArray *recRoomArr =[NSMutableArray array];
                        [recArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            QueryFlootUnitModel *bindM = obj;
                            if (![NSString isEmptyOrNull:bindM.ID]) {
                                [recUnitArr addObject:bindM];
                            }
                            else {
                                [recRoomArr addObject:bindM];
                            }
                        }];
                        
                        self.unitArray = [recUnitArr copy];
                        self.roomArray = [recRoomArr copy];
                        
                        if (self.unitArray.count > 0 ){
                            [self updateUIAndDataForAddUnitSection];
                        }
                        else {
                            [self updateUIAndDataForDelelateUnitSection];
                        }
                    } failed:^(id obj) {
                        self.unitArray =  [NSArray array];
                        self.roomArray =[NSArray array];
                        //房号清空，roomArr清空
                        self.roomTextF.text=@"";
                        self.unitTextF.text=@"";
                        [self updateUIAndDataForAddUnitSection];
                    }];
                }
            }
        }
            break;
        case PickerViewItemTagUnit: {
            NSInteger row =[[self pickVFromTextF:self.unitTextF] selectedRowInComponent:0];
            if (row < self.unitArray.count ) {
                QueryFlootUnitModel *queryM =[self.unitArray objectAtIndex:row];
                NSLog(@"unit%@",queryM.unit);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.unitTextF.text=queryM.houseName;
                    self.roomTextF.text = nil;
                });
                
                QueryFlootUnitModel *queryMM =[QueryFlootUnitModel new];
                QueryFlootUnitHandler *queryH =[QueryFlootUnitHandler new];
                queryMM.xqId  =_xqModel.xqNo;
                queryMM.type  = @"3";
                queryMM.parentId = queryM.ID;
                
                [queryH QueryFlootUnit:queryMM success:^(id obj) {
                    self.roomArray =(NSArray *)obj;
                } failed:^(id obj) {
                    self.roomArray = [NSArray array];
                }];
            }
        }
            break;
        case PickerViewItemTagRoom:{
            NSInteger row =[[self pickVFromTextF:self.roomTextF] selectedRowInComponent:0];
            if (row < self.roomArray.count) {
                QueryFlootUnitModel *queryMM = [self.roomArray objectAtIndex:row];
            
                roomPhone = queryMM.phone;
                rooIdStr  = queryMM.roomId;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.roomTextF.text = queryMM.room;
                });
            }
        }
            break;
        case PickerViewItemTagRelation:
        {
            NSInteger row =[[self pickVFromTextF:self.relationTextF] selectedRowInComponent:0];
            if (row < relationArr.count) {
                NSDictionary *relationDic = relationArr[row];
                if (relationDic.allValues.count > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.relationTextF.text = relationDic.allValues[0];
                    });
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Lazy Loading
- (UITextField *)floorTextF {
    if (!_floorTextF) {
        _floorTextF = [self textFieldAllocInitWithTitle:@"请选择楼栋号"
                                                withTag:PickerViewItemTagFloor];
        UIPickerView * floorPickerV = (UIPickerView *)_floorTextF.inputView;
        floorPickerV.tag = PickerViewTagFloor;
    }
    return _floorTextF;
}

- (UITextField *)unitTextF {
    if (!_unitTextF) {
        _unitTextF = [self textFieldAllocInitWithTitle:@"请选择单元号"
                                               withTag:PickerViewItemTagUnit];
        UIPickerView * unitPickerV = (UIPickerView *)_unitTextF.inputView;
        unitPickerV.tag = PickerViewTagUnit;
    }
    return _unitTextF;
}

- (UITextField *)roomTextF {
    if (!_roomTextF) {
        _roomTextF = [self textFieldAllocInitWithTitle:@"请选择房号"
                                               withTag:PickerViewItemTagRoom];
        UIPickerView * roomPickerV = (UIPickerView *)_roomTextF.inputView;
        roomPickerV.tag = PickerViewTagRoom;
    }
    return _roomTextF;
}

- (UITextField *)relationTextF {
    if (!_relationTextF) {
        _relationTextF = [self textFieldAllocInitWithTitle:@"请选择关系"
                                                   withTag:PickerViewItemTagRelation];
        UIPickerView * relationPickerV = (UIPickerView *)_relationTextF.inputView;
        relationPickerV.tag = PickerViewTagRelation;
    }
    return _relationTextF;
}

#pragma mark - Request
-(void)postQueryflootunit
{
    QueryFlootUnitModel *queryM =[QueryFlootUnitModel new];
    QueryFlootUnitHandler *queryH =[QueryFlootUnitHandler new];
    queryM.xqId  =_xqModel.xqNo;
    queryM.type  = @"1";
    
    [queryH QueryFlootUnit:queryM success:^(id obj) {
        self.flootArray =  (NSArray *)obj;
        [[self pickVFromTextF:self.floorTextF] reloadAllComponents];
        [AppUtils dismissHUD];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
    }];
}

#pragma mark - UTableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return nameArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    view.backgroundColor=[AppUtils colorWithHexString:@"eeeeea"];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identfier = @"BindingCell";
    BindingCell *Cell = [tableView dequeueReusableCellWithIdentifier:identfier];
    if (Cell==nil)
    {
        Cell  =[[BindingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    return Cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BindingCell *bindingCell = (BindingCell *)cell;
    bindingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [bindingCell setname:[nameArray objectAtIndex:indexPath.section]];

    switch (indexPath.section) {
        case 0: {
            [bindingCell.contentView addSubview:self.floorTextF];
        }
            break;
        case 1: {
            [bindingCell.contentView addSubview:self.unitTextF];
        }
            break;
        case 2: {
            [bindingCell.contentView addSubview:self.roomTextF];
        }
            break;
        case 3: {
            [bindingCell.contentView addSubview:self.relationTextF];
        }
            break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
}

#pragma mark - update
- (void)updateUIAndDataForAddUnitSection {
    if (nameArray.count == 3) {
        [nameArray insertObject:@"单        元 :" atIndex:1];
        [bindingTB insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)updateUIAndDataForDelelateUnitSection {
    if (nameArray.count == 4) {
        [nameArray removeObjectAtIndex:1];
        [bindingTB deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#pragma mark PickerDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == PickerViewTagFloor) {
        return self.flootArray.count;
    }
    
    if (pickerView.tag == PickerViewTagUnit) {
        return self.unitArray.count;
    }
    
    if (pickerView.tag == PickerViewTagRoom) {
        return self.roomArray.count;
    }

    if (pickerView.tag == PickerViewTagRelation) {
        return relationArr.count;
    }
    
    return 0;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == PickerViewTagFloor && row < self.flootArray.count) {
        QueryFlootUnitModel *queryM = [self.flootArray objectAtIndex:row];
        return queryM.houseName;
    }
    
    if (pickerView.tag == PickerViewTagUnit && row < self.unitArray.count) {
        QueryFlootUnitModel *queryM = [self.unitArray objectAtIndex:row];
        return queryM.houseName;
    }
    
    if (pickerView.tag == PickerViewTagRoom && row < self.roomArray.count) {
        QueryFlootUnitModel *queryM = [self.roomArray objectAtIndex:row];
        return queryM.room;
    }
    
    if (pickerView.tag == PickerViewTagRelation && row < relationArr.count) {
        NSDictionary *relationDic = relationArr[row];
        if (relationDic.allValues.count > 0) {
            return relationDic.allValues[0];
        }
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
