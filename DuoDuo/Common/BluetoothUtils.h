//
//  BluetoothUtils.h
//  rainbow
//
//  Created by 李世飞 on 17/1/20.
//  Copyright © 2017年 李世飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>

@protocol BluetoothUtilsDelegate <NSObject>
@optional
-(void) ScanCompleteNotify;  //扫描结果回调
-(void) CharacterDiscCompleteNotify; //发送通知
-(void) DataComeNotify; //蓝牙返回回调
-(void) DisconnectNotify; //蓝牙状态回调

@end

@interface BluetoothUtils : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic,weak) id <BluetoothUtilsDelegate> delegate;
@property (strong, nonatomic)  NSMutableArray *peripherals;
@property (strong, nonatomic) NSMutableArray *devRssi;
@property (strong, nonatomic) CBCentralManager *CM;//管理中心
@property (strong, nonatomic) NSTimer *scanTimer;
@property (strong, nonatomic) CBPeripheral *activePeripheral;//外设
@property (strong, nonatomic) NSMutableData *readBuffer; //接受返回数据
@property (strong ,nonatomic) CBCharacteristic *writeCharacteristic;

- (int)initBLE;
- (int)beginScan:(int) timeout withServiceUUID:(NSArray *)uuids;
- (void)stopScan;
- (void)connectPeripheral:(CBPeripheral *)peripheral;
-(void) writeValue:(CBPeripheral *)p data:(NSData *)data;
-(void) notification:(CBPeripheral *)p;

@end
