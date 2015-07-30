//
//  UIImageView+Event.h
//  BabyMusic
//
//  Created by Tayoji on 15-6-13.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagViewTouchEndh.h"
typedef void (^ImagViewEvent)(UIImageView * imageView);
@interface UIImageView (Event)
-(void)addEvent:(ImagViewEvent)myBlock;
@end
