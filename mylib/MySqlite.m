//
//  MySqlite.m
//  BabyMusic
//
//  Created by Tayoji on 15/6/21.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import "MySqlite.h"
@interface MySqlite()
{
    FMDatabase * _database;
}
@property(nonatomic,strong)FMDatabase *database;
@end
@implementation MySqlite
+(instancetype)sharaSqlite{
    static MySqlite * sqlite=nil;
    @synchronized(self){
        if (sqlite==nil) {
            sqlite=[[self alloc] init];
            [sqlite creatFMDB];
        }
    }
    return sqlite;
}
- (void)creatFMDB {
    
    //给一个数据库的本地路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataPath = [docPath stringByAppendingPathComponent:@"myData.sqlite"];
    //实例化一个数据库
    _database = [[FMDatabase alloc] initWithPath:dataPath];
    //打开
    if ([_database open]) {
        //open 如果 没有数据库文件那么 先创建 再打开，如果有直接打开
        [self creatMediaListModelTable];//如果成功创建表
        [self creatMusicModelTable];
    }else{
        //最近发生的错误
        NSLog(@"open failed:%@",_database.lastErrorMessage);
    }
}


- (void)creatMediaListModelTable {
    
    NSString *sql = @"create table if not exists MediaListModel (serial integer  Primary Key Autoincrement,title Varchar(256),authorPenname Varchar(256),speaker Varchar(256),descs Varchar(256),categoryIds Varchar(256),categorys Varchar(256),coverPic Varchar(256),feinei Varchar(256),mediaId integer,saleId integer,chapterCnt integer)";
    //执行语句
    BOOL ret = [_database executeUpdate:sql];
    if (!ret) {
        NSLog(@"create table failed:%@",_database.lastErrorMessage);
    }
}

