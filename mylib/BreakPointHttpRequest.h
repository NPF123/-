//
//  BreakPointHttpRequest.h
//  BreakPointDownFile
//
//  Created by LZXuan on 15-5-28.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"
//支持断点续传的客户端
//前提 是服务器也要支持断点续传。
//当前类仍然只下载数据 ，可以知道已经下载数据的多少，和文件总大小这时可以委托别人 处理这个数据，
//采用 block 回调形式
@class BreakPointHttpRequest;
typedef void (^DownloadBlock)(BreakPointHttpRequest *httpRequest);

@interface BreakPointHttpRequest : NSObject <NSURLConnectionDataDelegate>
{
    //请求连接
    NSURLConnection *_httpRequest;

}
@property(nonatomic,strong)MusicModel * model;
//文件已经下载的大小
@property(nonatomic,strong)NSMutableData * myData;
@property (nonatomic)unsigned long long loadedFileSize;
//文件的总大小
@property (nonatomic)unsigned long long totalFileSize;
- (void)downloadDataWithUrl:(MusicModel *)model progress:(DownloadBlock)myBlock;

//停止下载
- (void)stopDownload;

@end





