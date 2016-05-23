#import "UIButton+wrapper.h"

@implementation UIButton (wrapper)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

+ (nonnull instancetype)addWithFrame:(CGRect)frame
                           textColor:(nullable UIColor *)textColor
                            fontSize:(CGFloat)fontSize
                             imgName:(nullable NSString *)imgName
                                text:(nullable NSString *)text {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = frame;
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [btn setState:UIControlStateNormal
          imgName:imgName
             text:text];
    return btn;
}

- (void)setState:(UIControlState)state
         imgName:(nullable NSString *)imgName
            text:(nullable NSString *)text {
    [self setTitle:text forState:state];
    [self setImage:[UIImage imageNamed:imgName] forState:state];
}

@end
