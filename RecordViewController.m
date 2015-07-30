//
//  RecordViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "RecordViewController.h"
#import "MySqlite.h"
#import "CatagoryDetaliCell.h"
#import "AlbumViewController.h"
@interface RecordViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    if (self.catagory==nil) {
        self.catagory=kJilv;
    }
    if ([self.catagory isEqualToString:kJilv]) {
        self.navigationItem.title=@"记录";
    }else{
        self.navigationItem.title=@"我的收藏";
        [self creatBackButton];
    }
    
    [self creatTabView];
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self dataInit];
}
-(void)creatTabView{
    self.editButtonItem.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem=self.editButtonItem;
    self.tabelView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, kSreenSize.height-60) style:UITableViewStylePlain];
    self.tabelView.dataSource=self;
    self.tabelView.delegate=self;
    [self.view addSubview:self.tabelView];
    self.tabelView.tableFooterView=[[UIView alloc] init];
    [self.tabelView registerClass:[CatagoryDetaliCell class] forCellReuseIdentifier:@"CatagoryDetaliCell"];
    
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tabelView setEditing:!self.tabelView.editing animated:YES];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
        {
            MediaListModel * model=self.dataArr[indexPath.row];
            [self.dataArr removeObject:model];
            model.feinei=self.catagory;
            
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
            [[MySqlite sharaSqlite] deleteMediaListModel:model];
            
            [self.tabelView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
            
        }
            break;
            
        default:
            break;
    }
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)dataInit{
    self.dataArr=[[NSMutableArray alloc] init];
    NSArray *arr=[[MySqlite sharaSqlite] findMediaListModel];
    for (NSInteger i = 0; i<arr.count; i++) {
        MediaListModel * model=arr[arr.count-1-i];
        if ([model.feinei isEqualToString:self.catagory]) {
            [self.dataArr addObject:model];
            
        }
    }
    [self.tabelView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MediaListModel *model=self.dataArr[indexPath.row];
    CatagoryDetaliCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CatagoryDetaliCell" forIndexPath:indexPath];
    [cell showDataWith:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (kSreenSize.width-30)/3+20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MediaListModel * model=self.dataArr[indexPath.row];
    AlbumViewController * album=[[AlbumViewController alloc] init];
    album.model=model;
    album.isRecord=YES;
    [self.navigationController pushViewController:album animated:YES];
}


@end
