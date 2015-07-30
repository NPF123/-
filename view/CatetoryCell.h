//
//  CatetoryCell.h
//  BabyMusic
//
//  Created by Tayoji on 15-6-16.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
@interface CatetoryCell : UICollectionViewCell
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UIImageView * picImageView;
-(void)showDataWithModel:(CatetoryListModel *)model;
@end
