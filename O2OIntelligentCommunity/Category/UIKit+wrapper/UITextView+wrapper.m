#import "UITextView+wrapper.h"

@implementation UITextView (wrapper)

- (void)setPlaceHolder:(NSString *)text fontSize:(CGFloat)size
{
    
    CGSize lableSize = [AppUtils sizeWithString:text
                                           font:[UIFont systemFontOfSize:size]
                                           size:CGSizeMake(self.frame.size.width - 4, self.frame.size.height)];
    UILabel *labelPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(2, 5, self.frame.size.width - 4, lableSize.height)];
    labelPlaceHolder.numberOfLines = 0;
    labelPlaceHolder.font = [UIFont systemFontOfSize:size];
    labelPlaceHolder.textColor = [UIColor lightGrayColor];
    labelPlaceHolder.text = text;
    labelPlaceHolder.enabled = NO;
    [self addSubview:labelPlaceHolder];
}

- (void)showPlaceHolder
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *subView = self.subviews[idx];
        if ([subView isKindOfClass:[UILabel class]]) {
            subView.hidden = NO;
        }
    }];
}

- (void)hidePlaceHolder
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *subView = self.subviews[idx];
        if ([subView isKindOfClass:[UILabel class]]) {
            subView.hidden = YES;
        }
    }];
}

@end
