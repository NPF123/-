//
//  TimerViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "TimerViewController.h"
#import "NRTabBarViewController.h"
#import "LZXHelper.h"
extern double shiji;
@interface TimerViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    [self dataInit];
    [self creatBackButton];
}
-(void)creatTableView{
    self.tabelView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, kSreenSize.height-20) style:UITableViewStylePlain];
    self.tabelView.dataSource=self;
    self.tabelView.delegate=self;
    [self.tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tabelView.tableFooterView=[[UIView alloc] init];
    [self.view addSubview:self.tabelView];
    
}
-(void)dataInit{
    self.dataArr=[[NSMutableArray alloc] initWithObjects:@"-1",@"10",@"20",@"30",@"40",@"50",@"60",@"90",@"120",@"0", nil];
    [self.tabelView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString * str =self.dataArr[indexPath.row];
    cell.textLabel.numberOfLines=0;
    if ([str isEqualToString:@"-1"]) {
        cell.textLabel.text=@"取消定时播放";
    }else if([@"0" isEqualToString:str]){
        
        cell.textLabel.text=@"温馨提示:首页不要点击播放按钮,不然定时播放会失效.使用定时播放时,要在播放界面进行播放或者暂停！";
        cell.textLabel.font=[UIFont systemFontOfSize:12];
        
        cell.textLabel.textColor=[UIColor lightGrayColor];
    }else{
        
        cell.textLabel.text=[NSString stringWithFormat:@"%@分钟",str];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * str =self.dataArr[indexPath.row];
    //NSString * textStr=@"温馨提示:首页不要点击播放按钮,不然定时播放会失效.使用定时播放时,要在播放界面进行播放或者暂停！";
    if ([@"0" isEqualToString:str]) {
        return 44+10;
    }
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<9) {
        shiji=0;
        NSString * str =self.dataArr[indexPath.row];
        [self alect:str];
    }
    
    
}
-(void)alect:(NSString *)str{
    if ([str isEqualToString:@"-1"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消定时播放" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"取消按钮被点击");
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[NSUserDefaults standardUserDefaults] setDouble:-1.0 forKey:kTimer];
        }]];
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSString * string=[NSString stringWithFormat:@"%@分钟后暂停播放",str];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"取消按钮被点击");
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[NSUserDefaults standardUserDefaults] setDouble:[str doubleValue]*60 forKey:kTimer];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    NRTabBarViewController * tabbr=(NRTabBarViewController *)self.navigationController.tabBarController;
    tabbr.imageView.alpha=1.0;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    NRTabBarViewController * tabbr=(NRTabBarViewController *)self.navigationController.tabBarController;
    tabbr.imageView.alpha=0;
}

@end
