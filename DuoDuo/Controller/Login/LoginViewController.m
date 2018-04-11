//
//  LoginViewController.m
//  ble sps
//
//  Created by 李世飞 on 17/3/28.
//  Copyright © 2017年 shenhark. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "HomeViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:@"登录"];
    
    scr=[LSFUtil add_scollview:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Tag:1 View:self.view co:CGSizeMake(0, NavigationHeight+380)];
    
    [LSFUtil addSubviewImage:@"icon_logo" rect:CGRectMake((SCREEN_WIDTH-80)/2, NavigationHeight+30, 80, 80) View:scr Tag:1];
    
    
    UIView * view =[LSFUtil viewWithRect:CGRectMake(15,NavigationHeight+140, SCREEN_WIDTH-30, 120) view:scr backgroundColor:white];
    
    [LSFUtil labelName:@"手机号" fontSize:15.0 rect:CGRectMake(10,0,60,60) View:view  Alignment:0 Color:black Tag:1];
    
    username_text=[LSFUtil addTextFieldView:CGRectMake(80, 0, view.frame.size.width-90, 60) Tag:1 textColor:black Alignment:0 Text:nil placeholderStr:@"请输入手机号" View:view font:font14];
    
    
    [LSFUtil setXianTiao:ColorHUI rect:CGRectMake(10, 60,view.frame.size.width-20, 1) view:view];
    
    [LSFUtil labelName:@"密码" fontSize:15.0 rect:CGRectMake(10,60,60,60) View:view  Alignment:0 Color:black Tag:1];
    
    password_text=[LSFUtil addTextFieldView:CGRectMake(80, 60, view.frame.size.width-90, 60) Tag:1 textColor:black Alignment:0 Text:nil placeholderStr:@"密码(6-20位)" View:view font:font14];
    password_text.secureTextEntry=YES;
    
    
    
    UIButton * loginBtn=[self buttonPhotoAlignment:nil hilPhoto:nil rect:CGRectMake(15, NavigationHeight+290, SCREEN_WIDTH-30, 40) title:@"登录" select:@selector(Action:) Tag:2 View:scr textColor:white Size:font14 background:MS_RGB(40, 180, 254)];
    loginBtn.layer.cornerRadius=4;
    loginBtn.layer.masksToBounds=YES;
    
    UIButton * registerBtn=[self buttonPhotoAlignment:nil hilPhoto:nil rect:CGRectMake(15, NavigationHeight+340, SCREEN_WIDTH-30, 40) title:@"注册" select:@selector(Action:) Tag:3 View:scr textColor:white Size:font14 background:MS_RGB(40, 180, 254)];
    registerBtn.layer.cornerRadius=4;
    registerBtn.layer.masksToBounds=YES;
    
}

-(void)Action:(UIButton*)btn{
  
    if(btn.tag==3){
    
        RegisterViewController * f =[[RegisterViewController alloc] init];
        f.type=btn.tag;
        [self.navigationController pushViewController:f animated:YES];
    
    }else{
    
        if(![LSFEasy validateMobile:username_text.text]){
        
            [self showHint:@"请输入正确的手机号"];
            return;
        }
        if(password_text.text.length<6||password_text.text.length>20){
        
            [self showHint:@"密码不正确(6-20位)"];
            return;
        }
        
        [self showHudInView:self.view hint:@"加载中"];
        Api * api =[[Api alloc] init:self tag:@"login"];
        [api Login:username_text.text password:[LSFEasy md5:password_text.text]];
        
    
    }
    

}
-(void)Sucess:(id)response tag:(NSString*)tag
{
    [self hideHud];
    if([tag isEqualToString:@"login"]){
    
        
        [self showHint:@"登录成功"];
        
        [[NSUserDefaults standardUserDefaults] setObject:response[@"token"] forKey:@"token"];

        [[NSUserDefaults standardUserDefaults]synchronize];

        [self.navigationController popViewControllerAnimated:YES];
        
    }

}

-(void)Failed:(NSString*)message tag:(NSString*)tag
{
    [self hideHud];
    [self showHint:message];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
