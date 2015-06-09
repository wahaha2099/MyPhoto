//
//  iAdHelper.h
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/6/5.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@interface iAdHelper : NSObject<ADBannerViewDelegate>

@property ADBannerView * adView;

//获取实体类
+(iAdHelper*)Instance;

//隐藏广告
-(void)hideADBanner;

//显示广告
-(void)showADBanner:(UIView* ) view top:(bool)isTop;

//添加ad到view中
-(void)addADBanner:(UIView * )view top:(bool)isTop;

@end
