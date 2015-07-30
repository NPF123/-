//
//  ContainerViewController.h
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
@interface ContainerViewController : UIViewController
@property (nonatomic, strong) NSArray *viewControllers;

- (id)initWithViewControllers:(NSArray *)viewControllers;
@end
