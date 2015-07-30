//
//  MySqlite.h
//  BabyMusic
//
//  Created by Tayoji on 15/6/21.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

/*
 对底层 的C语言 sqlite 进行封装
 对数据库分别进行 增删改查
*/
//Model
#import "DataModel.h"
#import "MusicModel.h"
@interface MySqlite : NSObject
+(instancetype)sharaSqlite;
-(void)creatFMDB;
//插入
-(void)insertDataWithMediaListModel:(MediaListModel * )model;
-(void)insertDataWithMusicModel:(MusicModel * )model;
//查找
-(NSArray *)findMediaListModel;
-(NSArray *)findMusicModel;
//删除
-(void)deleteMediaListModel:(MediaListModel *)model;
-(void)deleteMusicModel:(MusicModel *)model;

- (void)updateMusicModel:(MusicModel *)model;
@end
