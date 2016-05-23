//
//  PassFooterView.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "PassFooterView.h"
#import "QRCodeGenerator.h"

@implementation PassFooterView
{
    __weak IBOutlet UIButton *createPassButton;
    __weak IBOutlet UIImageView *qrCodeImgV;
    __weak IBOutlet UIView *passInfoV;
    __weak IBOutlet UIButton *shareButton;

    __weak IBOutlet UILabel *passAdress;
    __weak IBOutlet UILabel *passUsername;
    __weak IBOutlet UILabel *passPhone;
    __weak IBOutlet UILabel *passValidity;
    
    __weak IBOutlet UIImageView *iconImgV;
}

- (IBAction)createPassClick:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock(sender.tag);
    }
}

- (void)awakeFromNib {
    passInfoV.hidden = YES;
    iconImgV.hidden = YES;
    shareButton.enabled = NO;
    iconImgV.image = [UIImage imageNamed:P_SHARE_IMAGE];
}

- (void)reloadDataWithModel:(PassPermitEntity *)passE isGeneratePass:(BOOL)isGene {
    if (isGene) {
        shareButton.enabled = YES;
        
        passAdress.text = passE.community;
        passUsername.text = passE.userName;
        passPhone.text = passE.phone;
        passValidity.text = passE.validity;
        passInfoV.hidden = NO;
        iconImgV.hidden = NO;
        
        shareButton.backgroundColor = [AppUtils colorWithHexString:@"fc6d22"];
        NSString *codeStr = [NSString stringWithFormat:@"小区名称:%@\n邀请人:%@\n联系电话:%@\n有效期:%@",passE.community,passE.userName,passE.phone,passE.validity];
        qrCodeImgV.image = [QRCodeGenerator qrImageForString:codeStr imageSize:self.bounds.size.width];
        return;
    }
    
    passInfoV.hidden = NO;
    shareButton.enabled = YES;
}
@end
