//
//  HorizontailCell.m
//  BabyMusic
//
//  Created by Tayoji on 15-6-13.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import "HorizontailCell.h"
#import "UIImageView+WebCache.h"
@interface HorizontailCell()
{
    UIImageView * _imageView;
    UILabel * _nameLabel;
}
@end
@implementation HorizontailCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self creatViewWithframe:frame];
    }
    return self;
}
-(void)creatViewWithframe:(CGRect)frame{
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.width)];
    _nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.width, frame.size.width, frame.size.height-frame.size.width)];
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    _nameLabel.numberOfLines=0;
    [self addSubview:_imageView];
    [self addSubview:_nameLabel];
}
-(void)showDataWith:(MediaListModel *)model{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.coverPic] placeholderImage:[UIImage imageNamed: @"default_cover"]];
    _nameLabel.font=[UIFont systemFontOfSize:13];
    
    _nameLabel.text=model.title;
}
@end
