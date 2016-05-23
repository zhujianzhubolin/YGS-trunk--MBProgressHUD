#import <Foundation/Foundation.h>

@interface NSString (wrapper)

//将参数字典和请求的服务器和端口转化为GET请求的链接形式
+ (NSString *)stringForUrlFromPath:(NSString *)path paramaters:(NSDictionary *)paraDic;

+ (Boolean)isEmptyOrNull:(NSString *)string;

//- (Boolean)isEmptyOrNull;

- (NSString *)substringFromIndex:(int)begin endIndex:(int)end;

//去掉字符串中的空格
- (NSString *)trim;

//16进制转2进制
- (NSData*)hexToBytes;

/*去除HTML 标签*/
+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;

/*获取当前时间戳*/
+ (NSString *)createTimestamp;

///*获取当前时间戳 , 末尾添加x位随机数*/
//+ (NSString *)createTimestampWithRnd:(int)number;

/*特殊字符转意 : 参数*/
- (NSString *)clearParams;

/*汉字转拼音*/
+ (NSString *)phonetic:(NSString *)sourceString;

//将对象类型转化为字符串类型
+ (NSString *)stringFromat:(id)obj;

/*格式化电话号码*/
+ (NSString *)phoneFormat:(NSString *)phone;

/*是否手机号码*/
+ (BOOL)isPhone:(NSString *)phone;

/*是否座机号码*/
+ (BOOL)isTel:(NSString *)tel;

+ (NSDate *)convertDateFromString:(NSString *)date;

+ (BOOL)isPureInt:(NSString *)string;

+ (NSString *)uuid;

//32位、64位加密
+ (NSString *)md5_32Bit_String:(NSString *)srcString;

+ (NSString*)encodeBase64String:(NSString * )input;

+ (NSString*)decodeBase64String:(NSString * )input;

+ (NSString*)encodeBase64Data:(NSData *)data;

+ (NSString*)decodeBase64Data:(NSData *)data;
@end
