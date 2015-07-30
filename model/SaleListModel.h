//
//  SaleListModel.h
//  BabyMusic
//
//  Created by Tayoji on 15-6-12.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import "JSONModel.h"
#import "MediaListModel.h"
@protocol SaleListModel
@end
@interface SaleListModel : JSONModel
//@property(nonatomic) int saleId;
@property(nonatomic,copy)NSArray<MediaListModel,Optional> *mediaList;
@end
