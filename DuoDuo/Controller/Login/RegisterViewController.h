//
//  RegisterViewController.h
//  ble sps
//
//  Created by 李世飞 on 17/3/28.
//  Copyright © 2017年 shenhark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : CommonViewController{

    
    UIScrollView * scr;
    UITextField * iphoneText,*passwordText,*aginpasswordText,*nickNameText;
    UIButton * boyBtn,*girlBtn;
    NSString* gender;
    
}
@property(nonatomic,assign)NSInteger type;//1忘记密码，3注册
@end
