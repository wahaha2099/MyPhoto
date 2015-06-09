//
//  ViewController.h
//  CorePhotoBroswerVC
//
//  Created by 成林 on 15/5/4.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBroswerVC.h"
#import "PhotoScrollView.h"
#import "DataMagic.h"
#import "UIImage+ReMake.h"
#import "PhotoScrollView.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "iAdHelper.h"
#import "UIImage+MultiFormat.h"

@interface ViewController : UIViewController



@property (nonatomic,strong) NSMutableArray *pins;

//显示隐藏tabBar
-(void)showTabBarController:(bool)show;

//隐藏广告
-(void)hideADBanner;

//显示广告
-(void)showADBanner;

//对应不同的tab,如network 和cache设置不同的内容
-(void)initTab;

//获取当前的scrollView
-(id) getScrollView;

@end

