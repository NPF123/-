//
//  myImageView.m
//  BabyMusic
//
//  Created by Tayoji on 15-6-13.
//  Copyright (c) 2015年 Tayoji. All rights reserved.
//

#import "myImageView.h"
@interface myImageView()
@property(nonatomic,copy)ImagViewEvent myBlock;
@end
@implementation myImageView
-(void)addEvent:(ImagViewEvent)myBlock{
    self.userInteractionEnabled=YES;
    if (self.myBlock!=myBlock) {
        self.myBlock=myBlock;
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
        self.myBlock(self);
}



@end
