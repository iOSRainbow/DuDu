//
//  LSFEasy.m
//  rainbow
//
//  Created by 李世飞 on 17/1/20.
//  Copyright © 2017年 李世飞. All rights reserved.
//

#import "LSFEasy.h"

@implementation LSFEasy



#pragma mark 判断对象是否为空
+(BOOL)isEmpty:(id)obj
{
    if(obj == nil)
    {
        return YES;
    }
    else if([obj isKindOfClass:[NSString class]])
    {
        NSString *objStr = (NSString *)obj;
        if ([objStr isEqual:@""])
        {
            return YES;
        }
        if(objStr.length == 0)
        {
            return YES;
        }
    }
   
    else if([obj isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else
    {
    }
    return NO;
}

#pragma mark 手机号正则
+(BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[01235-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    //虚拟运行商号段
    NSString *VT=@"^17\\d{9}";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestvt=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",VT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        ||([regextestvt evaluateWithObject:mobileNum]==YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark getHex
+(unsigned char)getHex:(unsigned char[2])value{
    unsigned char tH = value[0],tL = value[1];
    unsigned char vH,vL;
    if (tH >= '0' && tH <= '9') {
        vH = tH - '0';
    }else if (tH >= 'a' && tH <= 'f'){
        vH = tH - 'a' + 10;
    }else {
        vH = tH - 'A' + 10;
    }
    
    if (tL >= '0' && tL <= '9') {
        vL = tL - '0';
    }else if (tL >= 'a' && tL <= 'f'){
        vL = tL - 'a' + 10;
    }else {
        vL = tL - 'A' + 10;
    }
    
    unsigned char h = vH<<4,l = vL;
    unsigned char rV = h|l;
    return rV;
}

#pragma mark stringToHexData
+(NSData *)stringToHexData:(NSString *)string{
    NSMutableData *returnData = [[NSMutableData alloc] init];
    const char *temp = [string UTF8String];
    unsigned long len = strlen(temp);
    for (int i = 0; i < len; i+=2) {
        unsigned char doubleChar[2];
        if (i<len) {
            doubleChar[0] = temp[i];
        }
        if (i+1<len) {
            doubleChar[1] = temp[i+1];
        }
        
        unsigned char temp = [self getHex:doubleChar];
        [returnData appendData:[NSData dataWithBytes:&temp length:1]];
    }
    return [NSData dataWithData:returnData];
}

#pragma mark 将十六进制的字符串转换成NSString
+(NSString *)convertHexStrToString:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    NSString *string = [[NSString alloc]initWithData:hexData encoding:NSUTF8StringEncoding];
    return string;
}

#pragma mark md5加密
+(NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:32];
    
    for(int i = 0; i < 16; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return  output;
}

@end
