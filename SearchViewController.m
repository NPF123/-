//
//  SearchViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "SearchViewController.h"
#import "NRTabBarViewController.h"
#import "CatagoryDetaliCell.h"
#import "AlbumViewController.h"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate>
{
    UISearchController *_searchController;
    UISearchBar * _searchBar;
    
}
@property (nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,copy)NSString * textStr;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isRefresh=NO;
    self.isMore=NO;
    self.totalCount=0;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBar.backgroundColor=[UIColor colorWithRed:255/255.f green:233/255.f blue:97/255.f  alpha:1.0];
    self.navigationItem.title=@"搜索";
    self.view.backgroundColor=[UIColor whiteColor];
    [self creatBackbutton];
    [self creatView];
    [self creatRefreshing];
    
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
        if (weakSelf.startPossion<weakSelf.totalCount) {
            [weakSelf downloadWithstart:weakSelf.startPossion end:weakSelf.startPossion+20];
        }else{
            [weakSelf endRefreshing];
        }
    }];
    
}
-(void)creatBackbutton{
    UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=CGRectMake(0, 0, 25, 25);
    [button setBackgroundImage:[UIImage imageNamed: @"title_back_white"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];
}
-(void)butClick:(UIButton *)button{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}
-(void)creatView{
    self.dataArr=[[NSMutableArray alloc] init];
    self.tabelView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, kSreenSize.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    
    self.tabelView.dataSource=self;
    self.tabelView.delegate=self;
    [self.view addSubview:self.tabelView];
    self.searchController=[[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.delegate=self;
    self.searchController.searchResultsUpdater=self;
    self.searchController.searchBar.backgroundColor=[UIColor colorWithRed:255/255.f green:233/255.f blue:97/255.f  alpha:1.0];
    //self.searchController.dimsBackgroundDuringPresentation = YES;
    self.tabelView.tableHeaderView=self.searchController.searchBar;
    self.searchController.searchBar.placeholder=@"作者/书名/演播者";
    [self.tabelView registerClass:[CatagoryDetaliCell class] forCellReuseIdentifier:@"CatagoryDetaliCell"];
    [self.searchController.searchBar sizeToFit];
    self.tabelView.tableFooterView=[[UIView alloc] init];
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [self.dataArr removeAllObjects];
    if (searchController.searchBar.text.length) {
        self.textStr=searchController.searchBar.text;
        [self downloadWithstart:0 end:20];
    }
    
}
-(void)willDismissSearchController:(UISearchController *)searchController{
    [self.dataArr removeAllObjects];
    if (searchController.searchBar.text.length) {
        self.textStr=searchController.searchBar.text;
        [self downloadWithstart:0 end:20];
    }
    
}
-(void)downloadWithstart:(NSInteger)start end:(NSInteger)end{
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSString *url=[NSString stringWithFormat:kSearchResult,self.textStr,(long)start,(long)end];
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",url);
    __weak typeof(self)weakSelf=self;
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * dataDict=dict[@"data"];
            weakSelf.totalCount=[dict[@"totalCount"] integerValue];
            NSArray *arr=dataDict[@"searchList"];
            for (NSDictionary * dict in arr) {
                MediaListModel * model=[[MediaListModel alloc] init];
                model.title=dict[@"title"];
                model.authorPenname=dict[@"author"];
                model.chapterCnt=(int)dict[@"chapterCnt"];
                model.mediaId=[dict[@"mediaId"] intValue];
                
                model.saleId=[dict[@"saleId"] intValue];
                model.coverPic=dict[@"mediaPic"];
                model.descs=dict[@"description"];
                model.categorys=dict[@"category"];
                [weakSelf.dataArr addObject:model];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (kSreenSize.width-40)/3+20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MediaListModel * model=self.dataArr[indexPath.row];
    AlbumViewController * album=[[AlbumViewController alloc] init];
    album.model=model;
    [self.navigationController pushViewController:album animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.hidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // self.navigationController.navigationBar.hidden=YES;
    
}


@end
