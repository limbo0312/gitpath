//
//  NSString+Extensions.h
//  netWorkModule
//
//  Created by EGS on 13-8-9.
//  Copyright (c) 2013年 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)
{

}

+ (NSString *)getcurrDate;

// ex.  @"yyyy-MM-dd EEEE HH:mm:ss a"
+ (NSString *)getcurrDateWithFormat:(NSString *)strFormat;
//  @"yyyy年MM月dd日"
+ (NSString *)getDate:(NSDate *)dateGTM0
           WithFormat:(NSString *)defaultFormat
            add8Hours:(BOOL)bol;

//oriStrDate--->tarStr
+ (NSString *)getDateByString:(NSString *)oriStrDate
               originalFormat:(NSString *)oriFormat
                 targetFormat:(NSString *)tarFormat;

+ (NSDate *)getDateByString:(NSString *)dateString
                     Format:(NSString *)format;

+ (NSDate *)getDateByString_no8:(NSString *)dateString
                         Format:(NSString *)format;

/*默认是：  MD5 32位 小写 */
- (NSString *) stringFromMD5;
/*默认是：  sha1  */
- (NSString *)stringFromSHA1;

/*去掉空格*/
- (NSString *) string_TRIM;

/*生成随机：大小写字母*/
+ (NSString *)randomLetters_UPPER:(NSString *)prefix
                                 :(NSInteger)length;
+ (NSString *)randomLetters_LOWER:(NSString *)prefix
                                 :(NSInteger)length;
+ (int)getRandomNumber:(int)from
                    to:(int)to;

+ (NSString *)randomLetters_LOWER_NUM:(NSInteger)length;
+ (NSString *)randomLetters_UPPER_LOWER_NUM:(NSInteger)length;

//postMan id Type radom==>
+ (NSString *)getRandomPostManTypeId;

+ (NSString *)URLEncodedString:(NSString *)string;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;


//====NSLog输出汉字为16进制表示的解决方法
+ (NSString *)stringByReplaceUnicode:(NSString*)str;

@end
