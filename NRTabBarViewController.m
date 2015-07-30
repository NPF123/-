//
//  NRTabBarViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "NRTabBarViewController.h"
#import "BaseViewController.h"
#import "ContainerViewController.h"
#import "ChoicenessViewController.h"
#import "BangdanViewController.h"
#import "FeileiViewController.h"
#import "MediaDatalModel.h"

extern BOOL isWIFI;
extern BOOL isAuto;
extern NSTimer * _timer;

UIButton * tabBatPlay;
@interface NRTabBarViewController ()
{
    UIImageView * _imageView;
}
@end

@implementation NRTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![kFirst isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kFirst]]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsWIFI];
        [[NSUserDefaults standardUserDefaults] setDouble:-1.0 forKey:kTimer];
    }
    [[NSUserDefaults standardUserDefaults] setObject:kFirst forKey:kFirst];
    
    [self creatViewControlls];
    [self creatMytabBar];
}
-(void)creatViewControlls{
    NSArray * vcArr=@[@"ContainerViewController",@"RecordViewController",@"DownloadViewController",@"UserViewController"];
    
    NSMutableArray * arr=[[NSMutableArray alloc] init];
    for (NSInteger i =0; i<vcArr.count; i++) {
        
        if (i==0) {
             ContainerViewController*container=[[ContainerViewController alloc] init];
            ChoicenessViewController * choisceness=[[ChoicenessViewController alloc] init];
            choisceness.title=@"推荐";
            BangdanViewController * bangdan=[[BangdanViewController alloc] init];
            bangdan.title=@"榜单";
            FeileiViewController * feilei=[[FeileiViewController alloc] init];
            feilei.title=@"分类";
            container.viewControllers=@[choisceness,bangdan,feilei];
            UINavigationController * nvc =[[UINavigationController alloc] initWithRootViewController:container];
            container.navigationController.navigationBar.hidden=YES;
            [nvc.navigationBar setBackgroundImage:[UIImage imageNamed: @"navicagationBar"] forBarMetrics:UIBarMetricsDefault];
            [arr addObject:nvc];
        }else{
            Class vcName=NSClassFromString(vcArr[i]);
            BaseViewController * vc =[[vcName alloc] init];
            UINavigationController * nvc =[[UINavigationController alloc] initWithRootViewController:vc];
            [nvc.navigationBar setBackgroundImage:[UIImage imageNamed: @"navicagationBar"] forBarMetrics:UIBarMetricsDefault];
            [arr addObject:nvc];
        }
    }
    self.viewControllers=arr;
}

//1.定制TabBar
/*
 1.隐藏原先TabBar
 2.粘贴图片 打开用户交互
 3.粘贴按钮
 4.初始 设置 第一个为 选择的
 5.通过button 修改 TabBarController的selectIndex 就可以切换界面
 
 */
-(void)creatMytabBar{
    self.tabBar.hidden=YES;
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, kSreenSize.height-70, kSreenSize.width, 70)];
    _imageView.userInteractionEnabled=YES;
    _imageView.image=[UIImage imageNamed: @"tabBar_3"];
    [self.view addSubview:_imageView];
    NSArray *imageName=@[@"book_store",@"record",@"play123",@"download",@"mine"];
    CGFloat  space=(kSreenSize.width-50-4*30)/6;
    NSArray * titleName=@[@"精选",@"记录",@"下载",@"我的"];
    for (NSInteger i = 0; i<imageName.count; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
        button.tintColor=[UIColor clearColor];
        UILabel * label=[[UILabel alloc] init];
        label.textColor=[UIColor colorWithRed:114/255.f green:84/255.f blue:0 alpha:1.0];
        label.font=[UIFont systemFontOfSize:12];
        label.textAlignment=NSTextAlignmentCenter;
        if (i<2) {
            CGRect frame=CGRectMake(space+(30+space)*i, 20, 30, 30);
            button.frame=frame;
            label.tag=201+i;
            frame.origin.y+=30;
            frame.size.height=20;
            label.frame=frame;
            label.text=titleName[i];
        }else if(i==2){
            button.frame=CGRectMake(space+(30+space)*i, 8, 50, 50);
            tabBatPlay=button;
            self.playView=[[UIImageView alloc] initWithFrame:CGRectMake(space+(30+space)*i, 8, 50, 50)];
            self.playView.image=[UIImage imageNamed: @"default_play_bg"];
            self.playView.layer.masksToBounds=YES;
            self.playView.layer.cornerRadius=25;
            [self.imageView addSubview:self.playView];
        }else{
            CGRect frame=CGRectMake(space+50+space+(30+space)*(i-1), 20, 30, 30);
            button.frame=frame;
            frame.origin.y+=30;
            frame.size.height=20;
            label.frame=frame;
            label.tag=201+i;
            label.text=titleName[i-1];
            
        }
        button.tag=101+i;
        [button setBackgroundImage:[UIImage imageNamed:imageName[i]] forState:UIControlStateNormal];
        
        [button setBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed",imageName[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        [_imageView addSubview:button];
        [_imageView addSubview:label];
        
    }
    UIButton *button=(UIButton *)[_imageView viewWithTag:101];
    button.selected=YES;
}

//通过button 修改 TabBarController的selectIndex 就可以切换界面
-(void)butClick:(UIButton *)button{
    NSInteger  index=button.tag-101;
    if (index<2) {
        UILabel * label=(UILabel *)[_imageView viewWithTag:201+index];
        button.selected=YES;
        label.textColor=[UIColor blackColor];
        self.selectedIndex=index;
    }else if(index==2){
        if (myStreamer) {
            if (myStreamer.isPlaying) {
                button.selected=NO;
                [myStreamer pause];
            }else{
                button.selected=YES;
                [myStreamer start];
            }
        }
        if (myPlayer) {
            if(myPlayer.isPlaying){
                button.selected=NO;
                [myPlayer pause];
            }else{
                button.selected=YES;
                [myPlayer play];
            }
        }
    }else{
        UILabel * label=(UILabel *)[_imageView viewWithTag:201+index];
        label.textColor=[UIColor blackColor];
        button.selected=YES;
        self.selectedIndex=index-1;
    }
    for (NSInteger i = 0; i<5; i++) {
        UIButton * newButton=(UIButton *)[_imageView viewWithTag:101+i];
        if (i!=index&&i!=2&&index!=2) {
            newButton.selected=NO;
            UILabel * label=(UILabel *)[_imageView viewWithTag:201+i];
            button.selected=YES;
            label.textColor=[UIColor colorWithRed:114/255.f green:84/255.f blue:0 alpha:1.0];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
