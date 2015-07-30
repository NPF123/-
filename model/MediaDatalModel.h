//
//  MediaDatalModel.h
//  BabyMusic
//
//  Created by Tayoji on 15-6-12.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import "JSONModel.h"
@protocol MediaDatalModel
@end
@interface MediaDatalModel : JSONModel
@property(nonatomic,copy)NSString * authorPenname;
@property(nonatomic,copy)NSString * categoryIds;
@property(nonatomic,copy)NSString * categorys;
@property(nonatomic)int * chapterCnt;
@property(nonatomic,copy)NSString * coverPic;
@property(nonatomic,copy)NSString * descs;
@property(nonatomic)int  mediaId;
@property(nonatomic)int  saleId;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString<Optional> * speaker;
@end
