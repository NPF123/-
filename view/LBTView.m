//
//  LBTView.m
//  BabyMusic
//
//  Created by Tayoji on 15-6-12.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import "LBTView.h"
#import "LBTModel.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "UIImageView+Event.h"
#import "ImagViewTouchEndh.h"
#import "myImageView.h"
@interface LBTView()<UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    AFHTTPRequestOperationManager *_manager;

}

@property(nonatomic)NSInteger count;
@property(nonatomic,copy)HeadViewBlock myBlock;
@property(nonatomic,strong)NSMutableArray * dataArr;
@end
@implementation LBTView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        [self creatScrollView];
        
    }
    return self;
}
-(void)creatScrollView{
    self.dataArr=[[NSMutableArray alloc] init];
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width/720*200)];
    [self addSubview:_scrollView];
    NSArray * arr=@[@"儿童教育",@"童诗",@"儿歌",@"寓言故事"];
    CGFloat space=(self.bounds.size.width-50)/4;
    CGFloat y=CGRectGetMaxY(_scrollView.frame)+10;
    for (NSInteger i = 0; i<4; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
        button.frame=CGRectMake(10+(10+space)*i, y, space, 20);
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=10;
        button.tintColor=[UIColor lightGrayColor];
        button.tag=101+i;
        [button addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
    _manager=[[AFHTTPRequestOperationManager alloc] init];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
}
-(void)butClick:(UIButton *)button{
    switch (button.tag) {
        case 101:
        {
            self.myBlock(fETJY);
        }
            break;
        case 102:
        {
            self.myBlock(fTSS);
        }
            break;
        case 103:
        {
            self.myBlock(fEG);

        }
            break;
        case 104:
        {
            self.myBlock(fYYGS);
        }
            break;
        
        default:
            break;
    }
}

-(void)showDataWith:(NSString *)url myBlock:(HeadViewBlock)block{
    self.myBlock=block;
    __weak typeof(self) weakSelf=self;
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * dataDict=dict[@"data"];
            NSString * block=dataDict[@"block"];
            NSData * blockData=[block dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * blockDict=[NSJSONSerialization JSONObjectWithData:blockData options:NSJSONReadingMutableContainers error:nil];
            NSArray * dataArr=blockDict[@"data"];
            for (NSDictionary * mDict in dataArr) {
                LBTModel * model=[[LBTModel alloc] init];
                [model setValuesForKeysWithDictionary:mDict];
                [weakSelf.dataArr addObject:model];
            }
            [weakSelf showData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(void)showData{
    LBTModel * model=nil;
    self.count=self.dataArr.count+2;
    NSLog(@"%ld",self.count);
    for (NSInteger i = 0; i<self.count; i++) {
        NSString * url=@"";
        if (i==0) {
            model=self.dataArr[self.dataArr.count-1];
            url=model.img;
        }else if(i<self.count-1){
           model=self.dataArr[i-1];
            url=model.img;
        }else{
            model=self.dataArr[0];
            url=model.img;
        }
        myImageView * imageView=[[myImageView alloc] initWithFrame:CGRectMake(_scrollView.bounds.size.width*i, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed: @"botton_03down"]];
        __weak typeof(self) weakSelf=self;
        [imageView addEvent:^(UIImageView *imageView) {
            weakSelf.myBlock(model.saleId);
            NSLog(@"被点击");
        }];
        [_scrollView addSubview:imageView];
    }
    _scrollView.contentSize=CGSizeMake(_scrollView.bounds.size.width*(self.dataArr.count+2), _scrollView.bounds.size.height);
    _scrollView.contentOffset=CGPointMake(_scrollView.bounds.size.width, 0);
    _scrollView.bounces=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    //UIPageControl * page=[[UIPageControl alloc] initWithFrame:CGRectMake(_scrollView.bounds.size.width/2-40, _scrollView.bounds.size.height-20, 80, 20)];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint curp=_scrollView.contentOffset;
    if (curp.x==0) {
        _scrollView.contentOffset=CGPointMake((self.count-2)*_scrollView.bounds.size.width, 0);
    }else if(curp.x==(self.count-1)*_scrollView.bounds.size.width){
        _scrollView.contentOffset=CGPointMake(_scrollView.bounds.size.width, 0);
    }
}

@end
