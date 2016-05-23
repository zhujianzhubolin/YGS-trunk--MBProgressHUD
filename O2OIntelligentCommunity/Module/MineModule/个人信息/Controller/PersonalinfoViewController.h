//
//  PersonalinfoViewController.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"
#import "GetImgFromSystem.h"

@interface PersonalinfoViewController : O2OBaseViewController<UITableViewDataSource,UITableViewDelegate,GetImgFromSystemDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (strong,nonatomic)UITableView *TableView;

@end
