//
//  RegisterViewController.m
//  ble sps
//
//  Created by 李世飞 on 17/3/28.
//  Copyright © 2017年 shenhark. All rights reserved.
//

#import "RegisterViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"注册"];
    scr=[LSFUtil add_scollview:CGRectMake(0, NavigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64) Tag:1 View:self.view co:CGSizeMake(0, 310)];
    
    
    UIView * view =[LSFUtil viewWithRect:CGRectMake(15,20, SCREEN_WIDTH-30, 250) view:scr backgroundColor:white];
    
    NSMutableArray * ary =[[NSMutableArray alloc] init];
  
    [ary addObject:@"用户名"];
    [ary addObject:@"昵称"];
    [ary addObject:@"性别"];
    [ary addObject:@"密码"];
    [ary addObject:@"确认密码"];
    
    
    for(int i=0;i<ary.count;i++){
        
        [LSFUtil labelName:ary[i] fontSize:14.0f rect:CGRectMake(10, 50*i, 80, 50) View:view Alignment:0 Color:black Tag:i];
        [LSFUtil setXianTiao:ColorHUI rect:CGRectMake(10, 50*i, view.frame.size.width-20, 1) view:i==0?nil:view];
        
    }
    
    iphoneText=[LSFUtil addTextFieldView:CGRectMake(80,0,view.frame.size.width-80, 50) Tag:1 textColor:black Alignment:0 Text:nil placeholderStr:@"请输入手机号" View:view font:font14];
    
    nickNameText=[LSFUtil addTextFieldView:CGRectMake(80,50,view.frame.size.width-80, 50) Tag:1 textColor:black Alignment:0 Text:nil placeholderStr:@"请输入昵称" View:view font:font14];

    
    
    boyBtn=[self buttonPhotoAlignment:nil hilPhoto:nil rect:CGRectMake(80, 100+10,60, 30) title:@"男" select:@selector(SexAction:) Tag:1 View:view  textColor:MS_RGB(40, 180, 254)  Size:font14  background:nil];
    boyBtn.layer.cornerRadius=5;
    boyBtn.layer.masksToBounds=YES;
    boyBtn.layer.borderColor= [MS_RGB(40, 180, 254) CGColor];
    boyBtn.layer.borderWidth=1;
    gender=@"男";
    
    
    girlBtn=[self buttonPhotoAlignment:nil hilPhoto:nil rect:CGRectMake(170, 100+10,60, 30) title:@"女" select:@selector(SexAction:) Tag:2 View:view  textColor:gray  Size:font14  background:nil];
    girlBtn.layer.cornerRadius=5;
    girlBtn.layer.masksToBounds=YES;
    girlBtn.layer.borderColor= [gray CGColor];
    girlBtn.layer.borderWidth=1;

    
    
    passwordText=[LSFUtil addTextFieldView:CGRectMake(80,150,view.frame.size.width-80, 50) Tag:1 textColor:black Alignment:0 Text:nil placeholderStr:@"密码(6-20位)" View:view font:font14];
    
    aginpasswordText=[LSFUtil addTextFieldView:CGRectMake(80,200,view.frame.size.width-80, 50) Tag:1 textColor:black Alignment:0 Text:nil placeholderStr:@"确认密码(6-20位)" View:view font:font14];


    UIButton * loginBtn=[self buttonPhotoAlignment:nil hilPhoto:nil rect:CGRectMake(15, 300, SCREEN_WIDTH-30, 40) title:@"注册" select:@selector(Action:) Tag:1 View:scr textColor:white Size:font14 background:MS_RGB(40, 180, 254)];
    loginBtn.layer.cornerRadius=4;
    loginBtn.layer.masksToBounds=YES;

}

-(void)SexAction:(UIButton*)btn{

    if(btn.tag==1){
    
        boyBtn.layer.borderColor= [MS_RGB(40, 180, 254) CGColor];
        [boyBtn setTitleColor:MS_RGB(40, 180, 254) forState:normal];
        girlBtn.layer.borderColor= [gray CGColor];
        [girlBtn setTitleColor:gray forState:normal];
        gender=@"男";

    
    }else{
    
        
        girlBtn.layer.borderColor= [MS_RGB(40, 180, 254) CGColor];
        [girlBtn setTitleColor:MS_RGB(40, 180, 254) forState:normal];
        boyBtn.layer.borderColor= [gray CGColor];
        [boyBtn setTitleColor:gray forState:normal];
        gender=@"女";

        
    }

}
-(void)Action:(UIButton*)btn{


   
    
        if(![LSFEasy validateMobile:iphoneText.text]){
            
            [self showHint:@"请输入正确的手机号"];
            return;
        }
    if(nickNameText.text.length==0){
    
        [self showHint:@"昵称不能为空"];
        return;
    }
        
        if(passwordText.text.length<6||passwordText.text.length>20){
            
            [self showHint:@"密码不正确(6-20位)"];
            return;
        }
        if(![passwordText.text isEqual:aginpasswordText.text]){
            
            [self showHint:@"密码输入不一致"];
            return;
        }
        
        [self showHudInView:self.view hint:@"加载中"];
        Api * api =[[Api alloc] init:self tag:@"signup"];
        [api Signup:iphoneText.text password:[LSFEasy md5:passwordText.text] gender:gender nickName:nickNameText.text];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Sucess:(id)response tag:(NSString*)tag
{
    [self hideHud];
  
    if([tag isEqualToString:@"signup"]){
    
        [self showHint:@"注册成功"];
    }
   
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)Failed:(NSString*)message tag:(NSString*)tag
{
    [self hideHud];
    [self showHint:message];
    
}

@end
