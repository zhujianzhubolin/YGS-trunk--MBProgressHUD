//
//  ZJEditingHandler.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/29.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "ZJXiaoMiTemplateM.h"

@interface ZJEditingHandler : BaseHandler
@property (nonatomic, copy) NSString *currentPage;
@property (nonatomic, copy) NSString *pageCount;
@property (nonatomic, strong) NSMutableArray *templateArr;

//获取小蜜广告模板列表
- (void)ZJ_requestForGetTemplateList:(ZJXiaoMiTemplateM *)model
                             success:(SuccessBlock)success
                              failed:(FailedBlock)failed
                            isHeader:(BOOL)isHeader;

//获取模板合成后的图片路径
- (void)ZJ_requestForGetTemplateSynthesisImg:(id)paraDic
                                     success:(SuccessBlock)success
                                      failed:(FailedBlock)failed;
//上传图片
- (void)ZJ_RequestForUploadImg:(UIImage *)img
                       success:(SuccessBlock)success
                        failed:(FailedBlock)failed;

@end
