//
//  LBTView.h
//  BabyMusic
//
//  Created by Tayoji on 15-6-12.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTModel.h"
typedef void (^HeadViewBlock)(NSString * string);
@interface LBTView : UIView
-(void)showDataWith:(NSString *)url myBlock:(HeadViewBlock)block;
@end
