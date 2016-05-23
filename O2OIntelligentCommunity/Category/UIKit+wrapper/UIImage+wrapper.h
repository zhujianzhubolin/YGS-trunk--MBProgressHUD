#import <UIKit/UIKit.h>

@interface UIImage (wrapper)

+ (UIImage *)scaleFromImage:(UIImage *)image withSize:(CGSize)size; //缩放

+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size; //压缩
    
+ (void)writeUserPhoto:(UIImage *)image;

+ (UIImage *)readerUserPhoto;

+ (UIImage*)imageConvertFromView:(UIView*)view;

@end
