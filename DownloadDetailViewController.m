//
//  DownloadDetailViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "DownloadDetailViewController.h"
#import "NRTabBarViewController.h"
#import "MusicModel.h"
#import "DownloadCell.h"
#import "MySqlite.h"
#import "ListeningViewController.h"
#import "MyControl.h"
@interface DownloadDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DownloadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatView];
    self.isRefresh=NO;
    self.isMore=NO;
    self.startPossion=0;
    UIButton * leftButton=[MyControl creatButtonWithFrame:CGRectMake(0, 0, 25, 25) target:self sel:@selector(butClick:) tag:101 image:@"title_back_white" title:nil];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    //self.navigationItem.backBarButtonItem.tintColor=[UIColor ]
    if (self.model) {
        
    }
    if (self.isDownloadViewController) {
        self.navigationItem.title=[NSString stringWithFormat:@"共%d曲 下载%ld曲",self.model.chapterCnt,self.dataArr.count];
    }else{
        [self firstDown];
        [self creatRefreshing];
        self.navigationItem.title=[NSString stringWithFormat:@"共%d曲",self.model.chapterCnt];
    }
    
}
-(void)creatView{
    self.tabelView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, kSreenSize.height-20) style:UITableViewStylePlain];
    self.tabelView.dataSource=self;
    self.tabelView.delegate=self;
    [self.view addSubview:self.tabelView];
    self.tabelView.tableFooterView=[[UIView alloc] init];
    [self.tabelView registerNib:[UINib nibWithNibName:@"DownloadCell" bundle:nil] forCellReuseIdentifier:@"DownloadCell"];
}
-(void)creatRefreshing{
    __weak typeof(self)weakSelf=self;
    [self.tabelView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefresh) {
            return ;
        }
        weakSelf.isRefresh=YES;
        
        MediaListModel * model=weakSelf.model;
        [weakSelf creatDownHttpRequse:[NSString stringWithFormat:@"%d",model.mediaId] start:0 end:20];
        
    }];
    [self.tabelView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isMore) {
            return ;
        }
        weakSelf.isMore=YES;
        weakSelf.startPossion+=20;
        //NSLog(@"weakSelf.totalCount:%ld",weakSelf.totalCount);
        NSLog(@"totalCount%ld",weakSelf.totalCount);
        NSLog(@"startPossion%ld",weakSelf.startPossion);
        if (weakSelf.startPossion<weakSelf.totalCount) {
            NSLog(@"------");
            MediaListModel * model=weakSelf.model;
            [weakSelf creatDownHttpRequse:[NSString stringWithFormat:@"%d",model.mediaId] start:weakSelf.startPossion end:weakSelf.startPossion+20];
            
        }else{
            [weakSelf endRefreshing];
        }
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicModel * model=self.dataArr[indexPath.row];
    DownloadCell * cell=[tableView dequeueReusableCellWithIdentifier:@"DownloadCell" forIndexPath:indexPath];
    cell.meidiaModel=self.model;
    [cell showDataWithModel:model];
    [cell isWifiDownload:^{
        [self isWIFIAlet];
    }];
    return cell;
}
-(void)isWIFIAlet{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要关闭仅WIFI下载" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消按钮被点击");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsWIFI];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isDownloadViewController) {
        [self jumpListenController];
    }
    
}
-(void)jumpListenController{
    
    ListeningViewController * listen=[[ListeningViewController alloc] initWithNibName:@"ListeningViewController" bundle:nil];
    listen.model=self.model;
    listen.dataArr=self.dataArr;
    MediaListModel * model=self.model;
    NRTabBarViewController * tabber=(NRTabBarViewController *)self.navigationController.tabBarController;
    [tabber.playView sd_setImageWithURL:[NSURL URLWithString:model.coverPic] placeholderImage:[UIImage imageNamed: @"default_play_bg"]];
    model.feinei=kJilv;
    [[MySqlite sharaSqlite] insertDataWithMediaListModel:model];
    
    [self.navigationController pushViewController:listen animated:YES];
    
}
-(void)firstDown{
    MediaListModel * model=self.model;
    self.dataArr=[[NSMutableArray alloc] init];
    [self creatDownHttpRequse:[NSString stringWithFormat:@"%d",model.mediaId] start:0 end:20];
    
}
-(void)creatDownHttpRequse:(NSString *)str start:(NSInteger)start end:(NSInteger)end{
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    __weak typeof(self)weakSelf=self;
    NSString *url =[NSString stringWithFormat:kShiting,start,end,str];
    NSLog(@"------%@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (start==0) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * dataDict=dict[@"data"];
            
            weakSelf.totalCount=[dataDict[@"total"] integerValue];
            NSArray *arr=dataDict[@"contents"];
            
            for (NSDictionary *dict in arr) {
                MusicModel *model=[[MusicModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [weakSelf.dataArr addObject:model];
                
            }
            [weakSelf.tabelView reloadData];
        }
        [weakSelf endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"音乐列表下载失败");
        [weakSelf endRefreshing];
        
    }];
}
-(MusicModel *)findModel:(MusicModel *)model{
    NSArray * arr=[[MySqlite sharaSqlite] findMusicModel];
    for (NSInteger i = 0; i<arr.count; i++) {
        MusicModel *newmodel=arr[i];
        if ([newmodel.filePath isEqualToString:model.filePath]) {
            return model;
        }
    }
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53.0f;
}
-(void)butClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    NRTabBarViewController * tabbr=(NRTabBarViewController *)self.navigationController.tabBarController;
    tabbr.imageView.alpha=1.0;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
    
    NRTabBarViewController * tabbr=(NRTabBarViewController *)self.navigationController.tabBarController;
    tabbr.imageView.alpha=0;
    
}

@end
