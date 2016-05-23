//
//  ViewController.m
//  SearchDisplayC
//
//  Created by user on 15/9/10.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "SearchVC.h"
#import "NSString+wrapper.h"
#import "ChangePostionButton.h"

@interface SearchVC () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIView *myTBSuperView;
@property (nonatomic, strong) NSMutableArray *visableArray;
@property (nonatomic, strong) NSMutableArray *filterArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) UISearchBar *topSearchBar;
@end

@implementation SearchVC
{
    UITableViewCellStyle cellStyle;
    Class cellClass;
    CGFloat cellHeight;
    NSString *cellID;
    BOOL isNib;
    TableViewCellConfigurate cellConfigureBlock;
}

- (void)searchForSystemCellWithCellID:(NSString *)aCellID
                            cellHight:(CGFloat)aCellheight
                            cellStyle:(UITableViewCellStyle)aCellStyle
                                isNib:(BOOL)isFromNib
             tableViewCellConfigufate:(TableViewCellConfigurate)cellConfigurate {
    cellStyle = aCellStyle;
    [self searchForCustomCellWithCellClassName:[UITableViewCell class]
                                        cellID:aCellID
                                    cellHeight:aCellheight
                                         isNib:isFromNib
                      tableViewCellConfigufate:cellConfigurate];
}

- (void)searchForCustomCellWithCellClassName:(Class)aCellClass
                                      cellID:(NSString *)aCellID
                                  cellHeight:(CGFloat)aCellheight
                                       isNib:(BOOL)isFromNib
                    tableViewCellConfigufate:(TableViewCellConfigurate)cellConfigurate {
    isNib = isFromNib;
    cellHeight = aCellheight;
    cellID = aCellID;
    cellConfigureBlock = cellConfigurate;
    cellClass = aCellClass;
}

- (void)setSearchLocalArr:(NSArray *)searchLocalArr {
    _searchLocalArr = searchLocalArr;
    self.dataSourceArray = [_searchLocalArr mutableCopy];
}

- (id)init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    self.dataSourceArray = [NSMutableArray array];
    self.filterArray = [NSMutableArray array];
    self.searchLocalArr = [NSArray array];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self hidetabbar];
    UIButton *searchBtn = (UIButton *)[self.view viewWithTag:10];
    [searchBtn setTitle:@"点击搜索" forState:UIControlStateNormal];
    self.topSearchBar.showsCancelButton = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [AppUtils closeKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.topSearchBar.placeholder = _placeholder;
}

- (void)initUI{
    self.title = @"搜索";
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + self.navigationController.navigationBar.frame.size.height) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self viewDidLayoutSubviewsForTableView:_myTableView];
    _myTableView.tableFooterView = [AppUtils tableViewsFooterView];
    [self.view addSubview:_myTableView];
    
    self.topSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width *2 /3, self.navigationController.navigationBar.frame.size.height)];
    [self.topSearchBar.layer setMasksToBounds:YES];
    self.topSearchBar.showsCancelButton = YES;
    [self.topSearchBar sizeToFit];
    self.topSearchBar.delegate = self;
    if (self.placeholder.length <= 0) {
        self.topSearchBar.placeholder = @"搜索";
    }
    else {
        self.topSearchBar.placeholder = self.placeholder;
    }
    self.navigationItem.titleView = self.topSearchBar;
    self.navigationItem.titleView.layer.cornerRadius = 5;
    
    self.myTBSuperView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  self.myTableView.frame.size.width,
                                                                  self.view.frame.size.height- CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    self.myTBSuperView.backgroundColor = [AppUtils colorWithHexString:@"f5f4f4"];
    [_myTableView addSubview:self.myTBSuperView];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat  narrowWidth = MIN(self.view.frame.size.width, self.view.frame.size.height);
    CGFloat btnHeight = narrowWidth *2/5;
    CGFloat btnWidth  = btnHeight /187 *218;
    
    searchBtn.frame = CGRectMake((self.myTBSuperView.frame.size.width - btnWidth) /2, (self.myTBSuperView.frame.size.height - btnHeight) /2, btnWidth, btnHeight);
    
    searchBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    searchBtn.tag = 10;
    [searchBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -30, 0)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search_noData"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(startSearch) forControlEvents:UIControlEventTouchDown];
    searchBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.myTBSuperView addSubview:searchBtn];
}

- (void)startSearch {
    [AppUtils closeKeyboard];
    [self searchBarSearchButtonClicked:self.topSearchBar];
}

- (void)reloadWebSearchData:(NSArray *)searchArr {
    if ([NSArray isArrEmptyOrNull:searchArr]) {
        self.visableArray = [NSMutableArray array];
        UIButton *searchBtn = (UIButton *)[self.view viewWithTag:10];
        [searchBtn setTitle:@"未搜索到内容，点击搜索" forState:UIControlStateNormal];
    }
    else {
        self.visableArray = [searchArr mutableCopy];
    }
    [self.myTableView reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.visableArray.count > 0) {
        self.myTableView.scrollEnabled = YES;
        self.myTBSuperView.hidden = YES;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return _visableArray.count;
    }
    else {
        self.myTableView.scrollEnabled = NO;
        self.myTBSuperView.hidden = NO;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([NSString isEmptyOrNull:cellID]) {
        cellID = SYSTEM_CELL_ID;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        if (isNib) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(cellClass) owner:self options:nil] lastObject];
        }
        else {
            if (cellClass && [NSStringFromClass(cellClass) isEqualToString:@"UITableViewCell"]) {
                cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellID];
            }
            else {
                cell = [[cellClass alloc] init];
            }
        }
    }

    SearchCellEntity *searchE = _visableArray[indexPath.row];
    if (cellConfigureBlock) {
        cellConfigureBlock(cell,searchE);
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cellHeight > 0) {
        return cellHeight;
    }
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [AppUtils closeKeyboard];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.clickBlock) {
        self.clickBlock(self.visableArray[indexPath.row]);
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    NSString *filterString = searchBar.text;
    if ([NSString isEmptyOrNull:filterString]) {
        self.visableArray = [NSMutableArray array];
        [AppUtils showAlertMessageTimerClose:@"未搜索到数据"];
        UIButton *searchBtn = (UIButton *)[self.view viewWithTag:10];
        [searchBtn setTitle:@"未搜索到内容，点击搜索" forState:UIControlStateNormal];
        [self.myTableView reloadData];
        return;
    }
    
    //从服务器搜索数据
    if (self.webBlock) {
        self.webBlock(filterString);
        return;
    }
    
    //本地搜索数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.searchString contains [c] %@", filterString];
    self.visableArray = [NSMutableArray arrayWithArray:[self.dataSourceArray filteredArrayUsingPredicate:predicate]];
    [self.myTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    self.visableArray = [self.dataSourceArray mutableCopy];
    [self.myTableView reloadData];
    [searchBar resignFirstResponder];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return range.location < SEARCH_INPUT_LENGTH && [AppUtils isNotLanguageEmoji];
}

@end
