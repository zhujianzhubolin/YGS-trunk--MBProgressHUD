#import "NSString+wrapper.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (wrapper)

+ (NSString *)stringForUrlFromPath:(NSString *)path paramaters:(NSDictionary *)paraDic {
    NSMutableString *paraStr = [[NSMutableString alloc] init];
    for (id key in paraDic) {
        [paraStr appendFormat:@"%@=%@", key, [paraDic objectForKey:key]];
        [paraStr appendString:@"&"];
    }
    
    if ([paraStr hasSuffix:@"&"]) {
        [paraStr deleteCharactersInRange:NSMakeRange(paraStr.length - 1, 1)];
    }
    
    NSString *requestURL = [NSString stringWithFormat:@"%@?%@",path,paraStr];
    return requestURL;
}

+ (Boolean) isEmptyOrNull:(NSString *)string {
    if (!string) {
        return YES;
    } else if ([string isEqual:(NSNull *)[NSNull null]]) {
        return YES;
    }else if ([string isEqualToString:@"<null>"]) {
        return YES;
    }else if ([string isEqualToString:@"(null)"]) {
        return YES;
    } else if ([string isEqualToString:@"null"]) {
        return YES;
    }else {
        //去掉两端的空格
        NSString *trimedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

//- (Boolean) isEmptyOrNull {
//    if (!self) {
//        return YES;
//    } else if ([self isEqual:[NSNull null]]) {
//        return YES;
//    } else {
//        NSString *trimedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        if ([trimedString length] == 0) {
//            return YES;
//        } else {
//            return NO;
//        }
//    }
//}

- (NSString *) substringFromIndex:(int)begin endIndex:(int)end {
    if (end <= begin) {
        return @"";
    }
    NSRange range = NSMakeRange(begin, end - begin);
    return  [self substringWithRange:range];
}

- (NSString *)trim {
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *string = [temp mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)string);
    NSString *result = [string copy];
    return result;
}

+ (NSString *)stringFromat:(id)obj {
    return [NSString stringWithFormat:@"%@",obj];
}

- (NSData *)hexToBytes {
    NSMutableData *data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString *hexStr = [self substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

+ (NSString *)createTimestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;
    NSString *timestamp = [NSString stringWithFormat:@"%f", timeInterval];
    timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
    return timestamp;
}

//+ (NSString *)createTimestampWithRnd:(int)number
//{
//    NSString *timestamp = [self createTimestamp];
//    return timestamp;
//}

- (NSString *)clearParams
{
    NSString *clearLeftParenthesis = [self stringByReplacingOccurrencesOfString:@"{" withString:@"%7B"];
    NSString *clearRightParenthesis = [clearLeftParenthesis stringByReplacingOccurrencesOfString:@"}" withString:@"%7D"];
    NSString *result = [clearRightParenthesis stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    return result;
}

+ (NSString *)phonetic:(NSString*)sourceString {
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;
}

+ (NSString *)phoneFormat:(NSString *)phone
{
    NSString *stringResult;
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-9]|7[678]|4[57])\\d{0,8}$";
    NSPredicate *regexMOBILE = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSString *TEL = @"^(0[1|2][0|1|2|3|5|7|8|9])\\d{0,8}$";
    NSPredicate *regexTEL = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", TEL];
    NSString *Tel = @"^(0[3-9][0-9][0-9])\\d{0,8}$";
    NSPredicate *regexTel = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Tel];
    if (phone.length >= 8) {
        if (phone.length >= 9 && ([regexMOBILE evaluateWithObject:phone] == YES)) {
            stringResult = [phone substringWithRange:NSMakeRange(0, 3)];
            stringResult = [stringResult stringByAppendingString:@"-"];
            stringResult = [stringResult stringByAppendingString:[phone substringWithRange:NSMakeRange(3, 4)]];
            stringResult = [stringResult stringByAppendingString:@"-"];
            stringResult = [stringResult stringByAppendingString:[phone substringWithRange:NSMakeRange(7, phone.length - 7)]];
        } else if (phone.length >= 8 && ([regexTEL evaluateWithObject:phone] == YES)) {
            stringResult = [phone substringWithRange:NSMakeRange(0,3)];
            stringResult = [stringResult stringByAppendingString:@"-"];
            stringResult = [stringResult stringByAppendingString:[phone substringWithRange:NSMakeRange(3, phone.length - 3)]];
        } else if (phone.length >= 8 && ([regexTel evaluateWithObject:phone] == YES)) {
            stringResult = [phone substringWithRange:NSMakeRange(0, 4)];
            stringResult = [stringResult stringByAppendingString:@"-"];
            stringResult = [stringResult stringByAppendingString:[phone substringWithRange:NSMakeRange(4, phone.length - 4)]];
        } else {
            stringResult = phone;
        }
    } else {
        stringResult = phone;
    }
    return stringResult;
}

+ (BOOL)isPhone:(NSString *)phone  
{
    NSString *reg = @"^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    if ([predicate evaluateWithObject:phone]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isTel:(NSString *)tel
{
    NSString *reg = @"^(0[3-9][0-9][0-9]|0[1|2][0|1|2|3|5|7|8|9]|[3-9][0-9][0-9])\\d{7,8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    if ([predicate evaluateWithObject:tel]) {
        return YES;
    }
    
    reg = @"^(0[3-9][0-9][0-9]|0[1|2][0|1|2|3|5|7|8|9]|[3-9][0-9][0-9])\\d{3}$";
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    if ([predicate evaluateWithObject:tel]) {
        return YES;
    }
    
    reg = @"^(0[3-9][0-9][0-9]|0[1|2][0|1|2|3|5|7|8|9]|[3-9][0-9][0-9])([-])\\d{7,8}$";
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    if ([predicate evaluateWithObject:tel]) {
        return YES;
    }
    
    reg = @"^(0[3-9][0-9][0-9]|0[1|2][0|1|2|3|5|7|8|9]|[3-9][0-9][0-9])([-])\\d{3}$";
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    if ([predicate evaluateWithObject:tel]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (NSDate *)convertDateFromString:(NSString *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    return [formatter dateFromString:date];
}

+ (NSString *)uuid {
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+ (NSString*)encodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)encodeBase64Data:(NSData *)data {
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64Data:(NSData *)data {
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

//32位MD5加密方式
+ (NSString *)md5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, srcString.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

@end
