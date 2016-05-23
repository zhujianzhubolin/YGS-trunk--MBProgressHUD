//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

/*
   如果要是使用单例初始化该控件必须 将[NIDropDown dropDownInstance].delegate = self;这句话放在viewWillAppear方法里面
    尽量不使用单例，以后会去掉

*/

#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NSInteger) index forBtn:(UIButton *)button;
@end 

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, weak) id <NIDropDownDelegate> delegate;

+ (instancetype)dropDownInstance;
- (void)hideDropDown:(UIButton *)b isAnimation:(BOOL)isAnimation;
- (void)showDropDownWithSize:(CGSize)size withButton:(UIButton *)button withArr:(NSArray *)arr;
- (void)showDropDownWithRect:(CGRect)rect withButton:(UIButton *)button withArr:(NSArray *)arr withAccessoryType:(UITableViewCellAccessoryType)type withTextAligment:(NSTextAlignment)textAlig isSelHide:(BOOL)hide ; //最后一个参数指代理选中回调时需不需要隐藏，即调用hideDropDown方法
- (void)selectDropDownTextColorInRow:(NSUInteger)row withColor:(UIColor *)color;
@end
