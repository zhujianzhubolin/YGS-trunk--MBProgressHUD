#import "UIImageView+wrapper.h"

@implementation UIImageView (wrapper)

- (void)setRound
{
    [self.layer setCornerRadius:CGRectGetHeight(self.bounds) / 2];
    self.layer.masksToBounds = YES;
}

+ (nonnull UIImageView *)addimageView:(nonnull UIView *)view
                                frame:(CGRect)frame
                            imageName:(nullable NSString *)imageName {
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    [view addSubview:imageView];
    return imageView;
}

@end
