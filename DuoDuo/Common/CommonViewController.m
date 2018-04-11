//
//  CommonViewController.m
//  deyingSoft
//
//  Created by GuiDaYou on 16/1/23.
//  Copyright © 2016年 李世飞. All rights reserved.
//
#import "CommonViewController.h"


@interface CommonViewController ()<UIGestureRecognizerDelegate>

@end

@implementation CommonViewController

//UIButton
-(UIButton*)buttonPhotoAlignment:(NSString*)photo hilPhoto:(NSString*)Hphoto rect:(CGRect)rect  title:(NSString*)title  select:(SEL)sel Tag:(NSInteger)tag View:(UIView*)ViewA textColor:(UIColor*)textcolor Size:(UIFont*)size background:(UIColor *)background {
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setBackgroundImage:[UIImage imageNamed:photo] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:Hphoto] forState:UIControlStateHighlighted];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag=tag;
    [button setTitleColor:textcolor forState:UIControlStateNormal];
    button.titleLabel.font=size;
    button.backgroundColor=background;
    button.contentMode = UIViewContentModeScaleAspectFit;
    
    [ViewA addSubview:button];
    return button;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavView];
    [self initNavTitleView];
    [self addNavBackBtn];
    
    pageIndex=1;
    pageSize=10;
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
    self.automaticallyAdjustsScrollViewInsets=NO;
   
}

-(void)initNavView
{
    //先隐藏系统的导航栏
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=white;
    navView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationHeight)];
    navView.backgroundColor=MS_RGB(40, 180, 254);
    [self.view addSubview:navView];
    
}
-(void)initNavTitleView
{
    navTitleLable=[LSFUtil labelName:nil fontSize:16.0 rect:CGRectMake(80, StatusHeight+12, SCREEN_WIDTH-160, 20) View:navView Alignment:NSTextAlignmentCenter Color:white Tag:0];
    navTitleLable.userInteractionEnabled=NO;
}

- (void)addNavBackBtn
{
    if (!isModal&&self.navigationController.viewControllers[0]==self) {
        return;
    }
    else
    {
       navLeftBtn= [self buttonPhotoAlignment:@"back" hilPhoto:@"back" rect:CGRectMake(5, StatusHeight+7, 30, 30) title:0 select:@selector(actNavBack) Tag:0 View:navView textColor:nil Size:nil background:nil];
    }
    
}

-(void)actNavBack
{
    if (!isModal && self.navigationController) {
        //非模态视图
      
        [self.navigationController popViewControllerAnimated:true];
    }else{
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

#pragma mark - 设置Vc的title
-(void)setNavTitle:(NSString *)title
{
    navTitleLable.text=title;
}

#pragma mark - 导航栏2边按钮的响应处理方法
-(void)actNavLeftBtn
{
    //子类去实现
}

-(void)actNavRightBtn
{
    //子类去实现
}

@end
