//
//  NSString+Extensions.m
//  netWorkModule
//
//  Created by EGS on 13-8-9.
//  Copyright (c) 2013年 EGS. All rights reserved.
//

#import "NSString+Extensions.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSDate-Utilities.h"


@implementation NSString (Extensions)

static  NSString *LETTER_UPPER             = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static  NSString *LETTER_LOWER             = @"abcdefghijklmnopqrstuvwxyz";
static  NSString *DIGIT                    = @"0123456789";

static  NSString *LETTER_LOWER_DIGIT       = @"abcdefghijklmnopqrstuvwxyz0123456789"; //36  0-->35
static  NSString *LETTER_UPPER_LOWER_DIGIT = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"; //62  0-->61

#pragma mark - date group
//获取当前时间，default format
+ (NSString *)getcurrDate
{
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd EEEE HH:mm:ss a"];
    
    NSString *locationString=[formatter stringFromDate: [NSDate date]];

    return locationString;
}

// linkTo note below ex.  @"yyyy-MM-dd EEEE HH:mm:ss a"
+ (NSString *)getcurrDateWithFormat:(NSString *)strFormat
{
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:strFormat];
    
    NSString *locationString=[formatter stringFromDate: [NSDate date]];
    
    return locationString;
}

//  @"yyyy年MM月dd日 HH时mm分"
+ (NSString *)getDate:(NSDate *)dateGTM0
           WithFormat:(NSString *)defaultFormat
            add8Hours:(BOOL)bol
{
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    if (defaultFormat!=nil) {
        [formatter setDateFormat:defaultFormat];
    }
    else
        [formatter setDateFormat:@"yyyy年MM月dd日"];
    
    //特殊处理：时区问题  +8  ==EGS log
    NSDate * dateGTM8 = [dateGTM0 dateByAddingHours:8];
    if (bol) {
        NSString *locationString8=[formatter stringFromDate: dateGTM8];
        return locationString8;
    }
    
    
    NSString *locationString=[formatter stringFromDate: dateGTM0];
    
    return locationString;
}

//oriStrDate--->tarStr
+ (NSString *)getDateByString:(NSString *)oriStrDate
               originalFormat:(NSString *)oriFormat
                 targetFormat:(NSString *)tarFormat
{
    NSDateFormatter *formatter01 = [[NSDateFormatter alloc] init];
    [formatter01 setDateFormat:oriFormat];
    NSDate *dateMiddle = [formatter01  dateFromString:oriStrDate];
    
    NSDateFormatter *formatter02 = [[NSDateFormatter alloc] init];
    [formatter02 setDateFormat:tarFormat];
    NSString *tarStr = [formatter02 stringFromDate:dateMiddle];
    
    return tarStr;
}

//==》@"yyyy-MM-dd'T'HH:mm:ss.SSSZ'Z'" 马辉版传回的日期格式
+ (NSDate *)getDateByString:(NSString *)dateString
                     Format:(NSString *)format
{
    if (format==nil) {
        format = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ'Z'";
    }
    
    NSDateFormatter *formatter01 = [[NSDateFormatter alloc] init];
    [formatter01 setDateFormat:format];

    formatter01.locale = [NSLocale autoupdatingCurrentLocale];
    
    NSDate *dateGTM0 = [formatter01  dateFromString:dateString];
    
//    //特殊处理：时区问题  -8  ==EGS log
//    NSDate * dateGTM8 = [dateGTM0 dateBySubtractingHours:8];
    
    
    return dateGTM0;
}
+ (NSDate *)getDateByString_no8:(NSString *)dateString
                         Format:(NSString *)format
{
    if (format==nil) {
        format = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ'Z'";
    }
    
    NSDateFormatter *formatter01 = [[NSDateFormatter alloc] init];
    [formatter01 setDateFormat:format];
    
    
    
    NSDate *dateGTM0 = [formatter01  dateFromString:dateString];
    
//    //特殊处理：时区问题  -8  ==EGS log
//    NSDate * dateGTM8 = [dateGTM0 dateBySubtractingHours:8];
//    
    
    return dateGTM0;
}

