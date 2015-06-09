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
@interface MainTabbar ()

@end

@implementation MainTabbar

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //ViewController *view = [self viewControllers][0];
    SettingViewController *setting = [self viewControllers][1];
    CacheViewController *cacheView = [self viewControllers][2];
    
    self.delegate = self;
    [setting initTabItem];
    [cacheView initTabItem];
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
