//
//  VerticalCell.m
//  BabyMusic
//
//  Created by Tayoji on 15-6-13.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import "VerticalCell.h"
#import "UIImageView+WebCache.h"
@interface VerticalCell()
{
    UIImageView * _imaImgaView;
    UILabel * _titleLabel;
    UILabel * _contentLabel;
}
@end
@implementation VerticalCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.userInteractionEnabled=YES;
        CGFloat space=(kSreenSize.width-40)/3;
        _imaImgaView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10,space, space)];
        [self.contentView addSubview:_imaImgaView];
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20+space, 10, kSreenSize.width-30-space, 20)];
        _titleLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        _contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(20+space,10+ 22, kSreenSize.width-30-space, space-22)];
        _contentLabel.textColor=[UIColor lightGrayColor];
        _contentLabel.font=[UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines=0;
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}
- (void)awakeFromNib {
    
}
-(void)showDataWith:(MediaListModel *)model{
    [_imaImgaView sd_setImageWithURL:[NSURL URLWithString:model.coverPic] placeholderImage:[UIImage imageNamed: @"default_cover"]];
    _titleLabel.text=model.title;
    _contentLabel.text=model.descs;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
   [super setSelected:selected animated:animated];
    
   
}

@end
