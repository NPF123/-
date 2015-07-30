//
//  BaseViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
-(void)addJumpEvent:(jumpBlock)block{
    self.myBlock=block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)creatRefreshing{
    __weak typeof(self)weakSelf=self;
    [self.tabelView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefresh) {
            return ;
        }
        weakSelf.isRefresh=YES;
        weakSelf.startPossion=0;
        [weakSelf downloadWithstart:weakSelf.startPossion end:weakSelf.startPossion+20];
    }];
    [self.tabelView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isMore) {
            return ;
        }
        weakSelf.isMore=YES;
        weakSelf.startPossion+=20;
        //NSLog(@"weakSelf.totalCount:%ld",weakSelf.totalCount);
        if (weakSelf.startPossion < weakSelf.dataModel.total) {
            [weakSelf downloadWithstart:weakSelf.startPossion end:weakSelf.startPossion+20];
        }else{
            [weakSelf endRefreshing];
        }
    }];
    
}
-(void)downloadWithstart:(NSInteger)start end:(NSInteger)end{
    
    
}
-(void)endRefreshing{
    if (self.isRefresh) {
        self.isRefresh=NO;
        [self.tabelView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isMore) {
        self.isMore=NO;
        [self.tabelView footerEndRefreshing];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)creatBackButton{
    UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
    [button setBackgroundImage:[UIImage imageNamed: @"title_back_white"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=103;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];
}
-(void)backButClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
