//
//  CatagoryDetaliCell.m
//  BabyMusic
//
//  Created by Tayoji on 15/6/19.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import "CatagoryDetaliCell.h"
#import "UIImageView+WebCache.h"
@interface CatagoryDetaliCell()
{
    UIImageView * _imaImgaView;
    UILabel * _titleLabel;
    UILabel * _contentLabel;
    UILabel * _authorPenname;
    UILabel * _speaker;
}
@end
@implementation CatagoryDetaliCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.userInteractionEnabled=YES;
        CGFloat space=(kSreenSize.width-40)/3;
        CGFloat height=space/4;
        _imaImgaView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10,space, space)];
        [self.contentView addSubview:_imaImgaView];
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20+space, 10, kSreenSize.width-30-space, height)];
        _titleLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        _authorPenname=[[UILabel alloc] initWithFrame:CGRectMake(20+space,10+ height, kSreenSize.width-30-space, height)];
        _authorPenname.textColor=[UIColor lightGrayColor];
        _authorPenname.font=[UIFont systemFontOfSize:12];
        _authorPenname.numberOfLines=1;
        [self.contentView addSubview:_authorPenname];
        _speaker=[[UILabel alloc] initWithFrame:CGRectMake(20+space,10+ height+height, kSreenSize.width-30-space, height)];
        _speaker.textColor=[UIColor lightGrayColor];
        _speaker.font=[UIFont systemFontOfSize:12];
        _speaker.numberOfLines=1;
        [self.contentView addSubview:_speaker];
        _contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(20+space ,10+ height+height+height, kSreenSize.width-30-space, height)];
        _contentLabel.textColor=[UIColor lightGrayColor];
        _contentLabel.font=[UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines=1;
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}
-(void)showDataWith:(MediaListModel *)model{
    [_imaImgaView sd_setImageWithURL:[NSURL URLWithString:model.coverPic] placeholderImage:[UIImage imageNamed: @"default_cover"]];
    _authorPenname.text=[NSString stringWithFormat:@"作者:%@",model.authorPenname];
    _titleLabel.text=model.title;
    if (model.speaker.length) {
       _speaker.text=[NSString stringWithFormat:@"主播：%@",model.speaker];
    }else{
        _speaker.text=@"主播:佚名";
    }
    _contentLabel.text=model.descs;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
