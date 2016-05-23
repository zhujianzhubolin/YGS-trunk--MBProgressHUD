#import "UIView+wrapper.h"

@implementation UIView (wrapper)

- (void)animateShake
{
    CGAffineTransform moveRight = CGAffineTransformTranslate(CGAffineTransformIdentity, 5, 0);
    CGAffineTransform moveLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -5, 0);
    CGAffineTransform resetTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.transform = moveLeft;
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = moveRight;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                
                self.transform = moveLeft;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    
                    self.transform = resetTransform;
                    
                }];
            }];
            
        }];
    }];
}

- (void)animateFadeIn:(CFTimeInterval)duration
{
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @0.0f;
    fadeAnimation.toValue = @1.f;
    fadeAnimation.duration = duration;
    fadeAnimation.removedOnCompletion = YES;
    self.alpha = 1.0;
    [self.layer addAnimation:fadeAnimation forKey:nil];
}

- (void)animateFadeOut:(CFTimeInterval)duration
{
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @1.0f;
    fadeAnimation.toValue = @0.0f;
    fadeAnimation.duration = duration;
    fadeAnimation.removedOnCompletion = YES;
    self.alpha = 0.0;
    [self.layer addAnimation:fadeAnimation forKey:nil];
}

@end
