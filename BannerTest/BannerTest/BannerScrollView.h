//
//  BannerScrollView.h
//  BannerTest
//
//  Created by huangjian on 2018/8/21.
//  Copyright © 2018年 huangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerScrollViewDelegate <NSObject>
-(void)didSelectedImage:(NSInteger)row;
@end
@interface BannerScrollView : UIScrollView
@property(nonatomic,strong) NSArray *bannerImgArray;

@property(nonatomic,weak)id<BannerScrollViewDelegate> delegater;
@end