- (void)creatMusicModelTable {
    
    NSString *sql = @"create table if not exists MusicModel (serial integer  Primary Key Autoincrement,title Varchar(256),filePath Varchar(256),loadedFileSize integer,totalFileSize integer,saleId integer,myindex integer)";
    //执行语句
    BOOL ret = [_database executeUpdate:sql];
    if (!ret) {
        NSLog(@"create table failed:%@",_database.lastErrorMessage);
    }
}
-(void)insertDataWithMusicModel:(MusicModel *)model{
    NSArray * arr=[self findMusicModel];
    for (NSInteger i = 0; i<arr.count; i++) {
        MusicModel * newModel=arr[i];
        if ([newModel.filePath isEqualToString:model.filePath]) {
            return;
        }
        
    }
    NSString *sql = @"insert into MusicModel(title,filePath,loadedFileSize,totalFileSize,myindex,saleId) values (?,?,?,?,?,?)";
    NSString * title=model.title;
    NSString * filePath=model.filePath;
  
    long long loadedFileSize=model.loadedFileSize;
    long long totalFileSize =model.totalFileSize;
    NSInteger saleId=model.saleId;
    NSLog(@"saleId%ld",saleId);
    NSLog(@"index:%@",model.index);
    NSNumber *index=model.index ;
    if (![_database executeUpdate:sql,title,filePath,@(loadedFileSize),@(totalFileSize),index,@(saleId)]) {
        NSLog(@"insert failed:%@",_database.lastErrorMessage);
    }


}
- (void)insertDataWithMediaListModel:(MediaListModel *)model{
    //?  表示 一个占位符 和 %@ %d等等类似 对应必须只能是一个OC对象 地址
    NSLog(@"%@",model);
    NSArray * arr=[self findMediaListModel];
    for (NSInteger i = 0; i<arr.count; i++) {
        MediaListModel * newModel=arr[i];
        if (newModel.saleId-model.saleId==0&&[newModel.feinei isEqualToString:model.feinei]) {
            return;
        }
        
    }
    NSString *sql = @"insert into MediaListModel(title,authorPenname,speaker,descs,categoryIds,categorys,coverPic,feinei,mediaId,saleId,chapterCnt) values (?,?,?,?,?,?,?,?,?,?,?)";
    NSString * title=model.title;
    NSString * authorPenname=model.authorPenname;
    NSString * speaker=model.speaker;
    NSString * descs=model.descs;
    NSString * categoryIds=model.categoryIds;
    NSString * categorys=model.categorys;
    NSString * coverPic=model.coverPic;
    NSInteger mediaId=model.mediaId;
    NSInteger saleId=model.saleId;
    NSString * feinei=model.feinei;
    int chapterCnt=model.chapterCnt;
    if (![_database executeUpdate:sql,title,authorPenname,speaker,descs,categoryIds,categorys,coverPic,feinei,@(mediaId),@(saleId),@(chapterCnt)]) {
        NSLog(@"insert failed:%@",_database.lastErrorMessage);
    }
}
//查询
-(NSArray *)findMusicModel{
    NSString *sql = @"select title,filePath,loadedFileSize,totalFileSize,saleId,myindex from MusicModel";
    //执行查询语句
    //返回 一个集合 这个集合中存放着 查询的数据
    NSMutableArray  * arr=[[NSMutableArray alloc] init];
    FMResultSet *rs = [_database executeQuery:sql];
    // name age mydate icon
    while ([rs next]) {// [rs next]表示 还有没有记录
        //rs 内部 存放 查询记录
        MusicModel * model=[[MusicModel alloc] init];
        model.title=[rs stringForColumn:@"title"];
        model.filePath=[rs stringForColumn:@"filePath"];
        model.loadedFileSize=[rs intForColumn:@"loadedFileSize"];
        model.totalFileSize=[rs intForColumn:@"totalFileSize"];
        model.saleId=[rs intForColumn:@"saleId"];
        model.index=@([rs intForColumn:@"myindex"]);
        [arr addObject:model];
    }
    return arr;
}
- (NSArray *)findMediaListModel{
    //查询所有数据
    NSString *sql = @"select title,authorPenname,speaker,descs,categoryIds,categorys,coverPic,feinei,mediaId,saleId,chapterCnt from MediaListModel";
    //执行查询语句
    //返回 一个集合 这个集合中存放着 查询的数据
    NSMutableArray  * arr=[[NSMutableArray alloc] init];
    FMResultSet *rs = [_database executeQuery:sql];
    // name age mydate icon
    while ([rs next]) {// [rs next]表示 还有没有记录
        //rs 内部 存放 查询记录
        MediaListModel * model=[[MediaListModel alloc] init];
        model.title=[rs stringForColumn:@"title"];
        model.authorPenname=[rs stringForColumn:@"authorPenname"];
        model.speaker=[rs stringForColumn:@"speaker"];
        model.descs=[rs stringForColumn:@"descs"];
        model.categoryIds=[rs stringForColumn:@"categoryIds"];
        model.categorys=[rs stringForColumn:@"categorys"];
        model.coverPic=[rs stringForColumn:@"coverPic"];
        model.mediaId=(int)[rs longForColumn:@"mediaId"];
        model.saleId=(int)[rs longForColumn:@"saleId"];
        model.feinei=[rs stringForColumn:@"feinei"];
        model.chapterCnt=[rs intForColumn:@"chapterCnt"];
        [arr addObject:model];
    }
    return arr;
    /*
     执行过程:
     第一次循环 遍历第一条记录 ，第二次循环遍历 第二条记录 依次类推 直到遍历到没有记录了循环结束。
     */
}



//删除
- (void)deleteMediaListModel:(MediaListModel *)model {

    NSString * sql = @"delete from MediaListModel where mediaId = ? and feinei = ?";
    if (![_database executeUpdate:sql,@(model.mediaId),model.feinei]) {
        NSLog(@"delete error :%@",_database.lastErrorMessage);
    }
}
-(void)deleteMusicModel:(MusicModel *)model{
    NSString * sql = @"delete from MusicModel where filePath = ?";
    if (![_database executeUpdate:sql,model.filePath]) {
        NSLog(@"delete error :%@",_database.lastErrorMessage);
    }

}
//修改
-(void)updateMusicModel:(MusicModel *)model{
    NSString *sql = @"update MusicModel set loadedFileSize = ?,totalFileSize = ? where filePath = ?";
    
    if (![_database executeUpdate:sql,@(model.loadedFileSize),@(model.totalFileSize),model.filePath]) {
        NSLog(@"update failed:%@",_database.lastErrorMessage);
    }
}
@end
