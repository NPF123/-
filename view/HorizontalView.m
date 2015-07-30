//
//  HorizontalView.m
//  BabyMusic
//
//  Created by Tayoji on 15-6-11.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import "HorizontalView.h"
#import "HorizontailCell.h"
#import "AFNetworking.h"

@interface HorizontalView()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIImageView * _imageView;
    UILabel * _titleLabel;
    UICollectionView * _collectionView;
    NSMutableArray * _dataArr;
    AFHTTPRequestOperationManager * _manager;

}
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,copy)HorizontalViewBlock myBlock;
@end
@implementation HorizontalView

-(instancetype)initWithFrame:(CGRect)frame{
    frame.size.height=(frame.size.width-4*10)/3+40*2;
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        _manager=[[AFHTTPRequestOperationManager alloc] init];
        _manager.responseSerializer=[AFHTTPResponseSerializer serializer];

        [self creatView];
    }
    return self;
}
-(void)showDataWithURL:(NSString *)url block:(HorizontalViewBlock)block{
    self.myBlock=block;
        __weak typeof(self)weakSelf =self;
    NSLog(@"url:%@",url);
  [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      if (responseObject) {
          NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
          NSDictionary *dataDict=dict[@"data"];
          DataModel * dataModel=[[DataModel alloc] initWithDictionary:dataDict error:nil];
          if ([dataModel.name isEqualToString:@"为你推荐"]) {
              weakSelf.titleLabel.text=dataModel.name;
              weakSelf.imageView.image=[UIImage imageNamed: @"recommend"];
          }else{
              weakSelf.titleLabel.text=dataModel.name;
              weakSelf.imageView.image=[UIImage imageNamed: @"listen"];

          }
          NSArray * saleListArr=dataModel.saleList;
          for (SaleListModel *model in saleListArr) {
              NSArray * listModelArr=model.mediaList;
              for (MediaListModel *listModel in listModelArr) {
                  [weakSelf.dataArr addObject:listModel];
              }
          }
        
     
      }
      [weakSelf.collectionView reloadData];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
  }];
    
}
-(void)creatView{
    self.dataArr=[[NSMutableArray alloc] init];
    CGFloat space=(self.bounds.size.width-4*10)/3;
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 45/36*20, 20)];
    [self addSubview:_imageView];
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(5+CGRectGetMaxX(_imageView.frame), 5, 80, 25)];
    self.titleLabel.textColor=[UIColor blackColor];
    self.titleLabel.font=[UIFont systemFontOfSize:18];
    [self addSubview:self.titleLabel];
    UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake(space, space+40);
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset=UIEdgeInsetsMake(0, 10, 0, 10);

    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 40,self.bounds.size.width, space+40) collectionViewLayout:layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor clearColor];
    [self addSubview:_collectionView];
    [_collectionView registerClass:[HorizontailCell class] forCellWithReuseIdentifier:@"HorizontailCell"];

}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HorizontailCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"HorizontailCell" forIndexPath:indexPath];
    MediaListModel * model=self.dataArr[indexPath.row];
    [cell showDataWith:model];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MediaListModel * model=self.dataArr[indexPath.row];
 
    self.myBlock(model);
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
@end
