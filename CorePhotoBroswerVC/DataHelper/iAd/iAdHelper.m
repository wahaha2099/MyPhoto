//
//  iAdHelper.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/6/5.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "iAdHelper.h"

@implementation iAdHelper

static iAdHelper * iAdInstance ;

//获取实体类
+(iAdHelper*)Instance{
    if(iAdInstance == nil){
        iAdInstance = [[iAdHelper alloc]init];
    }
    return iAdInstance;
}

//隐藏广告
-(void)hideADBanner{
    if(_adView != nil){
        [_adView setHidden:YES];
    }
}

//显示广告
-(void)showADBanner:(UIView*)view top:(bool)isTop{
    [self addADBanner:view top:isTop];
    
    if(_adView != nil){
        [_adView setHidden:NO];
    }
}

-(void)addADBanner:(UIView * )view top:(bool)isTop{
    if(_adView == nil){
        _adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        //_adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        [_adView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        // 登陆ADBannerView的delegate，这里我们设定其父窗口自己
        _adView.delegate = self;
        
        // 添加到父窗口中
        [view addSubview:_adView];
        //[_adView setHidden:YES];
    }else{
        if([_adView superview] != view){
            // 添加到父窗口中
            [view addSubview:_adView];
        }
    }

    CGRect frame = [[UIScreen mainScreen] bounds];

    
    if(isTop)
        _adView.frame = CGRectOffset(frame, 0, 0);
    else{
        // 在父窗口下方表示
        _adView.frame = CGRectOffset(frame, 0, frame.size.height - _adView.frame.size.height);
    }
}


#pragma mark --------ad delege回调-------
-(void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Error loading");
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad loaded");
}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad will load");
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"Ad did finish");
    
}
#pragma mark -------end---------

@end
