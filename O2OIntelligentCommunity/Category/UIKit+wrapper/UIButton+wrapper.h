#import <UIKit/UIKit.h>

@interface UIButton (wrapper)
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;
+ (nonnull instancetype)addWithFrame:(CGRect)frame
                           textColor:(nullable UIColor *)textColor
                            fontSize:(CGFloat)fontSize
                             imgName:(nullable NSString *)imgName
                                text:(nullable NSString *)text;

- (void)setState:(UIControlState)state
         imgName:(nullable NSString *)imgName
            text:(nullable NSString *)text;
@end