/*  EGS Log====>format note 
 日期格式如下:
 y  年  Year  1996; 96
 M  年中的月份  Month  July; Jul; 07
 w  年中的周数  Number  27
 W  月份中的周数  Number  2
 D  年中的天数  Number  189
 d  月份中的天数  Number  10
 F  月份中的星期  Number  2
 E  星期中的天数  Text  Tuesday; Tue
 a  Am/pm 标记  Text  PM
 H  一天中的小时数（0-23）  Number  0
 k  一天中的小时数（1-24）  Number  24
 K  am/pm 中的小时数（0-11）  Number  0
 h  am/pm 中的小时数（1-12）  Number  12
 m  小时中的分钟数  Number  30
 s  分钟中的秒数  Number  55
 S  毫秒数  Number  978
 z  时区  General time zone  Pacific Standard Time; PST; GMT-08:00
 Z  时区  RFC 822 time zone  -0800
 */

#pragma mark - encryption MD5\SHA1

- (NSString *) stringFromMD5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString ;
}

- (NSString *)stringFromSHA1 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, strlen(cStr), result);
    NSString *s = [NSString  stringWithFormat:
                   @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                   result[0], result[1], result[2], result[3], result[4],
                   result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11], result[12],
                   result[13], result[14], result[15],
                   result[16], result[17], result[18], result[19]
                   ];
    return [s lowercaseString];
}

- (NSString *) string_TRIM
{
    return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}



#pragma mark --获取随机数 group
+ (NSString *)randomLetters_UPPER:(NSString *)prefix
                                 :(NSInteger)length
{
    int NUMBER_OF_CHARS = length;
    
    char data[NUMBER_OF_CHARS];
    for (int x=0;x<NUMBER_OF_CHARS;data[x++] = (char)('A' + (arc4random_uniform(26))));
    NSString *strTemp = [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
    
    return strTemp;
}

+ (NSString *)randomLetters_LOWER:(NSString *)prefix
                                 :(NSInteger)length
{
    int NUMBER_OF_CHARS = length;
    
    char data[NUMBER_OF_CHARS];
    for (int x=0;x<NUMBER_OF_CHARS;data[x++] = (char)('a' + (arc4random_uniform(26))));
    NSString *strTemp = [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
    
    return strTemp;
}

+ (NSString *)randomLetters_LOWER_NUM:(NSInteger)length
{
    int NUMBER_OF_CHARS = length;
    
    char data[NUMBER_OF_CHARS];
    
    for (int i = 0; i< NUMBER_OF_CHARS; i++) {
        
        int radomInt = [NSString getRandomNumber:0 to:35];
        
        @try {
            unichar cellChar = [LETTER_LOWER_DIGIT characterAtIndex:radomInt];
            
            data[i] = cellChar;
        }
        @catch (NSException *exception) {
            
            DebugLog(@"exception is %@",exception);
        }
        
    }
    
    NSString *strTemp = [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
    
    return strTemp;
}

+ (NSString *)randomLetters_UPPER_LOWER_NUM:(NSInteger)length
{
    int NUMBER_OF_CHARS = length;
    
    char data[NUMBER_OF_CHARS];
    
    for (int i = 0; i< NUMBER_OF_CHARS; i++) {
        
        int radomInt = [NSString getRandomNumber:0 to:61];
        
        @try {
            unichar cellChar = [LETTER_UPPER_LOWER_DIGIT characterAtIndex:radomInt];
            
            data[i] = cellChar;
        }
        @catch (NSException *exception) {
            
            DebugLog(@"exception is %@",exception);
        }
        
    }
    
    NSString *strTemp = [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
    
    return strTemp;
}

#pragma mark --- 获取一个随机整数，范围在[from,to]，包括from，包括to
+ (int)getRandomNumber:(int)from
                    to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

+ (NSString *)getRandomPostManTypeId
{
    
    return [NSString stringWithFormat:@"%@-%@-%@-%@-%@",[NSString randomLetters_LOWER_NUM:8],
            [NSString randomLetters_LOWER_NUM:4],
            [NSString randomLetters_LOWER_NUM:4],
            [NSString randomLetters_LOWER_NUM:4],
            [NSString randomLetters_LOWER_NUM:12]];
    
}


+ (NSString *)URLEncodedString:(NSString *)string
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR("!*'\"();:@&=+$,/?%#[]% "), kCFStringEncodingUTF8));
}

#pragma mark --- 检验手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark --- NSLog输出汉字为16进制表示的解决方法
+ (NSString *)stringByReplaceUnicode:(NSString*)str
{
    NSString *tempStr1 = [str stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    //NSLog(@"Output = %@", returnStr);
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

@end
