//
//  FeileiViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "FeileiViewController.h"
#import "DataModel.h"
#import "CatetoryCell.h"
#import "FeineiDetailViewController.h"
@interface FeileiViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    AFHTTPRequestOperationManager * _manager;
    UICollectionView * _collectionView;
}
@property(nonatomic,strong)UICollectionView  *collectionView;


@end

@implementation FeileiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatViewAndRequset];
    [self firstDown];
    [self creatRefreshing];
    
}
-(void)creatRefreshing{
    __weak typeof(self)weakSelf=self;
    [self.collectionView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefresh) {
            return ;
        }
        weakSelf.isRefresh=YES;
        weakSelf.startPossion=0;
        [weakSelf downloadWithstart:weakSelf.startPossion end:weakSelf.startPossion+20];
    }];
    [self.collectionView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isMore) {
            return ;
        }
        weakSelf.isMore=YES;
        weakSelf.startPossion+=20;
        if (weakSelf.startPossion+20<(int)weakSelf.dataModel.total) {
            [weakSelf downloadWithstart:weakSelf.startPossion end:weakSelf.startPossion+20];
        }else{
            [weakSelf endRefreshing];
        }
    }];
    
}
-(void)endRefreshing{
    if (self.isRefresh) {
        self.isRefresh=NO;
        [self.collectionView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isMore) {
        self.isMore=NO;
        [self.collectionView footerEndRefreshing];
    }
}
-(void)creatViewAndRequset{
    self.dataArr=[[NSMutableArray alloc] init];
    UICollectionViewFlowLayout * layout =[[UICollectionViewFlowLayout alloc] init];
    CGFloat  space=(kSreenSize.width-45)/2;
    layout.itemSize=CGSizeMake(space, space+20);
    layout.sectionInset=UIEdgeInsetsMake(15, 15, 15, 15);
    
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, kSreenSize.height-64-55) collectionViewLayout:layout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor=[UIColor colorWithRed:232/255.f green:232/255.f blue:232/255.f alpha:1.0];
    [self.collectionView registerClass:[CatetoryCell class] forCellWithReuseIdentifier:@"CatetoryCell"];
    [self.view addSubview:self.collectionView];
    _manager=[AFHTTPRequestOperationManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
}
-(void)firstDown{
    [self downloadWithstart:0 end:16];
}
-(void)downloadWithstart:(NSInteger)start end:(NSInteger)end{
    __weak typeof(self)weakSelf=self;
    NSString * str =[NSString stringWithFormat:kCategory,start,end];
    [_manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (start==0) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * dataDict=dict[@"data"];
            DataModel *model=[[DataModel alloc] initWithDictionary:dataDict error:nil];
            self.dataModel=model;
            NSArray * arr=model.catetoryList;
            for (CatetoryListModel * listModel in arr) {
                [weakSelf.dataArr addObject:listModel];
            }
            [weakSelf.collectionView reloadData];
            [weakSelf endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"分类下载失败");
        [weakSelf endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CatetoryCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CatetoryCell" forIndexPath:indexPath];
    CatetoryListModel *model=self.dataArr[indexPath.row];
    
    [cell showDataWithModel:model];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CatetoryListModel * model=self.dataArr[indexPath.row];
    self.myBlock(model);
    //[self.navigationController pushViewController:detail animated:YES];
}
-(void)viewWillShow{
    
}
@end
