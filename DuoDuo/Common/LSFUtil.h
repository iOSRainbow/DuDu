//
//  LSFUtil.h
//  rainbow
//
//  Created by 李世飞 on 17/1/20.
//  Copyright © 2017年 李世飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LSFUtil : NSObject

#pragma  mark 创建UILable
+(UILabel*)labelName:(NSString*)text   fontSize:(CGFloat)font  rect:(CGRect)rect View:(UIView*)viewA Alignment:(NSTextAlignment)alignment Color:(UIColor*)color Tag:(NSInteger)tag;

#pragma  mark 创建UITextField
+(UITextField*)addTextFieldView:(CGRect)rect Tag:(NSInteger)tag  textColor:(UIColor*)color Alignment:(NSTextAlignment)alignment Text:(NSString*)textStr  placeholderStr:(NSString *)placeholderStr View:(UIView*)viewA font:(UIFont*)font;


#pragma  mark 创建UITableView
+(UITableView *)add_tableview:(CGRect)rect Tag:(NSInteger) tag View:(UIView *)ViewA delegate:(id <UITableViewDelegate>)delegate dataSource:(id <UITableViewDataSource>)dataSource;


#pragma  mark 创建UIScrollView
+(UIScrollView *)add_scollview:(CGRect)rect Tag:(NSInteger) tag View:(UIView *)ViewA  co:(CGSize)co;


#pragma  mark 创建一条直线
+(UILabel *)setXianTiao:(UIColor *)color rect:(CGRect)rect view:(UIView *)View;


#pragma mark 创建UIView
+(UIView *)viewWithRect:(CGRect)rect view:(UIView *)viewA backgroundColor:(UIColor *)color;

#pragma mark 创建UIImageView
+(UIImageView*)addSubviewImage:(NSString*)imageName  rect:(CGRect)rect View:(UIView*)viewA Tag:(NSInteger)tag;



@end
