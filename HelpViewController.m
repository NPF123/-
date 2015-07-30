//
//  HelpViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "HelpViewController.h"
#import "LZXHelper.h"
#import "NRTabBarViewController.h"
@interface HelpViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _headArr;
}


@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTabelView];
    [self dataInit];
    [self creatBackButton];
}
-(void)creatTabelView{
    self.tabelView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, kSreenSize.height-20) style:UITableViewStylePlain];
    [self.view addSubview:self.tabelView];
    [self.tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tabelView.bounces=NO;
    self.tabelView.tableFooterView=[[UIView alloc] init];
    self.tabelView.delegate=self;
    self.tabelView.dataSource=self;
    
}
-(void)dataInit{
    NSArray * arr=@[@[@"使用BabyStorySchool是完成免费得，在线使用时产生的流量费用由当地运营收取，资费标准请资讯当地运营商"],@[@"锁屏后是可以继续收听宝宝天天听的"],@[@"为了节省流量建议您下载后收听，我们默认把个人>仅WIFI网络下载功能开启，保证您只在WIFI网络下才使用下载功能"],@[@"可以在播放界面，点击定时关闭图标设置关闭的时间"],@[@"使用定时播放时,要在播放界面进行播放或者暂停！首页不要点击播放或者暂停按钮,不然定时播放会失效.如果失效,请在播放界面再次点击播放或者暂停按钮即可"],@[@"进入我的>点击清理缓存"],@[@"请联系QQ303266900"]];
    self.dataArr=[[NSMutableArray alloc] initWithArray:arr];
    _headArr=@[@"1、BabyStorySchool听是否收费？",@"2、锁屏后BabyStorySchool还会自动播放内容吗？",@"3、使用BabyStorySchool客户端是，怎么节省流量？",@"4、可以定时关闭播放吗？",@"5、定时播放怎么不管用？",@"6、怎样清理缓存呢？",@"7、如果在这里没有我想要的答案怎么办？"];
    [self.tabelView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text=self.dataArr[indexPath.section][indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.textColor=[UIColor grayColor];
    cell.textLabel.numberOfLines=0;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSLog(@"%f",cell.textLabel.frame.size.width);
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, kSreenSize.width, 20)];
    label.text=_headArr[section];
    label.font=[UIFont systemFontOfSize:16];
    label.textColor=[UIColor redColor];
    label.backgroundColor=[UIColor whiteColor];
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [LZXHelper textHeightFromTextString:self.dataArr[indexPath.section][indexPath.row] width:kSreenSize.width fontSize:14] + 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    
    NRTabBarViewController * tabbr=(NRTabBarViewController *)self.navigationController.tabBarController;
    tabbr.imageView.alpha=1.0;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    NRTabBarViewController * tabbr=(NRTabBarViewController *)self.navigationController.tabBarController;
    tabbr.imageView.alpha=0;
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
