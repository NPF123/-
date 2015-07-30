//
//  ListeningViewController.m
//  BabyMusic
//
//  Created by Tayoji on 15-6-17.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import "ListeningViewController.h"
#import "NRTabBarViewController.h"
#import "MusicModel.h"
#import "BreakPointHttpRequest.h"
#import "NSString+Hashing.h"

#import <MediaPlayer/MediaPlayer.h>

#import "MySqlite.h"

#import "TimerViewController.h"
#import "UMSocial.h"

#define kplayer @"player"
#define kStreamer @"Streamer"
AudioStreamer * myStreamer;
NSInteger curCount;
extern UIButton * tabBatPlay;

double shiji;
NSTimer * _timer;

@interface ListeningViewController ()<AVAudioPlayerDelegate,UMSocialUIDelegate>
{
 
    UITableView * _tableView;
    AFHTTPRequestOperationManager * _manager;
    
}

@property(nonatomic,strong)NSMutableData * musicData;
@property(nonatomic,strong)UITableView * tableView;
@end

@implementation ListeningViewController

-(void)addShijiWith:(double)zero{

    @synchronized(@(shiji)){
        shiji+=1.0;
        if (zero==0) {
            shiji=0;
        }
        NSLog(@"shiji %lf",shiji);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatBackButton];
    self.navigationItem.backBarButtonItem.tintColor=[UIColor colorWithRed:114/255.f green:84/255.f blue:0 alpha:1.0];
    if (myPlayer) {
        myPlayer=nil;
        [myPlayer stop];
    }
    if (myStreamer)
    {
        [myStreamer stop];
        myStreamer = nil;
    }
    self.playButton.tintColor=[UIColor clearColor];
    if (self.model) {
        playingModel=self.model;
        self.titleLabel.text=self.model.title;
        if (self.model.speaker.length) {
            self.zhuLabel.text=self.model.speaker;
        }else{
            self.zhuLabel.text=@"佚名";
        }
        self.authorLable.text=self.model.authorPenname;
        [self.picImagView sd_setImageWithURL:[NSURL URLWithString:self.model.coverPic] placeholderImage:[UIImage imageNamed: @"default_cover"]];
        [self creatTableViewAndDataInitAndHttpRequset];

    }
    [self playMusic];
}

