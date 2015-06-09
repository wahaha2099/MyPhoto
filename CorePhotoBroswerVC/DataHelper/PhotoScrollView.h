//
//  PhotoScrollView.h
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/29.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Pin.h"
#import "UIImageView+SD.h"
#import "DataMagic.h"

@interface PhotoScrollView : UIScrollView

/** 图片数组 */
//@property (nonatomic,strong) NSArray *images;

@property (nonatomic,copy) void (^ClickImageBlock)(NSUInteger index);



//当前显示的界面
@property NSInteger * currentPage;

//是否离线模式
@property bool isCacheMode;

//添加image到view
-(void)showImages:(Pin *)image ;

//初始化scrollview
-(void)initScrollView:(id )controller;

//数据到了的通知
-(void)pinsRefresh;

@end
