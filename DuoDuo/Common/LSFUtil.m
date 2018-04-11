//
//  LSFUtil.m
//  rainbow
//
//  Created by 李世飞 on 17/1/20.
//  Copyright © 2017年 李世飞. All rights reserved.
//

#import "LSFUtil.h"

@implementation LSFUtil


#pragma  mark 创建UILable
+(UILabel*)labelName:(NSString*)text   fontSize:(CGFloat)font  rect:(CGRect)rect View:(UIView*)viewA Alignment:(NSTextAlignment)alignment Color:(UIColor*)color Tag:(NSInteger)tag{
    UILabel*label=[[UILabel alloc]initWithFrame:rect];
    label.text=text;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=alignment;
    label.textColor=color;
    label.numberOfLines=0;
    label.lineBreakMode=NSLineBreakByTruncatingTail;
    label.font = [UIFont systemFontOfSize:font];
    label.tag=tag;
    [viewA addSubview:label];
    
    return label;
}



#pragma  mark 创建UITextField
+(UITextField*)addTextFieldView:(CGRect)rect Tag:(NSInteger)tag  textColor:(UIColor*)color Alignment:(NSTextAlignment)alignment Text:(NSString*)textStr  placeholderStr:(NSString *)placeholderStr View:(UIView*)viewA font:(UIFont*)font{
    UITextField*textM=[[UITextField alloc] initWithFrame:rect];
    [textM setBackgroundColor:[UIColor clearColor]];
    [textM setTextColor:color];
    textM.tag=tag;
    textM.placeholder =placeholderStr;
    textM.font=font;
    textM.text=textStr;
    textM.autocapitalizationType=UITextAutocapitalizationTypeNone;
    textM.textAlignment = alignment;

    [viewA addSubview:textM];
    return textM;
}


#pragma  mark 创建UITableView
+(UITableView *)add_tableview:(CGRect)rect Tag:(NSInteger) tag View:(UIView *)ViewA delegate:(id <UITableViewDelegate>)delegate dataSource:(id <UITableViewDataSource>)dataSource{

    UITableView * tableview =[[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableview.delegate=delegate;
    tableview.dataSource=dataSource;
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableview.tag=tag;
    tableview.backgroundColor=[UIColor clearColor];
    [ViewA addSubview:tableview];
    return tableview;
}


#pragma  mark 创建UIScrollView
+(UIScrollView *)add_scollview:(CGRect)rect Tag:(NSInteger) tag View:(UIView *)ViewA  co:(CGSize)co{

    UIScrollView * scrll=[[UIScrollView alloc] initWithFrame:rect];
    scrll.tag=tag;
    scrll.scrollEnabled=YES;
    scrll.contentSize=co;
    [ViewA addSubview:scrll];
    return scrll;
}

#pragma  mark 创建一条直线
+(UILabel *)setXianTiao:(UIColor *)color rect:(CGRect)rect view:(UIView *)View{

    UILabel * lable = [[UILabel alloc] initWithFrame:rect];
    lable.backgroundColor=color;
    [View addSubview:lable];
    return lable;
}

#pragma mark 创建UIView
+(UIView *)viewWithRect:(CGRect)rect view:(UIView *)viewA backgroundColor:(UIColor *)color{

    UIView *view=[[UIView alloc]init];
    view.frame=rect;
    view.backgroundColor=color;
    [viewA addSubview:view];
    return view;
}


#pragma mark 创建UIImageView
+(UIImageView*)addSubviewImage:(NSString*)imageName  rect:(CGRect)rect View:(UIView*)viewA Tag:(NSInteger)tag{

    UIImageView*view=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    view.frame=rect;
    view.userInteractionEnabled=YES;
    view.tag=tag;
    view.contentMode=UIViewContentModeScaleAspectFill;
    view.clipsToBounds=YES;
    [viewA addSubview:view];
    return view;
}


@end
