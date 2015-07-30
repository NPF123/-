//
//  NRTabBarViewController.h
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioStreamer.h"
#import <AVFoundation/AVFoundation.h>
extern AVAudioPlayer * myPlayer;
extern  AudioStreamer * myStreamer;
@interface NRTabBarViewController : UITabBarController
@property(nonatomic,strong)UIImageView * playView;
@property(nonatomic,strong)UIImageView * imageView;
@end
