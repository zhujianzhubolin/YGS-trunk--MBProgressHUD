//
//  MoreLife1.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/10.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#define MORE_EACH_ROW_COUNT 4
#define MORE_ALL_INTERVAL 4

#import "MoreLife.h"
#import "ChangePostionButton.h"
#import "UIButton+wrapper.h"
#import "NoticeTBVC.h"
#import "UserManager.h"
#import "NSString+wrapper.h"
#import "PassPermitTBVC.h"
#import "WebVC.h"
#import "WTZhouBianKuaiSong.h"

@interface MoreLife () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *moreCollectionV;

@end

@implementation MoreLife

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多";
    self.view = self.moreCollectionV;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (UICollectionView *)moreCollectionV {
    if (!_moreCollectionV) {
        UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = MORE_ALL_INTERVAL / MORE_EACH_ROW_COUNT;//行间距(最小值);
        flowLayout.minimumInteritemSpacing = 1;
        _moreCollectionV = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        
        [_moreCollectionV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:SYSTEM_CELL_Col_ID];
        _moreCollectionV.dataSource = self;
        _moreCollectionV.delegate = self;
        _moreCollectionV.scrollEnabled = NO;
        _moreCollectionV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    }
    return _moreCollectionV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTongXingZhengVC {
    if ([[UserManager shareManager] showCommunityAlertIsBindingFromNav:self.navigationController]) {
        return;
    }
    
    if ([NSString isEmptyOrNull:[UserManager shareManager].comModel.pass] || ![[UserManager shareManager].comModel.pass isEqualToString:@"Y"]) {
        [AppUtils showAlertMessage:W_ALL_NO_SERVER];
        return;
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainTBViewController" bundle:nil];
    PassPermitTBVC *passVC = (PassPermitTBVC *)[mainStoryboard instantiateViewControllerWithIdentifier:@"PassPermitTBVCID"];
    [self.navigationController pushViewController:passVC animated:YES];
}

- (void)showWaiMaiVC {
    WebVC *waimaiVC = [WebVC new];
    waimaiVC.webURL = @"http://i.waimai.meituan.com";
    waimaiVC.title = @"外卖";
    [self.navigationController pushViewController:waimaiVC animated:YES];
}

- (void)showKuaidiYiVC {
    WebVC *kuadiVC = [WebVC new];
    kuadiVC.webURL = @"http://m.kuaidi100.com";
    kuadiVC.title = @"快递易";
    [self.navigationController pushViewController:kuadiVC animated:YES];
}

- (void)showAiDaChuVC {
    WebVC *loveChefVC = [WebVC new];
    loveChefVC.webURL = @"http://www.idachu.cn/";
    loveChefVC.title = @"爱大厨";
    [self.navigationController pushViewController:loveChefVC animated:YES];
}

- (void)moreBtnClick:(UIButton *)btn {
    switch (btn.tag - 1) {
        case 0: {
            #ifdef SmartComJYZX
                WTZhouBianKuaiSong * tuangou = [[WTZhouBianKuaiSong alloc] init];
                [self.navigationController pushViewController:tuangou animated:YES];
            #elif SmartComYGS
                [self showTongXingZhengVC];
            #else
                        
            #endif
        }
            break;
        case 1: {
            #ifdef SmartComJYZX
                UIStoryboard *mainSTB = [UIStoryboard storyboardWithName:@"MainTBViewController" bundle:nil];
                NoticeTBVC *noticeVC = [mainSTB instantiateViewControllerWithIdentifier:@"NoticeTBVCID"];
                [self.navigationController pushViewController:noticeVC animated:YES];
            #elif SmartComYGS
                [self showWaiMaiVC];
            #else
                        
            #endif
        }
            break;
        case 2: {
            #ifdef SmartComJYZX
                [self showTongXingZhengVC];
            #elif SmartComYGS
                [self showAiDaChuVC];
            #else
                        
            #endif
        }
            break;
        case 3: {
            #ifdef SmartComJYZX
                [self showKuaidiYiVC];
            #elif SmartComYGS
                        
            #else
                        
            #endif
        }
            break;
         case 4: {
            #ifdef SmartComJYZX
                [self showWaiMaiVC];
            #elif SmartComYGS
                        
            #else
                        
            #endif
        }
            break;
        default:
            break;
    }

}

- (void)refreshCollectionViewForCell:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    ChangePostionButton *moreBtn = [[ChangePostionButton  alloc] init];
    moreBtn.frame = cell.bounds;
    [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    
    [moreBtn setInternalPositionType:ButtonInternalLabelPositionButtom spacing:5];
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.tag = indexPath.row + 1;
    
    switch (indexPath.row) {
        case 0: {
#ifdef SmartComJYZX
            [moreBtn setState:UIControlStateNormal
                      imgName:@"m_More_SSJ"
                         text:@"惠团购"];
#elif SmartComYGS
            [moreBtn setState:UIControlStateNormal
                      imgName:@"mtongxingzheng"
                         text:@"通行证"];
#else
            
#endif
        }
            break;
        case 1: {
#ifdef SmartComJYZX
            [moreBtn setState:UIControlStateNormal
                      imgName:@"mkantonggao"
                         text:@"通知公告"];
#elif SmartComYGS
            [moreBtn setState:UIControlStateNormal
                      imgName:@"module_takeOut"
                         text:@"外卖"];
#else
            
#endif
        }
            break;
        case 2: {
#ifdef SmartComJYZX
            [moreBtn setState:UIControlStateNormal
                      imgName:@"mtongxingzheng"
                         text:@"通行证"];
#elif SmartComYGS
            [moreBtn setState:UIControlStateNormal
                      imgName:@"module_loveChef"
                         text:@"爱大厨"];
#else
            
#endif
        }
            break;
        case 3: {
#ifdef SmartComJYZX
            [moreBtn setState:UIControlStateNormal
                      imgName:@"mkuaidiyi"
                         text:@"快递易"];
#elif SmartComYGS
            
#else
            
#endif
        }
            break;
        case 4: {
#ifdef SmartComJYZX
            [moreBtn setState:UIControlStateNormal
                      imgName:@"mwaimai"
                         text:@"外卖"];
#elif SmartComYGS
            
#else
            
#endif
        }
            break;
        default:
            break;
    }
    [cell addSubview:moreBtn];
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

//设置元素的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsZero;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYSTEM_CELL_Col_ID forIndexPath:indexPath];
    
    if (SYSTEMVERYION < 8) {
        [self refreshCollectionViewForCell:cell forIndexPath:indexPath];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (SYSTEMVERYION >= 8) {
        [self refreshCollectionViewForCell:cell forIndexPath:indexPath];
    }
}

//设置单元格大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((collectionView.frame.size.width - MORE_ALL_INTERVAL)/MORE_EACH_ROW_COUNT,(collectionView.frame.size.width - MORE_ALL_INTERVAL)/MORE_EACH_ROW_COUNT);
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
