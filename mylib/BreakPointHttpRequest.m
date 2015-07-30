//
//  BreakPointHttpRequest.m
//  BreakPointDownFile
//
//  Created by LZXuan on 15-5-28.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "BreakPointHttpRequest.h"
#import "NSString+Hashing.h"
#import "MySqlite.h"

//md5 把一个字符串进行加密
@interface BreakPointHttpRequest()
{
    NSFileHandle *_fileHandle;
}
@property (nonatomic,copy) DownloadBlock myBlock;
@end

/*
 ⾸首先来了解下这个东⻄西: Range头域
 Range头域可以请求实体的⼀一个或者多个⼦子范围。例如,   
 表⽰示头500个字节:bytes=0-499   
 表⽰示第⼆二个500字节:bytes=500-999   
 表⽰示最后500个字节:bytes=-500   
 表⽰示500字节以后的范围:bytes=500-   
 第⼀一个和最后⼀一个字节:bytes=0-0,-1   
 同时指定⼏几个范围:bytes=500-600,601-999
 实现断点下载就是在httpRequest中加⼊入 Range 头。
 [request addValue:@"bytes=500-" forHTTPHeaderField:@"Range"];
 ⾄至于能否正常实现断点续传,还要看服务器是否⽀支持。 如果⽀支持,⼀一切没问题。 如果不⽀支持可能出现两种情况,1.不理会你得range值,每次都重
 新下载数据;2.直接下载失败。
 */

@implementation BreakPointHttpRequest
- (void)downloadDataWithUrl:(MusicModel *)model progress:(DownloadBlock)myBlock {
    self.model=model;
    if (_httpRequest) {
        [_httpRequest cancel];//取消上一次下载
        _httpRequest = nil;
    }
   // [[MySqlite sharaSqlite] insertDataWithMusicModel:model];
    //保存block
    self.myBlock = myBlock;
    self.myData=[[NSMutableData alloc] init];
    //获取本地已经下载了多少数据
    //1.检测文件是否存在
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[self  getFullPathWithFileUrl:model.filePath]];
    NSLog(@"filePath:%@",[self getFullPathWithFileUrl:model.filePath]);
    if (!isExist) {
        //不存在 那么要创建一个空的文件
        [[NSFileManager defaultManager] createFileAtPath:[self getFullPathWithFileUrl:model.filePath] contents:nil attributes:nil];
    }
    //2.获取本地文件大小
    //文件属性字典
    NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[self getFullPathWithFileUrl:model.filePath] error:nil];
    unsigned long long fileSize = fileDict.fileSize;//文件大小
    self.loadedFileSize = fileSize;
    
    //发送请求 建立连接
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:model.filePath]];
    //增加一个请求头域
    //告诉服务器 从 指定字节之后开始下载
    [request addValue:[NSString stringWithFormat:@"bytes=%llu-",self.loadedFileSize] forHTTPHeaderField:@"Range"];
    //建立请求连接
    _httpRequest = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //同时打开 下载到本地的文件
    //只写方式打开
    _fileHandle = [NSFileHandle fileHandleForWritingAtPath:[self getFullPathWithFileUrl:model.filePath]];
    
}
#pragma mark - 获取文件在沙盒Documents目录下的全路径
- (NSString *)getFullPathWithFileUrl:(NSString *)url {
    //把这个url 加密之后作为文件名字
    //把一个字符串 按照md5的加密算法进行加密，加密之后转化为一个唯一的新的字符串
    NSString *fileName =[NSString stringWithFormat:@"%@.mp3",[url MD5Hash]];
    //先获取Documents的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //返回 文件在Documents下的全路径 只是一个路径而已
    return [doc stringByAppendingPathComponent:fileName];
}
//服务器给客户端的响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //响应中会告知客户端 将要发送的数据大小
    NSHTTPURLResponse *httpResponse =(NSHTTPURLResponse *) response;
    /*
    NSLog(@"url:%@",httpResponse.URL);
    //状态码
    NSLog(@"status:%ld",httpResponse.statusCode);
    //发送文件的大小
    NSLog(@"len:%lld",httpResponse.expectedContentLength);
    //文件名字
    NSLog(@"fileName:%@",httpResponse.suggestedFilename);
    //文件类型
    NSLog(@"type:%@",httpResponse.MIMEType);
    */
    //获取文件的总大小 = 本地已经下载的文件大小+服务器发送的剩下的大小
    self.totalFileSize = self.loadedFileSize+httpResponse.expectedContentLength;
    MusicModel * model=self.model;
    // model.loadedFileSize=self.loadedFileSize;
    model.totalFileSize=self.totalFileSize;
    [[MySqlite sharaSqlite] insertDataWithMusicModel:self.model];

}
//服务器会一段一段 发送数据
//每发送一段那么就立即保存在本地
//如果数据大 下载过程
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //每下载一些数据 立即写入本地文件
    //把偏移量定位到文件尾
    [self.myData appendData:data];
    [_fileHandle seekToEndOfFile];
    //写文件
    [_fileHandle writeData:data];
    //同步到本地
    [_fileHandle synchronizeFile];
    //得到已经下载文件大小
    self.loadedFileSize += data.length;//字节为单位
    //每下载一点数据就通知 界面 告知界面 已经下载多少数据
    if (self.myBlock) {
        self.myBlock(self);
    }
    
}
//下载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self stopDownload];//停止下载
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
     [self stopDownload];//停止下载
}

//停止下载
- (void)stopDownload {
    if (_httpRequest) {
        [_httpRequest cancel];
        _httpRequest = nil;
    }
    //关闭文件
    [_fileHandle closeFile];
}

@end








