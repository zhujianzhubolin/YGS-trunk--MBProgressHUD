#import <UIKit/UIKit.h>

@interface UITextView (wrapper)

/*
 * UITextField+wrapper
 */

- (void)setPlaceHolder:(NSString *)text fontSize:(CGFloat)size;

- (void)showPlaceHolder;

- (void)hidePlaceHolder;

@end
