//
//  GoodDetailView.h
//  ble sps
//
//  Created by 李世飞 on 2017/11/10.
//  Copyright © 2017年 shenhark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodDetailView : UIView{
    
    UIScrollView * scr;
    NSDictionary *itemDic;

}
-(instancetype)initWithFrame:(CGRect)frame dic:(NSDictionary*)dic;

@end
