//
//  LBTModel.h
//  BabyMusic
//
//  Created by Tayoji on 15-6-12.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "title":"阿狸和小小云",
 "columnType":"",
 "mediaId":"1960065970",
 "img":"http://img63.ddimg.cn/bbttt/xxy.jpg",
 "saleId":"1980099481",
 "itType":"danpin"
 */
@interface LBTModel : NSObject
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * mediaId;
@property(nonatomic,copy)NSString * img;
@property(nonatomic,copy)NSString * saleId;
@property(nonatomic,copy)NSString * itType;


@end
