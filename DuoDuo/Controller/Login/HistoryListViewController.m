//
//  HistoryListViewController.m
//  ble sps
//
//  Created by 李世飞 on 17/5/20.
//  Copyright © 2017年 shenhark. All rights reserved.
//

#import "HistoryListViewController.h"
#import "MJRefresh.h"
@interface HistoryListViewController ()

@end

@implementation HistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"嘟查历史记录"];
    
    dataArray=[[NSMutableArray alloc] init];
    tableview=[LSFUtil add_tableview:CGRectMake(0, NavigationHeight, SCREEN_WIDTH, ViewHeight-50) Tag:1 View:self.view delegate:self dataSource:self];
    
    
    countLable=[LSFUtil labelName:@"嘟查总计: 0" fontSize:16.0 rect:CGRectMake(0,BottomHeight,SCREEN_WIDTH-10,50) View:self.view Alignment:2 Color:black Tag:1];
    
    [LSFUtil setXianTiao:ColorHUI rect:CGRectMake(0, BottomHeight, SCREEN_WIDTH, 1) view:self.view];
    
    
    [self addRefreshView];

    [self refreshData];
    
}
#pragma mark - 添加上拉下拉刷新控件
-(void)addRefreshView
{
    tableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    tableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
-(void)refreshData{

    pageIndex=1;
    [self showHudInView:self.view hint:@"加载中"];
    Api * api =[[Api alloc] init:self tag:@"queryHistory"];
    [api queryHistory:pageIndex];

}
-(void)loadMoreData{

    pageIndex++;
    [self showHudInView:self.view hint:@"加载中"];
    Api * api =[[Api alloc] init:self tag:@"queryHistory"];
    [api queryHistory:pageIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellWithIdentifier];
        
        
        [LSFUtil labelName:nil fontSize:14.0f rect:CGRectMake(10,10, SCREEN_WIDTH-20, 20) View:cell Alignment:0 Color:black Tag:2];

        [LSFUtil labelName:nil fontSize:14.0f rect:CGRectMake(10,30, SCREEN_WIDTH-20, 20) View:cell Alignment:0 Color:black Tag:3];
        
        [LSFUtil labelName:nil fontSize:14.0f rect:CGRectMake(10,50, SCREEN_WIDTH-20, 20) View:cell Alignment:0 Color:black Tag:4];

        [LSFUtil labelName:nil fontSize:14.0f rect:CGRectMake(10,70, SCREEN_WIDTH-20, 20) View:cell Alignment:0 Color:black Tag:5];
        
        [LSFUtil setXianTiao:ColorHUI rect:CGRectMake(0, 99, SCREEN_WIDTH, 1) view:cell];
        
    }
    
    UILabel * name =(UILabel *)[cell viewWithTag:2];
    UILabel * price =(UILabel *)[cell viewWithTag:3];
    UILabel * date =(UILabel *)[cell viewWithTag:4];
    UILabel * address =(UILabel *)[cell viewWithTag:5];
    
    NSDictionary*dic=dataArray[indexPath.row];
    
    name.text=[NSString stringWithFormat:@"商品名称: %@",dic[@"goodsName"]];
    price.text=[NSString stringWithFormat:@"商品价格: %@",dic[@"goodsPrice"]];
    date.text=[NSString stringWithFormat:@"嘟查日期: %@",dic[@"goodsDate"]];
    address.text=[NSString stringWithFormat:@"嘟查地址: %@",dic[@"goodsPlace"]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)Sucess:(id)response tag:(NSString*)tag
{
    [self hideHud];
    
    NSArray * ary=response[@"data"];
    if(pageIndex==1){
        
        [dataArray removeAllObjects];

        dataArray=[ary mutableCopy];
        [tableview.mj_footer resetNoMoreData];
        if(dataArray.count==0){
            tableview.mj_footer.hidden=YES;
        }
        else{
            if(dataArray.count<10){
                tableview.mj_footer.hidden=YES;
            }
            else{
                tableview.mj_footer.hidden=NO;
            }
        }
    }
    else{
        
        tableview.mj_footer.hidden=NO;
        
        if(ary.count<10){
            [tableview.mj_footer endRefreshingWithNoMoreData];
        }else{
            [tableview.mj_footer endRefreshing];
        }
        
        [dataArray addObjectsFromArray:ary];
    }
    
    [tableview.mj_header endRefreshing];
    
    countLable.text=[NSString stringWithFormat:@"嘟查总计: %@",response[@"count"]];
    [tableview reloadData];
    
}
-(void)Failed:(NSString*)message tag:(NSString*)tag
{
    [self hideHud];
    [self showHint:message];
}

@end
