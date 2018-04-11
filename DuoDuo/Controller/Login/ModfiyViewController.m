//
//  ModfiyViewController.m
//  ble sps
//
//  Created by 李世飞 on 17/5/20.
//  Copyright © 2017年 shenhark. All rights reserved.
//

#import "ModfiyViewController.h"
#import "AppDelegate.h"

@interface ModfiyViewController ()

@end

@implementation ModfiyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"修改密码"];
    
    NSMutableArray * ary =[[NSMutableArray alloc] init];
    
    [ary addObject:@"手机号"];
    [ary addObject:@"原密码"];
    [ary addObject:@"新密码"];
    [ary addObject:@"新密码"];
    
    UIView * view =[LSFUtil viewWithRect:CGRectMake(15,NavigationHeight+20, SCREEN_WIDTH-30, 200) view:self.view backgroundColor:nil];
    
    for(int i=0;i<ary.count;i++){
        
        [LSFUtil labelName:ary[i] fontSize:14.0f rect:CGRectMake(10, 50*i, 80, 50) View:view Alignment:0 Color:black Tag:i];
        [LSFUtil setXianTiao:ColorHUI rect:CGRectMake(10, 50*i, view.frame.size.width-20, 1) view:i==0?nil:view];
        
    }

    iphoneText=[LSFUtil addTextFieldView:CGRectMake(80,0,view.frame.size.width-80, 50) Tag:1 textColor:black Alignment:0 Text:nil placeholderStr:@"请输入手机号" View:view font:font14];
    
    passwordText=[LSFUtil addTextFieldView:CGRectMake(80,50,view.frame.size.width-80, 50) Tag:1 textColor:black Alignment:0 Text:nil placeholderStr:@"请输入原密码(6-20位)" View:view font:font14];
    
    newpasswordText=[LSFUtil addTextFieldView:CGRectMake(80,100,view.frame.size.width-80, 50) Tag:1 textColor:black Alignment:0 Text:nil placeholderStr:@"新密码(6-20位)" View:view font:font14];
    
    
    aginpasswordText=[LSFUtil addTextFieldView:CGRectMake(80,150,view.frame.size.width-80, 50) Tag:1 textColor:black Alignment:0 Text:nil placeholderStr:@"新密码(6-20位)" View:view font:font14];


    
    UIButton * loginBtn=[self buttonPhotoAlignment:nil hilPhoto:nil rect:CGRectMake(15, NavigationHeight+250, SCREEN_WIDTH-30, 40) title:@"修改" select:@selector(Action:) Tag:1 View:self.view textColor:white Size:font14 background:MS_RGB(40, 180, 254)];
    loginBtn.layer.cornerRadius=4;
    loginBtn.layer.masksToBounds=YES;


}

-(void)Action:(UIButton*)btn{

    if(![LSFEasy validateMobile:iphoneText.text]){
        
        [self showHint:@"请输入正确的手机号"];
        return;
    }
  
    
    if(passwordText.text.length<6||passwordText.text.length>20){
        
        [self showHint:@"原密码不正确(6-20位)"];
        return;
    }
    if(newpasswordText.text.length==0||aginpasswordText.text.length==0){
    
        [self showHint:@"新密码不正确(6-20位)"];
        return;
    }
    if(![newpasswordText.text isEqual:aginpasswordText.text]){
        
        [self showHint:@"新密码输入不一致"];
        return;
    }
    
    [self showHudInView:self.view hint:@"加载中"];
    Api * api =[[Api alloc] init:self tag:@"Reset"];
    [api Reset:iphoneText.text password:[LSFEasy md5:passwordText.text] newpass:[LSFEasy md5:newpasswordText.text]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)Sucess:(id)response tag:(NSString*)tag
{
    [self hideHud];
    [self showHint:@"修改密码成功"];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)Failed:(NSString*)message tag:(NSString*)tag
{
    [self hideHud];
    [self showHint:message];
}

@end
