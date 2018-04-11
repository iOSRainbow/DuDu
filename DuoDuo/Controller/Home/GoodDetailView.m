//
//  GoodDetailView.m
//  ble sps
//
//  Created by 李世飞 on 2017/11/10.
//  Copyright © 2017年 shenhark. All rights reserved.
//

#import "GoodDetailView.h"

@implementation GoodDetailView


-(instancetype)initWithFrame:(CGRect)frame dic:(NSDictionary*)dic{
    
    if(self=[super initWithFrame:frame]){
        
        itemDic=[[NSDictionary alloc] init];
        itemDic=dic;
        scr=[LSFUtil add_scollview:CGRectMake(0, 0, frame.size.width, frame.size.height) Tag:1 View:self co:CGSizeMake(0, 530)];
        [self CreateUI];
    }
    return self;
}

-(void)CreateUI
{
    
    UIImageView * img =[LSFUtil addSubviewImage:nil rect:CGRectMake(15, 20, SCREEN_WIDTH-30, 160) View:scr Tag:1];
    [img sd_setImageWithURL:[NSURL URLWithString:itemDic[@"goodsImage"]] placeholderImage:nil];
    
    NSArray * ary=@[[NSString stringWithFormat:@"商户号: %@",itemDic[@"operatorId"]],[NSString stringWithFormat:@"商品名称: %@",itemDic[@"goodsName"]],[NSString stringWithFormat:@"商品标签[品牌型号]: %@",itemDic[@"goodsBrand"]],[NSString stringWithFormat:@"商品价格: %@",itemDic[@"goodsPrice"]],[NSString stringWithFormat:@"生产日期: %@",itemDic[@"goodsDate"]],[NSString stringWithFormat:@"上次嘟查地址: %@",itemDic[@"goodsPlace"]],[NSString stringWithFormat:@"嘟查次数: %@",itemDic[@"goodsCount"]],[NSString stringWithFormat:@"商品描述: %@",itemDic[@"goodsCode"]]];
    
    for(int i=0;i<ary.count;i++){
        
        [LSFUtil labelName:ary[i] fontSize:14.0 rect:CGRectMake(15, 200+40*i, SCREEN_WIDTH-30, 40) View:scr Alignment:0 Color:gray Tag:1];
        
    }
    
}
@end
