//
//  DownloadViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "DownloadViewController.h"
#import "MusicModel.h"
#import "MySqlite.h"
#import "DownloadCell.h"
#import "VerticalCell.h"
#import "AlbumViewController.h"
#import "DownloadDetailViewController.h"
@interface DownloadViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSTimer * _timer;
    BOOL _isDownload;
    NSMutableArray * _timerArr;
}
@property(nonatomic)NSMutableArray * buttons;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isDownload=NO;
    _timerArr =[[NSMutableArray alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    [self creatView];
    
    
}
-(void)creatView{
    self.editButtonItem.tintColor=[UIColor blackColor];
    //self.navigationItem.rightBarButtonItem=self.editButtonItem;
    self.dataArr=[[NSMutableArray alloc] init];
    NSArray *arr=@[@"已经下载",@"正在下载"];
    self.buttons=[[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<arr.count; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
        button.frame=CGRectMake(0, 7, kSreenSize.width/2-20, 30);
        [button setTitle:arr[i] forState:UIControlStateNormal];
        // [button setTitleColor:[UIColor colorWithRed:114/255.f green:84/255.f blue:0 alpha:1.0] forState:UIControlStateNormal];
        //[button setTitleColor:[UIColor colorWithRed:114/255.f green:84/255.f blue:0 alpha:1.0] forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage imageNamed: @"line"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.titleLabel.font=[UIFont fontWithName:@"System Bold" size:18];
        [self.buttons addObject:button];
        button.tag=101+i;
        UIBarButtonItem * item=[[UIBarButtonItem alloc] initWithCustomView:button];
        //item.tag=201+i;
        //[arr1 addObject:item];
        if (i==0) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.navigationItem.leftBarButtonItem=item;
        }else{
            [button setTitleColor:[UIColor colorWithRed:114/255.f green:84/255.f blue:0 alpha:1.0] forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItems=@[self.editButtonItem,item];
        }
    }
    self.tabelView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, kSreenSize.height-60) style:UITableViewStylePlain];
    self.tabelView.dataSource=self;
    self.tabelView.delegate=self;
    [self.tabelView registerNib:[UINib nibWithNibName:@"DownloadCell" bundle:nil] forCellReuseIdentifier:@"DownloadCell"];
    [self.tabelView registerClass:[VerticalCell class] forCellReuseIdentifier:@"VerticalCell"];
    [self.view addSubview:self.tabelView];
    
    self.tabelView.tableFooterView=[[UIView alloc] init];
    
    
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tabelView setEditing:!self.tabelView.editing animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
        {
            if (_isDownload) {
                MusicModel * model=self.dataArr[indexPath.row];
                [[MySqlite sharaSqlite] deleteMusicModel:model];
                [[NSFileManager defaultManager] removeItemAtPath:[self getFullPathWithFileUrl:model.filePath] error:nil];
                [self.dataArr removeObject:model];
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
                [self.tabelView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
            }else{
                
                MediaListModel * model=self.dataArr[indexPath.row];
                [self.dataArr removeObject:model];
                model.feinei=kYiXia;
                [[MySqlite sharaSqlite] deleteMediaListModel:model];
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
                NSArray * arr=[self findDownloadModel:model];
                for (NSInteger i =0; i<arr.count; i++) {
                    MusicModel * musicModel=arr[i];
                    [[MySqlite sharaSqlite] deleteMusicModel:musicModel];
                    [[NSFileManager defaultManager] removeItemAtPath:[self getFullPathWithFileUrl:musicModel.filePath] error:nil];
                }
                [self.tabelView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
                
            }
            
            
        }
            break;
            
        default:
            break;
    }
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isDownload) {
        return 53.f;
        
    }
    return  (kSreenSize.width-40)/3 + 20;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isDownload) {
        DownloadCell * cell=[tableView dequeueReusableCellWithIdentifier:@"DownloadCell" forIndexPath:indexPath];
        MusicModel * model=self.dataArr[indexPath.row];
        [cell showDataWithModel:model];
        __weak typeof(self)weakSelf=self;
        [cell isWifiDownload:^{
            [weakSelf isWIFIAlet];
        }];
        return cell;
        
    }
    
    VerticalCell * cell=[tableView dequeueReusableCellWithIdentifier:@"VerticalCell" forIndexPath:indexPath];
    MediaListModel * model=self.dataArr[indexPath.row];
    [cell showDataWith:model];
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self yijingxiazai];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}


