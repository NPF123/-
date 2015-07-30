//
//  FeineiDetailViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "FeineiDetailViewController.h"
#import "CatagoryDetaliCell.h"
#import "AlbumViewController.h"
#import "MyControl.h"
@interface FeineiDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,copy)NSString * cataStr;

@end

@implementation FeineiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.clipsToBounds = YES;
    //[self.navigationController.navigationBar.layer setMasksToBounds:YES];
    NSLog(@"%@",self.model);
    //    UIButton * rightButton=[MyControl creatButtonWithFrame:CGRectMake(0, 0, 30, 30) target:self sel:@selector(butClick:) tag:104 image:@"share.png" title:nil];
    //    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
    [button setBackgroundImage:[UIImage imageNamed: @"title_back_white"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=103;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.title=self.model.name;
    self.cataStr=fPlay;
    
    [self creatView];
    [self downloadWithstart:0 end:20];
    [self creatRefreshing];
}

-(void)creatView{
    self.dataArr=[[NSMutableArray array] init];
    UIView * headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, 44)];
    headView.backgroundColor=[UIColor colorWithRed:255.0/255 green:233.0/255 blue:97.0/255 alpha:1.0];
    CGFloat width=(kSreenSize.width-30)/2;
    NSArray * arr=@[@"最新",@"最热"];
    for (NSInteger i = 0; i<2; i++                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.tag=101+i;
        //[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i==0) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(10+(10+width)*i, 0,width, 44);
        [headView addSubview:button];
    }
    self.tabelView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, kSreenSize.height-60) style:UITableViewStylePlain];
    self.tabelView.tableHeaderView=headView;
    self.tabelView.delegate=self;
    self.tabelView.dataSource=self;
    [self.tabelView registerClass:[CatagoryDetaliCell class] forCellReuseIdentifier:@"CatagoryDetaliCell"];
    [self.view addSubview:self.tabelView];
    
}
-(void)butClick:(UIButton *)button{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    switch (button.tag) {
        case 101:
        {
            UIButton *newButton=(UIButton *)[self.view viewWithTag:102];
            [newButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.cataStr=fPlay;
            [self downloadWithstart:0 end:20];
        }
            break;
        case 102:
        {
            UIButton *newButton=(UIButton *)[self.view viewWithTag:101];
            [newButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.cataStr=fUpdate;
            [self downloadWithstart:0 end:20];
        }
            break;
        case 103:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)downloadWithstart:(NSInteger)start end:(NSInteger)end{
    AFHTTPRequestOperationManager * manger=[AFHTTPRequestOperationManager manager];
    NSLog(@"___%@",self.category);
    NSLog(@"+++%@",self.model);
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString * url=@"";
    if (self.category.length) {
        url=[NSString stringWithFormat:kFeilei,self.category,self.cataStr,start,end];
    }else{
        url=[NSString stringWithFormat:kFeilei,self.model.code,self.cataStr,start,end];
    }
    __weak typeof(self)weakSelf=self;
    NSLog(@"%@",url);
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (start==0) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * dataDict=dict[@"data"];
            DataModel *model=[[DataModel alloc] initWithDictionary:dataDict error:nil];
            self.dataModel=model;
            NSArray * listArr=model.saleList;
            for (SaleListModel * saleModel in listArr) {
                NSArray * mediaArr=saleModel.mediaList;
                MediaListModel * mediaModel=mediaArr[0];
                [weakSelf.dataArr addObject:mediaModel];
            }
            [weakSelf.tabelView reloadData];
            [weakSelf endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf endRefreshing];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CatagoryDetaliCell * cell=[tableView dequeueReusableCellWithIdentifier:@"CatagoryDetaliCell" forIndexPath:indexPath];
    MediaListModel * model=self.dataArr[indexPath.row];
    [cell showDataWith:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MediaListModel *model=self.dataArr[indexPath.row];
    AlbumViewController * album=[[AlbumViewController alloc] init];
    album.model=model;
    [self.navigationController pushViewController:album animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (kSreenSize.width-30)/3+20;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    self.navigationController.navigationBar.hidden=NO;
}

@end
