//
//  PhotoScrollView.h
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/29.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pin.h"

@interface PhotoScrollView : UIScrollView

/** 图片数组 */
@property (nonatomic,strong) NSArray *images;


@property (nonatomic,copy) void (^ClickImageBlock)(NSUInteger index);

//添加image到view
-(void)showImages:(Pin *)image ;


@end
