#import <UIKit/UIKit.h>

@interface UIImageView (wrapper)

- (void)setRound;

+ (nonnull UIImageView *)addimageView:(nonnull UIView *)view
                                frame:(CGRect)frame
                            imageName:(nullable NSString *)imageName;

@end
