//
//  DownloadDetailViewController.h
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "BaseViewController.h"
#import "DataModel.h"
@interface DownloadDetailViewController : BaseViewController
@property(nonatomic,strong)MediaListModel * model;
@property(nonatomic)BOOL isDownloadViewController;
@end