- (NSString *)getFullPathWithFileUrl:(NSString *)url {
    //把这个url 加密之后作为文件名字
    //把一个字符串 按照md5的加密算法进行加密，加密之后转化为一个唯一的新的字符串
    NSString *fileName =[NSString stringWithFormat:@"%@.mp3",[url MD5Hash]];
    //先获取Documents的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //返回 文件在Documents下的全路径 只是一个路径而已
    return [doc stringByAppendingPathComponent:fileName];
}
-(NSMutableArray *)findDownloadModel:(MediaListModel *)model{
    NSArray *arr=[[MySqlite sharaSqlite] findMusicModel];
    NSMutableArray * modelArr=[[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<arr.count; i++) {
        MusicModel * musicModel=arr[i];
        if (model.saleId-musicModel.saleId==0) {
            NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[self getFullPathWithFileUrl:musicModel.filePath] error:nil];
            unsigned long long fileSize = fileDict.fileSize;
            if (fileSize>=musicModel.totalFileSize) {
                [modelArr addObject:musicModel];
            }
        }
    }
    return modelArr;
    
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isDownload) {
        
    }else{
        MediaListModel * model=self.dataArr[indexPath.row];
        DownloadDetailViewController * detail=[[DownloadDetailViewController alloc] init];
        detail.isDownloadViewController=YES;
        NSLog(@"%@",[self findDownloadModel:model]);
        detail.dataArr=[self findDownloadModel:model];
        detail.model=model;
        [self.navigationController pushViewController:detail animated:YES];
        
        
    }
    
}
-(void)butClick:(UIButton *)button{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    switch (button.tag) {
        case 101:
        {
            if (self.buttons.count==2) {
                UIButton *newButonn=self.buttons[1];
                [newButonn setTitleColor:[UIColor colorWithRed:114/255.f green:84/255.f blue:0 alpha:1.0] forState:UIControlStateNormal];
            }
            
            _isDownload=NO;
            [self yijingxiazai];
        }
            
            break;
        case 102:
        {
            if (self.buttons.count==2) {
                UIButton *newButonn=self.buttons[0];
                [newButonn setTitleColor:[UIColor colorWithRed:114/255.f green:84/255.f blue:0 alpha:1.0] forState:UIControlStateNormal];
            }
            _isDownload=YES;
            [self xiazaizhong];
        }
            break;
        default:
            break;
    }
    
}
-(void)yijingxiazai{
    _isDownload=NO;
    
    [self.dataArr removeAllObjects];
    
    NSArray * arr=[[MySqlite sharaSqlite] findMediaListModel];
    for (NSInteger i = 0; i<arr.count; i++) {
        MediaListModel * model=arr[arr.count-1-i];
        if ([model.feinei isEqualToString:kYiXia]) {
            [self.dataArr addObject:model];
        }
    }
    [self.tabelView reloadData];
}
-(void)xiazaizhong{
    [self.dataArr removeAllObjects];
    
    NSArray * arr=[[MySqlite sharaSqlite] findMusicModel];
    for (NSInteger i = 0; i<arr.count; i++) {
        MusicModel * model=arr[arr.count-1-i];
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[self getFullPathWithFileUrl:model.filePath] error:nil];
        unsigned long long fileSize = fileDict.fileSize;
        if (model.totalFileSize/fileSize>1) {
            [self.dataArr addObject:model];
        }
    }
    [self.tabelView reloadData];
}



@end
