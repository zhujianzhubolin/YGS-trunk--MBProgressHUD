#import <UIKit/UIKit.h>

@interface UIView (animation)

/*
 * UIView+wrapper
 */

- (void)animateShake;

- (void)animateFadeIn:(CFTimeInterval)duration;

- (void)animateFadeOut:(CFTimeInterval)duration;

@end
