//
//  MessageHandler.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "MessageModel.h"

@interface MessageHandler : BaseHandler

//验证获取到的验证码的正确性
- (void)executeVerifyCodeIsRightTaskWithModel:(MessageModel *)codeE
                                      success:(SuccessBlock)success
                                      failed:(FailedBlock)failed;

//获取验证码，（除开注册,开通钱包）
- (void)executeGetVerifyCodeTaskWithModel:(MessageModel *)codeE
                                  success:(SuccessBlock)success
                                   failed:(FailedBlock)failed;


//注册获取验证码，注册
- (void)executeRegisterGetVerifyCodeTaskWithModel:(MessageModel *)codeE
                                          success:(SuccessBlock)success
                                           failed:(FailedBlock)failed;

//获取开通钱包的验证码
- (void)executeMoneyBagCodeTaskWithModel:(MessageModel *)codeE
                                 success:(SuccessBlock)success
                                  failed:(FailedBlock)failed;

//绑定小区获取验证码
-(void)executeBindingXiaoQuWithModel:(MessageModel *)codeE
                             success:(SuccessBlock)success
                              failed:(FailedBlock)failed;
@end
