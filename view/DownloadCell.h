//
//  DownloadCell.h
//  BabyMusic
//
//  Created by Tayoji on 15/6/22.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
#import "NSString+Hashing.h"
#import "DataModel.h"
typedef void (^ISWIFIBlock)();
typedef void (^DownloadCellBlock)(MusicModel * model,UIProgressView * progress,UILabel * label);
@interface DownloadCell : UITableViewCell
{
    NSTimer * _timer;
}
@property(nonatomic)BOOL isDownload;
@property(nonatomic,strong)MusicModel * model;
@property(nonatomic,copy)DownloadCellBlock  myBlock;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *loaddown;
@property(nonatomic,strong)MediaListModel * meidiaModel;
@property(nonatomic,copy)ISWIFIBlock downloadBlock;
-(void)isWifiDownload:(ISWIFIBlock)block;
-(void)addDownBlock:(DownloadCellBlock)block;
- (IBAction)dowload:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

-(void)showDataWithModel:(MusicModel *)model;
@end
