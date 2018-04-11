//
//  HistoryListViewController.h
//  ble sps
//
//  Created by 李世飞 on 17/5/20.
//  Copyright © 2017年 shenhark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryListViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView*tableview;
    NSMutableArray*dataArray;
    UILabel * countLable;

}
@end
