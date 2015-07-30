//
//  GuyuViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "GuyuViewController.h"
#import "NRTabBarViewController.h"
@interface GuyuViewController ()

@end

@implementation GuyuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self creatView];
    [self creatBackButton];
}
-(void)creatView{
    UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(kSreenSize.width/2-36, 100,72, 72)];
    UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(kSreenSize.width/2-80, 100+72+5,160, 20)];
    imageView.image=[UIImage imageNamed: @"Icon.png"];
    imageView.layer.masksToBounds=YES;
    imageView.layer.cornerRadius=10;
    [self.view addSubview:imageView];
    label.text=@"BabyStorySchollV1.0.1";
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    
}
-(void)creatBackButton{
    UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
    [button setBackgroundImage:[UIImage imageNamed: @"title_back_white"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=103;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    
    
}
-(void)backButClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    NRTabBarViewController * tabbr=(NRTabBarViewController *)self.navigationController.tabBarController;
    tabbr.imageView.alpha=1.0;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    NRTabBarViewController * tabbr=(NRTabBarViewController *)self.navigationController.tabBarController;
    tabbr.imageView.alpha=0;
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
