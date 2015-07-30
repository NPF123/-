//
//  UserViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "UserViewController.h"
#import "RecordViewController.h"
#import "UIImageView+WebCache.h"
#import "GuyuViewController.h"
#import "HelpViewController.h"
#import "TimerViewController.h"
@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _dataArr;
}


@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"我的";
    [self creatView];

}
-(void)viewWillAppear:(BOOL)animated{
    [self.tabelView reloadData];
    
}
-(void)creatView{
    
    UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, kSreenSize.width/2)];
    imageView.image=[UIImage imageNamed: @"headback.png"];
    NSArray * arr=@[@[@"1我的收藏",@"2仅WIFI网络下载",@"1定时关闭"],@[@"0清理缓存",@"0问题反馈",@"1帮助中心",@"1关于"]];
    _dataArr=[[NSMutableArray array] init];
    [_dataArr addObjectsFromArray:arr];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, kSreenSize.height-70) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc] init];
    _tableView.tableHeaderView=imageView;
    _tableView.bounces=NO;
    _tableView.backgroundColor=[UIColor colorWithRed:232.0/255 green:232.0/255 blue:232.0/255 alpha:1.0];
    [self.view addSubview:_tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * str=_dataArr[indexPath.section][indexPath.row];
    NSString * strNum=[str substringToIndex:1];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if ([strNum isEqualToString:@"1"]) {
        UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(kSreenSize.width-25,(44-26)/2, 15, 26)];
        imageView.image=[UIImage imageNamed: @"next_level"];
        [cell.contentView addSubview:imageView];
    }else if([strNum isEqualToString:@"2"]){
        UISwitch * swith=[[UISwitch alloc] initWithFrame:CGRectMake(kSreenSize.width-70, 7, 60, 30)];
        [swith addTarget:self action:@selector(swithClick:) forControlEvents:UIControlEventValueChanged];
        swith.onTintColor=[UIColor colorWithRed:255.0/255 green:233.0/255 blue:97.0/255 alpha:1.0];
        BOOL iswifi=[[NSUserDefaults standardUserDefaults] boolForKey:kIsWIFI];
        NSLog(@"----++++ %d",iswifi);
        [swith setOn:iswifi];
        [cell.contentView addSubview:swith];
    }
    cell.textLabel.text=[str substringFromIndex:1];
    cell.textLabel.font=[UIFont fontWithName:@"System Blod" size:13];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        RecordViewController * record=[[RecordViewController alloc] init];
        record.catagory=kShouCang;
        [self.navigationController pushViewController:record animated:YES];
    }else if(indexPath.section==1&&indexPath.row==0){
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"清除缓存" message:[NSString stringWithFormat:@"总共有%.2fM缓存",[self getCanchSize]] preferredStyle:UIAlertControllerStyleActionSheet];
        
        [sheet addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSLog(@"清理了");
            //删除
            //清除磁盘
            [[SDImageCache sharedImageCache] clearDisk];
            //清除内存
            [[SDImageCache sharedImageCache] clearMemory];
            
        }]];
        
        [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //取消
        }]];
        [self presentViewController:sheet animated:YES completion:nil];
        
    }else if(indexPath.section==1&&indexPath.row==1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kFaikui]];
        
    }else if(indexPath.section==1&&indexPath.row==3){
        GuyuViewController * guyu =[[GuyuViewController alloc] init];
        [self.navigationController pushViewController:guyu animated:YES];
    }else if(indexPath.section==1&&indexPath.row==2){
        HelpViewController * help=[[HelpViewController alloc] init];
        [self.navigationController pushViewController:help animated:YES];
        
    }else if(indexPath.section==0&&indexPath.row==2){
        TimerViewController *timerVc=[[TimerViewController alloc] init];
        [self.navigationController pushViewController:timerVc animated:YES];
    }
}
-(void)swithClick:(UISwitch *)swith{
    
    [[NSUserDefaults standardUserDefaults] setBool:swith.on forKey:kIsWIFI];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 20;
    }
    return 0;
}
-(void)butClick:(UIButton *)button{
    
}
-(CGFloat )getCanchSize{
    // 两类缓存 sdWebImage和首页
    //获取图片缓存大小
    
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] getSize];
    //获取自定义缓存大小
    //枚举遍历一个文件夹
    //    NSString  *myCachaePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/MyCaches"];
    //    NSDirectoryEnumerator *enumator = [[NSFileManager defaultManager] enumeratorAtPath:myCachaePath];
    //    __block NSUInteger count = 0 ;
    //    for (NSString *fileName in enumator) {
    //        NSString *path = [myCachaePath stringByAppendingPathComponent:fileName];
    //        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    //        count += fileDict.fileSize;
    //    }
    //    //得到字节，转化为M
    //    CGFloat  totalaSize = ((CGFloat)imageCacheSize + count)/1024/1024;
    
    return imageCacheSize*1.0/(1024*1024);
    
}

@end
