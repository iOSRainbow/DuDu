//
//  BluetoothUtils.m
//  rainbow
//
//  Created by 李世飞 on 17/1/20.
//  Copyright © 2017年 李世飞. All rights reserved.
//

#import "BluetoothUtils.h"

@implementation BluetoothUtils

@synthesize CM,scanTimer,peripherals,devRssi, activePeripheral,readBuffer ;


//初始化蓝牙Center角色
- (int)initBLE{
    
    self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    readBuffer = [[NSMutableData alloc] init];
    
    return 0;
}

//开始扫描设备
- (int) beginScan:(int) timeout withServiceUUID:(NSArray *)uuids{
    NSLog(@"Start scan ble peripherals...\n");
    if (self.CM.state  != CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth not correctly initialized !\r\n");
        if ([self.delegate respondsToSelector:@selector(ScanCompleteNotify)])
        {
            [self.delegate ScanCompleteNotify];
        }
        return -1;
    }
    
    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    [self.peripherals removeAllObjects];
    self.peripherals = nil;//置空
    [self.devRssi removeAllObjects];
    self.devRssi = nil;
    [self.CM scanForPeripheralsWithServices:uuids options:0]; // Start scanning
    return 0; // Started scanning OK !
}


//停止扫描
-(void)stopScan{
    if(self.scanTimer){
        [scanTimer invalidate];
        scanTimer = nil;
    }
    [self.CM stopScan];
}


//扫描结果回调
- (void) scanTimer:(NSTimer *)timer {
    [self.CM stopScan];
    
    if ([self.delegate respondsToSelector:@selector(ScanCompleteNotify)])
    {
        [self.delegate ScanCompleteNotify];
    }
}
//去除重复的蓝牙设备
-(int) samePeripheral:(CBPeripheral *)p1 p2:(CBPeripheral *)p2{
    if (p1 == nil || p2 == nil) {
        NSLog(@"p is nil\n");
        return -1;
    }
    if (p1 == p2) {
        return 1;
    }else{
        return 0;
    }
}


 //注册蓝牙notify ,如果不注册，将收不到蓝牙数据返回
-(void)notification:(CBPeripheral *)p {
    
    for ( CBService *service in p.services ) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:SPS_SERVICE_UUID]]) {
            for (CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPS_CHAR_UUID]])
                {
                    [p setNotifyValue:YES forCharacteristic:characteristic];
                }
                
            }
        }
    }
}



 //向蓝牙发送数据
-(void) writeValue:(CBPeripheral *)p data:(NSData *)data{
    
    [p writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithResponse];
}

//连接蓝牙设备
- (void) connectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Connecting to %@\r\n",peripheral.name);
    activePeripheral = peripheral;
    activePeripheral.delegate = self;
    [CM connectPeripheral:activePeripheral options:nil];
}

//Central Delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!self.peripherals)
        {
            self.peripherals = [[NSMutableArray alloc] initWithObjects:peripheral,nil];
            self.devRssi = [[NSMutableArray alloc]initWithObjects:RSSI, nil];
        }
        else
        {
            for(int i = 0; i < self.peripherals.count; i++)
            {
                CBPeripheral *p = [self.peripherals objectAtIndex:i];
                if ([self samePeripheral:p p2:peripheral])
                {
                    [self.peripherals replaceObjectAtIndex:i withObject:peripheral];
                    [self.devRssi replaceObjectAtIndex:i withObject:RSSI];
                    return;
                }
            }
            [self.peripherals addObject:peripheral];//添加
            [self.devRssi addObject:RSSI];
        
        }
    });
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Connection to  : %@ successfull\r\n",peripheral.name);
        self.activePeripheral = peripheral;
        self.activePeripheral.delegate=self;
        [self.activePeripheral discoverServices:nil];
        NSLog(@"start discover service...");
    });
}


//外设中心回调
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"Disconnect complete!\r\n");
        self.activePeripheral = nil;
        if ([self.delegate respondsToSelector:@selector(DisconnectNotify)])
        {
            [self.delegate DisconnectNotify];
        }
    });
    
}

//发现外设服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!error) {
            
            for (CBService *s in peripheral.services) {
                
                if ([s.UUID isEqual:[CBUUID UUIDWithString:SPS_SERVICE_UUID]]) {
                    [peripheral discoverCharacteristics:nil forService:s];
                    break;
                }
            }
        }
        else {
            NSLog(@"Service discovery was unsuccessfull !\r\n");
        }
        
    });
    
    
}


//发现特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!error) {
            
            for(int i=0; i < service.characteristics.count; i++) {
                CBCharacteristic *c = [service.characteristics objectAtIndex:i];
                if ([c.UUID isEqual:[CBUUID UUIDWithString:SPS_CHAR_UUID]]) {
                    
                    _writeCharacteristic = c;
                    
                    if ([self.delegate respondsToSelector:@selector(CharacterDiscCompleteNotify)]) {
                        [self.delegate CharacterDiscCompleteNotify];
                        
                    }
                    break;
                }
            }
        }
        else {
            NSLog(@"Characteristic discorvery unsuccessfull !\r\n");
        }
        
    });
    
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error {
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
   
}

//蓝牙返回数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
        if(!error){
            
             [readBuffer appendData:characteristic.value];//蓝牙返回数据存入NSData
            if ([self.delegate respondsToSelector:@selector(DataComeNotify)])
            {
                [self.delegate DataComeNotify];//处理数据逻辑
            } 
          
        }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
}






@end
