//
//  NoticeDCell.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#define NOTICE_CONTENT_FONT 15

#import "NoticeDCell.h" 
#import "UserManager.h"
#import "NSString+wrapper.h"

@implementation NoticeDCell
{
    __weak IBOutlet UILabel *userLabel;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *contentLabel;
    __weak IBOutlet UILabel *numbelLabel;
    
    __weak IBOutlet UIButton *deleteBtn;
    NSString *idID;
}

- (IBAction)deleteClick:(UIButton *)sender {
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"删除评论" message:contentLabel.text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [deleteAlert show];
}

- (void)reloadDataWithModel:(CommentEntity *)entity withNum:(NSUInteger)num{
    if (![NSString isEmptyOrNull:entity.memberId] && [entity.memberId isEqualToString:[UserManager shareManager].userModel.memberId]) {
        deleteBtn.hidden = NO;
    }
    else {
        deleteBtn.hidden = YES;
    }
    
    idID = entity.idID;
    
    if ([NSString isEmptyOrNull:entity.nickName]) {
        userLabel.text = @"未知";
    }
    else {
        userLabel.text = entity.nickName;
    }
    
    dateLabel.text = entity.dateCreateStr;
    contentLabel.text = entity.content;
    
    CGSize discussSize = [NoticeDCell getDiscussSizeForEntity:entity.content];

    self.contentHeight = discussSize.height + contentLabel.frame.origin.y + numbelLabel.frame.size.height;
    contentLabel.frame = CGRectMake(contentLabel.frame.origin.x,
                                    contentLabel.frame.origin.y,
                                    contentLabel.frame.size.width,
                                    discussSize.height + 10);
//    self.frame = CGRectMake(self.frame.origin.x,
//                            self.frame.origin.y,
//                            self.frame.size.width,
//                            self.contentHeight + numbelLabel.frame.size.height);
//    
    numbelLabel.text = [NSString stringWithFormat:@"%lu楼",num];
}

+ (CGSize)getDiscussSizeForEntity:(NSString *)contentStr {
    return [AppUtils sizeWithString:contentStr
                               font:[UIFont systemFontOfSize:NOTICE_CONTENT_FONT]
                               size:CGSizeMake(IPHONE_WIDTH - 16, 1000)];
}

+ (CGFloat)contentHeightForEntity:(CommentEntity *)entity {
    CGSize discussSize = [NoticeDCell getDiscussSizeForEntity:entity.content];
    CGFloat initialCellHeight = 96;
    CGFloat initialContHeight = 28;
    return discussSize.height + initialCellHeight - initialContHeight;
}

- (void)awakeFromNib {
    contentLabel.font = [UIFont systemFontOfSize:NOTICE_CONTENT_FONT];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 &&
        !deleteBtn.hidden &&
        self.deleteBlock) {
        self.deleteBlock(idID);
    }
}

@end
