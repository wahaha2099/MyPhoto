//
//  MainTabbar.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/6/8.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "MainTabbar.h"
#import "SettingViewController.h"
#import "ViewController.h"
#import "CacheViewController.h"
#import "NetViewController.h"
#import "IndexNavigateController.h"

@interface MainTabbar ()

@property NetViewController *netView ;//= [self viewControllers][0];
@property SettingViewController *setting;// = [self viewControllers][1];
@property CacheViewController *cacheView ;//= [self viewControllers][2];
@property IndexNavigateController *indexView;
@end

@implementation MainTabbar

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_netView = [self viewControllers][0];
    _cacheView = [self viewControllers][1];
    _setting = [self viewControllers][2];
    _indexView = [self viewControllers][0];
    
    self.delegate = self;
    
    //[_netView initTabItem];
    [_setting initTabItem];
    [_cacheView initTabItem];
    [_indexView initTabItem];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

    if( [viewController isKindOfClass:[SettingViewController class]]){
        SettingViewController *setting = (SettingViewController*)viewController;
        [setting.settingView reloadData];
    }
    
    if( [viewController isKindOfClass:[CacheViewController class]]){
        [_netView tabNotSelected];
        [_cacheView tabSelected];
        [[iAdHelper Instance]showADBanner:viewController.view top:YES];
    }else if( [viewController isKindOfClass:[NetViewController class]]){
        [_cacheView tabNotSelected];
        [_netView tabSelected];
        [[iAdHelper Instance]showADBanner:viewController.view top:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
