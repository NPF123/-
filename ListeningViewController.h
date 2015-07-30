//
//  ListeningViewController.h
//  BabyMusic
//
//  Created by Tayoji on 15-6-17.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//
#import "AudioStreamer.h"
#import "BaseViewController.h"
#import "DataModel.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>


AVAudioPlayer * myPlayer;
static MediaListModel * playingModel;
@interface ListeningViewController : BaseViewController
{

    AVAudioPlayer * _player;
}
- (IBAction)sliderChaged:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *curTime;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property(nonatomic,strong)AVAudioPlayer * player;

@property (weak, nonatomic) IBOutlet UIImageView *picImagView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhuLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLable;
- (IBAction)butClick:(UIButton *)sender;

//-(void)playMusisWith:(NSURL *)url;





@property(nonatomic,strong)MediaListModel * model;
@end
