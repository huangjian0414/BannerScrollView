//
//  BannerScrollView.m
//  BannerTest
//
//  Created by huangjian on 2018/8/21.
//  Copyright © 2018年 huangjian. All rights reserved.
//

#import "BannerScrollView.h"
@interface BannerScrollView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic, assign)NSInteger centerIndex;

@property(nonatomic,strong) NSTimer *timer;

@property (nonatomic,weak)BannerImageView *leftImgView;

@property (nonatomic,weak)BannerImageView *centerImgView;

@property (nonatomic,weak)BannerImageView *rightImgView;
@end
@implementation BannerScrollView
-(void)startBanner
{
    [self startTimer];
}
-(NSTimer *)timer
{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
-(void)removeTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
}
-(void)startTimer
{
    [self.timer fireDate];
}
-(void)runImage
{
    self.scrollEnabled=NO;
    CGPoint apoint = self.contentOffset;
    [self setContentOffset:CGPointMake(apoint.x+CGRectGetWidth(self.frame), 0) animated:YES];
}
-(instancetype)init
{
    if (self=[super init]) {
        self.delegate=self;
        [self addImageView];
        self.frame=CGRectMake(0, 20, 375, 200);
        self.pagingEnabled=YES;
        self.bounces=NO;
        self.showsHorizontalScrollIndicator=NO;
        self.contentOffset=CGPointMake(self.frame.size.width, 0);
        [self startTimer];
    }
    return self;
}
-(void)setBannerImgArray:(NSArray *)bannerImgArray
{
    _bannerImgArray=bannerImgArray;
    self.leftImgView.imgView.image=bannerImgArray[bannerImgArray.count-1];
    self.centerImgView.imgView.image=bannerImgArray[0];
    self.rightImgView.imgView.image=bannerImgArray[1];
}
-(void)addImageView
{
    for (int i=0; i<3; i++) {
        BannerImageView *bannerImgView=[[BannerImageView alloc]init];
        [bannerImgView addTarget:self action:@selector(imgAction:forEvent:) forControlEvents:UIControlEventAllEvents];
        [self addSubview:bannerImgView];
        
        if (i==0) {
            self.leftImgView=bannerImgView;
        }else if (i==1)
        {
            self.centerIndex=0;
            self.centerImgView=bannerImgView;
        }else
        {
            self.rightImgView=bannerImgView;
        }
    }
}
- (void)imgAction:(id)sender forEvent:(UIEvent *)event{
    UITouchPhase phase = event.allTouches.anyObject.phase;
    if (phase == UITouchPhaseBegan) {
        NSLog(@"press");
        [self removeTimer];
    }
    else if(phase == UITouchPhaseEnded){
        NSLog(@"release");
        [self startTimer];
        if ([self.delegater respondsToSelector:@selector(didSelectedImage:)]) {
            [self.delegater didSelectedImage:self.centerIndex];
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentSize=CGSizeMake(self.frame.size.width*3, 0);
    self.leftImgView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.centerImgView.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    self.rightImgView.frame=CGRectMake(self.frame.size.width*2, 0, self.frame.size.width, self.frame.size.height);
}
//自动滚动滚动完毕
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self moveWithScrollView:scrollView];
    self.scrollEnabled=YES;
}
//手动拖拽滚动完毕
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self moveWithScrollView:scrollView];
}
//将要开始拖拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}
//结束拖拽
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"--%lf",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x==scrollView.frame.size.width*2||scrollView.contentOffset.x==0)
    {
        [self setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];
    }
}

//contentoffset处理
-(void)moveWithScrollView:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x/CGRectGetWidth(scrollView.bounds)>1) {
        self.centerIndex = self.centerIndex == self.bannerImgArray.count-1?0:self.centerIndex+1;
    }else if (scrollView.contentOffset.x/CGRectGetWidth(scrollView.bounds)<1)
    {
        self.centerIndex = self.centerIndex == 0?self.bannerImgArray.count-1:self.centerIndex-1;
    }
    NSInteger leftIndex = self.centerIndex == 0?self.bannerImgArray.count-1:self.centerIndex-1;
    
    NSInteger rightIndex = self.centerIndex == self.bannerImgArray.count -1?0:self.centerIndex+1;
    
    self.leftImgView.imgView.image = self.bannerImgArray[leftIndex];
    
    self.centerImgView.imgView.image = self.bannerImgArray[self.centerIndex];
    
    self.rightImgView.imgView.image = self.bannerImgArray[rightIndex];
    
}
@end

@implementation BannerImageView
-(instancetype)init
{
    if (self==[super init]) {
        [self addImageView];
    }
    return self;
}
-(void)addImageView
{
    UIImageView *imageView=[[UIImageView alloc]init];
    [self addSubview:imageView];
    self.imgView=imageView;
}
-(void)layoutSubviews
{
    self.imgView.frame=self.bounds;
}
@end
