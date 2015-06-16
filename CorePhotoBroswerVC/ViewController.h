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



@property (atomic,strong) NSMutableArray *pins;

//显示隐藏tabBar
-(void)showTabBarController:(bool)show;

//隐藏广告
-(void)hideADBanner;

//显示广告
-(void)showADBanner;

//初始化网络模式
-(void)initNetMode;

//获取当前的scrollView
-(id) getScrollView;

#pragma mark ========切换tab时,删除和重新显示======
//回收全部imageView
-(void)removeAllPage;
//显示当前page的imageView
-(void)addCurrentPage;
#pragma mark ========切换tab时,删除和重新显示======

//删除按钮后的通知
-(void) removePinNotify:(NSNotification*) aNotification;

//选中当前controller
-(void)tabSelected;

//切换tab,没选中当前
-(void)tabNotSelected;
@end

