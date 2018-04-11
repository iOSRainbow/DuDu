//
//  Api.h
//  HttpWithCacheDemo
//
//  Created by 大有 on 16/6/7.
//  Copyright © 2016年 大有. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HttpRequestWithCache.h"

@interface Api : NSObject

@property (nonatomic,strong)  HttpRequestWithCache *httpRequest;

#pragma mark - init方法
//无需token
-(instancetype)init:(id)delegate tag:(NSString *)tag;
//携带token
-(instancetype)init:(id)delegate tag:(NSString *)tag NeedToken:(NSInteger)NeedToken;


//登录
-(void)Login:(NSString*)userName password:(NSString*)password;

//注册
-(void)Signup:(NSString*)userName password:(NSString*)password gender:(NSString*)gender nickName:(NSString*)nickName;

//忘记密码
-(void)Reset:(NSString*)userName password:(NSString*)password newpass:(NSString*)newpass;

//获取商品信息
-(void)load:(NSString*)goodsId latitude:(NSString*)latitude longitude:(NSString*)longitude;

-(void)queryHistory:(NSInteger)pageNum;


@end
