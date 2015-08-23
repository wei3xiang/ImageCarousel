//
//  ViewController.m
//  ImageCarousel
//
//  Created by 魏翔 on 15/8/22.
//  Copyright (c) 2015年 魏翔. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scroView;

@property(nonatomic,strong) UIPageControl *pageControl;

@property(nonatomic,strong) NSTimer *timer;

#define imageCount 5

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i=0; i<imageCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"img_%02d",i+1]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scroView.bounds];//bounds
        imageView.image = image;
        CGRect frame = imageView.frame;
        frame.origin.x = i * frame.size.width;
        imageView.frame = frame;//frame
        [self.scroView addSubview:imageView];
    }
    
    self.pageControl.currentPage = 0;
    [self startTimer];
}


-(UIScrollView *)scroView{
    if(nil == _scroView){
        _scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(10,20, 300, 130)];
        [_scroView setBackgroundColor:[UIColor redColor]];
        _scroView.contentSize = CGSizeMake(_scroView.bounds.size.width*imageCount, 0);
        _scroView.showsHorizontalScrollIndicator = NO;
        _scroView.showsVerticalScrollIndicator = NO;
        _scroView.pagingEnabled = YES;
        _scroView.bounces = NO;
        _scroView.delegate = self;
        [self.view addSubview:_scroView];
    }
    return _scroView;
}

-(UIPageControl *)pageControl{
    
    if(nil == _pageControl){
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = imageCount;
        CGSize size = [_pageControl sizeForNumberOfPages:imageCount];
        _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
        _pageControl.center = CGPointMake(self.view.center.x, 130);
        _pageControl.pageIndicatorTintColor = [UIColor redColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        [self.view addSubview:_pageControl];
        [_pageControl addTarget:self action:@selector(changeImg:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

-(void)changeImg:(UIPageControl *)pageControl{
    CGFloat x = pageControl.currentPage * self.scroView.bounds.size.width;
    [self.scroView setContentOffset:CGPointMake(x, 0) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page =  scrollView.contentOffset.x/scrollView.bounds.size.width;
    self.pageControl.currentPage = page;
}

-(void)startTimer{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshTimer) userInfo:nil repeats:YES];
}

-(void)refreshTimer{
    int page = (self.pageControl.currentPage +1)%imageCount;
    self.pageControl.currentPage = page;
    [self changeImg:self.pageControl];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self startTimer];
}

@end