-(void)creatBackButton{
    UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
    [button setBackgroundImage:[UIImage imageNamed: @"back_white.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backButClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=103;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    
    
}
-(void)backButClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)justPlay:(NSString *)catagory{
    if ([catagory isEqualToString:kStreamer]) {
        UIBackgroundTaskIdentifier bgTask = 0;
        if([UIApplication sharedApplication].applicationState== UIApplicationStateBackground) {
            
            NSLog(@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx后台播放");
            
            [myStreamer start];
            
            UIApplication*app = [UIApplication sharedApplication];
            
            UIBackgroundTaskIdentifier newTask = [app beginBackgroundTaskWithExpirationHandler:nil];
            
            if(bgTask!= UIBackgroundTaskInvalid) {
                
                [app endBackgroundTask: bgTask];
                
            }
            
            bgTask = newTask;
            
        }
        
        else {
            
            NSLog(@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx前台播放");
            
            [myStreamer start];
            
        }
        
    }else{
    
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        myPlayer.delegate=self;
        [myPlayer prepareToPlay];
        [myPlayer play];
//        NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:fileNames];
//        musicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
//        musicPlayer.delegate = self;
//        [musicPlayer prepareToPlay];
//        [soundUrl release];
      //  [self.player play];
    
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 创建播放器
-(void)playMusisWith:(NSURL *)url catagory:(NSString *)catagory{
   // NSURL * newUrl=[NSURL URLWithString:url];
    if ([catagory isEqualToString:kStreamer]) {
        if (![url isEqual:myStreamer.url]) {
            if (myPlayer) {
                myPlayer=nil;
                [myPlayer stop];
            }
            if (myStreamer)
            {
                
                [myStreamer stop];
                myStreamer = nil;
            }
            
            myStreamer=[[AudioStreamer alloc] initWithURL:url];
            [self justPlay:kStreamer];
            if ([_timer isValid]) {
                [_timer invalidate];
                _timer=nil;
            }
            _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClick:) userInfo:nil repeats:YES];
        }
    }else{
        NSLog(@"------");
        if (![url isEqual:myPlayer.url]) {
            if (myStreamer)
            {
                
                [myStreamer stop];
                myStreamer = nil;
            }
            
            myPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [self justPlay:kplayer];
            if ([_timer isValid]) {
                [_timer invalidate];
                _timer=nil;
            }
            _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClick:) userInfo:nil repeats:YES];
        }
        
    
    }
    
    
    
}
-(void)timerClick:(NSTimer *)timer{
    [self addShijiWith:1];

    if (myStreamer) {
 
        if ([self orderPlay:shiji]) {
            [self playMusic];
        }else{
            [myStreamer pause];
            if ([_timer isValid]) {
                [_timer invalidate];
                _timer=nil;
            }
         
        }
        NSInteger cur=(NSInteger)myStreamer.progress;
        NSInteger total=(NSInteger)myStreamer.duration-3;
        if (total<0) {
            self.totalTime.alpha=0;
        }else{
            self.totalTime.alpha=1.0;
        }
        if (myStreamer.isPaused) {
            self.playButton.selected=NO;
            tabBatPlay.selected=NO;
        }else{
            self.playButton.selected=YES;
            tabBatPlay.selected=YES;
        }
        self.slider.value=(double)cur/total;
        self.curTime.text=[NSString stringWithFormat:@"%0.2ld:%0.2ld:%0.2ld",cur/3600,cur/60,cur%60];
        self.totalTime.text=[NSString stringWithFormat:@"%0.2ld:%0.2ld:%0.2ld",total/3600,total/60,total%60];
        if (myStreamer.isIdle) {
            curCount++;
            [self playMusic];

        }
    }
    NSLog(@"myPlayer---%@",myPlayer);
    NSLog(@"myStreamer---%@",myStreamer);
    
    if(myPlayer){
      
        if (myPlayer.isPlaying) {
            self.playButton.selected=YES;
            tabBatPlay.selected=YES;
        }else{
            tabBatPlay.selected=NO;
            self.playButton.selected=NO;
        }
        NSInteger cur=(NSInteger)myPlayer.currentTime;
        NSInteger total=(NSInteger)myPlayer.duration;
        self.slider.value=myPlayer.currentTime*1.0/myPlayer.duration;
        self.curTime.text=[NSString stringWithFormat:@"%0.2ld:%0.2ld:%0.2ld",cur/3600,cur/60,cur%60];
        self.totalTime.text=[NSString stringWithFormat:@"%0.2ld:%0.2ld:%0.2ld",total/3600,total/60,total%60];
        if ([self orderPlay:shiji]) {
            [self playMusic];
        }else{
            [myPlayer pause];
            if ([_timer isValid]) {
                [_timer invalidate];
                _timer=nil;
            }
        }
    }

    
}
-(BOOL)orderPlay:(double)shiji{

    double totalTime =[[NSUserDefaults standardUserDefaults] doubleForKey:kTimer];
    NSLog(@"totalTime%lf",totalTime);
    if (totalTime==-1.0) {
        return YES;
    }else{
        if (shiji>=totalTime) {
            return NO;
        }
    }
    return YES;
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"播放完毕");
    curCount++;
    [self playMusic];

}
-(void)playMusic{
     [self.playButton setBackgroundImage:[UIImage imageNamed: @"play_pressed"] forState:UIControlStateSelected];
    if (self.dataArr) {
        if (curCount<0) {
            curCount=0;
        }else if (curCount>self.dataArr.count-1) {
            curCount=self.dataArr.count-1;
        }
        MusicModel *model=self.dataArr[curCount];
        self.titleLabel.text=model.title;

        MusicModel *mymodel=[self findModel:model];
        if (mymodel) {
            NSString * str=[self getFullPathWithFileUrl:model.filePath];
            NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[self getFullPathWithFileUrl:model.filePath] error:nil];
            unsigned long long fileSize = fileDict.fileSize;
            if (fileSize>=mymodel.totalFileSize) {
                NSURL * url=[NSURL fileURLWithPath:str];

                [self playMusisWith:url catagory:kplayer];
                return;
                
            }
        }
        
        
        [self playMusisWith:[NSURL URLWithString:model.filePath] catagory:kStreamer];
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
-(void)downMusic:(NSString *)url{
    self.musicData=[[NSMutableData alloc] init];
    __weak typeof(self)weakSelf =self;
    
    BreakPointHttpRequest * requset=[[BreakPointHttpRequest alloc] init];
    [requset downloadDataWithUrl:url progress:^(BreakPointHttpRequest *httpRequest) {
        [weakSelf.musicData appendData:httpRequest.myData];
    }];
}
#pragma mark 创建tableView
-(void)creatTableViewAndDataInitAndHttpRequset{
    _manager=[AFHTTPRequestOperationManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
   

}

-(void)downloadMusicWith:(NSString *)url{
 
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navicagationBar"] forBarMetrics:UIBarMetricsDefault];
    NRTabBarViewController * tabbr=(NRTabBarViewController *)self.navigationController.tabBarController;
    tabbr.imageView.alpha=1.0;


}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"listenbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    NRTabBarViewController * tabbr=(NRTabBarViewController *)self.navigationController.tabBarController;
    tabbr.imageView.alpha=0;
    //self.navigationController.navigationBar.hidden=YES;
    
}


- (IBAction)butClick:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
        {
            curCount--;
            NSLog(@"curCount:%ld",curCount);
            [self playMusic];

        }
            break;
        case 102:
        {
            [self addShijiWith:0];
            if ([_timer isValid]) {
                [_timer invalidate];
                _timer=nil;
            }
            _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClick:) userInfo:nil repeats:YES];
            if (myStreamer) {
                if (myStreamer.isPlaying) {
                    sender.selected=NO;
                    [myStreamer pause];
                }else{
                    sender.selected=YES;
                    [myStreamer start];
                    
                }
            }else{
            
                if (myPlayer.isPlaying) {
                    sender.selected=NO;
                    [myPlayer pause];
                }else{
                    sender.selected=YES;
                    [myPlayer play];
                    
                }
            
            }
            
        }
            break;
        case 103:
        {
            curCount++;
          
            [self playMusic];
        }
            break;
        case 104:
        {
            NSLog(@"-+-+-+-");
            MusicModel * model=self.dataArr[curCount];
            NSString *body = [NSString stringWithFormat:@"宝宝天天听:%@\n%@",model.title,model.filePath];
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"558d1f7067e58eb6a1004a77"
                                              shareText:body
                                             shareImage:[UIImage imageNamed:@"icon.png"]
                                        shareToSnsNames:@[UMShareToSina,UMShareToQzone,UMShareToTencent,UMShareToRenren,UMShareToWechatTimeline,UMShareToEmail,UMShareToDouban,UMShareToSms] delegate:self];
        }
            break;
        case 106:
        {
            TimerViewController *timer=[[TimerViewController alloc] init];
            [self.navigationController pushViewController:timer animated:YES];
        }
            break;
        
        default:
            break;
    }
    
}

- (IBAction)sliderChaged:(UISlider *)sender {
    if (myStreamer) {
        NSInteger total=(NSInteger)myStreamer.duration;
        [myStreamer seekToTime:total*sender.value];
        
    }else{
    myPlayer.currentTime = myPlayer.duration*sender.value;
    
    }
}
@end
