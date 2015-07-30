//
//  CatetoryCell.m
//  BabyMusic
//
//  Created by Tayoji on 15-6-16.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import "CatetoryCell.h"
#import "UIImageView+WebCache.h"
@implementation CatetoryCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self creatView];
    }
    return self;
}
-(void)creatView{
    self.picImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.width)];
    self.picImageView.layer.masksToBounds=YES;
    self.picImageView.layer.cornerRadius=8;
    self.picImageView.layer.borderWidth=5;
    self.picImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    [self.contentView addSubview:self.picImageView];
    self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.picImageView.bounds)+5, self.contentView.bounds.size.width, 20)];
    self.nameLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];
}
-(void)showDataWithModel:(CatetoryListModel *)model{
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed: @"default_cover"]];
    self.nameLabel.text=model.name;
}
@end
