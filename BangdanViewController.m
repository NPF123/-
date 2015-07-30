//
//  BangdanViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "BangdanViewController.h"
#import "VerticalCell.h"
@interface BangdanViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //UITableView * _tabelView;
    // NSMutableArray * _dataArr;
    AFHTTPRequestOperationManager * _manager;
}


@end

@implementation BangdanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatViewAndHttpRequset];
    [self firstDown];
    [self creatRefreshing];
}
-(void)creatViewAndHttpRequset{
    self.dataArr=[[NSMutableArray alloc] init];
    self.tabelView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, kSreenSize.height-64-55) style:UITableViewStylePlain];
    self.tabelView.delegate=self;
    self.tabelView.dataSource=self;
    [self.tabelView registerClass:[VerticalCell class] forCellReuseIdentifier:@"VerticalCell"];
    [self.view addSubview:self.tabelView];
    _manager=[AFHTTPRequestOperationManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
}
-(void)firstDown{
    [self downloadWithstart:0 end:4];
}
-(void)creatRefreshing{
    __weak typeof(self)weakSelf=self;
    [self.tabelView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefresh) {
            return ;
        }
        
        weakSelf.isRefresh=YES;
        weakSelf.startPossion=0;
        [weakSelf downloadWithstart:weakSelf.startPossion end:weakSelf.startPossion+4];
    }];
    
}
-(void)endRefreshing{
    if (self.isRefresh) {
        self.isRefresh=NO;
        [self.tabelView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
}
-(void)downloadWithstart:(NSInteger)start end:(NSInteger)end{
    NSArray * arr=@[bReting,bXiazai,bResou];
    
    __weak typeof(self)weakSelf=self;
    for (NSInteger i = 0; i<arr.count; i++) {
        NSString * str=[NSString stringWithFormat:kBangdan,arr[i],start,end];
        [_manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (responseObject) {
                NSString * categoryStr=arr[i];
                if (start==0&&[categoryStr isEqualToString:bReting]) {
                    [weakSelf.dataArr removeAllObjects];
                }
                NSDictionary *dcit=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *dataDict=dcit[@"data"];
                DataModel * model=[[DataModel alloc] initWithDictionary:dataDict error:nil];
                NSArray * saleListArr=model.saleList;
                NSMutableArray * modelArr=[[NSMutableArray alloc] init];
                for (SaleListModel *model in saleListArr) {
                    NSArray * listModelArr=model.mediaList;
                    for (MediaListModel *listModel in listModelArr) {
                        [modelArr addObject:listModel];
                    }
                }
                [weakSelf.dataArr addObject:modelArr];
            }
            [weakSelf.tabelView reloadData];
            [weakSelf endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"榜单下载失败");
            [weakSelf endRefreshing];
        }];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VerticalCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VerticalCell" forIndexPath:indexPath];
    MediaListModel * model=self.dataArr[indexPath.section][indexPath.row];
    [cell showDataWith:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (kSreenSize.width-40)/3 + 20;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, 40)];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 192, 20)];
    imageView.image=[UIImage imageNamed: [NSString stringWithFormat:@"title_%ld",section+1]];
    view.backgroundColor=[UIColor whiteColor];
    [view addSubview:imageView];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MediaListModel * model =self.dataArr[indexPath.section][indexPath.row];
    self.myBlock(model);
}
-(void)viewWillShow{
    
}

@end
