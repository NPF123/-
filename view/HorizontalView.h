//
//  HorizontalView.h
//  BabyMusic
//
//  Created by Tayoji on 15-6-11.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

typedef void (^HorizontalViewBlock)(MediaListModel * model);
@interface HorizontalView : UIView
-(void)showDataWithURL:(NSString *)url block:(HorizontalViewBlock)block;

@end
