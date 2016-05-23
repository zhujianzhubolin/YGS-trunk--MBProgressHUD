//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface NIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) CGSize lastSize;
@property (nonatomic, assign) UITableViewCellAccessoryType cellAcctype;
@property (nonatomic, assign) NSTextAlignment textAligment;
@property (nonatomic, assign) BOOL isSelHide; //点击后是否调用hideDropDown ，默认YES

@end

@implementation NIDropDown {
    UIView *buttomView;
    UITapGestureRecognizer *cancelTap; //取消手势
}

@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize delegate;
@synthesize lastPoint;
@synthesize lastSize;
@synthesize cellAcctype;
@synthesize isSelHide;
@synthesize textAligment;

+ (instancetype)dropDownInstance {
    static NIDropDown *dropDown = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dropDown = [[NIDropDown alloc] initWithFrame:CGRectZero];
    });
   return dropDown;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(-5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        self.backgroundColor = [UIColor clearColor];
        
        table = [[UITableView alloc] initWithFrame:CGRectZero];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        table.showsVerticalScrollIndicator = NO;
        table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorColor = [UIColor grayColor];
        table.showsVerticalScrollIndicator = YES;
        table.bounces = NO;
        [self addSubview:table];
        
        if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
            [table setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([table respondsToSelector:@selector(setLayoutMargins:)]) {
            [table setLayoutMargins:UIEdgeInsetsZero];
        }
        buttomView = [[UIView alloc] initWithFrame:CGRectZero];
        buttomView.backgroundColor = [UIColor clearColor];
        [buttomView addSubview:self];
        self.isSelHide = YES;
        textAligment = NSTextAlignmentCenter;
        cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDrop)];
        cancelTap.delegate = self;
        [buttomView addGestureRecognizer:cancelTap];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint p = [touch locationInView:buttomView];
    return !CGRectContainsPoint(self.frame, p);
}

//表格顶部线
-(void)viewDidLayoutSubviews
{
    if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
        [table setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([table respondsToSelector:@selector(setLayoutMargins:)]) {
        [table setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)showDropDownWithRect:(CGRect)rect withButton:(UIButton *)button withArr:(NSArray *)arr withAccessoryType:(UITableViewCellAccessoryType)type withTextAligment:(NSTextAlignment)textAlig isSelHide:(BOOL)hide  {
    textAligment = textAlig;
    self.isSelHide = hide;
    if (arr.count <= 0) {
        return;
    }
    cellAcctype = type;
    if (button != btnSender) {
        [self hideDropDown:btnSender isAnimation:NO];
    }
    btnSender = button;
    self.frame = rect;
    lastPoint = rect.origin;
    lastSize = rect.size;
    self.list = [NSArray arrayWithArray:arr];
    [self.table reloadData];
    
    [self showDropDownWithHeight:rect.size.height];
}

- (void)showDropDownWithSize:(CGSize)size withButton:(UIButton *)button withArr:(NSArray *)arr {
    textAligment = NSTextAlignmentCenter;
    self.isSelHide = YES;
    if (arr.count <= 0) {
        return;
    }
    cellAcctype = UITableViewCellAccessoryNone;
    if (button != btnSender) {
        [self hideDropDown:btnSender isAnimation:NO];
    }
    btnSender = button;

    lastPoint = [[UIApplication sharedApplication].keyWindow convertPoint:CGPointMake(button.frame.origin.x, button.frame.origin.y + button.frame.size.height) fromView:button.superview];
    lastSize = size;
    self.frame = CGRectMake(lastPoint.x, lastPoint.y, size.width,0);
    
    self.list = [NSArray arrayWithArray:arr];
    [self.table reloadData];
    
    [self showDropDownWithHeight:size.height];
}

- (void)showDropDownWithHeight:(CGFloat)height {
    dispatch_async(dispatch_get_main_queue(), ^{
        buttomView.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT);
    });
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.frame;
        rect.size.height = height;
        self.frame = rect;
        self.table.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:buttomView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDrop)];
//    [buttomView addGestureRecognizer:tap];
}

- (void)hideDrop {
//    [self.delegate niDropDownDelegateMethod:indexPath.row forBtn:btnSender];
    if (isSelHide) {
        [self hideDropDown:btnSender isAnimation:YES];
    }
}

- (void)hideDropDown:(UIView *)b isAnimation:(BOOL)isAnimation {
    if (isAnimation) {
        [UIView animateWithDuration:0.2 animations:^{
            table.frame = CGRectMake(0, 0, lastSize.width, 0);
            self.frame = CGRectMake(lastPoint.x, lastPoint.y, lastSize.width, 0);
        } completion:^(BOOL finished) {
            buttomView.frame = CGRectZero;
        }];
    }
    else {
        self.frame = CGRectMake(lastPoint.x, lastPoint.y, lastSize.width, 0);
        table.frame = CGRectZero;
        buttomView.frame = CGRectZero;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}   


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    cell.textLabel.text =[list objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = cellAcctype;
    cell.textLabel.textAlignment = textAligment;
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
}

- (void)selectDropDownTextColorInRow:(NSUInteger)row withColor:(UIColor *)color {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (row < self.list.count) {
            UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            cell.textLabel.textColor = color;
        }
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate niDropDownDelegateMethod:indexPath.row forBtn:btnSender];
    if (isSelHide) {
        [self hideDropDown:btnSender isAnimation:YES];
    }
}

@end
