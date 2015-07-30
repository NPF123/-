//
//  AlbumViewController.h
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "BaseViewController.h"
#import "DataModel.h"
@interface AlbumViewController : BaseViewController
{
    BOOL _isReturn;
}
@property(nonatomic)NSInteger totalCount;
@property(nonatomic)BOOL isReturn;
@property(nonatomic)BOOL isRecord;
@property(nonatomic)BOOL isMusicList;
@property(nonatomic,strong)NSMutableArray * pushArr;

@property(nonatomic,strong)id  model;
@end
