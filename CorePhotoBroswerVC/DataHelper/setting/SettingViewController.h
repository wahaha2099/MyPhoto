//
//  SettingViewController.h
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/6/6.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDImageCache.h"
#import "DataHolder.h"

@interface SettingViewController : UIViewController

@property (nonatomic) UITableView * settingView;

//设置tabItem名称
-(void)initTabItem;

@end
