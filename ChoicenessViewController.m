//
//  ChoicenessViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "ChoicenessViewController.h"
#import "JHRefresh.h"
#import "LBTView.h"
#import "HorizontalView.h"
#import "myImageView.h"
#import "UIImageView+WebCache.h"
#import "DataModel.h"
#import "VerticalCell.h"
#import "AlbumViewController.h"
@interface ChoicenessViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //AFHTTPRequestOperationManager * _manager;
    UIScrollView * _scrollView;//头滚动视图
    LBTView * _lbtView;       //滚动button
    HorizontalView * _weiNi;  //为你推荐
    HorizontalView * _meiRi;  //每日精选
    myImageView * _gelinImagView;//单个图片
    BOOL _isRefresh;
    UITableView * _tableView;
    NSMutableArray * _dataArr;
}
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)LBTView * lbtView;
//@property(nonatomic)BOOL isRefresh;
@property(nonatomic,strong)myImageView * gelinImagView;
@property(nonatomic,strong)UITableView *tableView;
//@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation ChoicenessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isRefresh=NO;
    
    [self creatSrollView];
    //[self creatRefresh];
    [self creatView];
}
#pragma mark 创建滚动视图

-(void)creatSrollView{
    
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, kSreenSize.height-64-55)];
    _scrollView.backgroundColor=[UIColor colorWithRed:232/255.f green:232/255.f blue:232/255.f alpha:1.0];
    [self.view addSubview:_scrollView];
    _scrollView.bounces=NO;
    _scrollView.showsHorizontalScrollIndicator= NO;
    _scrollView.showsVerticalScrollIndicator= NO;
}
#pragma mark 创建各种视图

-(void)creatView{
    
    self.lbtView=[[LBTView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, kSreenSize.width/720*200+40)];
    [_scrollView addSubview:self.lbtView];
    _weiNi=[[HorizontalView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lbtView.frame)+10,kSreenSize.width, 200)];
    [_scrollView addSubview:_weiNi];
    _meiRi=[[HorizontalView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_weiNi.frame)+10, kSreenSize.width, 200)];
    [_scrollView addSubview:_meiRi];
    _gelinImagView=[[myImageView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_meiRi.frame), kSreenSize.width, kSreenSize.width/720*200)];
    _gelinImagView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:_gelinImagView];
    CGFloat space=(kSreenSize.width-40)/3;
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_gelinImagView.frame), kSreenSize.width,20+40*2+(space+20)*6) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.bounces=NO;
    [_scrollView addSubview:self.tableView];
    [self.tableView registerClass:[VerticalCell class] forCellReuseIdentifier:@"VerticalCell"];
    _scrollView.contentSize=CGSizeMake(kSreenSize.width,CGRectGetMaxY(self.tableView.frame));
    self.dataArr=[[NSMutableArray alloc] init];
    [self downloadData];
    
}
-(void)downloadData{
    __weak typeof(self)weakself=self;
    
    //让每一个类 自己下载自己的东西，用block 把URL传过去
    NSString * weiniStr=[NSString stringWithFormat:kTujian,tWeini,(long)0,(long)2];
    [_weiNi showDataWithURL:weiniStr block:^(MediaListModel *model) {
        weakself.myBlock(model);
    }];
    [self.lbtView showDataWith:kLBT myBlock:^(NSString *string) {
        weakself.myBlock(string);
    }];
    NSString * meiriStr=[NSString stringWithFormat:kTujian,tMeiri,(long)0,(long)2];
    [_meiRi showDataWithURL:meiriStr block:^(MediaListModel *model) {
        weakself.myBlock(model);
    }];
    NSArray * arr=@[tShuiqian,tZuiai];
    for (NSInteger i = 0; i<arr.count; i++) {
        [self downloadTablViewDatawith:arr[i]];
    }
    [self downLoadGeli];
}
-(void)downloadTablViewDatawith:(NSString *)url{
    NSString * str=[NSString stringWithFormat:kTujian,url,(long)0,(long)2];
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    __weak typeof(self)weakSelf=self;
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSMutableArray * mutableArr=[[NSMutableArray alloc] init];
            NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDict=dict[@"data"];
            DataModel * dataModel=[[DataModel alloc] initWithDictionary:dataDict error:nil];
            NSArray * saleListArr=dataModel.saleList;
            for (SaleListModel *model in saleListArr) {
                NSArray * listModelArr=model.mediaList;
                for (MediaListModel *listModel in listModelArr) {
                    [mutableArr addObject:listModel];
                }
            }
            [weakSelf.dataArr addObject:mutableArr];
            if (weakSelf.dataArr.count==2) {
                [weakSelf.tableView reloadData];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"tableViewData down failed");
    }];
}

-(void)downLoadGeli{
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    __weak typeof(self)weakSelf=self;
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:kGGT parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * dataDict=dict[@"data"];
            NSString * blockStr=dataDict[@"block"];
            NSData *data=[blockStr dataUsingEncoding:NSUTF8StringEncoding];
            dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray * arr=dataDict[@"data"];
            
            NSDictionary * datail=arr[0];
            
            [weakSelf.gelinImagView sd_setImageWithURL:[NSURL URLWithString:datail[@"img"]] placeholderImage: [UIImage imageNamed: @"botton_03down"]];
            __weak typeof(weakSelf)mySelf =weakSelf;
            [weakSelf.gelinImagView addEvent:^(UIImageView *imageView) {
                mySelf.myBlock(datail[@"saleId"]);
            }];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)creatRefresh{
    __weak typeof(self)weakSelf=self;
    [_scrollView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefresh) {
            return;
        }
        weakSelf.isRefresh=YES;
        [weakSelf downloadData];
    }];
}

-(void)endRefresh{
    self.isRefresh=NO;
    [_scrollView headerEndRefreshingWithResult:JHRefreshResultSuccess];
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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (kSreenSize.width-40)/3 + 20;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, 40)];
    view.backgroundColor=[UIColor whiteColor];
    UIImageView * imagView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45/36*20, 20)];
    [view addSubview:imagView];
    UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(45, 10, 80, 20)];
    [view addSubview:label];
    if (section==0) {
        imagView.image=[UIImage imageNamed: @"listen"];
        label.text=@"睡前故事";
    }else{
        imagView.image=[UIImage imageNamed: @"listen"];
        label.text=@"宝宝最爱";
    }
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell被点击");
    MediaListModel * model=self.dataArr[indexPath.section][indexPath.row];
    self.myBlock(model);
}

-(void)viewWillShow{
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
