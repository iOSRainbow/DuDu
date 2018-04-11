//
//  MineViewController.m
//  ble sps
//
//  Created by 李世飞 on 17/5/20.
//  Copyright © 2017年 shenhark. All rights reserved.
//

#import "MineViewController.h"
#import "AppDelegate.h"
#import "ModfiyViewController.h"
#import "HistoryListViewController.h"
@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:@"我的嘟嘟"];
    
    NSArray * ary=@[@"嘟查历史记录",@"修改密码"];
    for(int i=0;i<ary.count;i++){
   
        [LSFUtil labelName:ary[i] fontSize:14.0 rect:CGRectMake(10,NavigationHeight+60*i, 200, 60) View:self.view Alignment:0 Color:black Tag:1];
        [LSFUtil setXianTiao:ColorHUI rect:CGRectMake(0, 60+NavigationHeight+60*i, SCREEN_WIDTH, 1) view:self.view];
        
        [self buttonPhotoAlignment:nil hilPhoto:nil rect:CGRectMake(0, NavigationHeight+60*i, SCREEN_WIDTH, 60) title:nil select:@selector(Action:) Tag:i View:self.view textColor:nil Size:nil background:nil];
    }
    
    
   UIButton*btn= [self buttonPhotoAlignment:nil hilPhoto:nil rect:CGRectMake(15,BottomHeight, SCREEN_WIDTH-30, 40) title:@"退出登录" select:@selector(Action:) Tag:3 View:self.view textColor:white Size:font16 background:MS_RGB(40, 180, 254)];
    btn.layer.cornerRadius=5;
    btn.layer.masksToBounds=YES;

}


-(void)Action:(UIButton*)btn{

    if(btn.tag==0){
    
        HistoryListViewController * m =[[HistoryListViewController alloc] init];
        [self.navigationController pushViewController:m animated:YES];
    
    }else if (btn.tag==1){
    
        ModfiyViewController * m =[[ModfiyViewController alloc] init];
        [self.navigationController pushViewController:m animated:YES];
    
    }else{
    
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"是否退出登录?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"token"];
            [[NSUserDefaults standardUserDefaults]synchronize];

            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
