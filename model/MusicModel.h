//
//  MusicModel.h
//  BabyMusic
//
//  Created by Tayoji on 15-6-16.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
@property(nonatomic,copy)NSString * filePath;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSNumber *index;
@property(nonatomic)long long loadedFileSize;
@property(nonatomic)long long totalFileSize;
@property(nonatomic)NSInteger saleId;
@end
