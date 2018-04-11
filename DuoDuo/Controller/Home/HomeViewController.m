//
//  HomeViewController.m
//  ble sps
//
//  Created by 李世飞 on 17/3/28.
//  Copyright © 2017年 shenhark. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

//开始定位
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        //        CLog(@"--------开始定位");
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 100;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        [self showHint:@"访问被拒绝"];
        self.ownlatitude=@"31.555888";
        self.ownlongitude=@"120.305718";
    }
    if ([error code] == kCLErrorLocationUnknown) {
        [self showHint:@"无法获取位置信息"];
        self.ownlatitude=@"31.555888";
        self.ownlongitude=@"120.305718";
    }
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    
    self.ownlatitude= [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    self.ownlongitude= [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [self failTimer];
}

-(void)initDataView{
    
    emptView=[LSFUtil viewWithRect:CGRectMake(0, NavigationHeight+10, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationHeight-80) view:self.view backgroundColor:nil];
    
    [LSFUtil addSubviewImage:@"icon_logo" rect:CGRectMake((SCREEN_WIDTH-80)/2, 40, 80, 80) View:emptView Tag:1];

    [LSFUtil labelName:@"欢迎使用嘟嘟防伪" fontSize:16.0 rect:CGRectMake(10, 140, SCREEN_WIDTH-20, 20) View:emptView Alignment:1 Color:gray Tag:2];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"嘟嘟防伪"];
    
    [self startLocation]; //获取用户当前定位
    
    [self buttonPhotoAlignment:nil hilPhoto:nil rect:CGRectMake(SCREEN_WIDTH-90, StatusHeight,90, 44) title:@"读卡" select:@selector(actNavRightBtn) Tag:1 View:navView textColor:white Size:font16 background:nil];

    canRead=NO;//默认不读
    dataArray =[[NSMutableArray alloc] init];
    dataCardB=[[NSMutableData alloc] init];
    self.ownlatitude=@"31.555888";
    self.ownlongitude=@"120.305718";

    //蓝牙初始化
    _mBluetoothUtils = [[BluetoothUtils alloc]init];
    [_mBluetoothUtils initBLE];
    _mBluetoothUtils.delegate = self;
    
     [self initDataView]; //初始界面

        //开始扫描
    scanBtn=[self buttonPhotoAlignment:nil hilPhoto:nil rect:CGRectMake(20, BottomHeight, SCREEN_WIDTH/2-40, 40) title:@"连接设备" select:@selector(Action) Tag:1 View:self.view textColor:white Size:font14 background:MS_RGB(40, 180, 254)];
    scanBtn.layer.cornerRadius=5;
    scanBtn.layer.masksToBounds=YES;
    
    UIButton*btn=[self buttonPhotoAlignment:nil hilPhoto:nil rect:CGRectMake(SCREEN_WIDTH/2+20, BottomHeight, SCREEN_WIDTH/2-40, 40) title:@"我的" select:@selector(MineAction) Tag:2 View:self.view textColor:white Size:font14 background:MS_RGB(40, 180, 254)];
    btn.layer.cornerRadius=5;
    btn.layer.masksToBounds=YES;
}


//查询商品信息
-(void)getData:(NSString*)codeId{
    
    dataCardB=[[NSMutableData alloc] init];

    if([LSFEasy isEmpty:codeId])
    {
        [self showHint:@"卡内信息为空，此卡可能未发卡"];
        return;
    }
  
    [self showHudInView:self.view hint:@"正在获取商品信息"];
    Api * api =[[Api alloc] init:self tag:@"load"];
    [api load:codeId latitude:self.ownlatitude longitude:self.ownlongitude];
}

