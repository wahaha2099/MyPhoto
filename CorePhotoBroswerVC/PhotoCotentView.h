//
//  PhotoCotentView.h
//  CorePhotoBroswerVC
//
//  Created by 冯成林 on 15/5/15.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface PhotoCotentView : UIView<UIGestureRecognizerDelegate>


/** 图片数组 */
@property (nonatomic,strong) NSArray *images;


@property (nonatomic,copy) void (^ClickImageBlock)(NSUInteger index);

//添加image到view
-(void)showImages:(UIImage *)image ;

//传入父类的controller
//-(void)setParentViewController:(ViewController*)viewController;

@end
