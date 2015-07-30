//
//  AlbumViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "AlbumViewController.h"
#import "UIImageView+WebCache.h"
#import "myImageView.h"
#import "MyControl.h"
#import "MusicModel.h"
#import "ListeningViewController.h"
#import "MySqlite.h"
#import "NRTabBarViewController.h"
#import "BreakPointHttpRequest.h"
#import "DownloadDetailViewController.h"
#import "UMSocial.h"
#import "LZXHelper.h"
extern NSInteger curCount;
@interface AlbumViewController ()
<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    
    myImageView * _coverPicImagView;
    UILabel * _authorLabel;
    UILabel * _zhuLabel;
    UILabel * _musicCount;
    UILabel * _titleLabel;
    UITableView *_tabelView;
    NSMutableArray * _dataArr;
    
    BOOL _isList;
}

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isMore=NO;
    self.isRefresh=NO;
    self.pushArr=[[NSMutableArray alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    [self creatView];
    
    NSLog(@"album:%@",self.model);
    if ([self.model isKindOfClass:[MediaListModel class]]) {
        [self showHeaderDataWith:self.model];
        [self firstDown];
        
    }else{
        [self downloadMedia];
    }
    [self creatRefreshing];
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
    _isReturn=YES;
    _isList=NO;
    _isMusicList=NO;
    
}
-(void)creatView{
    UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
    [button setBackgroundImage:[UIImage imageNamed: @"title_back_white"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 25, 25);
    [button addTarget:self action:@selector(butClock:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=101;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    UIButton * rightButton=[MyControl creatButtonWithFrame:CGRectMake(0, 0, 25, 25) target:self sel:@selector(butClock:) tag:106 image:@"share.png" title:nil];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.dataArr=[[NSMutableArray alloc] init];
    self.tabelView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, kSreenSize.height-70) style:UITableViewStylePlain];
    self.tabelView.delegate=self;
    self.tabelView.dataSource=self;
    self.tabelView.tableHeaderView=[self creatHeaderView];
    self.tabelView.tableFooterView=[[UIView alloc] init];
    [self.tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    [self.view addSubview:self.tabelView];
}
-(UIView *)creatHeaderView{
    CGFloat space=(kSreenSize.width-40)/3;
    UIButton * collectButton=[MyControl creatButtonWithFrame:CGRectMake(kSreenSize.width-40, space-20, 25, 25) target:self sel:@selector(butClock:) tag:107 image:@"collect" title:nil];
    [collectButton setBackgroundImage:[UIImage imageNamed: @"collect_pressed"] forState:UIControlStateSelected];
    UIView * headerBackView=[[UIView alloc] initWithFrame:CGRectMake(0,0, kSreenSize.width, 70+space+40)];
    [headerBackView addSubview:collectButton];
    headerBackView.backgroundColor=[UIColor colorWithRed:232/255.f green:232/255.f blue:232/255.f alpha:1.0];
    _coverPicImagView=[[myImageView alloc] initWithFrame:CGRectMake(10, 10, space, space)];
    [headerBackView addSubview:_coverPicImagView];
    NSArray *arr=@[@"作者 :",@"主播 :",@"状态 :"];
    for (NSInteger i = 0; i<arr.count; i++) {
        UILabel *label=[MyControl creatLabelWithFrame:CGRectMake(20+space, 10+space/4*(i+1), 14*4, space/4) text:arr[i]];
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor lightGrayColor];
        [headerBackView addSubview:label];
    }
    _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20+space, 10, 200, space/4)];
    _titleLabel.font=[UIFont systemFontOfSize:16];
    [headerBackView addSubview:_titleLabel];
    _authorLabel =[[UILabel alloc] initWithFrame:CGRectMake(20+space+14*3, 10+space/4, 200, space/4)];
    _authorLabel.font=[UIFont systemFontOfSize:14];
    _authorLabel.textColor=[UIColor lightGrayColor];
    [headerBackView addSubview:_authorLabel];
    _zhuLabel =[[UILabel alloc] initWithFrame:CGRectMake(20+space+14*3, 10+space/4*2, 80, space/4)];
    _zhuLabel.font=[UIFont systemFontOfSize:14];
    _zhuLabel.textColor=[UIColor lightGrayColor];
    [headerBackView addSubview:_zhuLabel];
    _musicCount =[[UILabel alloc] initWithFrame:CGRectMake(20+space+14*3, 10+space/4*3, 80, space/4)];
    _musicCount.font=[UIFont systemFontOfSize:14];
    _musicCount.textColor=[UIColor redColor];
    [headerBackView addSubview:_musicCount];
    NSArray * arr1=@[@"试听",@"下载"];
    for (NSInteger i = 0; i<2; i++) {
        UIButton * button=[MyControl creatButtonWithFrame:CGRectMake(10+((kSreenSize.width-40)/2+20)*i, 10+space+10, (kSreenSize.width-40)/2, 40) target:self sel:@selector(butClock:) tag:102+i image:@"botton_03down" title:arr1[i]];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=8;
        button.layer.borderWidth=1;
        button.layer.borderColor=[UIColor orangeColor].CGColor;
        [headerBackView addSubview:button];
    }
    NSArray *arr2=@[@"作品简介",@"作品列表"];
    for (NSInteger i = 0; i<arr2.count; i++) {
        UIButton * button=[MyControl creatButtonWithFrame:CGRectMake(((kSreenSize.width-1)/2 +0.5)*i, 70+space, (kSreenSize.width-1)/2, 39) target:self sel:@selector(butClock:) tag:104+i image:nil title:arr2[i]];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.backgroundColor=[UIColor whiteColor];
        [headerBackView addSubview:button];
        if (i==0) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIView *view1=[[UIView alloc] initWithFrame:CGRectMake((kSreenSize.width-0.5)/2, 70+space+5, 1, 30)];
            view1.backgroundColor=[UIColor blackColor];
            [headerBackView addSubview:view1];
            UIView *view2=[[UIView alloc] initWithFrame:CGRectMake(0, 70+space+39, kSreenSize.width, 0.5)];
            view2.backgroundColor=[UIColor blackColor];
            [headerBackView addSubview:view2];
            
        }
    }
    return headerBackView;
}
-(void)downloadMedia{
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    __weak typeof(self)weakSelf =self;
    NSString *str =[NSString stringWithFormat:kZuiqi,self.model];
    NSLog(@"%@",str);
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary  *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *dataDict=dict[@"data"];
            NSDictionary *mediaSaleDict=dataDict[@"mediaSale"];
            SaleListModel * saleModel=[[SaleListModel alloc] initWithDictionary:mediaSaleDict error:nil];
            
            NSArray * arr=saleModel.mediaList;
            MediaListModel *model=arr[0];
            weakSelf.model=model;
            [weakSelf showHeaderDataWith:model];
            [weakSelf firstDown];
            [weakSelf.tabelView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Media 下载失败");
    }];
}
-(void)showHeaderDataWith:(MediaListModel *)model{
    MusicModel *musicModel=[[MusicModel alloc] init];
    if (model) {
        self.navigationItem.title=model.title;
        musicModel.title=model.descs;
        [self.dataArr addObject:musicModel];
        [_coverPicImagView sd_setImageWithURL:[NSURL URLWithString:model.coverPic] placeholderImage:[UIImage imageNamed: @"default_cover"]];
        _titleLabel.text=model.title;
        _authorLabel.text=model.authorPenname;
        if (model.speaker.length) {
            _zhuLabel.text=model.speaker;
        }else{
            _zhuLabel.text=@"佚名";
        }
        _musicCount.text=[NSString stringWithFormat:@"已更新%d集",model.chapterCnt];
        UIButton * button=(UIButton *)[self.view viewWithTag:107];
        button.selected=[self isShouCang];
        
    }
    
}
-(void)butClock:(UIButton *)button{
    NSLog(@"backButton被点击");
    switch (button.tag) {
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
            break;
        case 102:
        {
            [self jumpListenController];
            
            
        }
            break;
        case 103:
        {
            if (self.model) {
                DownloadDetailViewController *down=[[DownloadDetailViewController alloc] init];
                
                down.model=self.model;
                
                [self.navigationController pushViewController:down animated:YES];
            }else{
                [self isNet];
                
            }
            
        }
            break;
        case 104:
        {
            self.isMusicList=NO;
            [self.dataArr removeAllObjects];
            MediaListModel *model=self.model;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton * newButton=(UIButton *)[self.view viewWithTag:105];
            [newButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            MusicModel * musicModel=[[MusicModel alloc] init];
            musicModel.title=model.descs;
            [self.dataArr addObject:musicModel];
            [self.tabelView reloadData];
            
        }
            break;
        case 105:
        {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton * newButton=(UIButton *)[self.view viewWithTag:104];
            [newButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.isMusicList=YES;
            [self.dataArr removeAllObjects];
            NSLog(@"作品列表");
            
            [self.dataArr addObjectsFromArray:self.pushArr];
            [self.tabelView reloadData];
        }
            break;
        case 106:
        {
            MediaListModel *model=self.model;
            NSString *body = [NSString stringWithFormat:@"宝宝天天听:%@",model.descs];
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"558d1f7067e58eb6a1004a77"
                                              shareText:body
                                             shareImage:[UIImage imageNamed:@"icon.png"]
                                        shareToSnsNames:@[UMShareToSina,UMShareToQzone,UMShareToTencent,UMShareToRenren,UMShareToWechatTimeline,UMShareToEmail,UMShareToDouban,UMShareToSms] delegate:self];
            
        }
            break;
        case 107:
        {
            MediaListModel * myModel=self.model;
            myModel.feinei=kShouCang;
            if (button.selected) {
                button.selected=NO;
                [[MySqlite sharaSqlite] deleteMediaListModel:myModel];
                [self.tabelView reloadData];
            }else{
                button.selected=YES;
                [[MySqlite sharaSqlite] insertDataWithMediaListModel:myModel];
                [self.tabelView reloadData];
            }
        }
            break;
            
        default:
            break;
    }
    //self.navigationController.navigationBar.hidden=YES;
    
}
-(void)isNet{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据没有下载完成请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
    
    //    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    //        NSLog(@"取消按钮被点击");
    //    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"确定按钮被点击");
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)jumpListenController{
    if (self.pushArr.count){
        _isReturn=NO;
        ListeningViewController * listen=[[ListeningViewController alloc] initWithNibName:@"ListeningViewController" bundle:nil];
        listen.model=self.model;
        listen.dataArr=self.pushArr;
        MediaListModel * model=self.model;
        NRTabBarViewController * tabber=(NRTabBarViewController *)self.navigationController.tabBarController;
        [tabber.playView sd_setImageWithURL:[NSURL URLWithString:model.coverPic] placeholderImage:[UIImage imageNamed: @"default_play_bg"]];
        model.feinei=kJilv;
        [[MySqlite sharaSqlite] insertDataWithMediaListModel:model];
        [self.navigationController pushViewController:listen animated:YES];
    }else{
        [self isNet];
        
    }
    
}
-(BOOL)isShouCang{
    if (self.model) {
        MediaListModel * myModel=self.model;
        NSArray * arr=[[MySqlite sharaSqlite] findMediaListModel];
        for (NSInteger i = 0; i<arr.count; i++) {
            MediaListModel * model=arr[i];
            if ([model.feinei isEqualToString:kShouCang]) {
                if (model.saleId-myModel.saleId==0) {
                    return YES;
                }
            }
            
        }
    }
    return NO;
}

-(void)firstDown{
    MediaListModel * model=self.model;
    
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
                [weakSelf.pushArr removeAllObjects];
            }
            NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * dataDict=dict[@"data"];
            
            weakSelf.totalCount=[dataDict[@"total"] integerValue];
            NSArray *arr=dataDict[@"contents"];
            
            for (NSDictionary *dict in arr) {
                MusicModel *model=[[MusicModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [weakSelf.pushArr addObject:model];
                
            }
            if (weakSelf.isMusicList) {
                [weakSelf.dataArr removeAllObjects];
                [weakSelf.dataArr addObjectsFromArray:weakSelf.pushArr];
                [weakSelf.tabelView reloadData];
            }
        }
        [weakSelf endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"音乐列表下载失败");
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
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    MusicModel * model=self.dataArr[indexPath.row];
    cell.textLabel.text=model.title;
    cell.textLabel.numberOfLines=0;
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.textLabel.textColor=[UIColor grayColor];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicModel * model=self.dataArr[indexPath.row];
    if (!model.filePath.length) {
        return [LZXHelper textHeightFromTextString:model.title width:kSreenSize.width fontSize:15];
    }
    return 40.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isMusicList) {
        curCount=indexPath.row;
        [self jumpListenController];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"isrecord:%d",self.isRecord);
    if (self.isRecord) {
        self.navigationController.navigationBar.hidden=NO;
        return;
    }
    if (_isReturn) {
        self.navigationController.navigationBar.hidden=YES;
    }else{
        self.navigationController.navigationBar.hidden=NO;
    }
}
-(void)creatRefreshing{
    __weak typeof(self)weakSelf=self;
    [self.tabelView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefresh) {
            return ;
        }
        
        weakSelf.isRefresh=YES;
        weakSelf.startPossion=0;
        MediaListModel * model=weakSelf.model;
        [weakSelf creatDownHttpRequse:[NSString stringWithFormat:@"%d",model.mediaId] start:weakSelf.startPossion end:weakSelf.startPossion+20];
    }];
    [self.tabelView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isMore) {
            return ;
        }
        weakSelf.isMore=YES;
        weakSelf.startPossion+=20;
        NSLog(@"weakSelf.totalCount:%ld",weakSelf.totalCount);
        NSLog(@"start:%ld",weakSelf.startPossion);
        if (weakSelf.startPossion+20<weakSelf.totalCount) {
            MediaListModel * model=weakSelf.model;
            [weakSelf creatDownHttpRequse:[NSString stringWithFormat:@"%d",model.mediaId] start:weakSelf.startPossion end:weakSelf.startPossion+20];
        }else{
            [weakSelf endRefreshing];
        }
    }];
    
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

@end
