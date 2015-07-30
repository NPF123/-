//
//  ContainerViewController.m
//  NurseryRhyme
//
//  Created by qianfeng on 15/7/30.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "ContainerViewController.h"
#import "Topbar.h"
#import "ViewWillShow.h"
#import "AlbumViewController.h"
#import "FeineiDetailViewController.h"
#import "CatetoryListModel.h"
#import "FeineiDetailViewController.h"
#import "SearchViewController.h"
@interface ContainerViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) Topbar *topbar;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ContainerViewController


- (id)initWithViewControllers:(NSArray *)viewControllers {
    if (self = [super init]) {
        _viewControllers = viewControllers;
        
    }
    return self;
}

-(void)myPush:(NSArray *)arr{
    for (BaseViewController * vc in arr) {
        __weak typeof(self)weakSelf=self;
        
        [vc addJumpEvent:^(id obj) {
            NSLog(@"--------%@",[obj class]);
            if ([obj isKindOfClass:[CatetoryListModel class]]) {
                FeineiDetailViewController * detail=[[FeineiDetailViewController alloc] init];
                CatetoryListModel * model=obj;
                detail.model=model;
                
                [weakSelf.navigationController pushViewController:detail animated:YES];
            }else{
                if ([obj isKindOfClass:[NSString class]]) {
                    NSString * str=obj;
                    if (str.length<=4) {
                        FeineiDetailViewController * detail=[[FeineiDetailViewController alloc] init];
                        detail.category=str;
                        [weakSelf.navigationController pushViewController:detail animated:YES];
                        return;
                    }
                }
                AlbumViewController * albumView=[[AlbumViewController alloc] init];
                MediaListModel *model=obj;
                albumView.model=model;
                [weakSelf.navigationController pushViewController:albumView animated:YES];
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * navi=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSreenSize.width, 64)];
    navi.userInteractionEnabled=YES;
    navi.image=[UIImage imageNamed: @"navicagationBar"];
    [self.view addSubview:navi];
    self.navigationController.navigationBar.hidden=YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)searchBarClick:(UIButton *)button{
    NSLog(@"-----");
    SearchViewController * search=[[SearchViewController alloc] init];
    // [self.navigationController pushViewController:search animated:YES];
    UINavigationController * nav=[[UINavigationController alloc] initWithRootViewController:search];
    [self presentViewController:nav animated:YES completion:nil];
}
- (Topbar *)topbar {
    static NSInteger i = 0;
    i++;
    NSLog(@"i:----->%ld",i);
    if (!_topbar) {
        _topbar = [[Topbar alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), kTopbarHeight)];
        
        
        __block ContainerViewController *_self = self;
        _topbar.blockHandler = ^(NSInteger currentPage) {
            [_self setCurrentPage:currentPage];
        };
        [self.view addSubview:_topbar];
    }
    UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=CGRectMake(kSreenSize.width-40,20+7.5, 25, 25);
    [button setBackgroundImage:[UIImage imageNamed: @"bf_search_white"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    return _topbar;
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64,kSreenSize.width,kSreenSize.height-64-55)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate                       = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.bounces                        = NO;
        _scrollView.pagingEnabled                  = YES;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

// overwrite setter of property: viewControllers
- (void)setViewControllers:(NSArray *)viewControllers {
    [self myPush:viewControllers];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    _viewControllers = [NSArray arrayWithArray:viewControllers];
    CGFloat x = 0.0;
    for (UIViewController *viewController in _viewControllers) {
        [viewController willMoveToParentViewController:self];
        viewController.view.frame = CGRectMake(x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        x += CGRectGetWidth(self.scrollView.frame);
        _scrollView.contentSize   = CGSizeMake(x, _scrollView.frame.size.width);
    }
    self.topbar.titles = [_viewControllers valueForKey:@"title"];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self.scrollView setContentOffset:CGPointMake(_currentPage*_scrollView.frame.size.width, 0) animated:NO]; //
}

- (void)layoutSubViews
{
    CGFloat x = 0.0;
    for (UIViewController *viewController in self.viewControllers) {
        viewController.view.frame = CGRectMake(x, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        x += CGRectGetWidth(self.scrollView.frame);
    }
    self.scrollView.contentSize   = CGSizeMake(x, _scrollView.frame.size.width);
    //self.scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    _topbar.currentPage = currentPage;
    _currentPage = currentPage;
    [self callbackSubViewControllerWillShow];
}

- (void)callbackSubViewControllerWillShow {
    UIViewController<ViewWillShow> *controller = [self.viewControllers objectAtIndex:self.currentPage];
    if ([controller conformsToProtocol:@protocol(ViewWillShow)] && [controller respondsToSelector:@selector(viewWillShow)]) {
        [controller viewWillShow];
    }
}


@end
