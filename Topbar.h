//
//  Topbar.h
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kTopbarHeight 35
typedef void (^ButtonClickHandler)(NSInteger currentPage);
@interface Topbar : UIScrollView
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) ButtonClickHandler blockHandler;
@end