-(void)MineAction{
   
    NSString * token=[[NSUserDefaults standardUserDefaults] objectForKey:@"token"];

    if([LSFEasy isEmpty:token]){
        
        LoginViewController * login =[[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    MineViewController * m =[[MineViewController alloc] init];
    [self.navigationController pushViewController:m animated:YES];
}

//开始扫描
-(void)Action{
    
    if(scanBtn.tag==2){
        
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"确定断开连接吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alart show];
        
        return;
    }
    
    if(_mBluetoothUtils.CM.state==3){
        
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"请您设置允许「嘟嘟防伪」访问您的蓝牙\n设置>通用>隐私" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        return;
    }
  
    
    [dataArray removeAllObjects];
    dataCardB=[[NSMutableData alloc] init];
    [self showHudInView:self.view hint:@"开始扫描周边蓝牙设备"];
    [_mBluetoothUtils beginScan:3 withServiceUUID:@[[CBUUID UUIDWithString:SPS_SERVICE_UUID]]];
}

#pragma BluetoothUtils Delegate
//扫描结果回掉
- (void)ScanCompleteNotify{

    [self hideHud];
   
    UIActionSheet *portsList = [[UIActionSheet alloc] initWithTitle:@"读卡器列表" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    for (int i=0;i<_mBluetoothUtils.peripherals.count;i++)
    {
        CBPeripheral *peripheral = _mBluetoothUtils.peripherals[i];
        NSString *string = [NSString stringWithFormat:@"%@",peripheral.name];
        [dataArray addObject:string];
        [portsList addButtonWithTitle:string];
    }
    
    if(dataArray.count!=0){
        
        [portsList showInView:self.view];
        
    }else{
        [self showHint:@"未扫描到周边蓝牙设备,请检查蓝牙是否打开"];
    }
    
}

#pragma ActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0) {
        CBPeripheral *p = self.mBluetoothUtils.peripherals[buttonIndex-1];
        [self.mBluetoothUtils connectPeripheral:p];
        [self showHudInView:self.view hint:@"正在连接设备，请稍候..."];
    }
}

//连接失败
- (void)DisconnectNotify{
    
    [self hideHud];
    [self showHint:@"您已断开蓝牙连接"];
    [scanBtn setTitle:@"连接设备" forState:normal];
    scanBtn.tag=1;
}
//发现服务-特征--订阅
- (void)CharacterDiscCompleteNotify{
   
    [self hideHud];
    [self showHint:@"连接成功"];
    [scanBtn setTitle:@"断开连接" forState:normal];
    scanBtn.tag=2;
    [_mBluetoothUtils notification:_mBluetoothUtils.activePeripheral];
}

//区分是那种类型的卡
- (void)DataComeNotify{

    NSData * data =_mBluetoothUtils.readBuffer;
    Byte *table=(Byte*)[data bytes];
    NSInteger countByte= (table[2]&0xff)+4;//计算出返回总字节数
    //同步头为AABB，并且总字长与readBuffer存入的相同,否则return
    if(countByte!=data.length){
        return;
    }
    
    _mBluetoothUtils.readBuffer=[[NSMutableData alloc] init];
    NSLog(@"\n收到蓝牙返回数据：%@\n",data);
    
    if([LSFEasy isEmpty:data]){
        
        [self failTimer];
        return;
    }
    
    Byte *resultBype = (Byte *)[data bytes];
    
    
    //A、156913卡密码校验失败
    if((resultBype[6]==0x07&&resultBype[7]==0x02&&resultBype[8]!=0x00)||(resultBype[6]==0x01&&resultBype[7]==0x20&&resultBype[8]!=0x00)){
        
        [self failTimer];
        [self showHint:@"密码校验错误，此卡可能未发卡"];
        return;
    }
    
    //执行报错
    if(resultBype[8]!=0x00){
        
        [self failTimer];
        [self showHint:@"读卡失败，请重试"];
        return;
    }
    
    //A卡
    if(resultBype[6]==0x02&&resultBype[7]==0x02&&canRead){

        NSLog(@"\nA卡\n");
        
        NSData *data1 = [[NSData alloc]initWithData:[LSFEasy stringToHexData:@"AABB09000000"]];

        Byte  arry  [6] ={0x03,0x02,resultBype[11],resultBype[12],resultBype[13],resultBype[14]};
        NSData * data2 =[NSData dataWithBytes:&arry length:6];
        
        NSData * data3 =[self encodeData:data2];
        
        NSMutableData * sendData=[[NSMutableData alloc] init];//初始化一个可变data
        [sendData appendData:data1];
        [sendData appendData:data2];
        [sendData appendData:data3];

        NSLog(@"\nA卡:发送选择卡片指令 :%@\n",sendData);
        
        //发送选择卡片指令
        [self SendDataIntoBle:sendData];
    }
    else if (resultBype[6]==0x03&&resultBype[7]==0x02){
        
        NSMutableData *data = [[NSMutableData alloc]initWithData:[LSFEasy stringToHexData:@"AABB0D000000070260048C695D6A779450"]];
       
        NSLog(@"\nA卡：发送身份鉴定指令 :%@\n",data);

        //发送身份鉴定指令
        [self SendDataIntoBle:data];
        
    }else if (resultBype[6]==0x07&&resultBype[7]==0x02){
        
        NSMutableData *data = [[NSMutableData alloc]initWithData:[LSFEasy stringToHexData:@"AABB060000000802040E"]];
        
        NSLog(@"\nA卡：发送数据读书指令 :%@\n",data);

        //发送数据读书指令
        [self SendDataIntoBle:data];

    }else if (resultBype[6]==0x08&&resultBype[7]==0x02){
        
        
        [self BleSleep];

        
        Byte cardData[16]= {resultBype[9],resultBype[10],resultBype[11],resultBype[12],resultBype[13],resultBype[14],resultBype[15],resultBype[16],resultBype[17],resultBype[18],resultBype[19],resultBype[20],resultBype[21],resultBype[22],resultBype[23],resultBype[24]};

           NSData * codeData =[NSData dataWithBytes:&cardData length:16];
        
           [self getData:[self getCodeId:codeData]];
        
        return;

    }
    
    //B卡
    else  if(resultBype[6]==0x09&&resultBype[7]==0x05&&canRead){

        NSLog(@"\nB卡\n");
        
        NSMutableData *data = [[NSMutableData alloc]initWithData:[LSFEasy stringToHexData:@"AABB0600000006050704"]];

        NSLog(@"\nB卡: 发送 读数据 读第7块数据 :%@\n",data);
        //发送 读数据 读第7块数据
        [self SendDataIntoBle:data];
    }
    else if(resultBype[6]==0x06&&resultBype[7]==0x05&&resultBype[9]==0x07){

        Byte cardData[4]={resultBype[10],resultBype[11],resultBype[12],resultBype[13]};
     
        NSData * data00 =[NSData dataWithBytes:&cardData length:4];
        [dataCardB appendData:data00];
        
        
        NSMutableData *data = [[NSMutableData alloc]initWithData:[LSFEasy stringToHexData:@"AABB060000000605080B"]];
       
        NSLog(@"\nB卡: 发送 读数据 读第8块数据 :%@\n",data);

        //发送 读数据 读第8块数据
        [self SendDataIntoBle:data];

    }
    else if(resultBype[6]==0x06&&resultBype[7]==0x05&&resultBype[9]==0x08){
    
        Byte cardData[4]={resultBype[10],resultBype[11],resultBype[12],resultBype[13]};

        NSData * data01 =[NSData dataWithBytes:&cardData length:4];
        [dataCardB appendData:data01];
        
        NSMutableData *data = [[NSMutableData alloc]initWithData:[LSFEasy stringToHexData:@"AABB060000000605090A"]];
        
        NSLog(@"\nB卡: 发送 读数据 读第9块数据 :%@\n",data);

        //发送 读数据 读第9块数据
        [self SendDataIntoBle:data];
    }
    else if(resultBype[6]==0x06&&resultBype[7]==0x05&&resultBype[9]==0x09){
        
        Byte cardData[4]={resultBype[10],resultBype[11],resultBype[12],resultBype[13]};
        
        NSData * data02 =[NSData dataWithBytes:&cardData length:4];
        [dataCardB appendData:data02];
        
        NSMutableData *data = [[NSMutableData alloc]initWithData:[LSFEasy stringToHexData:@"AABB0600000006050A09"]];
        
        NSLog(@"\nB卡: 发送 读数据 读第0A块数据 :%@\n",data);
        
        //发送 读数据 读第0A块数据
        [self SendDataIntoBle:data];
    }
    else if(resultBype[6]==0x06&&resultBype[7]==0x05&&resultBype[9]==0x0a){
        
        
        [self BleSleep];

        
        Byte cardData[4]={resultBype[10],resultBype[11],resultBype[12],resultBype[13]};

        NSData * data03 =[NSData dataWithBytes:&cardData length:4];
        [dataCardB appendData:data03];
        
        [self getData:[self getCodeId:dataCardB]];
        
        return;
        
    }
    //15693卡
    else if (resultBype[6]==0x00&&resultBype[7]==0x10&&canRead){

        NSLog(@"\n15693卡\n");
        
        for(int i=0;i<8;i++){
            
            cardId15693[i]=resultBype[10+i];
        }
        NSData *data1 = [[NSData alloc]initWithData:[LSFEasy stringToHexData:@"AABB0D000000"]];
        
        Byte  arry  [10] ={0x03,0x10,cardId15693[0],cardId15693[1],cardId15693[2],cardId15693[3],cardId15693[4],cardId15693[5],cardId15693[6],cardId15693[7]};
        NSData * data2 =[NSData dataWithBytes:&arry length:10];
        
        NSData * data3 =[self encodeData:data2];
        
        NSMutableData * sendData=[[NSMutableData alloc] init];//初始化一个可变data
        [sendData appendData:data1];
        [sendData appendData:data2];
        [sendData appendData:data3];
        
        //发送选择卡片指令
        [self SendDataIntoBle:sendData];
        
    }else if (resultBype[6]==0x03&&resultBype[7]==0x10){
        
        if(0x01==cardId15693[5]){
            
            card15693Type=0;
            
            NSData *data1 = [[NSData alloc]initWithData:[LSFEasy stringToHexData:@"AABB0E000000"]];
            
            Byte  arry  [11] ={0x0C,0x10,0x02,cardId15693[0],cardId15693[1],cardId15693[2],cardId15693[3],cardId15693[4],cardId15693[5],cardId15693[6],cardId15693[7]};
            NSData * data2 =[NSData dataWithBytes:&arry length:11];
            
            NSData * data3 =[self encodeData:data2];
            
            NSMutableData * sendData=[[NSMutableData alloc] init];//初始化一个可变data
            [sendData appendData:data1];
            [sendData appendData:data2];
            [sendData appendData:data3];
            
            //发送标签系统指令
            [self SendDataIntoBle:sendData];
            
        }else if(0x02==cardId15693[5]||0x03==cardId15693[5]){
            
            card15693Type=1;

            NSData *data1 = [[NSData alloc]initWithData:[LSFEasy stringToHexData:@"AABB12000000"]];
            
            Byte  arry  [15] ={0x01,0x20,cardId15693[0],cardId15693[1],cardId15693[2],cardId15693[3],cardId15693[4],cardId15693[5],cardId15693[6],cardId15693[7],0x01,0x8C,0x69,0x5D,0x6A};
            NSData * data2 =[NSData dataWithBytes:&arry length:15];
            
            NSData * data3 =[self encodeData:data2];
            
            NSMutableData * sendData=[[NSMutableData alloc] init];//初始化一个可变data
            [sendData appendData:data1];
            [sendData appendData:data2];
            [sendData appendData:data3];
            
            //发送密码校验指令
            [self SendDataIntoBle:sendData];
        }
        
        
    }
    else if (resultBype[6]==0x0c&&resultBype[7]==0x10){
        
        
        NSData *data1 = [[NSData alloc]initWithData:[LSFEasy stringToHexData:@"AABB10000000"]];
        
        Byte  arry  [13] ={0x05,0x10,0x02,cardId15693[0],cardId15693[1],cardId15693[2],cardId15693[3],cardId15693[4],cardId15693[5],cardId15693[6],cardId15693[7],0x00,0x04};
        NSData * data2 =[NSData dataWithBytes:&arry length:13];
        
        NSData * data3 =[self encodeData:data2];
        
        NSMutableData * sendData=[[NSMutableData alloc] init];//初始化一个可变data
        [sendData appendData:data1];
        [sendData appendData:data2];
        [sendData appendData:data3];
        
        //发送读数据指令
        [self SendDataIntoBle:sendData];
        
    }
    else if (resultBype[6]==0x01&&resultBype[7]==0x20){
        
        //0
        block=0x00;
        NSData *data1 = [[NSData alloc]initWithData:[LSFEasy stringToHexData:@"AABB10000000"]];
        
        Byte  arry  [13] ={0x05,0x10,0x02,cardId15693[0],cardId15693[1],cardId15693[2],cardId15693[3],cardId15693[4],cardId15693[5],cardId15693[6],cardId15693[7],0x00,0x00};
        NSData * data2 =[NSData dataWithBytes:&arry length:13];
        
        NSData * data3 =[self encodeData:data2];
        
        NSMutableData * sendData=[[NSMutableData alloc] init];//初始化一个可变data
        [sendData appendData:data1];
        [sendData appendData:data2];
        [sendData appendData:data3];
        
        //发送读数据指令
        [self SendDataIntoBle:sendData];
    }
    else if (resultBype[6]==0x05&&resultBype[7]==0x10){

        if(card15693Type==0){
            
            [self BleSleep];

            
            Byte cardData[16]={resultBype[9],resultBype[10],resultBype[11],resultBype[12],resultBype[13],resultBype[14],resultBype[15],resultBype[16],resultBype[17],resultBype[18],resultBype[19],resultBype[20],resultBype[21],resultBype[22],resultBype[23],resultBype[24]};
          
            NSData * codeData =[NSData dataWithBytes:&cardData length:16];
           
            [self getData:[self getCodeId:codeData]];

            return;
            
        }
        else if (card15693Type==1){
            
            if(block<0x03){
              
                Byte cardData[4]={resultBype[9],resultBype[10],resultBype[11],resultBype[12]};
              
                NSData * data01 =[NSData dataWithBytes:&cardData length:4];
                [dataCardB appendData:data01];
                
                
                NSData *data1 = [[NSData alloc]initWithData:[LSFEasy stringToHexData:@"AABB10000000"]];
                
                Byte  arry  [13] ={0x05,0x10,0x02,cardId15693[0],cardId15693[1],cardId15693[2],cardId15693[3],cardId15693[4],cardId15693[5],cardId15693[6],cardId15693[7],++block,0x00};
                
                NSData * data2 =[NSData dataWithBytes:&arry length:13];
                
                NSData * data3 =[self encodeData:data2];
                
                NSMutableData * sendData=[[NSMutableData alloc] init];//初始化一个可变data
                [sendData appendData:data1];
                [sendData appendData:data2];
                [sendData appendData:data3];
                
                //发送读数据指令
                [self SendDataIntoBle:sendData];
                
            }else{
                
                [self BleSleep];

                
                Byte cardData[4]={resultBype[9],resultBype[10],resultBype[11],resultBype[12]};

                NSData * data01 =[NSData dataWithBytes:&cardData length:4];
                [dataCardB appendData:data01];
                
                block=0x00;

                [self getData:[self getCodeId:dataCardB]];
                
                return;
            }
        }
        
    }

}


-(NSString*)getCodeId:(NSData*)data{
    
    
    Byte * dataByte = (Byte *)[data bytes];

    NSMutableArray *allArr=[[NSMutableArray alloc] init];
    for(int i=0;i<[data length];i++)
    {
        NSString *hexString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",dataByte[i]]];
        
        if(![hexString isEqualToString:@"0"]||hexString.integerValue!=0){
            
            [allArr addObject:hexString];
        }
    }
    
    NSString * codeId =[allArr componentsJoinedByString:@""];
    NSLog(@"codeId= %@",codeId);
    return [LSFEasy convertHexStrToString:codeId];
}

-(void)actNavRightBtn{
    
   
    if([scanBtn.titleLabel.text isEqualToString:@"连接设备"]){
        
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先点击左下角'连接设备'按键，连接蓝牙读卡器！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        return;
    }
    
    
    canRead=YES;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(ReadCardFailTimer) userInfo:nil repeats:NO];
    
    dataCardB=[[NSMutableData alloc] init];
    
    [self showHudInView:self.view hint:@"请放卡，正在读卡，请稍候..."];

    
   NSMutableData *data1 = [[NSMutableData alloc]initWithData:[LSFEasy stringToHexData:@"AABB05000000556633"]];
    
    NSLog(@"\n发送初始化指令 ：%@\n",data1);
        //发送初始化指令
   [self SendDataIntoBle:data1];
    
}
-(void)ReadCardFailTimer{
    
    [self failTimer];
    [self showHint:@"读卡失败，请重试"];
    dataCardB=[[NSMutableData alloc] init];
}

-(void)failTimer
{
    [self hideHud];
    [timer invalidate];
    timer=nil;
    canRead=NO;
}

-(void)BleSleep{
    
    
    NSMutableData *data = [[NSMutableData alloc]initWithData:[LSFEasy stringToHexData:@"AABB06000000778801FE"]];
    
    NSLog(@"\n读卡成功 发送蜂鸣指令：%@\n",data);
    
    //发送蜂鸣指令
    [self SendDataIntoBle:data];
    [self failTimer];
    
}

-(void)SendDataIntoBle:(NSMutableData*)data{
    
    
    for (int i = 0; i < [data length]; i += 20) {
        // 预加 最大包长度，如果依然小于总数据长度，可以取最大包数据大小
        if ((i + 20) < [data length]) {
            NSString *rangeStr = [NSString stringWithFormat:@"%i,%i", i, 20];
            NSData *subData = [data subdataWithRange:NSRangeFromString(rangeStr)];
            
            [_mBluetoothUtils writeValue:_mBluetoothUtils.activePeripheral data:subData];
            //根据接收模块的处理能力做相应延时
            [NSThread sleepForTimeInterval:0.05];

        }
        else {
            NSString *rangeStr = [NSString stringWithFormat:@"%i,%i", i, (int)([data length] - i)];
            NSData *subData = [data subdataWithRange:NSRangeFromString(rangeStr)];
            
            [_mBluetoothUtils writeValue:_mBluetoothUtils.activePeripheral data:subData];
            
           [NSThread sleepForTimeInterval:0.05];
       
        }
    
    }
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//异或和校验
-(NSData *)encodeData:(NSData*)data{
    Byte *sourceDataPoint = (Byte *)[data bytes];
    Byte  b[1] ={0};
    for(int i=0;i<data.length;i++){
        b[0] = b[0] ^ sourceDataPoint[i]; //然后按位进行异或运算
    }
    NSData * data11 = [NSData dataWithBytes:&b length:sizeof(b)];
    return data11;
}


-(void)Failed:(NSString*)message tag:(NSString*)tag
{
    [self hideHud];
    [self showHint:message];
}
-(void)Sucess:(id)response tag:(NSString*)tag
{
    [self hideHud];
    [self showHint:@"读取成功"];
    [goodDetailView removeFromSuperview];
    [emptView removeFromSuperview];
    goodDetailView=[[GoodDetailView alloc] initWithFrame:CGRectMake(0, NavigationHeight+10, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationHeight-80) dic:response[@"data"]];
    [self.view addSubview:goodDetailView];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==1){
        
        [_mBluetoothUtils.CM cancelPeripheralConnection:_mBluetoothUtils.activePeripheral];
    }
}
@end
