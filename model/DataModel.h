//
//  DataModel.h
//  BabyMusic
//
//  Created by Tayoji on 15-6-12.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import "JSONModel.h"
#import "CatetoryListModel.h"
#import "SaleListModel.h"
@interface DataModel : JSONModel
@property(nonatomic,copy)NSString<Optional> * name;
@property(nonatomic,copy)NSString<Optional> * dimension;
@property(nonatomic)id<Optional> total;
@property(nonatomic,copy)NSArray<Optional,SaleListModel> *saleList;
@property(nonatomic,copy)NSArray<Optional,CatetoryListModel> *catetoryList;
@end
