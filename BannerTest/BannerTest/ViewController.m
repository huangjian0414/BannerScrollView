//
//  ViewController.m
//  BannerTest
//
//  Created by huangjian on 2018/8/21.
//  Copyright © 2018年 huangjian. All rights reserved.
//

#import "ViewController.h"
#import "BannerScrollView.h"
@interface ViewController ()<BannerScrollViewDelegate>
@property(nonatomic,strong) NSArray *imgArray;
@end

@implementation ViewController
-(NSArray *)imgArray
{
    if (!_imgArray) {
        _imgArray=@[[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpeg"],[UIImage imageNamed:@"4.JPG"]];
    }
    return _imgArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBanner];
}
-(void)setBanner
{
    BannerScrollView *banner=[[BannerScrollView alloc]init];
    banner.bannerImgArray=self.imgArray;
    banner.delegater=self;
    [self.view addSubview:banner];
    banner.frame=CGRectMake(0, 30, self.view.bounds.size.width, 500);
}
-(void)didSelectedImage:(NSInteger)row
{
    NSLog(@"你点击了第%ld张图片哟",row+1);
}
@end
