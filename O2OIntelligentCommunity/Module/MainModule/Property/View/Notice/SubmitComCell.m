//
//  SubmitComCell.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "SubmitComCell.h"
#import "UITextField+wrapper.h"

@implementation SubmitComCell
{

    __weak IBOutlet UILabel *remainCharacterL;
    NSInteger textLength;
    
}

- (void)awakeFromNib {
    textLength = 200;
    self.textV.delegate = self;
    [self.textV setPlaceHolder:@"请填写评论内容" fontSize:15];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textViewEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:self.textV];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextViewTextDidChangeNotification"
                                                 object:self.textV];
}

- (void)textViewEditChanged:(NSNotification*)obj{
    if ([obj.object isKindOfClass:[UITextView class]]) {
        UITextView *textV = (UITextView *)obj.object;
        dispatch_async(dispatch_get_main_queue(), ^{
            remainCharacterL.text = [NSString stringWithFormat:@"您还可以输入%lu字",textLength - textV.text.length];
        });
        NSUInteger kMaxLength = textLength;
        [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                                    inTextView:textV];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length > 0) {
        [textView hidePlaceHolder];
    }
    else {
        [textView showPlaceHolder];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView.text.length <= 0) {
        [textView showPlaceHolder];
    }
    else {
        [textView hidePlaceHolder];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) {
        return YES;
    }
    
    if (range.location < textLength && [AppUtils isNotLanguageEmoji]) {
        return YES;
    }
    return NO;
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
