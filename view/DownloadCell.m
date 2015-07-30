//
//  DownloadCell.m
//  BabyMusic
//
//  Created by Tayoji on 15/6/22.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import "DownloadCell.h"
#import "BreakPointHttpRequest.h"
#import "MySqlite.h"
#import "AFNetworking.h"
@interface DownloadCell()
{
    BreakPointHttpRequest * _httprequset;
}
@property(nonatomic,strong)BreakPointHttpRequest *httprequset;
@end
@implementation DownloadCell


- (void)awakeFromNib {
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    _httprequset=[[BreakPointHttpRequest alloc] init];
    self.downloadButton.tintColor=[UIColor clearColor];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
}


- (IBAction)dowload:(UIButton *)sender {

    BOOL iswifi=[[NSUserDefaults standardUserDefaults] boolForKey:kIsWIFI];
    __weak typeof(self)weakSlelf=self;
     [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld",(long)status);
        if (status!=2) {
            if (iswifi) {
                [weakSlelf.httprequset stopDownload];
                sender.selected=NO;
                weakSlelf.downloadBlock();
            }else{
                [weakSlelf isdowload];
            }
        }else{
            [weakSlelf isdowload];
        }
        
    }];
    
    
}
-(void)isWifiDownload:(ISWIFIBlock)block{
    self.downloadBlock=block;
}
-(void)isdowload{
    UIButton * sender=(UIButton *)[self viewWithTag:1001];
    [sender setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    if (self.meidiaModel) {
        MediaListModel * myModel=self.meidiaModel;
        myModel.feinei=kYiXia;
        [[MySqlite sharaSqlite] insertDataWithMediaListModel:myModel];
       // MusicModel * musicmodel=self.model;
        // musicmodel.mediaId=myModel.mediaId;
        self.model.saleId=myModel.saleId;
    }
    if (sender.selected) {
        sender.selected=NO;
        [_httprequset stopDownload];
    }else{
        [_httprequset downloadDataWithUrl:self.model progress:^(BreakPointHttpRequest *httpRequest) {
            
        }];
        
        sender.selected=YES;
        
    }

}
-(void)timerClick{
    if (self.model) {
        MusicModel * mymodel=[self findModel:self.model];
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[self getFullPathWithFileUrl:self.model.filePath] error:nil];
        unsigned long long fileSize = fileDict.fileSize;
        if (mymodel) {
            self.totalLabel.text=[NSString stringWithFormat:@"%0.2fM",mymodel.totalFileSize*1.0/(1024*1024)];
            self.progress.progress=fileSize*1.0/mymodel.totalFileSize;
            self.loaddown.text=[NSString stringWithFormat:@"%0.1f%@",self.progress.progress*100,@"%"];
            if (fileSize>=mymodel.totalFileSize) {
                [self.downloadButton setBackgroundImage:[UIImage imageNamed: @"radio_selected"] forState:UIControlStateNormal];
                self.downloadButton.enabled=NO;
                //                if ([_timer isValid]) {
                //                    [_timer invalidate];
                //                    _timer=nil;
                //                }
                
            }else{
                [self.downloadButton setBackgroundImage:[UIImage imageNamed: @"download_file"] forState:UIControlStateNormal];
                self.downloadButton.enabled=YES;
            }
        }
        
    }
    
    
}
-(MusicModel *)findModel:(MusicModel *)model{
    NSArray * arr=[[MySqlite sharaSqlite] findMusicModel];
    for (NSInteger i = 0; i<arr.count; i++) {
        MusicModel *newmodel=arr[i];
        if ([newmodel.filePath isEqualToString:model.filePath]) {
            return model;
        }
    }
    return nil;
    
}
- (NSString *)getFullPathWithFileUrl:(NSString *)url {
    //把这个url 加密之后作为文件名字
    //把一个字符串 按照md5的加密算法进行加密，加密之后转化为一个唯一的新的字符串
    NSString *fileName =[NSString stringWithFormat:@"%@.mp3",[url MD5Hash]];
    //先获取Documents的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //返回 文件在Documents下的全路径 只是一个路径而已
    return [doc stringByAppendingPathComponent:fileName];
}
-(void)addDownBlock:(DownloadCellBlock)block{
    self.myBlock=block;
}
-(void)showDataWithModel:(MusicModel *)model{
    self.model=model;
    self.progress.alpha=1.0;
    self.progress.progress=0;
    self.titleLabel.text=model.title;
    self.totalLabel.text=[NSString stringWithFormat:@"%0.2fM",model.totalFileSize*1.0/(1024*1024)];
    if (self.isDownload) {
        self.progress.alpha=0;
        [self.downloadButton setBackgroundImage:[UIImage imageNamed: @"radio_selected"] forState:UIControlStateNormal];
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer=nil;
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
