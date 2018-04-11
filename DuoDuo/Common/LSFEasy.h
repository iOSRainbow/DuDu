//
//  LSFEasy.h
//  rainbow
//
//  Created by 李世飞 on 17/1/20.
//  Copyright © 2017年 李世飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@interface LSFEasy : NSObject

#pragma mark 判断对象是否为空
+(BOOL)isEmpty:(id)obj;

#pragma mark 手机号正则
+(BOOL)validateMobile:(NSString *)mobileNum;

#pragma mark getHex
+(unsigned char)getHex:(unsigned char[2])value;

#pragma mark stringToHexData
+(NSData *)stringToHexData:(NSString *)string;

#pragma mark 将十六进制的字符串转换成NSString
+(NSString *)convertHexStrToString:(NSString *)str;

#pragma mark md5加密
+(NSString *) md5:(NSString *) input;
@end
