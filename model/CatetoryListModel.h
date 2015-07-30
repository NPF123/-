//
//  CatetoryListModel.h
//  BabyMusic
//
//  Created by Tayoji on 15-6-16.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import "JSONModel.h"
@protocol CatetoryListModel
@end
@interface CatetoryListModel : JSONModel
@property(nonatomic,copy)NSString * code;
@property(nonatomic,copy)NSString * image;
@property(nonatomic,copy)NSString * name;
@end
