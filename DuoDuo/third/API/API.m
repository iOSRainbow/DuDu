//
//  Api.m
//  HttpWithCacheDemo
//
//  Created by 大有 on 16/6/7.
//  Copyright © 2016年 大有. All rights reserved.
//

#import "Api.h"
@implementation Api
@synthesize httpRequest;

#pragma mark - init方法
//无需token
-(instancetype)init:(id)delegate tag:(NSString *)tag
{
    return [self init:delegate tag:tag NeedToken:0];
}

//携带token
-(instancetype)init:(id)delegate tag:(NSString *)tag NeedToken:(NSInteger)NeedToken
{
    if (self=[super init]) {
        httpRequest=[[HttpRequestWithCache alloc]initWithDelegate:delegate bindTag:tag NeedToken:NeedToken];
    }
    return self;
}

//登录
-(void)Login:(NSString*)userName password:(NSString*)password{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userName forKey:@"userName"];
    [params setObject:password forKey:@"password"];
    [params setObject:@"2" forKey:@"state"];

    [httpRequest httpPostRequest:@"login" params:params];

}

//注册
-(void)Signup:(NSString*)userName password:(NSString*)password gender:(NSString*)gender nickName:(NSString*)nickName{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userName forKey:@"userName"];
    [params setObject:nickName forKey:@"nickName"];
    [params setObject:password forKey:@"password"];
    [params setObject:gender forKey:@"gender"];
    [httpRequest httpPostRequest:@"signup" params:params];
}

//忘记密码
-(void)Reset:(NSString*)userName password:(NSString*)password newpass:(NSString*)newpass{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userName forKey:@"userName"];
    [params setObject:password forKey:@"password"];
    [params setObject:newpass forKey:@"newpass"];
    [httpRequest httpPostRequest:@"reset" params:params];
}

//获取商品信息
-(void)load:(NSString*)goodsId latitude:(NSString*)latitude longitude:(NSString*)longitude{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:goodsId forKey:@"id"];
    [params setObject:latitude forKey:@"latitude"];
    [params setObject:longitude forKey:@"longitude"];
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    if(![LSFEasy isEmpty:token]){
        
        [params setObject:token forKey:@"token"];
    }
    
    [httpRequest httpPostRequest:@"load" params:params];

}


-(void)queryHistory:(NSInteger)pageNum{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [params setObject:token forKey:@"token"];
    [params setObject:[NSNumber numberWithInteger:pageNum] forKey:@"pageNum"];
    [params setObject:[NSNumber numberWithInteger:10] forKey:@"pageSize"];
    [httpRequest httpPostRequest:@"queryHistory" params:params];
}

@end
