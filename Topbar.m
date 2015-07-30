//
//  Topbar.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "Topbar.h"
@interface Topbar ()

@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation Topbar
- (void)setTitles:(NSMutableArray *)titles {
    self.showsHorizontalScrollIndicator = NO;
    _titles = titles;
    self.buttons = [NSMutableArray array];
    CGFloat padding =(kSreenSize.width)/4;
    
    // CGSize contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    for (int i = 0; i < titles.count; i++) {
        if ([_titles[i] isKindOfClass:[NSNull class]]) {
            continue;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:114/255.f green:84/255.f blue:0 alpha:1.0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        button.titleLabel.font=[UIFont systemFontOfSize:18];
        
        
        // set button frame
        static CGFloat originX = 0;
        CGRect frame = CGRectMake(padding*i,5,padding,30);
        button.frame = frame;
        originX      = CGRectGetMaxX(frame) + padding; //originX + padding + button.intrinsicContentSize.width;
        
        [self addSubview:button];
        [self.buttons addObject:button];
    }
    
    
    self.contentSize = CGSizeMake(CGRectGetMaxX([self.buttons.lastObject frame]) + padding, self.frame.size.height);
    
    // mark view
    UIButton *firstButton = self.buttons.firstObject;
    CGRect frame = firstButton.frame;
    self.markView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x+firstButton.frame.size.width/2-15, CGRectGetMaxY(frame)-3, 30, 2)];
    _markView.backgroundColor = [UIColor blackColor];
    [self addSubview:_markView];
}

/**
 - (void)setTitles:(NSMutableArray *)titles {
 _titles = titles;
 self.buttons = [NSMutableArray array];
 CGFloat padding = 20.0;
 CGSize contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
 
 for (int i = 0; i < titles.count; i++) {
 if ([_titles[i] isKindOfClass:[NSNull class]]) {
 continue;
 }
 
 // buttons
 UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
 [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
 [button setTitle:_titles[i] forState:UIControlStateNormal];
 [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 
 // set button frame
 static CGFloat originX = 0;
 CGRect frame = CGRectMake(originX+padding, 0, button.intrinsicContentSize.width, kTopbarHeight);
 button.frame = frame;
 originX      = CGRectGetMaxX(frame) + padding; //originX + padding + button.intrinsicContentSize.width;
 contentSize.width += frame.size.width += padding;
 
 [self addSubview:button];
 [self.buttons addObject:button];
 }
 
 contentSize.width += padding;
 self.contentSize = contentSize;
 
 // mark view
 UIButton *firstButton = self.buttons.firstObject;
 CGRect frame = firstButton.frame;
 self.markView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, CGRectGetMaxY(frame)-3, frame.size.width, 3)];
 _markView.backgroundColor = [UIColor whiteColor];
 [self addSubview:_markView];
 }
 */

- (void)buttonClick:(UIButton *)sender {
    //        NSInteger index=sender.tag-1001;
    //        sender.selected=YES;
    //        for (NSInteger i = 0; i<_titles.count; i++) {
    //            if (i!=index) {
    //                sender.selected=NO;
    //            }
    //        }
    self.currentPage = [self.buttons indexOfObject:sender];
    if (_blockHandler) {
        _blockHandler(_currentPage);
    }
}

// overwrite setter of property: selectedIndex
- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    UIButton *button = [_buttons objectAtIndex:_currentPage];
    CGRect frame = button.frame;
    frame.origin.x -= 5;
    frame.size.width += 10;
    [self scrollRectToVisible:frame animated:YES];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.markView.frame = CGRectMake(button.frame.origin.x+button.frame.size.width/2-15, CGRectGetMaxY(button.frame)-3, 30, 2);
    } completion:nil];
}


@end
