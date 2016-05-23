//
//  DES3EncryptUtil.h
//  加密解密测试
//
//  Created by app on 16/1/14.
//  Copyright © 2016年 kuroneko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3EncryptUtil : NSObject

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;
// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;

@end
