//
//  BaseViewController.h
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "DataModel.h"
#import "JHRefresh.h"

typedef void (^jumpBlock)(id obj);
@interface BaseViewController : UIViewController
{
    UITableView * _tabelView;
    NSMutableArray * _dataArr;
    BOOL _isRefresh;
    BOOL _isMore;
    NSInteger _startPossion;
}

@property(nonatomic)NSInteger totalCount;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)DataModel * dataModel;
@property(nonatomic,strong)UITableView *tabelView;
@property(nonatomic,copy)jumpBlock myBlock;
@property(nonatomic)BOOL isRefresh;
@property(nonatomic)BOOL isMore;
@property(nonatomic)NSInteger startPossion;
-(void)addJumpEvent:(jumpBlock)block;
-(void)downloadWithstart:(NSInteger)start end:(NSInteger)end;
-(void)creatRefreshing;
-(void)endRefreshing;
-(void)creatBackButton;


@end
