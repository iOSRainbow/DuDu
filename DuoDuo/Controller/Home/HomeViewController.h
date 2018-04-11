//
//  HomeViewController.h
//  ble sps
//
//  Created by 李世飞 on 17/3/28.
//  Copyright © 2017年 shenhark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LoginViewController.h"
#import "MineViewController.h"
#import "GoodDetailView.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
@interface HomeViewController : CommonViewController<BluetoothUtilsDelegate,CLLocationManagerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UIButton * scanBtn;
    NSMutableArray * dataArray;
    NSString * blueName;
    BOOL canRead;
    NSMutableData * dataCardB;
    Byte  cardId15693[8];
    NSInteger card15693Type;

    Byte block;
    
    GoodDetailView * goodDetailView;
    
    NSTimer * timer;

    UIView * emptView;
    
}



@property(strong,nonatomic)BluetoothUtils *mBluetoothUtils;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (copy,nonatomic)NSString *ownlatitude;
@property (copy,nonatomic)NSString *ownlongitude;
@end
