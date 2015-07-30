//
//  UIImageView+Event.h
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagViewTouchEndh.h"
typedef void (^ImagViewEvent)(UIImageView * imageView);
@interface UIImageView (Event)
-(void)addEvent:(ImagViewEvent)myBlock;
@end
