//
//  CommonViewController.h
//  deyingSoft
//
//  Created by GuiDaYou on 16/1/23.
//  Copyright © 2016年 李世飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CommonViewController : UIViewController
{
    UIView *navView;

    UIButton *navLeftBtn;
    UIButton *navRightBtn;
    
    UILabel *navTitleLable;
    BOOL isModal;//是否是模态视图
    
    NSInteger pageIndex;
    NSInteger pageSize;
    

}

#pragma mark - 设置Vc的title
-(void)setNavTitle:(NSString *)title;


#pragma mark - 导航栏2边按钮的响应处理方法
-(void)actNavLeftBtn;
-(void)actNavRightBtn;



//UIButton
-(UIButton*)buttonPhotoAlignment:(NSString*)photo hilPhoto:(NSString*)Hphoto rect:(CGRect)rect  title:(NSString*)title  select:(SEL)sel Tag:(NSInteger)tag View:(UIView*)ViewA textColor:(UIColor*)textcolor Size:(UIFont*)size background:(UIColor *)background;

@end
